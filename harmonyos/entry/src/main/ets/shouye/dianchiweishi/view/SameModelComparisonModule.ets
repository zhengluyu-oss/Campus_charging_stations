import { SpecItem_14 } from '../viewmodel/SameModelComparisonModule';

@Component
export struct SameModelComparisonModule {
  private specItem_14_: SpecItem_14[] = [
    { var_0: '同城同车型' },
    { var_0: '本车' },
    { var_0: '电池健康得分' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '电池容量' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '车龄(年)' },
    { var_0: '--' },
    { var_0: '--' }
  ]

  @Builder
  SpecItem_14_Builder(item: SpecItem_14) {
    Text(item.var_0)
      .maxFontSize(14)
      .margin(2)
      .minFontSize(8)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .width('100%')
  }

  build() {
    Column() {
      Row() {
        Text('同车型平均对比')
          .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
        Image($rawfile('shouye/emoji_image_1_0.png'))
          .margin(2)
          .height('36px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .alignItems(VerticalAlign.Center)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })
      .width('100%')

      Grid() {
        ForEach(this.specItem_14_, (item: SpecItem_14) => {
          GridItem() {
            this.SpecItem_14_Builder(item)
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
      .maxCount(4)
      .alignSelf(ItemAlign.Center)
      .backgroundColor('#E6F7FF')

      Row() {
        Text('展开全部')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shouye/emoji_image_1_1.png'))
          .margin(2)
          .height('13px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .alignItems(VerticalAlign.Center)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })
      .width('100%')

      Button('打败同车型--%的用户')
        .fontSize(14)
        .height(40)
        .type(ButtonType.Normal)
        .fontColor('#000000')
        .backgroundColor('#E6E6FA')
        .constraintSize({ 'minWidth': '80%' })
    }
    .width('95%')
    .borderRadius(20)
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .margin({ bottom: 10 })
    .clip(true)
  }
}