import { AssetTypeDBManager, RdbStoreConfig } from 'asset_base'
import { DBConstants , DatabaseManager} from 'commonlib'

import relationalStore from '@ohos.data.relationalStore';
import { common } from '@kit.AbilityKit';

/**
 * 数据初始化工具
 *
 * @author czx
 * @date 2026-03-06
 * */
export class ServiceContainer {
  private static instance: ServiceContainer;
  private context: common.Context | null = null;
  // 数据库连接管理
  private dbManager: DatabaseManager | null = null;
  // 资产类型数据库管理
  private assetTypeDBManager: AssetTypeDBManager | null = null;

  private constructor() {}

  public static getInstance(): ServiceContainer {
    if (!ServiceContainer.instance) {
      ServiceContainer.instance = new ServiceContainer();
    }
    return ServiceContainer.instance;
  }

  /**
   * 初始化容器（在应用启动时调用）
   */
  public async initialize(context: common.Context): Promise<void> {
    console.log('初始化服务容器...');
    this.context = context;

    try {
      // 按依赖顺序初始化服务
      this.dbManager = new DatabaseManager(context);
      // 创建数据库，连接
      await this.dbManager.initialize();

      // 初始化其他服务===================================================================S
      // 资产类型管理
      this.assetTypeDBManager = new AssetTypeDBManager(this.dbManager);
      // 资产类型管理数据初始化
      await this.assetTypeDBManager.initDB();
      // 初始化其他服务===================================================================E

      console.log('数据库初始化流程完成');
    } catch (error) {
      console.error('数据库初始化失败:', error);
      new Error('数据库初始化失败');
    }

  }

  /**
   * 获取资产类型服务的接口
   * */
  public getAssetTypeDBManager(): AssetTypeDBManager {
    if (!this.assetTypeDBManager) {
      throw new Error('AssetTypeDBManager 未初始化，请先调用 initialize');
    }
    return this.assetTypeDBManager;
  }

}