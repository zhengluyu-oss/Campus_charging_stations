import { MyCouponsModule } from '../view/MyCouponsModule';
import { CouponCategorySelector } from '../view/CouponCategorySelector';
import { SortOptionsModule } from '../view/SortOptionsModule';
import { DiscountCouponModule } from '../view/DiscountCouponModule';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        MyCouponsModule()
        CouponCategorySelector()
        SortOptionsModule()
        DiscountCouponModule()
      }
      .width('100%')
      .padding({ top: '10vp', bottom: '20vp' })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .backgroundColor($r('app.color.background_secondary'))
  }
}