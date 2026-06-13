import router from "@ohos.router"

@Component
export struct PersonalPileApplication {

  build() {
    Column() {
      // 顶部返回箭头和标题区域
      Row() {
        // 返回箭头
        Text('‹')
          .fontSize(24)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .textAlign(TextAlign.Center)
          .onClick(() => {
            router.back();
            // 返回上一页逻辑
          })
        Blank()
        // 页面标题居中
        Text('申请建桩')
          .maxFontSize(18)
          .fontColor('#FFFFFF')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        // 右侧占位，保持对称
        Blank()
          .width(24)
          .height(24)
          .margin({ right: 16 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({ top: '20px', bottom: '20px' })
      .margin({ bottom: 20 })

      // 主要内容区域
      Column() {
        // 购买个人桩卡片
        Row() {
          Column() {
            Text('购买个人桩')
              .fontSize(16)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })
            Text('没有充电桩，有专用停车位，具备电力接入条件，想购买特来电充电桩。')
              .fontSize(12)
              .fontColor('#888888')
              .lineHeight(18)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .padding({ left: 20, right: 20 })

          Image($rawfile("wode/emoji_image_0_0.png"))
            .width(80)
            .height(80)
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
            .margin({ right: 20 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 24, bottom: 24 })
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 20 })

        // 安装个人桩卡片
        Row() {
          Image($rawfile("wode/emoji_image_0_1.png"))
            .width(80)
            .height(80)
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
            .margin({ left: 20 })
          Column() {
            Text('安装个人桩')
              .fontSize(16)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })
            Text('有充电桩，不了解如何安装，购买特来电安装服务，让特来电帮您安装。')
              .fontSize(12)
              .fontColor('#888888')
              .lineHeight(18)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .padding({ left: 20, right: 20 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 24, bottom: 24 })
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 20 })

        // 绑定个人桩卡片
        Row() {
          Column() {
            Text('绑定个人桩')
              .fontSize(16)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })
            Text('有充电桩且已安装。绑定个人桩后，成为桩主，设置对外共享后，可对外提供充电服务。')
              .fontSize(12)
              .fontColor('#888888')
              .lineHeight(18)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .padding({ left: 20, right: 20 })

          Image($rawfile("wode/emoji_image_2_0.png"))
            .width(80)
            .height(80)
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
            .margin({ right: 20 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .padding({ top: 24, bottom: 24 })
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 20 })
      }
      .width('90%')
      .alignSelf(ItemAlign.Center)
      .margin({ top: 20 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 0, bottom: 20 })
    .backgroundColor('#0099FF')
    .height('100%')
  }
}