import { router } from "@kit.ArkUI"

@Component
export struct SearchBarModule {
  build() {
    Row() {
      Text('北京市')
        .maxFontSize(14)
        .fontColor('#FFFFFF')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)

      Search({ placeholder: '搜出好商品' })
        .placeholderFont({ size: 14 })
        .backgroundColor('#FFFFFF')
        .layoutWeight(1)
        .onClick(() => {
          router.push({url:
          "goods-shop/shouye/A_fenyemian/A_sousuo/Index"
          })
        })
    }

    .width('95%')
    .backgroundColor('#FF6347')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({ left: '8.4px', right: '8.4px' })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}