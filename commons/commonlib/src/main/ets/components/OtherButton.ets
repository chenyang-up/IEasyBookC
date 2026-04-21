
@ComponentV2
export struct OtherButton {
  build() {
    Column() {
      // 右侧 ... 按钮
      Image($r('app.media.czx_ic_other'))
        .width(40)
        .height(40)
        .borderRadius(20)
        .objectFit(ImageFit.Cover)
        .onClick(() => {
          // 更多操作逻辑
        });
    }
    .borderRadius(20)
    .shadow({ radius: 8, color: '#40000000', offsetX: 2, offsetY: 2 })
  }
}