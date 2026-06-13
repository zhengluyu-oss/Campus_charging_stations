@Component
export struct PlusMembershipActivation {
  build() {
    Column() {
      // 主标题区域
      Row() {
        Text('PLUS会员开通')
          .fontSize(20)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 16 })

      // 图片展示区域
      Row() {
        Column() {
          Image($rawfile('shouye/emoji_image_14_0.png'))
            .width('80px')
            .height('80px').objectFit(ImageFit.Cover).borderRadius(16)
          Text('会员权益')
            .fontSize(12)
            .fontColor('#666666')
            .fontWeight(FontWeight.Medium)
            .margin({ top: 8 })
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Center)

        Blank()
        Column() {
          Image($rawfile('shouye/emoji_image_14_1.png'))
            .width('80px')
            .height('80px').objectFit(ImageFit.Cover).borderRadius(16)
          Text('专属优惠')
            .fontSize(12)
            .fontColor('#666666')
            .fontWeight(FontWeight.Medium)
            .margin({ top: 8 })
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Center)

        Blank()
        Column() {
          Image($rawfile('shouye/emoji_image_14_1.png'))
            .width('80px')
            .height('80px').objectFit(ImageFit.Cover).borderRadius(16)
          Text('增值服务')
            .fontSize(12)
            .fontColor('#666666')
            .fontWeight(FontWeight.Medium)
            .margin({ top: 8 })
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .padding({
      top: 20,
      bottom: 20,
      left: 24,
      right: 24
    })
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 4
    })
  }
}