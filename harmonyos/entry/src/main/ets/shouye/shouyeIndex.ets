import { ScreenShot } from './pages/ScreenShot'

@Entry
@Component
export  struct shouye {
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
          ScreenShot()
        }.tabBar(this.tabBuilder('首页', 0, $rawfile('all_in/shouye.png')))

        TabContent() {
          ScreenShot()
        }.tabBar(this.tabBuilder('商城', 3, $rawfile('all_in/shangcheng‘.png')))

        TabContent() {
          ScreenShot()
        }.tabBar(this.tabBuilder('我', 4, $rawfile('all_in/wo.png')))
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
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .linearGradient({
      angle: 180,
      colors: [['#E6F7FF', 0.0], ['#E6F7FF', 0.06], [$r('app.color.page_bg_color'), 0.06]]
    })
  }
}