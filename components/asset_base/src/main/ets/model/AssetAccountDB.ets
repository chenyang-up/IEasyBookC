import { DBConstants } from 'commonlib'

// 资产账户信息数据模型（数据库表结构对应）基础字段
export interface AssetAccountDBBase {
  assetTypeId: number, // 资产类型 Id
  name: string; // 账户名称
  remake: string; // 账户备注
  accountBalance: number; // 账户余额
  accountCurrency: string; // 账户币种
  includedTotalAssets: number; // 是否计入总资产（默认1计入）
  isOptional: number // 是否记账时可选择

  // 预留字段
  billId: number// 账单id
}

// 完整接口（继承基础字段 + 自动字段）
export interface AssetAccountDB extends AssetAccountDBBase {
  id: number; // 主键（自增）
  createTime: string; // 创建时间
}

// 3. 数据库常量
interface GeneratedObjectLiteralInterface_1 {
  DB_NAME: string;
  TABLE_NAME: string;
  SECURITY_LEVEL: number;
}

export const DB_CONSTANTS: GeneratedObjectLiteralInterface_1 = {
  DB_NAME: DBConstants.DB_NAME, // 数据库名
  TABLE_NAME: 'asset_account', // 资产账户表名
  SECURITY_LEVEL: DBConstants.SECURITY_LEVEL          // 安全级别（S1）
};