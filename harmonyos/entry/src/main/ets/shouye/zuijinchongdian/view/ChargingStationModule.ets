@Component
export struct ChargingStationModule {
  @State currentTab: number = 0; // 0: 充电站, 1: 充电终端

  build() {
    Column() {
      // 空状态内容区
      Column() {
        // 插图
        Image($rawfile('shouye/emoji_image_1_0.png'))
          .width(120)
          .height(120)
          .objectFit(ImageFit.Contain)
          .margin({ bottom: 16 })
        // 提示文字
        Text('最近还没有充电呢')
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }
}