import { UserProfileModule } from '../view/UserProfileModule';
import { FunctionMenuModule } from '../view/FunctionMenuModule';
import { BrandServiceInfoModule } from '../view/BrandServiceInfoModule';
import { ChargingStatusDisplay } from '../view/ChargingStatusDisplay';

@Component
export struct ChargingMyPage {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        UserProfileModule()
        ChargingStatusDisplay()
        FunctionMenuModule()
        BrandServiceInfoModule()
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .height("100%")
    .width('100%')
    .align(Alignment.Top)
    .backgroundColor($r('app.color.page_bg_color'))
  }
}