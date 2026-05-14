import relationalStore from '@ohos.data.relationalStore';
import { DatabaseManager } from 'commonlib';
import { AssetAccountDB, AssetAccountDBBase, DB_CONSTANTS } from '../model/AssetAccountDB';
import { JSON } from '@kit.ArkTS';
import { Logger } from 'commonlib/src/main/ets/utils/logger/Index';

const TAG = '[AssetAccountDBManager]';

/**
 * 资产账户数据库管理类（封装RelationalStore增删改查）
 *
 * @author czx
 * @date 2026-03-23
 */
export class AssetAccountDBManager {
  private dbManager: DatabaseManager;
  constructor(dbManager: DatabaseManager) {
    this.dbManager = dbManager;
  }

  /**
   * 初始化创建资产账户表
   */
  public async initDB(): Promise<void> {
    // 获取数据库连接实例
    const rdbStore = this.getRdbStore();
    try {
      // 创建资产账户表（不存在则创建）
      const createTableSql = `
        CREATE TABLE IF NOT EXISTS ${DB_CONSTANTS.TABLE_NAME} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          assetTypeId INTEGER NOT NULL,
          name TEXT NOT NULL,
          remake TEXT DEFAULT '',
          accountBalance INTEGER NOT NULL,
          accountCurrency TEXT NOT NULL,
          includedTotalAssets INTEGER DEFAULT 1,
          isOptional INTEGER DEFAULT 1,
          billId INTEGER DEFAULT 1,
          createTime TEXT DEFAULT CURRENT_TIMESTAMP
        )
      `;
      await rdbStore.executeSql(createTableSql);
      console.log('资产账户表创建成功');
    } catch (e) {
      console.error('资产账户表初始化失败：', e);
    }
  }

  /**
   * 新增资产账户信息
   *
   * @param item 资产类型数据（无需传id，自增）
   * @returns 新增数据的id
   */
  async addAssetAccount(item: AssetAccountDBBase): Promise<number> {
    const rdbStore = this.getRdbStore();

    return this.transaction(async (): Promise<number> => {
      console.log('新增资产账户开始:', JSON.stringify(item));
      const values: relationalStore.ValuesBucket = this.createValuesBucket(item);
      const insertId = await rdbStore.insert(DB_CONSTANTS.TABLE_NAME, values);
      console.log('新增资产账户成功，id：', insertId);
      Logger.info(TAG, 'insert asset account success.');
      return insertId;
    });
  }

  /**
   * 删除资产账户
   */
  async deleteAssetAccountById(id: number): Promise<number> {
    const rdbStore = this.getRdbStore();
    try {
      // 指定表名
      let predicates = new relationalStore.RdbPredicates(DB_CONSTANTS.TABLE_NAME);

      // 构建条件
      predicates.equalTo('id', id)

      // 执行删除
      const deleteCount = await rdbStore.delete(predicates);
      console.log(`删除${deleteCount}条资产账户数据`);
      return deleteCount;
    } catch (e) {
      throw new Error(`新增资产账户失败: ${e}`);
    }
  }

  /**
   * 修改资产类型
   * @param id 要修改的id
   * @param updateData 要修改的字段
   * @returns 修改的行数
   */
  async updateAssetAccount(id: number, updateData: Partial<AssetAccountDBBase>): Promise<number> {
    const rdbStore = this.getRdbStore();
    try {
      // 指定表名
      let predicates = new relationalStore.RdbPredicates(DB_CONSTANTS.TABLE_NAME);

      // 组装要修改的字段
      const values: relationalStore.ValuesBucket = {};
      // 账户名称
      if (updateData.name !== undefined) {
        values['name'] = updateData.name;
      }
      // 账户备注
      if (updateData.remake !== undefined) {
        values['remake'] = updateData.remake;
      }
      // 账户余额
      if (updateData.accountBalance !== undefined) {
        values['accountBalance'] = updateData.accountBalance;
      }
      // 账户币种
      if (updateData.accountCurrency !== undefined) {
        values['accountCurrency'] = updateData.accountCurrency;
      }
      // 是否计入总资产（默认1计入）
      if (updateData.includedTotalAssets !== undefined) {
        values['includedTotalAssets'] = updateData.includedTotalAssets;
      }
      // 是否记账时可选择（默认1计入）
      if (updateData.isOptional !== undefined) {
        values['isOptional'] = updateData.isOptional;
      }
      predicates.equalTo('id', id);

      // 执行修改
      const updateCount = await rdbStore.update(values, predicates);
      console.log(`修改${updateCount}条资产账户数据`);
      return updateCount;
    } catch (e) {
      throw new Error(`修改资产账户失败: ${e}`);
    }
  }

  /**
   * 资产账户列表使用
   * 查询所有资产账户 (之后添加查询条件，按账本去进行隔离)
   * @returns 资产账户列表
   */
  async queryAssetAccountAll(): Promise<AssetAccountDB[]> {
    const rdbStore = this.getRdbStore();
    let cursor: relationalStore.ResultSet | null = null;
    try {
      // 指定表名
      let predicates = new relationalStore.RdbPredicates(DB_CONSTANTS.TABLE_NAME);
      // 排序规则
      predicates.orderByDesc('createTime');

      // 执行查询
      cursor = await rdbStore.query(
        predicates,
        ['id', 'assetTypeId','name', 'remake', 'accountBalance', 'accountCurrency', 'includedTotalAssets', 'isOptional', 'billId', 'createTime'] // 查询字段
      );

      // 解析查询结果（Cursor转数组）
      const result: AssetAccountDB[] = [];

      // 先判断是否有数据，避免空指针
      if (cursor.rowCount === 0) {
        console.log('暂无资产账户数据');
        return result;
      }

      // 遍历游标，转换数据
      while (cursor.goToNextRow()) {
        result.push({
          id: cursor.getLong(cursor.getColumnIndex('id')),
          assetTypeId: cursor.getLong(cursor.getColumnIndex('assetTypeId')),
          billId: cursor.getLong(cursor.getColumnIndex('billId')),
          name: cursor.getString(cursor.getColumnIndex('name')),
          remake: cursor.getString(cursor.getColumnIndex('remake')),
          accountBalance: cursor.getDouble(cursor.getColumnIndex('accountBalance')),
          accountCurrency: cursor.getString(cursor.getColumnIndex('accountCurrency')),
          includedTotalAssets: cursor.getLong(cursor.getColumnIndex('includedTotalAssets')),
          isOptional: cursor.getLong(cursor.getColumnIndex('isOptional')),
          createTime: cursor.getString(cursor.getColumnIndex('createTime'))
        });
      }
      cursor.close(); // 关闭游标（避免内存泄漏）
      console.log('查询到', result.length, '条资产账户数据');
      return result;
    } catch (e) {
      throw new Error(`查询资产账户失败: ${e}`);
    } finally {
      // 无论是否报错，都关闭游标（避免内存泄漏）
      if (cursor) {
        cursor.close();
      }
    }
  }


  /**
   * 数据转换为 ValuesBucket
   * */
  public createValuesBucket(item: AssetAccountDBBase): relationalStore.ValuesBucket {
    return {
      'assetTypeId': item.assetTypeId,
      'name': item.name,
      'remake': item.remake,
      'accountBalance': item.accountBalance,
      'accountCurrency': item.accountCurrency ?? 'CNY',
      'includedTotalAssets': item.includedTotalAssets ?? 1,
      'isOptional': item.isOptional ?? 1,
      'createTime': new Date().toISOString()
    } as relationalStore.ValuesBucket;
  }

  private getRdbStore(): relationalStore.RdbStore{
    const rdbStore = this.dbManager.getRdbStore();
    if (!rdbStore) {
      throw new Error('数据库未连接');
    }
    return rdbStore;
  }

  // 事务处理
  protected async transaction<T>(callback: () => Promise<T>): Promise<T> {
    const rdbStore = this.getRdbStore();
    if (!rdbStore) {
      throw new Error(`database has not been initialized`);
    }
    try {
      rdbStore.beginTransaction();
      const result = await callback();
      rdbStore.commit();
      return result;
    } catch (err) {
      rdbStore.rollBack();
      const errMsg = `database start transaction failed. error: ${JSON.stringify(err)}`;
      throw new Error(errMsg);
    }
  }
}