import { SearchBarModule } from '../view/SearchBarModule';
import { FunctionMenuModule } from '../view/FunctionMenuModule';
import { ChargeRewardProgress } from '../view/ChargeRewardProgress';
import { RecommendedStationModule } from '../view/RecommendedStationModule';
import { BrandCooperationActivities } from '../view/BrandCooperationActivities';
import { DiscountCouponModule } from '../view/DiscountCouponModule';
import { ChargingPileHotSales } from '../view/ChargingPileHotSales';
import { CumulativeChargeStatistics } from '../view/CumulativeChargeStatistics';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        SearchBarModule()
        FunctionMenuModule()
        ChargeRewardProgress()
        RecommendedStationModule()
        BrandCooperationActivities()
        DiscountCouponModule()
        ChargingPileHotSales()
        CumulativeChargeStatistics()
      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .align(Alignment.Top)
    // .backgroundColor($rawfile('app.color.page_bg_color'))
    // Column() {
    //   SearchBarModule()
    //   Scroll() {
    //     Column() {
    //       FunctionMenuModule()
    //       ChargeRewardProgress()
    //       RecommendedStationModule()
    //     }
    //     .width('100%')
    //   }
    //   .layoutWeight(1) // 让内容区占据剩余空间
    //   .scrollBar(BarState.Off)
    // }
    // .width('100%')
    // .height('100%')
    // .backgroundColor('#F5F7FA') // 必须设置这个浅灰色背景，白色卡片才能显现出来
  }
}