@Component
export struct ConclusionAndSuggestionModule {
  build() {
    Column() {
      Text('结论')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Column() {
        Text('暂无结论')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('90%')
      .borderRadius(4)
      .backgroundColor('#E6F7FF')
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })

      Text('建议')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Column() {
        Text('暂无建议')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('90%')
      .borderRadius(4)
      .backgroundColor('#E6F7FF')
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })
    }
    .width('95%')
    .borderRadius(20)
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .margin({ bottom: 10 })
    .clip(true)
  }
}