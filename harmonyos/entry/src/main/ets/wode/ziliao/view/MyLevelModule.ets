@Component
export struct MyLevelModule {
  build() {
    Row() {
      Text('我的等级')
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
      Blank()
      Text('普卡会员')
        .maxFontSize(14)
        .fontColor('#888888')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Image($rawfile("wode/emoji_image_11_0.png"))
        .margin(2)
        .height('27px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '9.2px',
      bottom: '9.2px',
      left: '18.5px',
      right: '18.5px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}