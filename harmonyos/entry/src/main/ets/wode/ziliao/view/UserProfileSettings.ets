@Component
export struct UserProfileSettings {
  build() {
    Column() {
      // 头像设置
      Row() {
        Text('头像')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 15 })
        Blank()
        Image($rawfile("wode/emoji_image_2_0.png"))
          .height('60px').width('60px').objectFit(ImageFit.Cover).borderRadius(30)
        Text('>')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ right: 15 })
      }
      .width('100%')
      .height(80)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      // 分隔线
      Divider()
        .strokeWidth(1)
        .color('#F0F0F0')
        .margin({ left: 15, right: 15 })
      // 昵称设置
      Row() {
        Text('昵称')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 15 })
        Blank()
        Text('153****5261')
          .fontSize(16)
          .fontColor('#666666')
        Text('>')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ right: 15 })
      }
      .width('100%')
      .height(60)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      // 电话号码设置
      Row() {
        Text('电话号码')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 15 })
        Blank()
        Text('138****5678')
          .fontSize(16)
          .fontColor('#666666')
        Text('>')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ right: 15 })
      }
      .width('100%')
      .height(60)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      // 分隔线
      Divider()
        .strokeWidth(1)
        .color('#F0F0F0')
        .margin({ left: 15, right: 15 })
      // 爱车用途设置
      Row() {
        Text('爱车用途')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 15 })
        Blank()
        Text('未填写')
          .fontSize(16)
          .fontColor('#666666')
        Text('>')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ right: 15 })
      }
      .width('100%')
      .height(60)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .borderRadius(15)
    .margin({ bottom: 15 })
    .clip(true)
  }
}