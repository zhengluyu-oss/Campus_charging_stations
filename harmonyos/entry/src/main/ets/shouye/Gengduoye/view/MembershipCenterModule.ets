import { SpecItem_42 } from '../viewmodel/MembershipCenterModule';

@Component
export struct MembershipCenterModule {
  private specItem_42_: SpecItem_42[] = [
    { var_0: $rawfile('shouye/emoji_image_4_0.png'), var_1: '我的积分' },
    { var_0: $rawfile('shouye/emoji_image_4_1.png'), var_1: '积分兑换' },
    { var_0: $rawfile('shouye/emoji_image_4_2.png'), var_1: 'PLUS会员' },
    { var_0: $rawfile('shouye/emoji_image_4_3.png'), var_1: '网约车认证' },
    { var_0: $rawfile('shouye/emoji_image_4_4.png'), var_1: '商城' }
  ]

  @Builder
  SpecItem_42_Builder(item: SpecItem_42) {
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
      Text('会员中心')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Grid() {
        ForEach(this.specItem_42_, (item: SpecItem_42) => {
          GridItem() {
            this.SpecItem_42_Builder(item)
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