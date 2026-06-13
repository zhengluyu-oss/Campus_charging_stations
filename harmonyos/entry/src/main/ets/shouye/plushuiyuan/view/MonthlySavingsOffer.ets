@Component
export struct MonthlySavingsOffer {
  build() {
    Column() {
      // 主标题
      Text('每月最高省')
        .fontSize(18)
        .fontColor('#8B4513')
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
      // 金额突出显示
      Row() {
        Text('158')
          .fontSize(36)
          .fontColor('#FF6B35')
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
        Text('元')
          .fontSize(20)
          .fontColor('#8B4513')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 4 })
          .maxLines(1)
      }
      .alignItems(VerticalAlign.Bottom)
      .margin({ top: 8, bottom: 8 })

      // 副标题
      Text('开通PLUS会员立享优惠')
        .fontSize(14)
        .fontColor('#8B4513')
        .fontWeight(FontWeight.Normal)
        .maxLines(1)
    }
    .width('100%')
    .backgroundColor('#FFF5E6')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: 20,
      bottom: 20,
      left: 24,
      right: 24
    })
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 3
    })
    .border({ width: 2, color: '#FFE4C4', style: BorderStyle.Solid })
  }
}