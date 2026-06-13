@Component
export struct CompanyCertificationInfo {
  build() {
    Column() {
      Row() {
        // Image($r('app.media.emoji_image_4_0'))
        //   .margin(2)
        //   .height('63px').objectFit(ImageFit.Cover).borderRadius(8)
        Text('唐山学院生活服务部')
          .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
        Blank()
        Button('关注')
          .fontSize(14)
          .height(20)
          .type(ButtonType.Capsule)
          .fontColor('#FFFFFF')
          .backgroundColor('#555555')
          .onClick(() => {})
        Button('客服')
          .fontSize(14)
          .height(20)
          .type(ButtonType.Capsule)
          .fontColor('#FFFFFF')
          .backgroundColor('#555555')
          .onClick(() => {})
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.4px',
        bottom: '8.4px',
        left: '8.4px',
        right: '8.4px'
      })

      Column() {
        Text('已认证：校务处认证')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Text('开店时间：2018-04-23')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Image($rawfile('shangcheng/B_shouye/tangshanxueyuanxiaohui.png'))
          .margin(2)
          .width('227px')
          .height('236px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('进入唐山学院官网即可查看店铺细节')
          .maxFontSize(14)
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Center)
      .padding({
        top: '8.4px',
        bottom: '8.4px',
        left: '8.4px',
        right: '8.4px'
      })
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}