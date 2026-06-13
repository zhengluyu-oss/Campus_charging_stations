@Component
export struct BatteryStatusSummary {
  build() {
    Column() {
      Row() {
        Text('当前电池估价')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_9_0.png'))
          .margin(2)
          .height('30px').objectFit(ImageFit.Cover).borderRadius(8)
        Blank()
        Text('当前满电续航')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_9_1.png'))
          .margin(2)
          .height('30px').objectFit(ImageFit.Cover).borderRadius(8)
        Blank()
        Text('电池故障率')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_9_2.png'))
          .margin(2)
          .height('30px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .width('100%')
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '17.1px',
        right: '17.1px'
      })

      Row() {
        Text('--')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        Text('--')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        Text('--')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '17.1px',
        right: '17.1px'
      })

      Row() {
        Text('更多电池参数')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_9_3.png'))
          .margin(2)
          .height('21px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .width('100%')
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .padding({
        top: '17.1px',
        bottom: '17.1px',
        left: '17.1px',
        right: '17.1px'
      })
    }
    .width('95%')
    .borderRadius(20)
    .backgroundColor('#ffffff')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .margin({ bottom: 10 })
    .clip(true)
  }
}