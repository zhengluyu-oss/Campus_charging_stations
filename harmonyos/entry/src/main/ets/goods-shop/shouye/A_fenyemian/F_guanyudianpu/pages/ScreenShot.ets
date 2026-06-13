import { AboutShopModule } from '../view/AboutShopModule';
import { CompanyCertificationInfo } from '../view/CompanyCertificationInfo';
import { LegalDocumentsModule } from '../view/LegalDocumentsModule';
@Entry
@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        AboutShopModule()
        CompanyCertificationInfo()
        LegalDocumentsModule()
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