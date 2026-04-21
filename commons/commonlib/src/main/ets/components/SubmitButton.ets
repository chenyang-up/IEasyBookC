@ComponentV2
export struct SubmitButton {
  build() {
    Column() {
      Image($r('app.media.czx_ic_submit_button'))
        .width(40)
        .height(40)
    }
    .borderRadius(20)
    .shadow({ radius: 8, color: '#40000000', offsetX: 2, offsetY: 2 })
  }
}