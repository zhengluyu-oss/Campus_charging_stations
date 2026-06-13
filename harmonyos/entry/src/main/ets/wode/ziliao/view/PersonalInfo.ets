@Component
export struct PersonalInfo {
  @State userName: string = "个人信息";
  @State userIcon: Resource = $rawfile("wode/emoji_image_7_0.png");
  @State subtitle: string[] = ['电话号码', '邮箱'];
  @State counts: string[] = ['138****5678', 'example@email.com'];

  build() {
    Column() {
      // 个人信息标题
      Row() {
        Text(this.userName)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ left: 15 })
      }
      .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Center)

      // 分隔线
      Divider()
        .strokeWidth(1)
        .color('#F0F0F0')
        .margin({ left: 15, right: 15 })
      // 电话号码
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
          .margin({ right: 15 })
      }
      .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      // 分隔线
      Divider()
        .strokeWidth(1)
        .color('#F0F0F0')
        .margin({ left: 15, right: 15 })
      // 邮箱
      Row() {
        Text('邮箱')
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 15 })
        Blank()
        Text('example@email.com')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ right: 15 })
      }
      .width('100%')
      .height(50)
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