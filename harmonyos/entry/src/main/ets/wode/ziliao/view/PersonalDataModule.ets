import router from "@ohos.router"

@Component
export struct PersonalDataModule {

  build() {
    Row() {
      Image($rawfile("wode/emoji_image_7_0.png"))
        .margin({ left: 15, right: 10 })
        .height('60px')
        .width('60px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
        .onClick(()=>{
          router.back();
        })
      Blank()
      Text('个人资料')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .margin({ right: 15 })
    }
    .width('95%')
    .height(80)
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({ top: 10, bottom: 10 })
    .borderRadius(15)
    .margin({ top: 20, bottom: 15 })
    .clip(true)
  }
}