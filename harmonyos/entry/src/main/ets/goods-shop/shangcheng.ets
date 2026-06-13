import { ScreenShot } from './shouye/pages/ScreenShot'
import { ScreenShot as shouye } from './shouye/pages/ScreenShot'
import { ScreenShot as wode } from './wode/pages/ScreenShot'
import { ScreenShot as dingdan } from './ding_dan/pages/ScreenShot'
import { ScreenShot as fenLei } from './fen_lei/pages/ScreenShot'
@Entry
@Component
export  struct shangcheng {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();

  @Builder
  tabBuilder(title: string, targetIndex: number, icon: Resource) {
    Column() {
      Image(icon)
        .width("24vp")
        .height("24vp")
        .objectFit(ImageFit.Contain)
        .fillColor(this.currentIndex === targetIndex ? ($r('app.color.app_icon_pressed_color')) :
          ($r('app.color.app_icon_color')))
      Text(title)
        .fontSize("10vp")
        .fontColor(this.currentIndex === targetIndex ? ($r('app.color.app_icon_pressed_color')) :
          ($r('app.color.app_icon_color')))
        .textAlign(TextAlign.Center)
        .lineHeight("14vp")
        .fontWeight(500)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  build() {
    Navigation(this.appPathStack) {
      Tabs({
        barPosition: BarPosition.End,
        controller: this.tabsController
      }) {
        TabContent() {
          shouye()
        }.tabBar(this.tabBuilder('首页', 0, $r("app.media.lib_icon_37")))

        TabContent() {
          fenLei()
        }.tabBar(this.tabBuilder('分类', 1, $r("app.media.lib_icon_173")))

        TabContent() {
          dingdan()
        }.tabBar(this.tabBuilder('订单', 2, $r("app.media.lib_icon_182")))

        TabContent() {
          wode()
        }.tabBar(this.tabBuilder('我的', 3, $r("app.media.lib_icon_181")))
      }
      .barWidth("100%")
      .barHeight("76vp")
      .barMode(BarMode.Fixed, { nonScrollableLayoutStyle: LayoutStyle.ALWAYS_CENTER })
      .vertical(false)
      .scrollable(false)
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.page_bg_color'))
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}