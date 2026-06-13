import { PlusMembershipActivation } from '../view/PlusMembershipActivation';
import { MonthlySavingsOffer } from '../view/MonthlySavingsOffer';
import { MembershipBenefitsModule } from '../view/MembershipBenefitsModule';
import { MembershipPricingOptions } from '../view/MembershipPricingOptions';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        PlusMembershipActivation()
          .margin({ top: 16, bottom: 12 })
        MonthlySavingsOffer()
          .margin({ top: 12, bottom: 12 })
        MembershipBenefitsModule()
          .margin({ top: 12, bottom: 12 })
        MembershipPricingOptions()
          .margin({ top: 12, bottom: 24 })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .backgroundColor('#F8F9FA')
  }
}