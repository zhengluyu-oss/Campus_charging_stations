import { BatteryGuardReport } from '../view/BatteryGuardReport';
import { BatteryLevelDisplay } from '../view/BatteryLevelDisplay';
import { BatteryHealthScore } from '../view/BatteryHealthScore';
import { BatteryStatusSummary } from '../view/BatteryStatusSummary';
import { ConclusionAndSuggestionModule } from '../view/ConclusionAndSuggestionModule';
import { ChargeHealthReportModule } from '../view/ChargeHealthReportModule';
import { ConclusionPlaceholder } from '../view/ConclusionPlaceholder';
import { BatteryHealthCheckModule } from '../view/BatteryHealthCheckModule';
import { SameModelComparisonModule } from '../view/SameModelComparisonModule';
import { BatteryFaultStatus } from '../view/BatteryFaultStatus';
import { BatteryHealthOverview } from '../view/BatteryHealthOverview';
import { BatteryHealthAnalysis } from '../view/BatteryHealthAnalysis';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        BatteryGuardReport()
        BatteryLevelDisplay()
        BatteryHealthScore()
        BatteryStatusSummary()
        ConclusionAndSuggestionModule()
        ChargeHealthReportModule()
        ConclusionPlaceholder()
        BatteryHealthCheckModule()
        SameModelComparisonModule()
        BatteryFaultStatus()
        BatteryHealthOverview()
        BatteryHealthAnalysis()
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