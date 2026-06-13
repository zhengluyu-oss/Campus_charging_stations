import router from '@ohos.router';
@Component
export struct MyCouponsModule {
  private onAddCouponClick(): void {
    console.info('添加卡券按钮被点击');
  }

  build() {
    Row() {
        Text('<')
        .margin({ left: '12vp', right: '8vp' })
        .width('24vp')
        .height('24vp')
        .borderRadius(12)
          .onClick(() => { // 搜索框点击事件
            router.pushUrl({
              url: 'shouye/shouyeIndex' // 你的目标搜索详情页
            })
          });
      Text('我的卡券')
        .fontSize('16fp')
        //.fontColor($r('app.color.content_font_color'))
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
      Button('+')
        .fontSize('18fp')
        .width('32vp')
        .height('32vp')
        .type(ButtonType.Circle)
       // .fontColor($r('app.color.font_on_primary'))
        //.backgroundColor($r('app.color.background_emphasize'))
        .margin({ right: '12vp' })
        .onClick(() => {
          this.onAddCouponClick();
        })
    }
    .width('92%')
    .height('56vp')
    //.backgroundColor($rawfile('app.color.background_primary'))
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius('28vp')
    .margin({
      top: '8vp',
      bottom: '12vp',
      left: '4%',
      right: '4%'
    })
    .shadow({
      radius: 6,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 1
    })
  }
}