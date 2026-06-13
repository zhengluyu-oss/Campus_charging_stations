@Component
export struct FaultImageUpload {
  build() {
    Column() {
      Text('请上传充电桩故障图片')
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '9.2px',
      bottom: '9.2px',
      left: '9.2px',
      right: '9.2px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}