@Component
export struct PersonalCenterModule {
  build() {
    Row() {
      Image($r('app.media.emoji_image_14_0'))
        .margin(5)
        .height('100px').objectFit(ImageFit.Cover).borderRadius(8)
      Blank()
      Text('个人中心')
        .margin(5).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
      Blank()
      Image($rawfile('shangcheng/A_common/share.png'))
        .margin(5)
        .height('100px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '12.5px',
      bottom: '12.5px',
      left: '12.5px',
      right: '12.5px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}