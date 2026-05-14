import { CommonConstants, BackButton, ListGroupName } from 'commonlib'
import { AssetDisplayTypeItem, AssetType, AssetTypeUtil, Constants } from 'asset_base';
import { ServiceContainer } from '../../initializer/ServiceContainer';
import { AssetTypeDB } from 'asset_base/src/main/ets/model/AssetTypeDB';
import { curves, router } from '@kit.ArkUI';

@Builder
export function AssetTypeListPageBuilder() {
  AssetTypeListPage()
}

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
  // 展开状态 map
  @State expandMap: Map<number, boolean> = new Map();

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
  renderAssetItem(item: AssetTypeDB) {
    ListItem() {
      Row() {
        // 图标
        Image($r(item.icon))
          .width(40)
          .height(40)
          .borderRadius(20)
          .margin(10);
        Blank()
        // 名称
        Text(item.name)
          .fontSize(12)
          .width('100%')
          .fontColor(CommonConstants.FONT_COLOR_LEVEL1)
          .fontWeight(FontWeight.Regular)
      }
      .width('100%')
      .animation({ curve: curves.interpolatingSpring(0, 1, 528, 39) })
      .onClick(() => console.log('选中：', item.name + item.id))
    }
    .width("100%")
  }

  build() {
    NavDestination() {
      Column() {
        Text('测试页面')
          .fontSize(30)
          .backgroundColor(Color.Red)
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Red)
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}