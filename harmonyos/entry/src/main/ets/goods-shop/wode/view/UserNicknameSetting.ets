@Component
export struct UserNicknameSetting {
  build() {
    // Column() {
    //   Row() {
    //     Image($rawfile("shangcheng/E_wode/emoji_image_5_0.png"))
    //       .margin(2)
    //       .height('197px').objectFit(ImageFit.Cover).borderRadius(8)
    //     Blank()
    //     Text('未设置昵称')
    //       .maxFontSize(14)
    //       .fontColor('#FFFFFF')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //   }
    //   .width('100%')
    //   .backgroundColor('#FF6347')
    //   .alignItems(VerticalAlign.Center)
    //   .justifyContent(FlexAlign.SpaceBetween)
    //   .padding({
    //     top: '12.5px',
    //     bottom: '12.5px',
    //     left: '12.5px',
    //     right: '12.5px'
    //   })
    // }
    // .width('95%')
    // .backgroundColor('#FF6347')
    // .alignItems(HorizontalAlign.Center)
    // .padding({
    //   top: '0.0px',
    //   bottom: '0.0px',
    //   left: '0.0px',
    //   right: '0.0px'
    // })
    // .borderRadius(20)
    // .margin({ bottom: 10 })
    // .clip(true)
    Column() {
      Row() {
        // 头像：增加边框
        Image($rawfile("shangcheng/E_wode/emoji_image_5_0.png"))
          .width(60)
          .height(60)
          .borderRadius(30)
          .border({ width: 2, color: Color.White })
          .objectFit(ImageFit.Cover)
          .shadow({ radius: 4, color: '#33000000' })

        Column({ space: 6 }) {
          Text('未设置昵称')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)

          Row() {
            Text('普通会员')
              .fontSize(10)
              .fontColor('#FF6666')
              .backgroundColor('#FFF0F0')
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .borderRadius(10)
          }
        }
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 设置/箭头图标
        Image($rawfile("shangcheng/E_wode/fanhui.png")) // 假设有系统图标
          .width(24)
          .height(24)
          .fillColor('#FFFFFF80')
      }
      .width('100%')
      .padding({ top: 40, bottom: 40, left: 24, right: 24 })
      .linearGradient({
        angle: 135,
        colors: [['#FF9A9E', 0.0], ['#FECFEF', 1.0]] // 糖果色渐变，更年轻
      })
      .borderRadius({ bottomLeft: 24, bottomRight: 24 })
    }
    .width('100%')
  }
}