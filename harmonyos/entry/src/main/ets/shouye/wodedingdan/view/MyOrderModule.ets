import router from '@ohos.router';
@Component
export struct MyOrderModule {
  build() {
    Row() {
      Image($rawfile('shouye/emoji_image_2_0.png'))
        .margin({ left: 12, right: 8 })
        .width('40px')
        .height('40px')
        .objectFit(ImageFit.Cover)
        .borderRadius(20)
        .onClick(() => { // 搜索框点击事件
          router.pushUrl({
            url: 'shouye/shouyeIndex' // 你的目标搜索详情页
          })
        });

      Text('我的订单')
        .maxFontSize(18)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .margin({ right: 8 })
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Blank()
      Text('筛选')
        .maxFontSize(14)
        .fontColor('#666666')
        .margin({ right: 16 })
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Text('开票')
        .maxFontSize(14)
        .fontColor('#666666')
        .margin({ right: 12 })
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '12px',
      bottom: '12px',
      left: '0px',
      right: '0px'
    })
    .borderRadius(12)
    .margin({ bottom: 10 })
    .clip(true)
  }
}