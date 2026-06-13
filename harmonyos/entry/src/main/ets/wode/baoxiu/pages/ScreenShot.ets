import { PersonalPileRepair } from '../view/PersonalPileRepair';
import { FaultReportModule } from '../view/FaultReportModule';
import { FaultImageUpload } from '../view/FaultImageUpload';
import { SubmitRepairButton } from '../view/SubmitRepairButton';

@Component
export struct ScreenShot {
  private scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Column() {
        PersonalPileRepair()
        FaultReportModule()
        FaultImageUpload()
        SubmitRepairButton()
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