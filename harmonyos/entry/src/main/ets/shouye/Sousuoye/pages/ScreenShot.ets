import { SearchBarModule } from '../view/SearchBarModule';
import { EmptyContentModule } from '../view/EmptyContentModule';
import { VoiceSearchModule } from '../view/VoiceSearchModule';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        SearchBarModule()
        EmptyContentModule()
        VoiceSearchModule()
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