import { CommonHeader , AvatarButton, AddButton , OtherButton} from 'commonlib';

/**
 * 资产主页
 *
 * @author czx
 * @date 2026-03-01
 * */
@Entry
@ComponentV2
struct AssetsAdminPage {
  private navStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.navStack) {
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
    .mode(NavigationMode.Stack)

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
