import { CommonHeader } from 'commonlib';

/**
 * 资产主页
 * @author czx
 * @date
 * */
@Entry
@Component
struct AssetsAdminPage {
  // build() {
  //   Column() {
  //     Button("进入到选择资产类型列表页")
  //       .onClick(() => {
  //
  //       })
  //       .fontSize(20) // 增大字体，更易识别
  //       .width('80%') // 按钮宽度设为屏幕80%
  //       .height(60) // 按钮高度
  //       .backgroundColor('#007DFF') // 按钮背景色（可选）
  //       .fontColor(Color.White) // 字体颜色（可选）
  //   }
  //   .width('100%') // 根容器宽度占满屏幕
  //   .height('100%') // 根容器高度占满屏幕
  //   .justifyContent(FlexAlign.Center) // 内容垂直居中
  //   .alignItems(HorizontalAlign.Center) // 内容水平居中
  // }
  build() {
    Column() {
      // 顶部操作空间=========================================================================S
      Column({ space: 16 }) {

        AddAssetButton({
          handleSuccess: () => {
            this.vm.assetProcessing.getAssetReport();
          },
        });
      }
      .padding({
        left: $r('app.string.space_l'),
        right: $r('app.string.space_l'),
        top: $r('app.string.space_l'),
      })
      .layoutWeight(1);
      // 顶部操作空间=========================================================================E

      // 页面标题头部组件
      CommonHeader({ title: '资产' });

      // 主要卡片信息区=======================================================================S
      Column({ space: 16 }) {

      }
      .padding({
        left: $r('app.string.space_l'),
        right: $r('app.string.space_l'),
        top: $r('app.string.space_l'),
      })
      .layoutWeight(1);
      // 主要卡片信息区=======================================================================E
    }
    .height($r('app.string.height_percent_full'))
    .width($r('app.string.width_percent_full'))
    .backgroundColor($r('app.color.system_color_background_auxiliary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);

  }
}