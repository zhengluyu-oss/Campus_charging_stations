import { NewProductZone } from '../view/NewProductZone';
import { ProductListModule } from '../view/ProductListModule';
@Entry
@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        NewProductZone()
        Blank().height(20)
        ProductListModule()
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