import { SpecItem_141 } from '../viewmodel/ChargingStationListModule';

@Component
export struct ChargingStationListModule {
  private specItem_141_: SpecItem_141[] = [
    {
      var_0: $rawfile('shouye/emoji_image_14_0.png'),
      var_1: '库尔勒市首府花苑小区充电站',
      var_2: '5.0分',
      var_3: '最近充电3小时前',
      var_4: '对外开放',
      var_5: '1.7km',
      var_6: '此电站按照场地方规定收费',
      var_7: '¥0.7830/度',
      var_8: '慢闲0/9'
    },
    {
      var_0: $rawfile('shouye/emoji_image_14_1.png'),
      var_1: '库尔勒龙祥小区充电站',
      var_2: '5.0分',
      var_3: '最近充电14分钟前',
      var_4: '对外开放',
      var_5: '1.7km',
      var_6: '根据场地方规定收取停车费',
      var_7: '¥1.1467/度',
      var_8: '慢闲0/4'
    },
    {
      var_0: $rawfile('shouye/emoji_image_14_2.png'),
      var_1: '新时州客运汽车站充电站',
      var_2: '5.0分',
      var_3: '最近充电16分钟前',
      var_4: '对外开放',
      var_5: '2.2km',
      var_6: '限制1小时内免费；超出部分按照停车场…',
      var_7: '¥0.8500/度',
      var_8: '快闲3/5'
    }
  ]

  @Builder
  SpecItem_141_Builder(item: SpecItem_141) {
    Column() {
      Row() {
        Image(item.var_0)
          .margin(2)
          .height('108px').objectFit(ImageFit.Cover).borderRadius(8)
        Column() {
          Text(item.var_1)
            .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
          Row() {
            Text(item.var_2)
              .maxFontSize(12)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text(item.var_3)
              .maxFontSize(12)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text(item.var_4)
              .maxFontSize(12)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text(item.var_5)
              .maxFontSize(12)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')

          Text(item.var_6)
            .maxFontSize(12)
            .margin(2)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
          Row() {
            Text(item.var_7)
              .fontColor('#FF0000')
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text(item.var_8)
              .maxFontSize(12)
              .fontColor('#008000')
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        }
      }
    }
    .width('100%')
    .borderRadius(5)
    .backgroundColor('#FFFFFF')
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .width('100%')
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.specItem_141_, (item: SpecItem_141) => {
          GridItem() {
            this.SpecItem_141_Builder(item)
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
      .maxCount(3)
      .alignSelf(ItemAlign.Center)
      .backgroundColor('#FFFFFF')
    }
    .width('95%')
    .borderRadius(20)
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
    .margin({ bottom: 10 })
    .clip(true)
  }
}