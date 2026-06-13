@Component
export struct OrderStatusDisplay {
  @State currentStatus: string = '全部'

  build() {
    Column() {
      Row() {
        Column() {
          Text('全部')
            .maxFontSize(16)
            .fontColor(this.currentStatus === '全部' ? '#FF6B35' : '#666666')
            .fontWeight(this.currentStatus === '全部' ? FontWeight.Bold : FontWeight.Normal)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .padding({
          top: 8,
          bottom: 8,
          left: 16,
          right: 16
        })
        .backgroundColor(this.currentStatus === '全部' ? '#FFF5F2' : '#FFFFFF')
        .borderRadius(20)
        .onClick(() => {
          this.currentStatus = '全部'
        })

        Column() {
          Text('进行中')
            .maxFontSize(16)
            .fontColor(this.currentStatus === '进行中' ? '#FF6B35' : '#666666')
            .fontWeight(this.currentStatus === '进行中' ? FontWeight.Bold : FontWeight.Normal)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .padding({
          top: 8,
          bottom: 8,
          left: 16,
          right: 16
        })
        .backgroundColor(this.currentStatus === '进行中' ? '#FFF5F2' : '#FFFFFF')
        .borderRadius(20)
        .onClick(() => {
          this.currentStatus = '进行中'
        })

        Column() {
          Text('待支付')
            .maxFontSize(16)
            .fontColor(this.currentStatus === '待支付' ? '#FF6B35' : '#666666')
            .fontWeight(this.currentStatus === '待支付' ? FontWeight.Bold : FontWeight.Normal)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .padding({
          top: 8,
          bottom: 8,
          left: 16,
          right: 16
        })
        .backgroundColor(this.currentStatus === '待支付' ? '#FFF5F2' : '#FFFFFF')
        .borderRadius(20)
        .onClick(() => {
          this.currentStatus = '待支付'
        })

        Column() {
          Text('待评价')
            .maxFontSize(16)
            .fontColor(this.currentStatus === '待评价' ? '#FF6B35' : '#666666')
            .fontWeight(this.currentStatus === '待评价' ? FontWeight.Bold : FontWeight.Normal)
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .padding({
          top: 8,
          bottom: 8,
          left: 16,
          right: 16
        })
        .backgroundColor(this.currentStatus === '待评价' ? '#FFF5F2' : '#FFFFFF')
        .borderRadius(20)
        .onClick(() => {
          this.currentStatus = '待评价'
        })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: '16px', bottom: '16px' })

      Column() {
        Image($rawfile('shouye/emoji_image_1_0.png'))
          .margin({ bottom: 16 })
          .width('120px')
          .height('80px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('暂无订单')
          .maxFontSize(16)
          .fontColor('#999999')
          .margin({ bottom: 8 })
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: '60px', bottom: '60px' })
    }
    .width('95%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 10 })
    .clip(true)
  }
}