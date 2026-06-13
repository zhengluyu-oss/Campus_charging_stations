import router from '@ohos.router';
@Component
export struct BatteryGuardReport {
  build() {
    Row() {
      Image($rawfile('shouye/emoji_image_6_0.png'))
        .margin(2)
        .height('55px').objectFit(ImageFit.Cover).borderRadius(8)
        .onClick(() => { // 搜索框点击事件
          router.pushUrl({
            url: 'shouye/shouyeIndex' // 你的目标搜索详情页
          })
        });
      Image($rawfile('shouye/emoji_image_6_1.png'))
        .margin(2)
        .height('55px').objectFit(ImageFit.Cover).borderRadius(8)
      Text('电池卫士检测报告')
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
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