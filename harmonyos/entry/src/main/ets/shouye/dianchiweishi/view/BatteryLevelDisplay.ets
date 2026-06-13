@Component
export struct BatteryLevelDisplay {
  build() {
    Row() {
      Button()
        .fontSize(14)
        .height(40)
        .type(ButtonType.Capsule)
        .fontColor('#000000')
        .backgroundColor('#D0E8FF')
      Blank()
      Text('电池级别：--')
        .maxFontSize(14)
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .backgroundColor('#F0F8FF')
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