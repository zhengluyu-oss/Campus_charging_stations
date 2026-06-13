import { BillFilterModule } from '../view/BillFilterModule';
import { BillingOverviewModule } from '../view/BillingOverviewModule';
import { BillListModule } from '../view/BillListModule';
import { InvoiceExportSupportModule } from '../view/InvoiceExportSupportModule';
import { CommonConstants } from '../common/CommonConstants';
import router from '@ohos.router';

@Component
export struct ChargingBill {
  private scroller: Scroller = new Scroller();
  @Consume('appPathStack') appPathStack: NavPathStack;
  @State currentFilter: string = '日';

  build() {
    Scroll(this.scroller) {
      Column() {
        // 顶部标题栏
        Row() {
          // 返回箭头（小于号样式）
          Text('‹')
            .fontSize(24)
            .fontColor($r('app.color.font_primary'))
            .fontWeight(FontWeight.Bold)
            .width(24)
            .height(24)
            .margin({ left: 16 })
            .textAlign(TextAlign.Center)

          // 充电账单标题
          Text('充电账单')
            .fontSize($r('app.integer.title_text_M'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_primary'))
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ left: -48 }) // 抵消返回箭头的宽度
        }
        .width('100%')
        .height(56)
        .backgroundColor($r('app.color.comp_background_primary'))
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.back()
        })

        BillingOverviewModule()
        BillFilterModule({ currentFilter: $currentFilter })
        // 根据选中的过滤器显示不同的账单内容
        if (this.currentFilter === '日') {
          Column() {
            Text('日账单内容')
              .fontSize($r('app.integer.title_text_M'))
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.font_primary'))
              .margin({ top: 20, bottom: 20 })
            BillListModule()
          }
          .width('100%')
        } else if (this.currentFilter === '周') {
          Column() {
            Text('周账单内容')
              .fontSize($r('app.integer.title_text_M'))
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.font_primary'))
              .margin({ top: 20, bottom: 20 })
            BillListModule()
          }
          .width('100%')
        } else if (this.currentFilter === '月') {
          Column() {
            Text('月账单内容')
              .fontSize($r('app.integer.title_text_M'))
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.font_primary'))
              .margin({ top: 20, bottom: 20 })
            BillListModule()
          }
          .width('100%')
        }
        InvoiceExportSupportModule()
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