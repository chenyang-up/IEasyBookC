import { CommonHeader , AvatarButton} from 'commonlib';
import { AddAssetButton , OtherButton} from 'asset_manage';
import router from '@ohos.router';

/**
 * 资产主页
 *
 * @author czx
 * @date 2026-03-01
 * */
@Entry
@Component
struct AssetsAdminPage {
  build() {
    Column() {
      // 顶部操作空间=========================================================================================S
      Column({ space: 16 }) {
        Row() {
          // 添加资产按钮
          AddAssetButton()
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

      // 主要卡片信息区=======================================================================================S
      Column({ space: 16 }) {

      }
      .padding({
        left: $r('app.string.space_l'),
        right: $r('app.string.space_l'),
        top: $r('app.string.space_l'),
      })
      .layoutWeight(1);
      // 主要卡片信息区=======================================================================================E
    }
    .height($r('app.string.height_percent_full'))
    .width($r('app.string.width_percent_full'))
    .backgroundColor($r('app.color.system_color_background_auxiliary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }

  /**
   * navigateToAssetTypeListPage 跳转到资产类型列表页面
   *
   * */
  private async navigateToAssetTypeListPage() {
    console.log('===== 开始执行跳转 =====');
    try {
      const targetUrl = 'pages/assets/AssetTypeListPage';
      await router.pushUrl({
        url: targetUrl,
      });
      console.info('成功跳转到 AssetTypeListPage');
    } catch (err) {
      console.error('跳转 AssetTypeListPage 失败: ' + JSON.stringify(err));
    }
  }
}