import { SpecItem_636 } from '../viewmodel/MembershipBenefitsModule';

@Component
export struct MembershipBenefitsModule {
  private specItem_636_: SpecItem_636[] = [
    { var_0: $rawfile('shouye/emoji_image_6_2.png'), var_1: '爱车体检' },
    { var_0: $rawfile('shouye/emoji_image_6_3.png'), var_1: '加倍积分' },
    { var_0: $rawfile('shouye/emoji_image_6_4.png'), var_1: '商城专属价' },
    { var_0: $rawfile('shouye/emoji_image_6_5.png'), var_1: '专属客服' }
  ]

  @Builder
  SpecItem_636_Builder(item: SpecItem_636) {
    Column() {
      Image(item.var_0)
        .width('56px')
        .height('56px').objectFit(ImageFit.Cover).borderRadius(12)
      Text(item.var_1)
        .fontSize(13)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .margin({ top: 8 })
        .maxLines(1)
    }
    .padding({
      top: 16,
      bottom: 16,
      left: 12,
      right: 12
    })
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F8F9FA')
    .borderRadius(12)
  }

  build() {
    Column() {
      // 模块标题
      Text('会员权益详情')
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
      // 版本选择区域
      Column() {
        Text('选择版本')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .margin({ bottom: 12 })
        Row() {
          Column() {
            Image($rawfile('shouye/emoji_image_6_0.png'))
              .width('40px')
              .height('30px').objectFit(ImageFit.Cover).borderRadius(8)
            Text('轻享版')
              .fontSize(15)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .margin({ top: 6 })
              .maxLines(1)
          }
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)

          Blank()
          Column() {
            Image($rawfile('shouye/emoji_image_6_1.png'))
              .width('40px')
              .height('30px').objectFit(ImageFit.Cover).borderRadius(8)
            Text('畅享版')
              .fontSize(15)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .margin({ top: 6 })
              .maxLines(1)
          }
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)
        }
        .width('100%')
      }
      .padding({
        top: 12,
        bottom: 16,
        left: 24,
        right: 24
      })
      .backgroundColor('#F8F9FA')
      .margin({ left: 24, right: 24 })
      .borderRadius(12)

      // 价格信息区域
      Column() {
        Row() {
          Column() {
            Text('会员专享价')
              .fontSize(18)
              .fontColor('#FF6B35')
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
            Text('全国18000+会员站可用')
              .fontSize(13)
              .fontColor('#999999')
              .margin({ top: 4 })
              .maxLines(1)
          }
          .layoutWeight(1)

          Text('6折起')
            .fontSize(16)
            .fontColor('#FF6B35')
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
        }
        .width('100%')

        Text('单次最高可减免5元服务费，部分场站可享受更高减免')
          .fontSize(13)
          .fontColor('#666666')
          .margin({ top: 8 })
          .maxLines(2)
      }
      .padding({
        top: 16,
        bottom: 16,
        left: 24,
        right: 24
      })

      // 券包信息
      Column() {
        Text('8元会员专属券包')
          .fontSize(18)
          .fontColor('#FF6B35')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .margin({ bottom: 16 })
        Grid() {
          GridItem() {
            Column() {
              Text('3元')
                .fontSize(16)
                .fontColor('#FF6B35')
                .fontWeight(FontWeight.Bold)
                .maxLines(1)
              Text('整单立减券')
                .fontSize(13)
                .fontColor('#666666')
                .margin({ top: 4 })
                .maxLines(1)
            }
            .padding({
              top: 16,
              bottom: 16,
              left: 12,
              right: 12
            })
            .backgroundColor('#FFF5F5')
            .borderRadius(12)
          }
          .padding({
            top: 6,
            left: 6,
            bottom: 6,
            right: 6
          })

          GridItem() {
            Column() {
              Text('1元')
                .fontSize(16)
                .fontColor('#FF6B35')
                .fontWeight(FontWeight.Bold)
                .maxLines(1)
              Text('服务费券')
                .fontSize(13)
                .fontColor('#666666')
                .margin({ top: 4 })
                .maxLines(1)
              Text('满3元可用')
                .fontSize(12)
                .fontColor('#999999')
                .margin({ top: 2 })
                .maxLines(1)
            }
            .padding({
              top: 16,
              bottom: 16,
              left: 12,
              right: 12
            })
            .backgroundColor('#FFF5F5')
            .borderRadius(12)
          }
          .padding({
            top: 6,
            left: 6,
            bottom: 6,
            right: 6
          })

          GridItem() {
            Column() {
              Text('1元')
                .fontSize(16)
                .fontColor('#FF6B35')
                .fontWeight(FontWeight.Bold)
                .maxLines(1)
              Text('服务费券')
                .fontSize(13)
                .fontColor('#666666')
                .margin({ top: 4 })
                .maxLines(1)
              Text('满3元可用')
                .fontSize(12)
                .fontColor('#999999')
                .margin({ top: 2 })
                .maxLines(1)
            }
            .padding({
              top: 16,
              bottom: 16,
              left: 12,
              right: 12
            })
            .backgroundColor('#FFF5F5')
            .borderRadius(12)
          }
          .padding({
            top: 6,
            left: 6,
            bottom: 6,
            right: 6
          })
        }
        .width('100%')
        .columnsTemplate('1fr 1fr 1fr')
      }
      .padding({
        top: 16,
        bottom: 16,
        left: 24,
        right: 24
      })

      // 更多权益
      Column() {
        Text('更多权益')
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .margin({ bottom: 16 })
        Grid() {
          ForEach(this.specItem_636_, (item: SpecItem_636) => {
            GridItem() {
              this.SpecItem_636_Builder(item)
            }.width('100%')
          })
        }.width('100%')
        .columnsTemplate('1fr 1fr')
      }
      .padding({
        top: 16,
        bottom: 16,
        left: 24,
        right: 24
      })

      // 兑换码开通
      Row() {
        Text('兑换码开通')
          .fontSize(15)
          .fontColor('#007AFF')
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
        Text('>')
          .fontSize(16)
          .fontColor('#007AFF')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 4 })
          .maxLines(1)
      }
      .alignItems(VerticalAlign.Center)
      .padding({
        top: 16,
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