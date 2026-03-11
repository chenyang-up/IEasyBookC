import { CommonConstants, BackButton, ListGroupName } from 'commonlib'
import { AssetDisplayTypeItem, AssetType, AssetTypeUtil, Constants } from 'asset_base';
import { ServiceContainer } from '../../initializer/ServiceContainer';
import { AssetTypeDB } from 'asset_base/src/main/ets/model/AssetTypeDB';

/**
 * 资产类型列表页面
 *
 * @author czx
 * @date 2026-03-02
 * */
@Entry
@Component
struct AssetTypeListPage {
  @State allAssetTypeList: AssetTypeDB[] = [];
  private serviceContainer = ServiceContainer.getInstance();
  // 分组后的数据
  @State groupedTypes: Map<number, AssetTypeDB[]> = new Map();
  @State letters: number[] = [];

  async aboutToAppear() {
    await this.loadData();
  }

  async loadData() {
    try {
      const assetTypeDBManager = this.serviceContainer.getAssetTypeDBManager();
      this.allAssetTypeList = await assetTypeDBManager.queryAssetAllTypes();

      const grouped = new Map<number, AssetTypeDB[]>();
      // 按类型分组
      this.allAssetTypeList.forEach(item => {
        const type = item.type;
        if (!grouped.has(type)) {
          grouped.set(type, []);
        }
        grouped.get(type)?.push(item);
      });

      // 对每个分组内的数据排序，从小到大
      grouped.forEach((value, key) => {
        value.sort((a, b) => a.subType - b.subType);
      });
      const letters = Array.from(grouped.keys()).sort();
      this.groupedTypes = grouped;
      this.letters = letters;
    } catch (error) {
      console.error('加载失败:', error);
    }
  }

  /**
   * 构建分组名称
   * */
  @Builder
  renderGroupHeader(groupName: string) {
    Text(groupName)
      .fontSize(16)
      .backgroundColor($r('app.color.system_color_background_auxiliary'))
      .width('100%')
      .fontWeight(FontWeight.Medium)
      .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
      .padding({ top: 10 ,bottom: 16 });
  }

  /**
   * 构建分组内的资产项
   * */
  @Builder
  renderAssetItem(item: AssetTypeDB) {
    ListItem() {
      Row() {
        // 图标
        Image($r(item.icon))
          .width(40)
          .height(40)
          .borderRadius(20)
          .margin({ bottom: 10 });
        // 名称
        Text(item.name)
          .fontSize(12)
          .width('100%')
          .backgroundColor($r('app.color.system_color_background_white'))
          .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
          .fontWeight(FontWeight.Regular);
      }.onClick(() => console.log('选中：', item.name + item.id));
    }
  }

  build() {
    Column() {
      // 顶部操作空间=========================================================================================S
      Column() {
        // Stack包裹返回按钮和标题，按钮重叠显示，而非横向排列，标题不再受按钮空间影响
        Stack() {
          Text('选择类型')
            .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Center)
            .width('100%');

          // 返回按钮
          BackButton()
          // 按钮绝对定位在左侧，不占用标题的居中空间，仅视觉上叠加在标题左侧
            .position({
              left: 0,
              top: 0,
              bottom: 0
            })
            .onClick(() => {

            });
        }
      }
      .padding({
        left: $r('app.string.space_l'),
        right: $r('app.string.space_l'),
        top: $r('app.string.space_l'),
      })
      .width('100%')
      .backgroundColor($r('app.color.system_color_background_auxiliary'));

      // 顶部操作空间=========================================================================================E


      // 资产列表区=======================================================================================S
      Column({ space: 16 }) {
        List() {
          ForEach(this.letters, (letter: number) => {
            ListItemGroup({ header: this.renderGroupHeader(AssetTypeUtil.getAssetTypeByType(letter)) }) {
              // 循环渲染该分组下的列表项
              ForEach(this.groupedTypes.get(letter) || [], (item: AssetTypeDB) => {
                ListItem() {
                  this.renderAssetItem(item)
                }

                // .swipeAction({ end: this.deleteButton(item) })  // 可选：滑动删除
              }, (item: AssetTypeDB) => item.id.toString())
            }
            .divider({ strokeWidth: 1, color: '#f0f0f0' })
          }, (letter: string) => letter)
        }
        .width('100%')
        .backgroundColor($r('app.color.system_color_background_white'))
      }
      .padding({
        left: $r('app.string.space_l'),
        right: $r('app.string.space_l'),
        top: $r('app.string.space_l'),
      })
      .layoutWeight(1)
      .backgroundColor($r('app.color.system_color_background_auxiliary'))
      .width('100%')
      .height('100%');

      // 资产列表区=======================================================================================E
    }
    .height($r('app.string.height_percent_full'))
    .width($r('app.string.width_percent_full'))
    .backgroundColor($r('app.color.system_color_background_auxiliary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}