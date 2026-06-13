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
      .width('100%')
      .backgroundColor('#ffffff')
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
          .width('691px')
          .height('135px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('暂时没有订单哟~')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .backgroundColor('#f5f5f5')
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: '84.4px',
        bottom: '84.4px',
        left: '0.0px',
        right: '0.0px'
      })
    }
    .width('95%')
    .backgroundColor('#ffffff')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}