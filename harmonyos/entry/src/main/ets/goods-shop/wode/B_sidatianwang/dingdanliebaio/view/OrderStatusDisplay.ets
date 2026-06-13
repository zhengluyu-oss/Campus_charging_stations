@Component
export struct OrderStatusDisplay {
  build() {
    Column() {
      Row() {
        Text('全部')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text('待付款')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text('待收货/使用')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text('待评价')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text('退款/售后')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })
      .width('100%')

      Column() {
        Image($r('app.media.emoji_image_2_0'))
          .margin(2)
          .width('736px')
          .height('171px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('暂时没有订单哟~')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })
    }
    .width('95%')
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}