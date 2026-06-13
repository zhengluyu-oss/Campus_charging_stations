@Component
export struct LogoutButton {
  build() {
    Column() {
      Button('退出登录')
        .width('95%')
        .height(50)
        .fontColor('#FFFFFF')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#FF3B30')
        .borderRadius(25)
        .onClick(() => {
          // 退出登录逻辑
          this.getUIContext().getRouter().replaceUrl({url:"LoginPage"})
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 20, bottom: 30 })
  }
}