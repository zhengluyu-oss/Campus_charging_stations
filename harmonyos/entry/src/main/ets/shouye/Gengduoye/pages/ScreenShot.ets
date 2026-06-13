import { FunctionCenterModule } from '../view/FunctionCenterModule';
import { HomePageFunctionModule } from '../view/HomePageFunctionModule';
import { FindChargingStationModule } from '../view/FindChargingStationModule';
import { MyWalletModule } from '../view/MyWalletModule';
import { MyChargingModule } from '../view/MyChargingModule';
import { MyPileManagement } from '../view/MyPileManagement';
import { MyCommunityModule } from '../view/MyCommunityModule';
import { MembershipCenterModule } from '../view/MembershipCenterModule';
import { MyLoveCarModule } from '../view/MyLoveCarModule';
import { SettingsMenuModule } from '../view/SettingsMenuModule';
import { MobileCloudDisk } from '../view/MobileCloudDisk';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        FunctionCenterModule()
        HomePageFunctionModule()
        FindChargingStationModule()
        MyWalletModule()
        MyChargingModule()
        MyPileManagement()
        MyCommunityModule()
        MembershipCenterModule()
        MyLoveCarModule()
        SettingsMenuModule()
        MobileCloudDisk()
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