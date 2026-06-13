import { ScreenShot } from './pages/ScreenShot'

@Entry
@Component
struct Index {
  // 移除了和 tabs 相关的变量（currentIndex、tabsController）
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.appPathStack) {
      // 直接展示 ScreenShot 组件，移除所有 Tabs/TabContent 相关代码
      ScreenShot()
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .width('100%') // 补充宽度，确保页面占满屏幕
    .height('100%') // 补充高度，确保页面占满屏幕
  }
}