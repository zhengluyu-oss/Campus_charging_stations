import { SearchBarModule } from '../view/SearchBarModule';
import { ChargingStationFinder } from '../view/ChargingStationFinder';
import { ChargingStationListModule } from '../view/ChargingStationListModule';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        SearchBarModule()
        ChargingStationFinder()
        ChargingStationListModule()
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