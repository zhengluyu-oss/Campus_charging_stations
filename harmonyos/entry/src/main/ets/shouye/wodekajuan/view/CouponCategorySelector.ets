@Component
export struct CouponCategorySelector {
  private selectedCategory: string = '全部';

  private onCategoryClick(category: string): void {
    this.selectedCategory = category;
    console.info(`分类按钮被点击: ${category}`);
  }

  build() {
    Row() {
      Button('全部(1)')
        .fontSize('14fp')
        //.fontColor($rawfile('app.color.font_on_primary'))
        .fontWeight(FontWeight.Medium)
        .padding({
          top: '8vp',
          bottom: '8vp',
          left: '16vp',
          right: '16vp'
        })
        //.backgroundColor($rawfile('app.color.background_emphasize'))
        .borderRadius('20vp')
        .borderWidth(0)
        .onClick(() => {
          this.onCategoryClick('全部');
        })
      Button('E卡(0)')
        .fontSize('14fp')
        //.fontColor($rawfile('app.color.background_emphasize'))
        .padding({
          top: '8vp',
          bottom: '8vp',
          left: '16vp',
          right: '16vp'
        })
       // .backgroundColor($rawfile('app.color.comp_emphasize_secondary'))
        .borderRadius('20vp')
        .borderWidth(0)
        .onClick(() => {
          this.onCategoryClick('E卡');
        })
      Button('赠券(0)')
        .fontSize('14fp')
        //.fontColor($rawfile('app.color.background_emphasize'))
        .padding({
          top: '8vp',
          bottom: '8vp',
          left: '16vp',
          right: '16vp'
        })
        //.backgroundColor($rawfile('app.color.comp_emphasize_secondary'))
        .borderRadius('20vp')
        .borderWidth(0)
        .onClick(() => {
          this.onCategoryClick('赠券');
        })
      Button('优惠券(1)')
        .fontSize('14fp')
        //.fontColor($rawfile('app.color.background_emphasize'))
        .padding({
          top: '8vp',
          bottom: '8vp',
          left: '16vp',
          right: '16vp'
        })
       // .backgroundColor($rawfile('app.color.comp_emphasize_secondary'))
        .borderRadius('20vp')
        .borderWidth(0)
        .onClick(() => {
          this.onCategoryClick('优惠券');
        })
    }
    .width('92%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
    //.backgroundColor($rawfile('app.color.background_primary'))
    .borderRadius('20vp')
    .padding({ top: '12vp', bottom: '12vp' })
    .margin({ bottom: '12vp', left: '4%', right: '4%' })
    .shadow({
      radius: 4,
      color: '#08000000',
      offsetX: 0,
      offsetY: 1
    })
  }
}