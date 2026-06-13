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
        .height(30)
        .type(ButtonType.Normal)
        .fontColor('#333333')
        .backgroundColor('#ffffff')
    }
    .width('95%')
    .backgroundColor('#f5f5f5')
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