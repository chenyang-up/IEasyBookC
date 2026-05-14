import { relationalStore } from "@kit.ArkData";

/**
 * RelationalStore的配置结构
 *
 * @author czx
 * @date 2026-03-03
 * */
export interface RdbStoreConfig {
  name: string; // 数据库名（必填）
  securityLevel: relationalStore.SecurityLevel; // 安全级别（必填）
  createIfMissing?: boolean,
  encrypt?: boolean, // 加密（可选）
  readOnly?: boolean
  // 可补充其他可选字段（如数据库版本、存储路径等），按需添加
}