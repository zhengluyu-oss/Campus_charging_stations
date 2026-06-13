@Component
export struct SearchBarModule {
  build() {
    Row() {
      Text('巴音郭…')
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Image($rawfile('shouye/emoji_image_1_0.png'))
        .margin(2)
        .height('17px').objectFit(ImageFit.Cover).borderRadius(8)
      Search({ placeholder: '目的地/电站名…' })
        .placeholderFont({ size: 14 })
        .backgroundColor('#ffffff')
        .layoutWeight(1)
      Image($rawfile('shouye/emoji_image_1_0.png'))
        .margin(2)
        .height('17px').objectFit(ImageFit.Cover).borderRadius(8)
      Image($rawfile('shouye/emoji_image_1_0.png'))
        .margin(2)
        .height('17px').objectFit(ImageFit.Cover).borderRadius(8)
      Image($rawfile('shouye/emoji_image_1_0.png'))
        .margin(2)
        .height('17px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('95%')
    .backgroundColor('#ffffff')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
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