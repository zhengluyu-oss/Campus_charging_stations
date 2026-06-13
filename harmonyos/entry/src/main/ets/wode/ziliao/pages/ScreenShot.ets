import { PersonalDataModule } from '../view/PersonalDataModule';
import { UserProfileSettings } from '../view/UserProfileSettings';
import { AddressNotificationModule } from '../view/AddressNotificationModule';
import { MyLevelModule } from '../view/MyLevelModule';
import { LogoutButton } from '../view/LogoutButton';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        PersonalDataModule()
          .margin({ top: 20, bottom: 15 })
        UserProfileSettings()
          .margin({ top: 15, bottom: 15 })
        AddressNotificationModule()
          .margin({ top: 15, bottom: 15 })
        MyLevelModule()
          .margin({ top: 15, bottom: 20 })
        LogoutButton()
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