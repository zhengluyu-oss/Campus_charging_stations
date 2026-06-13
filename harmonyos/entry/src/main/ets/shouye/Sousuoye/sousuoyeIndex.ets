import { ScreenShot } from './pages/ScreenShot'

@Entry
@Component
struct Index {
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();

  build() {
    RelativeContainer() {
      ScreenShot()

    }
  }
}