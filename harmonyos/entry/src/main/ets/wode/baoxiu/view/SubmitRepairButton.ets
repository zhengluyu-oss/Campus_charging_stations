@Component
export struct SubmitRepairButton {
  build() {
    Column() {
      Row() {
        Column() {
          Text('提交报修')
            .fontColor('#FFFFFF')
            .margin(2)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .backgroundColor('#0099FF')
        .alignItems(HorizontalAlign.Center)
        .padding({
          top: '9.2px',
          bottom: '9.2px',
          left: '18.5px',
          right: '18.5px'
        })
        .layoutWeight(1)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}