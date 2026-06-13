import { SpecItem_35 } from '../viewmodel/ChargingPileHotSales';

@Component
export struct ChargingPileHotSales {
  private specItem_35_: SpecItem_35[] = [
    {
      var_0: $rawfile('shouye/emoji_image_3_0.png'),
      var_1: '家用交流桩',
      var_2: '¥1399',
      var_3: '¥2999'
    },
    {
      var_0: $rawfile('shouye/emoji_image_3_1.png'),
      var_1: '便携随车充',
      var_2: '¥370',
      var_3: '¥1299'
    },
    {
      var_0: $rawfile('shouye/emoji_image_3_2.png'),
      var_1: '直流充电桩',
      var_2: '¥17990',
      var_3: '¥19999'
    }
  ]

  @Builder
  SpecItem_35_Builder(item: SpecItem_35) {
    Column() {
      Image(item.var_0)
        .margin(2)
        .width('171px')
        .height('171px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
      Text(item.var_1)
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Text(item.var_2)
        .fontColor('#FF4500')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Text(item.var_3)
        .maxFontSize(12)
        .fontColor('#808080')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('33%')
    .alignItems(HorizontalAlign.Center).width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('充电桩热销榜')
          .maxFontSize(18)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        Text('逛逛商城 >')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Grid() {
        ForEach(this.specItem_35_, (item: SpecItem_35) => {
          GridItem() {
            this.SpecItem_35_Builder(item)
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
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}