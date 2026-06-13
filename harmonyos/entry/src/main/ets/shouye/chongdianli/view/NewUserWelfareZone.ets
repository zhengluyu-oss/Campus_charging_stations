import router from '@ohos.router';
@Component
export struct NewUserWelfareZone {
  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('<')
          .fontSize(30)
          .margin({ left: 12, right: 10 })
          .width('50px')
          .height('50px')
          .borderRadius(4)
          .onClick(() => { // 搜索框点击事件
            router.pushUrl({
              url: 'shouye/shouyeIndex' // 你的目标搜索详情页
            })
          });

        Text('新人福利专区')
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .margin({ right: 12 })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: 16, bottom: 16 })
      .width('100%')
      .backgroundColor('#FFFFFF')

      // 主内容区域
      Column() {
        // 活动规则横幅
        Row() {
          Text('活动规则')
            .fontSize(12)
            .fontColor('#FFFFFF')
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4
            })
        }
        .width('auto')
        .borderRadius(12)
        .backgroundColor('#D94B2B')
        .alignItems(VerticalAlign.Center)
        .margin({ top: 16, bottom: 12 })

        // 主标题
        Text('新人福利专区')
          .fontSize(20)
          .fontColor('#D94B2B')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })
        // 副标题
        Text('完成充电任务领专属福利')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 16 })
        // 宣传图片
        Image($rawfile('shouye/emoji_image_1_1.png'))
          .width('100%')
          .height('160px')
          .objectFit(ImageFit.Cover)
          .borderRadius(12)
          .margin({ bottom: 20 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right: 16 })

      // 任务卡片1 - 已完成
      Column() {
        Row() {
          Text('任务1')
            .fontSize(14)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          Text('福利已发放')
            .fontSize(12)
            .fontColor('#52C41A')
            .backgroundColor('#F6FFED')
            .padding({
              left: 8,
              right: 8,
              top: 2,
              bottom: 2
            })
            .borderRadius(4)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ top: 16, bottom: 8 })

        Text('注册特来电账号')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 12 })
        Row() {
          Column() {
            Text('9折')
              .fontSize(18)
              .fontColor('#D94B2B')
              .fontWeight(FontWeight.Bold)
            Text('最高抵6元')
              .fontSize(12)
              .fontColor('#D94B2B')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Text('折扣券x1')
            .fontSize(14)
            .fontColor('#666666')
            .width('40%')
            .textAlign(TextAlign.Center)
          Text('已完成')
            .fontSize(12)
            .fontColor('#52C41A')
            .width('30%')
            .textAlign(TextAlign.End)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 8, bottom: 16 })
      }
      .width('92%')
      .borderRadius(12)
      .backgroundColor('#FFFFFF')
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 12 })
      .shadow({
        radius: 8,
        color: '#1A000000',
        offsetX: 0,
        offsetY: 2
      })

      // 任务卡片2 - 已过期
      Column() {
        Row() {
          Text('任务2')
            .fontSize(14)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          Text('已过期')
            .fontSize(12)
            .fontColor('#BFBFBF')
            .backgroundColor('#FAFAFA')
            .padding({
              left: 8,
              right: 8,
              top: 2,
              bottom: 2
            })
            .borderRadius(4)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ top: 16, bottom: 8 })

        Text('7日内累计充电达到10度')
          .fontSize(16)
          .fontColor('#999999')
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 12 })
        Row() {
          Column() {
            Text('5折')
              .fontSize(18)
              .fontColor('#BFBFBF')
              .fontWeight(FontWeight.Bold)
            Text('最高抵4元')
              .fontSize(12)
              .fontColor('#BFBFBF')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Text('折扣券x1')
            .fontSize(14)
            .fontColor('#BFBFBF')
            .width('40%')
            .textAlign(TextAlign.Center)
          Text('已过期')
            .fontSize(12)
            .fontColor('#BFBFBF')
            .width('30%')
            .textAlign(TextAlign.End)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 8, bottom: 16 })
      }
      .width('92%')
      .borderRadius(12)
      .backgroundColor('#FFFFFF')
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 12 })
      .shadow({
        radius: 8,
        color: '#1A000000',
        offsetX: 0,
        offsetY: 2
      })

      // 任务卡片3 - 进行中
      Column() {
        Row() {
          Text('任务3')
            .fontSize(14)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          Button('去充电')
            .fontSize(14)
            .height(32)
            .width(80)
            .type(ButtonType.Capsule)
            .fontColor('#FFFFFF')
            .backgroundColor('#D94B2B')
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ top: 16, bottom: 8 })

        Text('14日内累计充电达到50度')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)
          .margin({ bottom: 8 })
        // 进度条
        Row() {
          Text('0%')
            .fontSize(12)
            .fontColor('#D94B2B')
            .fontWeight(FontWeight.Medium)
            .width('15%')
          // 进度条背景
          Column() {
            Row() {
              // 进度条填充
              Column() {
              }
              .width('0%')
              .height(6)
              .backgroundColor('#D94B2B')
              .borderRadius(3)
            }
            .width('100%')
            .height(6)
            .backgroundColor('#D9D9D9')
            .borderRadius(3)
          }
          .width('70%')
          .margin({ left: 8, right: 8 })

          Text('进行中')
            .fontSize(12)
            .fontColor('#D94B2B')
            .width('15%')
            .textAlign(TextAlign.End)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 4, bottom: 8 })

        Row() {
          Text('已充电0度')
            .fontSize(12)
            .fontColor('#D94B2B')
          Text('再充50度可获得奖励')
            .fontSize(12)
            .fontColor('#666666')
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ top: 4, bottom: 12 })

        Row() {
          Column() {
            Text('20元')
              .fontSize(18)
              .fontColor('#D94B2B')
              .fontWeight(FontWeight.Bold)
            Text('含5张券>')
              .fontSize(12)
              .fontColor('#D94B2B')
          }
          .width('30%')
          .alignItems(HorizontalAlign.Start)

          Text('券包')
            .fontSize(14)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
            .width('40%')
            .textAlign(TextAlign.Center)
          Text('待领取')
            .fontSize(12)
            .fontColor('#D94B2B')
            .backgroundColor('#FFE8D9')
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4
            })
            .borderRadius(4)
            .width('30%')
            .textAlign(TextAlign.End)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 8, bottom: 16 })
      }
      .width('92%')
      .borderRadius(12)
      .backgroundColor('#FFFFFF')
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 20 })
      .shadow({
        radius: 8,
        color: '#1A000000',
        offsetX: 0,
        offsetY: 2
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 0, bottom: 20 })
    .backgroundColor('#E8E8E8')
    .margin({ bottom: 0 })
    .clip(true)
  }
}