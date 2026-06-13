import router from '@ohos.router';
@Component
export struct FunctionCenterModule {
  build() {
    Row() {
      Text('<')
        .maxFontSize(14)
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .onClick(() => { // 搜索框点击事件
          router.pushUrl({
            url: 'shouye/shouyeIndex' // 你的目标搜索详情页
          })
        });

      Blank()
      Text('功能中心')
        .maxFontSize(18)
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Blank()
      Text('编辑')
        .maxFontSize(14)
        .fontColor('#00BFFF')
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
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