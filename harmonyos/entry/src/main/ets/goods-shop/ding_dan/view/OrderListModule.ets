@Component
export struct OrderListModule {
  build() {
    Row() {
      Image($rawfile('shangcheng/A_common/zuojiantou.png'))
        .margin(2)
        .height('59px').objectFit(ImageFit.Cover).borderRadius(8)
      Blank()
      Text('订单列表')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Blank()
      Image($rawfile('shangcheng/A_common/share.png'))
        .margin(2)
        .height('59px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '8.4px',
      bottom: '8.4px',
      left: '8.4px',
      right: '8.4px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}