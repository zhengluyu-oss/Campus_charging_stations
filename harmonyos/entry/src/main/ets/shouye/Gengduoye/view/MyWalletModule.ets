@Component
export struct MyWalletModule {
  build() {
    Column() {
      Text('我的钱包')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Row() {
        Column() {
          Image($rawfile('shouye/emoji_image_2_0.png'))
            .margin(2)
            .width('68px')
            .height('77px')
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
          Text('余额充值')
            .maxFontSize(14)
            .margin(2)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)

        Column() {
          Row() {
            Image($rawfile('shouye/emoji_image_2_1.png'))
              .margin(2)
              .height('77px').objectFit(ImageFit.Cover).borderRadius(8)
            Image($rawfile('shouye/emoji_image_2_2.png'))
              .margin(2)
              .height('42px').objectFit(ImageFit.Cover).borderRadius(8)
          }
          .alignItems(VerticalAlign.Center)
          .width('100%')

          Text('我的卡券')
            .maxFontSize(14)
            .margin(2)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width('100%')
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
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