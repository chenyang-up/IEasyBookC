import { CommonConstants, BackButton, ListGroupName } from 'commonlib'
import { AssetDisplayTypeItem, AssetType, AssetTypeUtil, Constants } from 'asset_base';

/**
 * 资产类型列表页面
 *
 * @author czx
 * @date 2026-03-02
 * */
@Entry
@ComponentV2
struct AssetTypeListPage {
  assetTypeList: AssetDisplayTypeItem[] = AssetTypeUtil.displayTypeList;

  /**
   * 构建分组名称
   * */
  @Builder
  renderGroupHeader(groupName: string) {
    Text(groupName)
      .backgroundColor($r('app.color.system_color_background_auxiliary'))
      .width('100%')
      .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
      .padding(16)
  }

  /**
   * 构建分组内的资产项
   * */
  @Builder
  renderAssetItem(item: AssetDisplayTypeItem) {
    ListItemGroup({ header: this.renderGroupHeader(AssetTypeUtil.getAssetTypeByType(item.type)) }) {
      ListItem() {
        Text(item.name)
          .width('100%')
          .backgroundColor($r('app.color.system_color_background_white'))
          .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
          .padding(16);
      }
      .onClick(() => console.log('选中：', item.name));
    };
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
          ForEach(
            this.assetTypeList, // 第一个参数：要遍历的数组
            (item: AssetDisplayTypeItem) => {
              // 第二个参数：迭代函数，item是当前遍历项
              this.renderAssetItem(item);
            },
            (item: string) => item // 第三个参数：唯一标识（必须！否则列表刷新会出问题）
          );
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