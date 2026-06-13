import { NavRouterModifier, Router, router } from "@kit.ArkUI"

@Component
export struct OrderListModule {
  build() {
    Row() {
      Image($rawfile('shangcheng/A_common/zuojiantou.png'))
        .margin(2)
        .height('55px').objectFit(ImageFit.Cover).borderRadius(8)
        .onClick(() => {
          router.push({url: "goods-shop/Index"})
        // router.back()
        })
      Blank()
      Text('订单列表')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Blank()
      Image($rawfile('shangcheng/A_common/share.png'))
        .margin(2)
        .height('55px').objectFit(ImageFit.Cover).borderRadius(8)
        .onClick(() => {
          router.push({url:""})
        })
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}