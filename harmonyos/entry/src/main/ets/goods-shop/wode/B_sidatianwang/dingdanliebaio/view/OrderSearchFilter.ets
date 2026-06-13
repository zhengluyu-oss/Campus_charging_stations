@Component
export struct OrderSearchFilter {
  build() {
    Row() {
      Search({ placeholder: '搜索我的订单' })
        .placeholderFont({ size: 14 })
        .backgroundColor('#ffffff')
        .layoutWeight(1)
      Blank()
      Button('筛选')
        .fontSize(14)
        .height(20)
        .type(ButtonType.Normal)
        .fontColor('#000000')
        .backgroundColor('#ffffff')
    }
    .width('95%')
    .backgroundColor('#f5f5f5')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
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