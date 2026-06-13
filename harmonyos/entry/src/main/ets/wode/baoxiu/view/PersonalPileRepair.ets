import router from "@ohos.router"

@Component
export struct PersonalPileRepair {

  build() {
    Row() {
      Image($rawfile("wode/emoji_image_10_0.png"))
        .margin(2)
        .height('69px').objectFit(ImageFit.Cover).borderRadius(8)
        .onClick(()=>{
          router.back();
        })
      Blank()
      Text('充电桩报修')
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '9.2px',
      bottom: '9.2px',
      left: '9.2px',
      right: '9.2px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}