@Component
export struct CouponAvailabilityModule {
  @State selectedCouponType: number = 0; // 0:代金券, 1:店铺赠券
  @State selectedAvailabilityType: number = 0; // 0:可用券, 1:不可用券
  @Consume('appPathStack') appPathStack: NavPathStack;

  build() {
    Column() {
      // 代金券/店铺赠券导航栏
      Row() {
        Text('代金券')
          .fontColor(this.selectedCouponType === 0 ? '#FFFFFF' : '#333333')
          .fontSize(16)
          .fontWeight(this.selectedCouponType === 0 ? FontWeight.Bold : FontWeight.Normal)
          .padding({
            left: 20,
            right: 20,
            top: 10,
            bottom: 10
          })
          .backgroundColor(this.selectedCouponType === 0 ? '#FF6B35' : '#F5F5F5')
          .borderRadius(20)
          .onClick(() => {
            this.selectedCouponType = 0;
            this.appPathStack.pushPath({ name: 'VoucherDetail' });
          })
        Text('店铺赠券')
          .fontColor(this.selectedCouponType === 1 ? '#FFFFFF' : '#333333')
          .fontSize(16)
          .fontWeight(this.selectedCouponType === 1 ? FontWeight.Bold : FontWeight.Normal)
          .padding({
            left: 20,
            right: 20,
            top: 10,
            bottom: 10
          })
          .backgroundColor(this.selectedCouponType === 1 ? '#FF6B35' : '#F5F5F5')
          .borderRadius(20)
          .onClick(() => {
            this.selectedCouponType = 1;
            this.appPathStack.pushPath({ name: 'StoreCouponDetail' });
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ top: '15px', bottom: '15px' })

      // 可用券/不可用券导航栏
      Row() {
        Text('可用券(0)')
          .fontColor(this.selectedAvailabilityType === 0 ? '#FFFFFF' : '#333333')
          .fontSize(14)
          .fontWeight(this.selectedAvailabilityType === 0 ? FontWeight.Bold : FontWeight.Normal)
          .padding({
            left: 15,
            right: 15,
            top: 8,
            bottom: 8
          })
          .backgroundColor(this.selectedAvailabilityType === 0 ? '#FF6B35' : '#F5F5F5')
          .borderRadius(15)
          .onClick(() => {
            this.selectedAvailabilityType = 0;
            this.appPathStack.pushPath({ name: 'AvailableCouponList' });
          })
        Text('不可用券(0)')
          .fontColor(this.selectedAvailabilityType === 1 ? '#FFFFFF' : '#333333')
          .fontSize(14)
          .fontWeight(this.selectedAvailabilityType === 1 ? FontWeight.Bold : FontWeight.Normal)
          .padding({
            left: 15,
            right: 15,
            top: 8,
            bottom: 8
          })
          .backgroundColor(this.selectedAvailabilityType === 1 ? '#FF6B35' : '#F5F5F5')
          .borderRadius(15)
          .onClick(() => {
            this.selectedAvailabilityType = 1;
            this.appPathStack.pushPath({ name: 'UnavailableCouponList' });
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({ top: '15px', bottom: '15px', left: '20px' })

      Column() {
        Image($r('app.media.emoji_image_1_0'))
          .margin(2)
          .width('162px')
          .height('188px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
        Text('暂无可用卡券')
          .maxFontSize(14)
          .fontColor('#333333')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: '17.1px', bottom: '17.1px' })
    }
    .width('95%')
    .alignItems(HorizontalAlign.Center)
    .padding({ top: '8.6px', bottom: '8.6px' })
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}