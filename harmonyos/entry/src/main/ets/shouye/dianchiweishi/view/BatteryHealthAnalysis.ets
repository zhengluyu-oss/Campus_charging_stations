import { SpecItem_24 } from '../viewmodel/BatteryHealthAnalysis';

@Component
export struct BatteryHealthAnalysis {
  private specItem_24_: SpecItem_24[] = [
    { var_0: '温度一致性', var_1: $rawfile('shouye/emoji_image_2_1.png') },
    { var_0: '最高温度', var_1: $rawfile('shouye/emoji_image_2_2.png') },
    { var_0: 'SOC一致性', var_1: $rawfile('shouye/emoji_image_2_3.png') },
    { var_0: '电压一致性', var_1: $rawfile('shouye/emoji_image_2_4.png') }
  ]

  @Builder
  SpecItem_24_Builder(item: SpecItem_24) {
    Row() {
      Text(item.var_0)
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Blank()
      Image(item.var_1)
        .margin(2)
        .height('17px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('100%')
    .backgroundColor('#E6F7FF')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: '8.6px', right: '8.6px' })
    .width('100%')
  }

  build() {
    Column() {
      Column() {
        Text('电池健康专业分析')
          .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
        Image($rawfile('shouye/emoji_image_2_0.png'))
          .margin(2)
          .width('34px')
          .height('34px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Start)
      .padding({ left: '8.6px', top: '8.6px' })

      List() {
        ForEach(this.specItem_24_, (item: SpecItem_24) => {
          ListItem() {
            this.SpecItem_24_Builder(item)
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
      .divider({
        strokeWidth: 1,
        startMargin: 10,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
      .backgroundColor('#FFFFFF')
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
    .padding({ top: '8.6px', bottom: '8.6px' })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}