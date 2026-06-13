import { SpecItem_15 } from '../viewmodel/DiscountCouponModule';

@Component
export struct DiscountCouponModule {
  private specItem_15_: SpecItem_15[] = [
    { var_0: $rawfile('shouye/emoji_image_1_0.png'), var_1: '¥98购 ¥100' },
    { var_0: $rawfile('shouye/emoji_image_1_1.png'), var_1: '¥95购 ¥100' },
    { var_0: $rawfile('shouye/emoji_image_1_2.png'), var_1: '¥190购 ¥200' }
  ]

  @Builder
  SpecItem_15_Builder(item: SpecItem_15) {
    Column() {
      Image(item.var_0)
        .margin(2)
        .width('210px')
        .height('197px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
      Text(item.var_1)
        .maxFontSize(14)
        .fontColor('#FF4500')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('33%')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    }).width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('优惠购券')
          .maxFontSize(20)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        Text('全额抵扣服务费电费 >')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })

      Grid() {
        ForEach(this.specItem_15_, (item: SpecItem_15) => {
          GridItem() {
            this.SpecItem_15_Builder(item)
          }.width('100%').borderRadius(8).clip(true)
          .padding({
            top: 5,
            left: 3,
            bottom: 5,
            right: 3
          })
        })
      }
      .width('95%')
      .borderRadius(8)
      .clip(true)
      .margin({ bottom: 10 })
      .columnsTemplate(('1fr ').repeat(3))
      .maxCount(1)
      .alignSelf(ItemAlign.Center)
      .backgroundColor('#FFFFFF')
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
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