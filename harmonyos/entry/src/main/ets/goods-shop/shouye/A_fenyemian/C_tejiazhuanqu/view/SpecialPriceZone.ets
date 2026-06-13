import { router } from "@kit.ArkUI"

@Component
export struct SpecialPriceZone {
  build() {
    Column() {
      Row() {
        Button('<')
          .fontSize(14)
          .height(40)
          .type(ButtonType.Normal)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
          .onClick(()=>{
            router.back()
          })
        Text('特价专区')
          .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
        Blank()
        Button()
          .fontSize(14)
          .height(40)
          .type(ButtonType.Normal)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.4px',
        bottom: '8.4px',
        left: '8.4px',
        right: '8.4px'
      })

      Column() {
        Row() {
          Text('特价专区')
            .maxFontSize(14)
            .margin(2)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
          Blank()
          Button()
            .fontSize(14)
            .height(40)
            .type(ButtonType.Normal)
            .fontColor('#000000')
            .backgroundColor('#FFFFFF')
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          top: '8.4px',
          bottom: '8.4px',
          left: '8.4px',
          right: '8.4px'
        })

        Column() {
          Image($r('app.media.emoji_image_2_0'))
            .margin(2)
            .width('675px')
            .height('421px')
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
          Text('没有任何商品上架哦~')
            .maxFontSize(14)
            .margin(2)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .width('100%')
        .backgroundColor('#F5F5F5')
        .alignItems(HorizontalAlign.Center)
        .padding({
          top: '8.4px',
          bottom: '8.4px',
          left: '8.4px',
          right: '8.4px'
        })
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: '8.4px',
        bottom: '8.4px',
        left: '8.4px',
        right: '8.4px'
      })
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}