import { router } from "@kit.ArkUI"

@Component
export struct SearchProductModule {
  build() {
    Row() {
      Image($r('app.media.emoji_image_2_0'))
        .margin(2)
        .height('42px').objectFit(ImageFit.Cover).borderRadius(8)
      Blank()
      Search({ placeholder: '搜索商品' })
        .placeholderFont({ size: 16 })
        .backgroundColor('#FFFFFF')
        .layoutWeight(1)
      Blank()
        Text('取消')
        .margin(2)
        .height('42px')
          .onClick(()=>{
            router.back()
          })

    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '8.4px',
      bottom: '8.4px',
      left: '8.4px',
      right: '8.4px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}