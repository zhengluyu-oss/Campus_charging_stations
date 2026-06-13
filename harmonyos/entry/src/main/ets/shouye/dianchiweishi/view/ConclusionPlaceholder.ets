@Component
export struct ConclusionPlaceholder {
  build() {
    Row() {
      Text('结论：暂无结论')
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .backgroundColor('#e6f7ff')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
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