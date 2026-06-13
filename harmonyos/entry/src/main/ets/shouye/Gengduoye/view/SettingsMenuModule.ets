import { SpecItem_62 } from '../viewmodel/SettingsMenuModule';

@Component
export struct SettingsMenuModule {
  private specItem_62_: SpecItem_62[] = [
    { var_0: $rawfile('shouye/emoji_image_6_0.png'), var_1: '个人资料' },
    { var_0: $rawfile('shouye/emoji_image_6_1.png'), var_1: '账号与安全' },
    { var_0: $rawfile('shouye/emoji_image_6_2.png'), var_1: '偏好设置' },
    { var_0: $rawfile('shouye/emoji_image_6_3.png'), var_1: '充电设置' },
    { var_0: $rawfile('shouye/emoji_image_6_4.png'), var_1: '消息提醒' },
    { var_0: $rawfile('shouye/emoji_image_6_5.png'), var_1: '支付设置' },
    { var_0: $rawfile('shouye/emoji_image_6_6.png'), var_1: '换肤' },
    { var_0: $rawfile('shouye/emoji_image_6_7.png'), var_1: '小特课堂' },
    { var_0: $rawfile('shouye/emoji_image_6_8.png'), var_1: '客服中心' }
  ]

  @Builder
  SpecItem_62_Builder(item: SpecItem_62) {
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
      Text('设置')
        .maxFontSize(18)
        .margin(5)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Grid() {
        ForEach(this.specItem_62_, (item: SpecItem_62) => {
          GridItem() {
            this.SpecItem_62_Builder(item)
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