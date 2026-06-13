import { OrderListModule } from '../view/OrderListModule';
import { OrderSearchFilter } from '../view/OrderSearchFilter';
import { OrderStatusDisplay } from '../view/OrderStatusDisplay';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        OrderListModule()
        OrderSearchFilter()
        OrderStatusDisplay()
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