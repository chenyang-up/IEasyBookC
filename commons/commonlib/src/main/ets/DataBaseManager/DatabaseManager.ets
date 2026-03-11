// DatabaseManager.ets - 全局数据库连接管理器
import relationalStore from '@ohos.data.relationalStore';
import { common } from '@kit.AbilityKit';
import { DBConstants } from '../constants/DBConstants';
import { RdbStoreConfig } from './RdbStoreConfig';

/**
 * 全局数据库连接管理器（单例）
 */
export class DatabaseManager {
  private rdbStore: relationalStore.RdbStore | null = null;
  private isInitialized: boolean = false;
  private context: common.Context;

  constructor(context: common.Context) {
    this.context = context;
  }

  /**
   * 初始化数据库连接
   */
  public async initialize(): Promise<void> {
    if (this.isInitialized && this.isConnected()) {
      console.log('数据库已初始化');
      return;
    }
    // 数据库配置信息
    const config: RdbStoreConfig = {
      name: DBConstants.DB_NAME,
      securityLevel: relationalStore.SecurityLevel[`S${DBConstants.SECURITY_LEVEL}`],
      createIfMissing: true,
      encrypt: false,
      readOnly: false
    };

    let retryCount: number = 0;
    while (retryCount <= 3) {
      try {
        console.log(`[数据库] 第${retryCount+1}次尝试连接`);
        this.rdbStore = await relationalStore.getRdbStore(this.context, config);
        this.isInitialized = true;
        console.log('数据库连接成功');
        return;
      } catch (error) {
        retryCount++;
        console.error(`[数据库] 第${retryCount}次失败：`, error.message);
        // 每次重试延迟2秒（给模拟器服务足够启动时间）
        await new Promise<void>(resolve => setTimeout(resolve, 2000));
      }
    }
    throw new Error("数据库连接失败：已重试3次");
  }

  /**
   * 获取数据库连接（供其他Manager使用）
   */
  public getRdbStore(): relationalStore.RdbStore {
    if (!this.isInitialized || !this.rdbStore) {
      throw new Error('数据库未初始化');
    }
    return this.rdbStore;
  }

  /**
   * 执行事务
   */
  public async transaction<T>(action: () => Promise<T>): Promise<T> {
    const rdbStore = this.getRdbStore();
    try {
      await rdbStore.beginTransaction();
      const result = await action();
      await rdbStore.commit();
      return result;
    } catch (error) {
      await rdbStore.rollBack();
      throw new Error('数据库事务执行失败');
    }
  }

  /**
   * 检查是否已连接
   */
  public isConnected(): boolean {
    return this.rdbStore !== null;
  }
}