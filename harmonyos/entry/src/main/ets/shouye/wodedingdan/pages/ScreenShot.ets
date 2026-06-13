import { MyOrderModule } from '../view/MyOrderModule';
import { OrderStatusDisplay } from '../view/OrderStatusDisplay';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        MyOrderModule()
        OrderStatusDisplay()
      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    //.backgroundColor($rawfile('app.color.page_bg_color'))
  }
}