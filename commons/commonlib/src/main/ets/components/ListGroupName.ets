
/**
 * 有分组的列表数据的分组名称设置
 *
 * @author czx
 * @date 2026-03-02
 * */
@ComponentV2
export struct ListGroupName {
  @Param groupName: string = '';

  build() {
    Column() {
      Text(this.groupName)
        .fontSize(20)
        .backgroundColor($r('app.color.system_color_background_auxiliary'))
        .width('100%')
        .padding(5)
    }
  }
}