import { SpecItem_32 } from '../viewmodel/MyCommunityModule';

@Component
export struct MyCommunityModule {
  private specItem_32_: SpecItem_32[] = [
    { var_0: $rawfile('shouye/emoji_image_3_0.png'), var_1: '我的动态' },
    { var_0: $rawfile('shouye/emoji_image_3_1.png'), var_1: '我的好友' },
    { var_0: $rawfile('shouye/emoji_image_3_2.png'), var_1: '我的私信' },
    { var_0: $rawfile('shouye/emoji_image_3_3.png'), var_1: '我的反馈' },
    { var_0: $rawfile('shouye/emoji_image_3_4.png'), var_1: '我的问答' }
  ]

  @Builder
  SpecItem_32_Builder(item: SpecItem_32) {
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
      Text('我的社区')
        .maxFontSize(18)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Grid() {
        ForEach(this.specItem_32_, (item: SpecItem_32) => {
          GridItem() {
            this.SpecItem_32_Builder(item)
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