import { ShopAnnouncementModule } from '../view/ShopAnnouncementModule';
import { ShopAnnouncementModuleStyleA } from '../view/ShopAnnouncementModuleStyleA';
import { InvoiceNotificationModule } from '../view/InvoiceNotificationModule';
@Entry
@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        ShopAnnouncementModule()
        ShopAnnouncementModuleStyleA()
        InvoiceNotificationModule()
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