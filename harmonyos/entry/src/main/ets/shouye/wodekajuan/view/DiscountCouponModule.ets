@Component
export struct DiscountCouponModule {
  build() {
    Column() {
      Text('优惠券')
        .fontSize('16fp')
       //.fontColor($rawfile('app.color.content_font_color'))
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: '12vp' })
      Row() {
        Column() {
          Image($rawfile('shouye/emoji_image_0_0.png'))
            .width('100%')
            .aspectRatio(1)
            .objectFit(ImageFit.Cover)
            .borderRadius('12vp')
            .margin({ bottom: '12vp' })
          Text('新客注册礼')
            .fontSize('14fp')
            //.fontColor($rawfile('app.color.font_on_primary'))
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: '8vp' })
          Text('9折')
            .fontSize('32fp')
            //.fontColor($rawfile('app.color.font_on_primary'))
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: '4vp' })
          Text('最高抵扣6元')
            .fontSize('14fp')
            //.fontColor($rawfile('app.color.font_on_primary'))
        }
        //.backgroundColor($rawfile('app.color.background_emphasize'))
        .alignItems(HorizontalAlign.Center)
        .padding('16vp')
        .borderRadius('12vp')
        .layoutWeight(1)
        .margin({ right: '12vp' })

        Column() {
          Row() {
            Text('折扣券')
              .fontSize('14fp')
             // .fontColor($rawfile('app.color.background_emphasize'))
              .fontWeight(FontWeight.Medium)
              .padding({
                top: '4vp',
                bottom: '4vp',
                left: '8vp',
                right: '8vp'
              })
             // .backgroundColor($rawfile('app.color.comp_emphasize_secondary'))
              .borderRadius('8vp')
            Text('仅适用于服务费')
              .fontSize('12fp')
             // .fontColor($rawfile('app.color.font_tertiary'))
              .layoutWeight(1)
              .textAlign(TextAlign.End)
          }
          .width('100%')
          .margin({ bottom: '12vp' })

          Text('有效期至2026.02.05 19:29:50')
            .fontSize('12fp')
           // .fontColor($rawfile('app.color.font_tertiary'))
            .width('100%')
            .textAlign(TextAlign.Start)
            .margin({ bottom: '16vp' })
          Row() {
            Text('详细信息')
              .fontSize('14fp')
              //.fontColor($rawfile('app.color.background_emphasize'))
            Button('可用电站')
              .fontSize('14fp')
              .height('32vp')
              .type(ButtonType.Capsule)
              //.fontColor($rawfile('app.color.font_on_primary'))
              //backgroundColor($rawfile('app.color.background_emphasize'))
              .onClick(() => {
                console.info('可用电站按钮被点击');
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('92%')
   // .backgroundColor($rawfile('app.color.background_primary'))
    .alignItems(HorizontalAlign.Start)
    .padding('16vp')
    .borderRadius('20vp')
    .margin({ bottom: '12vp', left: '4%', right: '4%' })
    .shadow({
      radius: 6,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 1
    })
  }
}