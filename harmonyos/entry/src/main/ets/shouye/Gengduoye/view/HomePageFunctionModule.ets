@Component
export struct HomePageFunctionModule {
  build() {
    Row() {
      Text('首页功能')
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
      Blank()
      Text('已添加9个功能')
        .maxFontSize(14)
        .fontColor('#666666')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Image($rawfile('shouye/emoji_image_10_0.png'))
        .margin(2)
        .height('54px').objectFit(ImageFit.Cover).borderRadius(8)
      Image($rawfile('shouye/emoji_image_10_1.png'))
        .margin(2)
        .height('56px').objectFit(ImageFit.Cover).borderRadius(8)
      Image($rawfile('shouye/emoji_image_10_2.png'))
        .margin(2)
        .height('54px').objectFit(ImageFit.Cover).borderRadius(8)
      Image($rawfile('shouye/emoji_image_10_3.png'))
        .margin(2)
        .height('16px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
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