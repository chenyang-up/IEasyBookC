import { Type } from '@kit.ArkUI';
import { AssetType, AssetCategory } from './Enums';
import { AssetGroup, AssetRecordItem, AssetTypeItem } from './Types';

@ObservedV2
export class AssetGroupModel implements AssetGroup {
  @Trace fund: AssetRecordItem[] = [];
  @Trace credit: AssetRecordItem[] = [];
}

export class AssetTypeItemModel implements AssetTypeItem {
  name: string = '';
  type: AssetType = AssetType.FUND;
  subType: number = -1;
  category: AssetCategory = AssetCategory.ASSET;
  isCustom?: boolean;
}

@ObservedV2
export class AssetTypeListModel {
  @Type(AssetTypeItemModel)
  @Trace
  list: AssetTypeItemModel[] = [];
}

@ObservedV2
export class AssetRecordItemModel implements AssetRecordItem {
  @Trace assetId: number = 0;
  @Trace name: string = '';
  @Trace icon: ResourceStr = '';
  @Trace type: AssetType = AssetType.FUND;
  @Trace subType: number = -1;
  @Trace category: AssetCategory = AssetCategory.ASSET;
  @Trace note: string = '';
  @Trace amount: number = 0;
  @Trace isCustom: boolean = false;
}

@ObservedV2
export class AssetAccountRecordItemModel {
  // 资产类型 Id
  @Trace assetId: number = 0;
  // 账户名称
  @Trace name: string = '';
  // 资产类型
  @Trace type: AssetType = AssetType.FUND;
  @Trace subType: number = -1;
  // 资产账户类别
  @Trace category: AssetCategory = AssetCategory.ASSET;
  // 备注
  @Trace note: string = '';
  // 余额
  @Trace balance: number = 0;
  // 账户币种,默认是人民币
  @Trace currency: string = 'CNY';
  // 是否记入总资产, 默认1记入总资产
  @Trace addTotalAssets: number = 1;
  // 记账时可被选择, 默认1可选择
  @Trace selectable: number = 1;
}


