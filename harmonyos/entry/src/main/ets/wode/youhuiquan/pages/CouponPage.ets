import { CouponStatusFilterModule } from '../view/CouponStatusFilterModule';
import { CouponListModule } from '../view/CouponListModule';
import { CouponCollapseModule } from '../view/CouponCollapseModule';
import { FixedActionModule } from '../view/FixedActionModule';
import { CommonConstants } from '../common/CommonConstants';
import router from '@ohos.router';

@Component
export struct CouponPage {
  private scroller: Scroller = new Scroller();
  @Consume('appPathStack') appPathStack: NavPathStack;
  @State currentStatus: number = 0;

  build() {
    Scroll(this.scroller) {
      Column() {
        // 页面顶部标题栏
        Row() {
          // 返回箭头
          Text('<')
            .fontSize(24)
            .fontColor($r('app.color.font_primary'))
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              router.back();
            })
          // 页面标题
          Text('优惠券')
            .fontSize($r('app.integer.title_text_M'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_primary'))
          Blank()
            .width(24)
        }
        .width('100%')
        .height(56)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r('app.color.comp_background_primary'))

        CouponStatusFilterModule({ currentStatus: $currentStatus })
        CouponListModule({ currentStatus: $currentStatus })
        CouponCollapseModule({ currentStatus: $currentStatus })
        FixedActionModule()
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