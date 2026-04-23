
@ObservedV2
export class AssetAccountRecordItemReap {
  @Trace id: number = 0;
  // 资产类型 Id
  @Trace assetTypeId: number = 0;
  // 账本类型 Id
  @Trace billId: number = 1;
  // 账户名称
  @Trace name: string = '';
  // 备注
  @Trace remake: string = '';
  // 余额
  @Trace accountBalance: number = 0;
  // 账户币种,默认是人民币
  @Trace accountCurrency: string = 'CNY';
  // 是否记入总资产, 默认1记入总资产
  @Trace includedTotalAssets: number = 1;
  // 记账时可被选择, 默认1可选择
  @Trace isOptional: number = 1;
  // 创建时间
  @Trace createTime: string = '';

  // 补充信息==========================================================
  // 资产类型名称
  @Trace assetTypeName: string = '';
  // 资产类型图标
  @Trace assetTypeIcon: string = '';
  // 资产大类（如Fund）
  @Trace type: number = 1;
}