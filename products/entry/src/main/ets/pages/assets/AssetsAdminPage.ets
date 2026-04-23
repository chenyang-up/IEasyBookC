import { AssetAccountRecordItemReap, AssetTypeUtil } from 'asset_base';
import { AssetAccountDB } from 'asset_base/src/main/ets/model/AssetAccountDB';
import { CommonHeader , AvatarButton, AddButton , OtherButton, CommonConstants, CommonUtil} from 'commonlib';
import { ServiceContainer } from '../../initializer/ServiceContainer';
import { curves, router } from '@kit.ArkUI';



@Builder
export function AssetsAdminPageBuilder() {
  AssetsAdminPage()
}
/**
 * 资产主页
 *
 * @author czx
 * @date 2026-03-01
 * */
@Entry
@Component
export struct AssetsAdminPage {
  private navStack: NavPathStack = new NavPathStack();
  private serviceContainer = ServiceContainer.getInstance();

  // 分组排序后的数据
  @State groupedTypes: Map<number, AssetAccountRecordItemReap[]> = new Map();
  @State letters: number[] = [];
  @State allAssetAccountList: AssetAccountDB[] = [];

  // 展开状态 map
  @State expandMap: Map<number, boolean> = new Map();


  async aboutToAppear() {
    await this.loadData();
    this.navStack.clear();
  }

  async loadData() {
    try {
      const assetAccountDBManager = this.serviceContainer.getAssetAccountDBManager();
      const assetTypeDBManager = this.serviceContainer.getAssetTypeDBManager();
      // 全部账户信息
      this.allAssetAccountList = await assetAccountDBManager.queryAssetAccountAll();
      if (this.allAssetAccountList.length <= 0) {
        this.letters = [];
        this.groupedTypes.clear();
        return;
      }
      // 所有账户类型id列表
      const assetTypeIds = this.allAssetAccountList.map(item => item.assetTypeId);
      // 查询类型信息
      const assetTypes = await assetTypeDBManager.queryAssetTypesByIds(assetTypeIds);
      const typeMap = new Map(
        assetTypes.map(item => [item.id, item])
      );

      // 准备数据
      let allRecordList: AssetAccountRecordItemReap[] = [];
      this.allAssetAccountList.map(item => {
        let infoRecord: AssetAccountRecordItemReap = new AssetAccountRecordItemReap()
        // 拷贝字段值
        infoRecord.id = item.id;
        infoRecord.name = item.name;
        infoRecord.assetTypeId = item.assetTypeId;
        infoRecord.remake = item.remake;
        infoRecord.accountBalance = item.accountBalance;
        infoRecord.accountCurrency = item.accountCurrency;
        infoRecord.includedTotalAssets = item.includedTotalAssets;
        infoRecord.isOptional = item.isOptional;
        infoRecord.createTime = item.createTime;

        // 补充信息填充
        const typeInfo = typeMap.get(item.assetTypeId);
        if (typeInfo != null) {
          infoRecord.assetTypeName = typeInfo.name;
          infoRecord.assetTypeIcon = typeInfo.icon;
          infoRecord.type = typeInfo.type;
        }
        allRecordList.push(infoRecord);
      })

      const grouped = new Map<number, AssetAccountRecordItemReap[]>();
      // 按类型分组
      allRecordList.forEach(item => {
        const type = item.type;
        if (!grouped.has(type)) {
          grouped.set(type, []);
        }
        grouped.get(type)?.push(item);
      });
      // 按照时间排序
      grouped.forEach((value, key) => {
        value.sort((a, b) => a.createTime.localeCompare(b.createTime));
      });

      this.letters = Array.from(grouped.keys()).sort();
      this.groupedTypes = grouped;

      // 默认全部展开
      this.letters.forEach(letter => {
        this.expandMap.set(letter, true);
      });
    } catch (error) {
      console.error('加载失败:', error);
    }
  }

  // 折叠/展开平滑动画
  toggleGroup(letter: number) {
    animateTo({ duration: 300 }, () => {
      const current = this.expandMap.get(letter) ?? true;
      this.expandMap.set(letter, !current);
      this.expandMap = new Map(this.expandMap);
    });
  }

  /**
   * 构建分组名称
   * */
  @Builder
  renderGroupHeader(letter: number) {
    Row() {
      Text(AssetTypeUtil.getAssetTypeByType(letter))
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
        .layoutWeight(1)
      Image(this.expandMap.get(letter) ?? true ? $r('app.media.czx_ic_collapse') : $r('app.media.czx_ic_expand'))
        .width(16)
        .height(16)
        .margin({right: 8 })
    }
    .width("100%")
    .height(48)
    .padding({top: 10, bottom: 10, left: 5})
    .onClick(() => this.toggleGroup(letter))
  }

  /**
   * 构建分组内的资产项
   * */
  @Builder
  renderAssetAccountRecordItem(item: AssetAccountRecordItemReap) {
    ListItem() {
      Row() {
        // 图标
        Image($r(item.assetTypeIcon))
          .width(40)
          .height(40)
          .borderRadius(20)
          .margin(10);
        Column() {
          // 名称
          Text(item.name)
            .fontSize(16)
            .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
            .fontWeight(FontWeight.Bolder)
            .textAlign(TextAlign.Start)
            .alignSelf(ItemAlign.Start)
          Text(item.remake)
            .fontSize(12)
            .fontColor(CommonConstants.FONT_COLOR_LEVEL2)
            .fontWeight(FontWeight.Regular)
            .textAlign(TextAlign.Start)
            .alignSelf(ItemAlign.Start)
            .margin({ top: 2 }); // 与名称间距
          Text(item.assetTypeName)
            .fontSize(12)
            .fontColor(CommonConstants.FONT_COLOR_LEVEL2)
            .fontWeight(FontWeight.Regular)
            .textAlign(TextAlign.Start)
            .alignSelf(ItemAlign.Start)
            .margin({ top: 4 }); // 与备注间距
        }
        .flexGrow(1)
        .margin({top:10, bottom:10});

        Column() {
          // 金额
          Text('¥' + CommonUtil.formatNumberToThousands(item.accountBalance))
            .fontSize(16)
            .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
            .fontWeight(FontWeight.Regular)
            .textAlign(TextAlign.End)
        }
        .margin({top:10, bottom:10, right:10});
      }
      .width('100%')
      .animation({ curve: curves.interpolatingSpring(0, 1, 528, 39) })
      .onClick(() => {
        // 跳转到资产账户-账单列表页面
        // this.navStack.pushPath({
        //   name: 'AddAssetAccount',
        //   param: item.id
        // });
      })
    }
    .width("100%")
  }

  build() {
    NavDestination() {
      Column() {
        // 顶部操作空间=========================================================================================S
        Column({ space: 16 }) {
          Row() {
            // 添加资产按钮
            AddButton()
              .onClick(() => {
                // 进入到资产类型列表页面
                this.navigateToAssetTypeListPage();
              });

            Row({ space: 16 }) {
              // 其他按钮
              OtherButton()
                .onClick(() => {
                  // 其他设置页面
                });

              // 圆形头像按钮
              AvatarButton()
                .onClick(() => {
                  // 进入到用户信息页面
                });
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween);
        }
        .padding({
          left: $r('app.string.space_l'),
          right: $r('app.string.space_l'),
          top: $r('app.string.space_l'),
        })
        .backgroundColor($r('app.color.system_color_background_auxiliary'));
        // 顶部操作空间=========================================================================================E

        // 页面标题头部组件
        CommonHeader({ title: '资产' });

        // TODO 汇总卡片位置 =======================================================================================S
        Column() {

        }
        .padding({
          left: $r('app.string.space_l'),
          right: $r('app.string.space_l'),
          top: $r('app.string.space_l'),
        })
        .height(36)
        .width('100%')
        .backgroundColor(Color.Blue)
        // TODO 汇总卡片位置 =======================================================================================E

        // 资产账户列表信息区=======================================================================================S
        Column() {
          List({ space: 12 }) {
            ForEach(this.letters, (letter: number) => {
              ListItemGroup({
                header: this.renderGroupHeader(letter),
                style: ListItemGroupStyle.CARD   // 设置为卡片样式
              }) {
                if (this.expandMap.get(letter) ?? true) {
                  // 循环渲染该分组下的列表项
                  ForEach(this.groupedTypes.get(letter) || [], (item: AssetAccountRecordItemReap) => {
                    ListItem() {
                      this.renderAssetAccountRecordItem(item)
                    }
                  }, (item: AssetAccountRecordItemReap) => item.id.toString())
                }
              }
              .borderRadius(12)
              .divider({ strokeWidth: 1, color: '#f0f0f0' })
              .backgroundColor($r('app.color.system_color_background_white'))
            }, (letter: string) => letter)
          }
          .width('100%')
          .height('100%')
        }
        .backgroundColor($r('app.color.system_color_background_auxiliary'))
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .layoutWeight(1);
        // 资产账户列表信息区=======================================================================================E
      }
      .height($r('app.string.height_percent_full'))
      .width($r('app.string.width_percent_full'))
      .backgroundColor($r('app.color.system_color_background_auxiliary'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.navStack = context.pathStack;
    })
  }

  /**
   * navigateToAssetTypeListPage 跳转到资产类型列表页面
   *
   * */
  private async navigateToAssetTypeListPage() {
    console.log('===== 开始执行跳转 =====');
    try {
      this.navStack.pushPath({
        name: 'AssetTypeListPage',
      });
      console.info('成功跳转到 AssetTypeListPage');
    } catch (err) {
      console.error('跳转 AssetTypeListPage 失败: ' + JSON.stringify(err));
    }
  }
}
