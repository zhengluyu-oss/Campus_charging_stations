@Component
export struct BatteryHealthOverview {
  build() {
    Column() {
      Row() {
        Text('电池健康概览')
          .maxFontSize(18)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_4_0.png'))
          .margin(2)
          .height('36px').objectFit(ImageFit.Cover).borderRadius(8)
        Blank()
        Text('电池健康得分：--')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .backgroundColor('#E6FFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })

      Text('暂无数据')
        .maxFontSize(14)
        .fontColor('#808080')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .borderRadius(20)
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '17.1px',
      bottom: '17.1px',
      left: '17.1px',
      right: '17.1px'
    })
    .margin({ bottom: 10 })
    .clip(true)
  }
}