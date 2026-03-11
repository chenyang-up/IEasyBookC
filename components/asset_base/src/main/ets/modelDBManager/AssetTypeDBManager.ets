import relationalStore from '@ohos.data.relationalStore';
import { AssetTypeDBBase, AssetTypeDB, DB_CONSTANTS } from '../model/AssetTypeDB';
import { AssetConstants } from '../commons/Constants';
import { DatabaseManager } from 'commonlib';


/**
 * 资产类型数据库管理类（封装RelationalStore增删改查）
 *
 * @author czx
 * @date 2026-03-03
 */
export class AssetTypeDBManager {
  private dbManager: DatabaseManager;
  constructor(dbManager: DatabaseManager) {
    this.dbManager = dbManager;
  }

  /**
   * 初始化创建资产类型表
   */
  public async initDB(): Promise<void> {
    // 获取数据库连接实例
    const rdbStore = this.getRdbStore();

    try {
      // 创建资产类型表（不存在则创建）
      const createTableSql = `
        CREATE TABLE IF NOT EXISTS ${DB_CONSTANTS.TABLE_NAME} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          type INTEGER NOT NULL,
          subType INTEGER UNIQUE NOT NULL,
          icon TEXT DEFAULT '',
          isCustom INTEGER DEFAULT 0,
          createTime TEXT DEFAULT CURRENT_TIMESTAMP
        )
      `;
      await rdbStore.executeSql(createTableSql);
      console.log('资产类型表创建成功');

      // 查询资产类型表所有数据
      let typeList: AssetTypeDB[] = await this.queryAssetAllTypes();
      console.log(`当前表中数据条数: ${typeList.length}`);

      // 添加列表
      const addList: Array<AssetTypeDBBase> = [];
      const existingSubTypes = new Set(typeList.map(item => item.subType));
      // 创建初始数据信息
      AssetConstants.ASSET_TYPE_MAP.forEach((item) => {
        if (!existingSubTypes.has(item.subType)) {
          const addInfo: AssetTypeDBBase = {
            name: item.name,
            type: item.type.valueOf(),
            subType: item.subType,
            icon: item.icon.toString(),
            isCustom: 0
          };
          addList.push(addInfo);
        }
      });
      if (addList.length > 0) {
        await this.batchAddAssetType(addList);
        console.log(`新增了 ${addList.length} 条缺失的数据`);
      } else {
        console.log('所有数据都已存在，无需添加');
      }
    } catch (e) {
      console.error('资产类型表初始化失败：', e);
    }
  }

  /**
   * 新增资产类型
   *
   * @param item 资产类型数据（无需传id，自增）
   * @returns 新增数据的id
   */
  async addAssetType(item: AssetTypeDBBase): Promise<number> {
    const rdbStore = this.getRdbStore();
    try {
      // 组装数据（ValuesBucket是RelationalStore的专用数据结构）
      const values: relationalStore.ValuesBucket = this.createValuesBucket(item);
      // 插入数据
      const insertId = await rdbStore.insert(DB_CONSTANTS.TABLE_NAME, values);
      console.log('新增资产类型成功，id：', insertId);
      return insertId;
    } catch (e) {
      throw new Error(`新增资产类型失败: ${e}`);
    }
  }

  /**
   * 删除资产类型（支持按id/子类型删除）
   * @param key 删除维度（id/subType）
   * @param value 对应值
   * @returns 删除的行数
   */
  async deleteAssetType(key: 'id' | 'subType', value: number): Promise<number> {
    const rdbStore = this.getRdbStore();
    try {
      // 指定表名
      let predicates = new relationalStore.RdbPredicates(DB_CONSTANTS.TABLE_NAME);

      // 构建条件
      predicates.equalTo(key, value)

      // 执行删除
      const deleteCount = await rdbStore.delete(predicates);
      console.log(`删除${deleteCount}条资产类型数据`);
      return deleteCount;
    } catch (e) {
      throw new Error(`新增资产类型失败: ${e}`);
    }
  }

  /**
   * 修改资产类型
   * @param id 要修改的id
   * @param updateData 要修改的字段
   * @returns 修改的行数
   */
  async updateAssetType(id: number, updateData: Partial<AssetTypeDBBase>): Promise<number> {
    const rdbStore = this.getRdbStore();
    try {
      // 指定表名
      let predicates = new relationalStore.RdbPredicates(DB_CONSTANTS.TABLE_NAME);

      // 组装要修改的字段
      const values: relationalStore.ValuesBucket = {};
      if (updateData.name !== undefined) {
        values['name'] = updateData.name;
      }
      if (updateData.icon !== undefined) {
        values['icon'] = updateData.icon;
      }
      if (updateData.isCustom !== undefined) {
        values['isCustom'] = updateData.isCustom;
      }
      predicates.equalTo('id', id);

      // 执行修改
      const updateCount = await rdbStore.update(values, predicates);
      console.log(`修改${updateCount}条资产类型数据`);
      return updateCount;
    } catch (e) {
      throw new Error(`修改资产类型失败: ${e}`);
    }
  }

  /**
   * 查询所有资产类型
   * @returns 资产类型列表
   */
  async queryAssetAllTypes(): Promise<AssetTypeDB[]> {
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
        ['id', 'name', 'type', 'subType', 'icon', 'isCustom', 'createTime'] // 查询字段
      );

      // 解析查询结果（Cursor转数组）
      const result: AssetTypeDB[] = [];

      // 先判断是否有数据，避免空指针
      if (cursor.rowCount === 0) {
        console.log('暂无资产类型数据');
        return result;
      }

      // 遍历游标，转换数据
      while (cursor.goToNextRow()) {
        result.push({
          id: cursor.getLong(cursor.getColumnIndex('id')),
          name: cursor.getString(cursor.getColumnIndex('name')),
          type: cursor.getLong(cursor.getColumnIndex('type')),
          subType: cursor.getLong(cursor.getColumnIndex('subType')),
          icon: cursor.getString(cursor.getColumnIndex('icon')),
          isCustom: cursor.getLong(cursor.getColumnIndex('isCustom')),
          createTime: cursor.getString(cursor.getColumnIndex('createTime'))
        });
      }
      cursor.close(); // 关闭游标（避免内存泄漏）
      console.log('查询到', result.length, '条资产类型数据');
      return result;
    } catch (e) {
      throw new Error(`查询资产类型失败: ${e}`);
    } finally {
      // 无论是否报错，都关闭游标（避免内存泄漏）
      if (cursor) {
        cursor.close();
      }
    }
  }

  /**
   * 批量新增资产类型
   * */
  async batchAddAssetType(itemList: AssetTypeDBBase[]) {
    const rdbStore = this.getRdbStore();

    try {
      // 1. 将数据数组转换为 ValuesBucket 数组
      const valueBuckets: relationalStore.ValuesBucket[] = itemList.map(this.createValuesBucket);

      // 2. 执行批量插入
      // batchInsert 内部已使用事务处理，效率高且安全 [citation:7]
      const insertedRows = await rdbStore.batchInsert(
        DB_CONSTANTS.TABLE_NAME,
        valueBuckets
      );
      console.log(`批量插入成功，插入行数: ${insertedRows}`);
    } catch (e) {
      console.error('批量插入失败:', e);
      throw new Error(`批量插入资产类型失败: ${e}`);
    }
  }

  /**
   * 数据转换为 ValuesBucket
   * */
  public createValuesBucket(item: AssetTypeDBBase): relationalStore.ValuesBucket {
    return {
      'name': item.name,
      'type': item.type,
      'subType': item.subType,
      'icon': item.icon ?? '',
      'isCustom': item.isCustom ?? 0,
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
}