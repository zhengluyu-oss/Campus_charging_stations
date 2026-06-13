import { SpecItem_02 } from '../viewmodel/MyChargingModule';

@Component
export struct MyChargingModule {
  private specItem_02_: SpecItem_02[] = [
    { var_0: $rawfile('shouye/emoji_image_0_0.png'), var_1: '我的订单' },
    { var_0: $rawfile('shouye/emoji_image_0_1.png'), var_1: '我的发票' },
    { var_0: $rawfile('shouye/emoji_image_0_2.png'), var_1: '充电账单' },
    { var_0: $rawfile('shouye/emoji_image_0_3.png'), var_1: '行程规划' },
    { var_0: $rawfile('shouye/emoji_image_0_4.png'), var_1: '即插即充' },
    { var_0: $rawfile('shouye/emoji_image_0_5.png'), var_1: 'V2G' },
    { var_0: $rawfile('shouye/emoji_image_0_6.png'), var_1: '代充订单' },
    { var_0: $rawfile('shouye/emoji_image_0_7.png'), var_1: '电池卫士' }
  ]

  @Builder
  SpecItem_02_Builder(item: SpecItem_02) {
    Column() {
      Image(item.var_0)
        .margin(5)
        .width('100px')
        .height('100px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
      Text(item.var_1)
        .maxFontSize(14)
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('20%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center).width('100%')
  }

  build() {
    Column() {
      Text('我的充电')
        .maxFontSize(18)
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Grid() {
        ForEach(this.specItem_02_, (item: SpecItem_02) => {
          GridItem() {
            this.SpecItem_02_Builder(item)
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
      .columnsTemplate(('1fr ').repeat(5))
      .maxCount(2)
      .alignSelf(ItemAlign.Center)
      .backgroundColor('#FFFFFF')
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
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