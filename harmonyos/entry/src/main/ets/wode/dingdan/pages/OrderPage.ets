import { OrderStatusTabModule } from '../view/OrderStatusTabModule';
import { OrderListModule } from '../view/OrderListModule';
import { CommonConstants } from '../common/CommonConstants';
import router from '@ohos.router';

@Component
export struct OrderPage {
  private scroller: Scroller = new Scroller();
  @Consume('appPathStack') appPathStack: NavPathStack;
  @State currentTabIndex: number = 0;

  back(): void {
    router.back();
  }

  build() {
    Scroll(this.scroller) {
      Column() {
        // 顶部标题栏
        Row() {
          // 返回箭头
          Image($rawfile("wode/ic_back.svg"))
            .width(24)
            .height(24)
            .margin({ left: 16 })
            .onClick(() => {
              router.back();
            })
          Blank()
          // 页面标题
          Text('我的订单')
            .fontSize($r('app.integer.title_text_M'))
            .fontColor($r('app.color.font_primary'))
            .fontWeight(FontWeight.Medium)
          Blank()
          // 占位元素，保持对称
          Image($rawfile("wode/ic_back.svg"))
            .width(24)
            .height(24)
            .opacity(0)
            .margin({ right: 16 })
        }
        .width('100%')
        .height(56)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor($r('app.color.background_primary'))

        OrderStatusTabModule({ currentIndex: $currentTabIndex })
        OrderListModule({ currentTabIndex: $currentTabIndex })
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