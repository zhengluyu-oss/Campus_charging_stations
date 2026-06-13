import { SpecItem_10 } from '../viewmodel/AddressNotificationModule';

@Component
export struct AddressNotificationModule {
  private specItem_10_: SpecItem_10[] = [
    { var_0: '家庭住址', var_1: '可接收附近新站及促销活动等通知', var_2: $rawfile("wode/emoji_image_1_0.png")},
    { var_0: '公司地址', var_1: '可接收附近新站及促销活动等通知', var_2: $rawfile("wode/emoji_image_1_1.png")}
  ]

  @Builder
  SpecItem_10_Builder(item: SpecItem_10) {
    Row() {
      Text(item.var_0)
        .fontColor('black')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Blank()
      Text(item.var_1)
        .maxFontSize(14)
        .fontColor('gray')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Image(item.var_2)
        .margin(2)
        .height('27px').objectFit(ImageFit.Cover).borderRadius(8)
    }
    .width('100%')
    .backgroundColor('white')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: '9.2px',
      bottom: '9.2px',
      left: '18.5px',
      right: '18.5px'
    })
    .width('100%')
  }

  build() {
    List() {
      ForEach(this.specItem_10_, (item: SpecItem_10) => {
        ListItem() {
          this.SpecItem_10_Builder(item)
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
    .backgroundColor('white')
  }
}