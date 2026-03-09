import { DBConstants } from 'commonlib'

// 资产类型数据模型（数据库表结构对应）基础字段
export interface AssetTypeDBBase {
  name: string; // 类型名称（如“支付宝/现金/微信”）
  type: number; // 资产大类（如Fund）
  subType: number; // 子类型编码（唯一标识）
  icon: string; // 图标资源名
  isCustom: number; // 是否自定义类型
}

// 完整接口（继承基础字段 + 自动字段）
export interface AssetTypeDB extends AssetTypeDBBase {
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
  TABLE_NAME: 'asset_type', // 资产类型表名
  SECURITY_LEVEL: DBConstants.SECURITY_LEVEL          // 安全级别（S1）
};