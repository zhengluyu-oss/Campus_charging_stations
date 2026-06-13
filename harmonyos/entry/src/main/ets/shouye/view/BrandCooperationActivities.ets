import { SpecItem_45 } from '../viewmodel/BrandCooperationActivities';

@Component

export struct BrandCooperationActivities {
  private specItem_45_: SpecItem_45[] = [
    { var_0: $rawfile('shouye/emoji_image_4_2.png'), var_1: '特来电企业账号', var_2: '助力解决企业充电管理痛点' },
    { var_0: $rawfile('shouye/emoji_image_4_3.png'), var_1: '电池全面体检', var_2: '多维查询 速出报告' },
    { var_0: $rawfile('shouye/emoji_image_4_4.png'), var_1: '新人进群领取费', var_2: '新人福利领取中' }
  ]

  @Builder
  SpecItem_45_Builder(item: SpecItem_45) {
    Column() {
      Image(item.var_0)
        .margin(2)
        .width('100px')
        .height('100px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
      Text(item.var_1)
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
      Text(item.var_2)
        .maxFontSize(14)
        .fontColor('#666666')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('50%')
    .alignItems(HorizontalAlign.Center).width('100%')
  }

  build() {
    Column() {
      Text('品牌合作·精彩活动')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Row() {
        Image($rawfile('shouye/emoji_image_4_0.png'))
          .margin(2)
          .height('247px').objectFit(ImageFit.Cover).borderRadius(8)
        Image($rawfile('shouye/emoji_image_4_1.png'))
          .margin(2)
          .height('247px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceBetween)

      Grid() {
        ForEach(this.specItem_45_, (item: SpecItem_45) => {
          GridItem() {
            this.SpecItem_45_Builder(item)
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
      .columnsTemplate(('1fr ').repeat(2))
      .maxCount(2)
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