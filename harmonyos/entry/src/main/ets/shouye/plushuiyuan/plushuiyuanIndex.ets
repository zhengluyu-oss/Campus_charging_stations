import { ScreenShot } from './pages/ScreenShot'
import router from '@ohos.router';
@Entry
@Component
struct Index {
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();

  build() {
    // 堆叠布局：设置整体内容对齐方式为「左上角」
    Stack() {
      // 下层：ScreenShot 占满整个容器（不受对齐方式影响，因已设置宽高100%）
      ScreenShot()
        .width('100%')
        .height('100%')

      // 上层：按钮固定在左上角，设置灰色背景，优化边距
      Button('<')
        .width(40)
        .height(40)
        .fontSize(24)
        .backgroundColor(Color.Gray) // 关键：设置按钮背景色为灰色（核心修改点）

        .margin({ left: 10, top: -30 }) // 修正：移除负边距（top: -30会导致按钮超出页面可视区域）
      .onClick(() => { // 搜索框点击事件
      router.pushUrl({
        url: 'shouye/shouyeIndex' // 你的目标搜索详情页
      })
    });
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.TopStart) // 关键：设置Stack内子组件（未占满容器的）对齐方式为「左上角」
  }
}