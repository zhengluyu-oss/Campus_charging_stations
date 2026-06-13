import { PersonalCenterModule } from '../view/PersonalCenterModule';
import { UserNicknameSetting } from '../view/UserNicknameSetting';
import { MyOrderModule } from '../view/MyOrderModule';
import { MyAccountSettings } from '../view/MyAccountSettings';
import { EmptyContentModule } from '../view/EmptyContentModule';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        PersonalCenterModule()
        UserNicknameSetting()
        MyOrderModule()
        MyAccountSettings()
        EmptyContentModule()
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