
@ComponentV2
export struct AddButton {
  build() {
    Column() {
      // 最左侧添加资产按钮
      Image($r('app.media.czx_ic_add'))
        .width(40)
        .height(40)
    }
    .borderRadius(20)
    .shadow({ radius: 8, color: '#40000000', offsetX: 2, offsetY: 2 })
  }
}