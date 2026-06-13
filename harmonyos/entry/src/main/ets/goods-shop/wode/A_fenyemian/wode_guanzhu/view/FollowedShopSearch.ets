@Component
export struct FollowedShopSearch {
  build() {
    Column() {
      Row() {
        Search({ placeholder: '搜索我关注的店铺' })
          .searchButton('搜索', { fontSize: 14, fontColor: '#FFFFFF' })
          .backgroundColor('#FFFFFF')
          .layoutWeight(1)
        Blank()
        Button('搜索')
          .fontSize(14)
          .height(40)
          .type(ButtonType.Normal)
          .fontColor('#FFFFFF')
          .backgroundColor('#FF6666')
      }
      .width('100%')
      .backgroundColor('#FF6666')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.4px',
        bottom: '8.4px',
        left: '8.4px',
        right: '8.4px'
      })

      Column() {
        Image($r('app.media.emoji_image_1_0'))
          .margin(2)
          .width('144px')
          .height('93px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('暂无数据哦~')
          .maxFontSize(14)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: '84.4px',
        bottom: '84.4px',
        left: '0.0px',
        right: '0.0px'
      })
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}