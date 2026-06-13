@Component
export struct MembershipPricingOptions {
  build() {
    Column() {
      // 模块标题
      Text('选择套餐')
        .fontSize(20)
        .fontColor('#333333')
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .padding({
          top: 20,
          bottom: 16,
          left: 24,
          right: 24
        })
      // 价格选项
      Grid() {
        // 月卡 - 推荐选项
        GridItem() {
          Column() {
            Row() {
              Text('月卡')
                .fontSize(18)
                .fontColor('#333333')
                .fontWeight(FontWeight.Bold)
                .maxLines(1)
              Text('首月')
                .fontSize(12)
                .fontColor('#FFFFFF')
                .backgroundColor('#FF6B35')
                .padding({
                  left: 8,
                  right: 8,
                  top: 4,
                  bottom: 4
                })
                .borderRadius(6)
                .margin({ left: 8 })
                .maxLines(1)
            }
            .alignItems(VerticalAlign.Center)

            Text('¥2.9')
              .fontSize(24)
              .fontColor('#FF6B35')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 12 })
              .maxLines(1)
            Row() {
              Text('¥15')
                .fontSize(14)
                .fontColor('#999999')
                .decoration({ type: TextDecorationType.LineThrough })
                .maxLines(1)
              Text('省¥12.1')
                .fontSize(12)
                .fontColor('#FF6B35')
                .fontWeight(FontWeight.Medium)
                .margin({ left: 8 })
                .maxLines(1)
            }
            .margin({ top: 4 })

            Text('到期自动取消')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 8 })
              .maxLines(1)
          }
          .backgroundColor('#FFFFFF')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: 20,
            bottom: 20,
            left: 16,
            right: 16
          })
          .borderRadius(16)
          .border({ width: 3, color: '#FF6B35', style: BorderStyle.Solid })
          .shadow({
            radius: 8,
            color: '#1AFF6B35',
            offsetX: 0,
            offsetY: 2
          })
        }
        .padding({
          top: 4,
          left: 4,
          bottom: 4,
          right: 4
        })

        // 年卡
        GridItem() {
          Column() {
            Text('年卡')
              .fontSize(18)
              .fontColor('#333333')
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
            Text('¥99')
              .fontSize(24)
              .fontColor('#333333')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 12 })
              .maxLines(1)
            Text('¥8.3/月')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 4 })
              .maxLines(1)
            Text('到期自动取消')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 8 })
              .maxLines(1)
          }
          .backgroundColor('#F8F9FA')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: 20,
            bottom: 20,
            left: 16,
            right: 16
          })
          .borderRadius(16)
          .border({ width: 1, color: '#E0E0E0', style: BorderStyle.Solid })
        }
        .padding({
          top: 4,
          left: 4,
          bottom: 4,
          right: 4
        })

        // 连续包月
        GridItem() {
          Column() {
            Text('连续包月')
              .fontSize(18)
              .fontColor('#333333')
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
            Text('¥2')
              .fontSize(24)
              .fontColor('#333333')
              .fontWeight(FontWeight.Bold)
              .margin({ top: 12 })
              .maxLines(1)
            Text('自动续费')
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 4 })
              .maxLines(1)
            Text('随时可取消')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 8 })
              .maxLines(1)
          }
          .backgroundColor('#F8F9FA')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: 20,
            bottom: 20,
            left: 16,
            right: 16
          })
          .borderRadius(16)
          .border({ width: 1, color: '#E0E0E0', style: BorderStyle.Solid })
        }
        .padding({
          top: 4,
          left: 4,
          bottom: 4,
          right: 4
        })
      }
      .width('100%')
      .columnsTemplate('1fr 1fr 1fr')

      // 协议同意
      Row() {
        Image($rawfile('shouye/emoji_image_7_0.png'))
          .width('20px')
          .height('20px').objectFit(ImageFit.Cover).borderRadius(6)
        Text('已阅读并同意《特来电PLUS会员协议》《特来电PLUS会员自动续费服务协议》')
          .fontSize(13)
          .fontColor('#666666')
          .margin({ left: 12 })
          .maxLines(2)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .padding({
        top: 20,
        bottom: 20,
        left: 24,
        right: 24
      })
    }
    .backgroundColor('#FFFFFF')
    .width('100%')
    .borderRadius(16)
    .shadow({
      radius: 12,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 4
    })
  }
}