@Component
export struct BatteryHealthScore {
  build() {
    Column() {
      Row() {
        Text('电池健康得分')
          .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
        Image($rawfile('shouye/emoji_image_20_0.png'))
          .margin(2)
          .height('42px').objectFit(ImageFit.Cover).borderRadius(8)
        Blank()
        Button('查看报告模板')
          .fontSize(16)
          .height(40)
          .type(ButtonType.Capsule)
          .fontColor('#FFFFFF')
          .backgroundColor('#00B050')
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '17.1px',
        right: '17.1px'
      })

      Row() {
        Image($rawfile('shouye/emoji_image_20_1.png'))
          .margin(2)
          .height('25px').objectFit(ImageFit.Cover).borderRadius(8)
        Image($rawfile('shouye/emoji_image_20_2.png'))
          .margin(2)
          .height('25px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '17.1px',
        right: '17.1px'
      })
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '17.1px',
      bottom: '17.1px',
      left: '17.1px',
      right: '17.1px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}