@Component
export struct CumulativeChargeStatistics {
  build() {
    Column() {
      Row() {
        Image($rawfile('shouye/emoji_image_42_0.png'))
          .margin(2)
          .height('103px').objectFit(ImageFit.Cover).borderRadius(8)
        Text('TELD')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text('特来电')
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('100%')

      Text('平台累计充电量已达598.44亿度')
        .maxFontSize(14)
        .fontColor('#888888')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .alignItems(HorizontalAlign.Center)
    .padding({ top: '8.6px', bottom: '8.6px' })
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}