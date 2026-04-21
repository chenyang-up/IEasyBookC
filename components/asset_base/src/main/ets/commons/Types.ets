import { AssetCategory, AssetType } from './Enums';

export interface AssetRecordItem {
  assetId: number;
  name: string;
  icon: ResourceStr;
  type: AssetType;
  subType: number;
  category: AssetCategory;
  amount: number;
  note?: string;
  isCustom?: boolean;
}

export interface AssetSummary {
  totalAsset: number;
  totalLiability: number;
}

export interface AssetReportRsp extends AssetSummary {
  assets: AssetRecordItem[];
}

export interface AssetGroup {
  fund: AssetRecordItem[];
  credit: AssetRecordItem[];
}

export interface AssetTypeItem {
  name: string;
  type: AssetType;
  subType: number;
  category: AssetCategory;
  isCustom?: boolean;
}

export interface AssetDisplayTypeItem extends AssetTypeItem {
  icon: ResourceStr;
}

/**
 * 币种类型
 * */
export interface AssetCurrency {
  // 币种代码
  code: string;
  // 币种名称
  name: string;
  // 币种图标
  icon: string;
  // 币种备注
  note: string;
  // 汇率
  rate: number;
}
