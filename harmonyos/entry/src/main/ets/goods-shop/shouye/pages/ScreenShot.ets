import { ShopHomePageModule } from '../view/ShopHomePageModule';
import { SearchBarModule } from '../view/SearchBarModule';
import { TelaECommerceHeader } from '../view/TelaECommerceHeader';
import { FunctionAreaNavigation } from '../view/FunctionAreaNavigation';
import { ChargeStationPromotionModule } from '../view/ChargeStationPromotionModule';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        ShopHomePageModule()
        SearchBarModule()
        TelaECommerceHeader()
        FunctionAreaNavigation()
        ChargeStationPromotionModule()
      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    .backgroundColor($r('app.color.page_bg_color'))
  }
}