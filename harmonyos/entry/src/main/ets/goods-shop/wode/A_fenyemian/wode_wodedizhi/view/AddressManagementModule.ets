import { router } from "@kit.ArkUI"

@Component
export struct AddressManagementModule {
  build() {
    Column() {
      Row() {
        Text('<')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .onClick(() => {
            router.back()
          })
        Blank()
        Text('地址管理')
          .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
        Blank()
        Image($r('app.media.emoji_image_2_0'))
          .margin(2)
          .height('23px').objectFit(ImageFit.Cover).borderRadius(8)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Search({ placeholder: '请输入联系人、手机号码、详细地址' })
          .searchButton('搜索', { fontSize: 12, fontColor: '#000000' })
          .backgroundColor('#F0F0F0')
          .layoutWeight(1)
        Text('搜索')
          .maxFontSize(12)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        Image($r('app.media.emoji_image_2_1'))
          .margin(2)
          .width('183px')
          .height('109px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('暂时没有地址哟~')
          .maxFontSize(12)
          .fontColor('#888888')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: '10%', bottom: '10%' })

      Button('新增地址')
        .fontSize(14)
        .height(40)
        .type(ButtonType.Capsule)
        .fontColor('#FFFFFF')
        .backgroundColor('#FF6666')
        .constraintSize({ 'minWidth': '90%' })
    }
    .width('95%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}