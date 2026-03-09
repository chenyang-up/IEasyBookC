import { Constants } from 'asset_base';
// import { AssetManageUtil } from '../utils/AssetManageUtil';
import { emitter } from '@kit.BasicServicesKit';
import { ASSET_CREATE_EVENT_ID } from '../commons/Constants';

@ComponentV2
export struct AddAssetButton {
  build() {
    Column() {
      Row() {
        // 最左侧添加资产按钮
        Image($r('app.media.czx_ic_add'))
          .width(40)
          .height(40)
          .onClick(() => {
            // 跳转到资产类型列表页
          });

        Row({ space: 16 }) {
          // 右侧 ... 按钮
          Image($r('app.media.czx_ic_other'))
            .width(40)
            .height(40)
            .borderRadius(20) // 圆形头像
            .objectFit(ImageFit.Cover)
            .onClick(() => {
            // 更多操作逻辑
            });

          // 圆形头像
          Image($r('app.media.tx')) // 后期替换为用户头像资源 动态值
            .width(40)
            .height(40)
            .borderRadius(20) // 圆形头像
            .objectFit(ImageFit.Cover);
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween); // 左右两端对齐
    }
    .width('100%')
    .backgroundColor($r('app.color.system_color_background_auxiliary_dev'))
    .padding(16);
  }
}