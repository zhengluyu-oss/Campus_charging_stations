import { CommonConstants } from '../common/CommonConstants';
import { CouponDetailModuleSecondPage } from '../view/CouponDetailModuleSecondPage';

@Component
export struct StoreCouponDetail {
  @Consume('appPathStack') appPathStack: NavPathStack;
  private scroller: Scroller = new Scroller();

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column() {
          TopNavigationView({
            title: "返回",
            onBackClick: () => {
              this.appPathStack.pop();
            }
          })
          CouponDetailModuleSecondPage()
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width('100%')
      .align(Alignment.Top)
      .backgroundColor($r('app.color.page_bg_color'))
    }.hideTitleBar(true)
  }
}

@Component
struct TopNavigationView {
  title?: ResourceStr;
  onBackClick?: Function;

  build() {
    Row() {
      if (this.onBackClick) {
        Image($r('app.media.ic_back'))
          .width("24vp")
          .height("24vp")
          .margin({ right: "8vp" })
          .onClick(() => this.onBackClick?.())
      }
      Text(this.title)
        .fontSize("18fp")
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
        .onClick(() => this.onBackClick?.())
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PERCENT)
    .height("54vp")
    .padding({
      left: "14vp",
      right: "14vp"
    })
  }
}