import { PageMap } from './detail/SecondPageBuilder'
import { BreakpointConstants } from './common/BreakpointConstants';
import { CommonConstants } from './common/CommonConstants';
import { ChargingMyPage } from './pages/ChargingMyPage';

@Entry
@Component
struct Index {
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();
  @StorageLink('currentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  build() {
    Navigation(this.appPathStack) {
      ChargingMyPage()
    }
    .backgroundColor($r('app.color.page_bg_color'))
    .navDestination(PageMap)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}