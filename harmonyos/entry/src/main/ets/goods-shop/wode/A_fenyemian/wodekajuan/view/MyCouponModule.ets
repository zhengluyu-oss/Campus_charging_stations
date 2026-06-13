import { router } from "@kit.ArkUI";

@Component
export struct MyCouponModule {
  @Consume('appPathStack') appPathStack: NavPathStack;

  build() {
    Row() {
      Image($rawfile('shangcheng/A_common/zuojiantou.png'))
        .margin(2)
        .height('71px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
        .onClick(() => {
          router.back()
        })
      Blank()
      Text('我的卡券')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Blank()
      Image($rawfile('shangcheng/A_common/share.png'))
        .margin(2)
        .height('71px').objectFit(ImageFit.Cover).borderRadius(8)
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
    .onClick(() => {
      this.appPathStack.pushPath({ name: 'MyCouponList' });
    })
  }
}