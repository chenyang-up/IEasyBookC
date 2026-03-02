import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
            this.navigateToAssetsAdminPage();
        })
    }
    .height('100%')
    .width('100%')
  }

  // 跳转到 assets 模块的页面
  private async navigateToAssetsAdminPage() {
    console.log('===== 开始执行跳转 =====');
    try {
      const targetUrl = 'pages/assets/AssetsAdminPage';
      await router.pushUrl({
        url: targetUrl,
      });
      console.info('成功跳转到 AssetsAdminPage');
    } catch (err) {
      console.error('跳转 AssetsAdminPage 失败: ' + JSON.stringify(err));
    }
  }
}