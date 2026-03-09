
@ComponentV2
export struct AvatarButton {
  build() {
    Column() {
      // 圆形头像
      Image($r('app.media.tx')) // 后期替换为用户头像资源 动态值
        .width(40)
        .height(40)
        .borderRadius(20) // 圆形头像
        .objectFit(ImageFit.Cover);
    }
  }
}