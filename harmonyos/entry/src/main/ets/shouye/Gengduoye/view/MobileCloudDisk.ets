@Component
export struct MobileCloudDisk {
  build() {
    Column() {
      Text('其他')
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
      Column() {
        Image($rawfile('shouye/emoji_image_7_0.png'))
          .margin(2)
          .width('85px')
          .height('65px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('移动云盘')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Start)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })
    }
    .width('95%')
    .backgroundColor('#F5F5F5')
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