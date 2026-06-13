@Component
export struct InvoiceNotificationModule {
  build() {
    Column() {
      Text('发票开具通知')
        .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
      Text('亲爱的特来电用户：')
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Text('自2022年起，商城内付费购买的代金券或服务费套餐，可直接在“我的订单”，申请开具电子发票，如选择申请纸质发票，需要填写正确的地址，申请开票销售实际支付金额满200元包邮；订单金额不足200元，发票邮寄费用需自行承担或订单金额累计满200元后再享包邮。')
        .maxFontSize(12)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
      Text('请广大用户知悉，不再另行通知。')
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: '8.4px',
      bottom: '8.4px',
      left: '8.4px',
      right: '8.4px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}