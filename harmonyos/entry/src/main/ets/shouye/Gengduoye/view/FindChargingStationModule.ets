import { SpecItem_82 } from '../viewmodel/FindChargingStationModule';

@Component
export struct FindChargingStationModule {
  private specItem_82_: SpecItem_82[] = [
    { var_0: $rawfile('shouye/emoji_image_8_0.png'), var_1: '电站搜索' },
    { var_0: $rawfile('shouye/emoji_image_8_1.png'), var_1: '我的收藏' },
    { var_0: $rawfile('shouye/emoji_image_8_2.png'), var_1: '最近充电' },
    { var_0: $rawfile('shouye/emoji_image_8_3.png'), var_1: '充电地图' },
    { var_0: $rawfile('shouye/emoji_image_8_4.png'), var_1: '一键导航' },
    { var_0: $rawfile('shouye/emoji_image_8_5.png'), var_1: '星级站' }
  ]

  @Builder
  SpecItem_82_Builder(item: SpecItem_82) {
    Column() {
      Image(item.var_0)
        .margin(2)
        .width('100px')
        .height('100px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
      Text(item.var_1)
        .maxFontSize(14)
        .margin(2)
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
      Text('找桩充电')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Grid() {
        ForEach(this.specItem_82_, (item: SpecItem_82) => {
          GridItem() {
            this.SpecItem_82_Builder(item)
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