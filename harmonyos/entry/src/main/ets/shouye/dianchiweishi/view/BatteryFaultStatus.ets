import { SpecItem_34 } from '../viewmodel/BatteryFaultStatus';

@Component
export struct BatteryFaultStatus {
  private specItem_34_: SpecItem_34[] = [
    { var_0: '故障率', var_1: '--' },
    { var_0: '故障订单数', var_1: '--' },
    { var_0: '充电订单数', var_1: '--' }
  ]

  @Builder
  SpecItem_34_Builder(item: SpecItem_34) {
    Column() {
      Text(item.var_0)
        .maxFontSize(14)
        .fontColor('#666666')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Text(item.var_1)
        .maxFontSize(14)
        .fontColor('#666666')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '17.1px',
      right: '17.1px'
    }).width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('电池故障情况')
          .maxFontSize(18)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_3_0.png'))
          .margin(2)
          .height('36px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .alignItems(VerticalAlign.Center)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '17.1px',
        right: '17.1px'
      })
      .width('100%')

      Grid() {
        ForEach(this.specItem_34_, (item: SpecItem_34) => {
          GridItem() {
            this.SpecItem_34_Builder(item)
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
      .maxCount(2)
      .alignSelf(ItemAlign.Center)
      .backgroundColor('#ffffff')
    }
    .width('95%')
    .backgroundColor('#ffffff')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '17.1px',
      right: '17.1px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}