@Component
export struct SearchBarModule {
  build() {
    Row() {
      Text('请输入关键字')
        .fontSize(16)
        .fontColor('#999999')
        .textAlign(TextAlign.Center)
        .layoutWeight(1)
    }
    .width('95%')
    .height(40)
    .backgroundColor('#f5f5f5')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .padding({
      top: '8.4px',
      bottom: '8.4px',
      left: '8.4px',
      right: '8.4px'
    })
    .borderRadius(8)
    .margin({ bottom: 10 })
    .clip(true)
  }
}