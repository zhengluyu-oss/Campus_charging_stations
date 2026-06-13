@Component
export struct ChargeHealthReportModule {
  build() {
    Column() {
      Row() {
        Text('充电体检单')
          .maxFontSize(18)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_8_0.png'))
          .margin(2)
          .height('34px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('100%')

      Row() {
        Text('初始SOC:--')
          .maxFontSize(14)
          .fontColor('#FFA500')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        Text('充电度数:--')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        Text('结束SOC:--')
          .maxFontSize(14)
          .fontColor('#008080')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Image($rawfile('shouye/emoji_image_8_1.png'))
        .margin(2)
        .width('888px')
        .height('10px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}