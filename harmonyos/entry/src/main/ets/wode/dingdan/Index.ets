import { PageMap } from './detail/SecondPageBuilder'
import { OrderPage } from './pages/OrderPage';

@Entry
@Component
struct Index {
  private scroller: Scroller = new Scroller();
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();
  @State title: string = 'page_title';

  build() {
    Navigation(this.appPathStack) {
      Column() {
        Scroll(this.scroller) {
          Column() {
            OrderPage()
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .width('100%')
      }
      .backgroundColor('#F1F3F5')
      .height('100%')
    }
    .navDestination(PageMap)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}