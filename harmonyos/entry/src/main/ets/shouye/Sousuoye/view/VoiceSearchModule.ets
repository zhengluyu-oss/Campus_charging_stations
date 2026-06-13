@Component
export struct VoiceSearchModule {
  build() {
    Row() {
      Image($rawfile('shouye/emoji_image_1_0.png'))
        .margin(5)
        .height('64px').objectFit(ImageFit.Cover).borderRadius(8)
      Text('按住 说出要搜的内容')
        .maxFontSize(14)
        .fontColor('black')
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .backgroundColor('white')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '17.1px',
      right: '17.1px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}