import router from '@ohos.router';
@Component
export struct NearbySearchBar {
  build() {
    Row() {
      Button('<')
        .fontSize(14)
        .height(20)
        .type(ButtonType.Normal)
        .fontColor('#000000')
        .backgroundColor('#FFFFFF')
        .onClick(() => { // 搜索框点击事件
          router.pushUrl({
            url: 'shouye/shouyeIndex' // 你的目标搜索详情页
          })
        });

      Blank()
      Text('附近')
        .margin(5).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
      Image($rawfile('shouye/emoji_image_1_0.png'))
        .margin(2)
        .height('34px').objectFit(ImageFit.Cover).borderRadius(8)
      Blank()
      Search({ placeholder: '目的地/电站...' })
        .placeholderFont({ size: 14 })
        .backgroundColor('#FFFFFF')
        .layoutWeight(1)
      Image($rawfile('shouye/emoji_image_1_1.png'))
        .margin(5)
        .height('51px').objectFit(ImageFit.Cover).borderRadius(8)
      Image($rawfile('shouye/emoji_image_1_2.png'))
        .margin(5)
        .height('51px').objectFit(ImageFit.Cover).borderRadius(8)
      Image($rawfile('shouye/emoji_image_1_3.png'))
        .margin(5)
        .height('51px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .margin({ bottom: 10 })
    .clip(true)
    .constraintSize({ minHeight: ' 4.44%' })
    .backgroundColor('#FFFFFF')
  }
}