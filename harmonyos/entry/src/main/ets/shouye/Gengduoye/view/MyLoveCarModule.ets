@Component
export struct MyLoveCarModule {
  build() {
    Column() {
      Text('我的爱车')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Image($rawfile('shouye/emoji_image_5_0.png'))
        .margin(2)
        .width('74px')
        .height('71px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
      Text('我的爱车')
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
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