import { ChargingStationModule } from '../view/ChargingStationModule';
import router from '@ohos.router';
@Component
export struct ScreenShot {
  @State selectedTab: string = '充电站'

  build() {
    Column() {
      // 导航栏
      Row() {
        // 返回按钮
        Button() {
          Image($r('app.media.emoji_image_2_0'))
            .width(24)
            .height(24)
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(40)
        .height(40)
        .onClick(() => { // 搜索框点击事件
          router.pushUrl({
            url: 'shouye/shouyeIndex' // 你的目标搜索详情页
          })
        });


        Blank()
        // 标题文字
        Text('最近充电')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.content_main_title_font_color'))
        Blank()
        // 占位，保持对称
        Blank()
          .width(40)
      }
      .width('100%')
      .height(56)
      .backgroundColor($r('app.color.background_primary'))
      .padding({ left: 16, right: 16 })

      // 选项卡区域
      Row() {
        Button('充电站')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.selectedTab === '充电站' ? $r('app.color.content_main_title_font_color') :
            $r('app.color.content_sub_title_font_color'))
          .backgroundColor(this.selectedTab === '充电站' ? $r('app.color.background_emphasize') : Color.Transparent)
          .borderRadius(20)
          .padding({
            left: 20,
            right: 20,
            top: 8,
            bottom: 8
          })
          .margin({ right: 12 })
          .onClick(() => {
            this.selectedTab = '充电站'
          })
        Button('充电终端')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.selectedTab === '充电终端' ? $r('app.color.content_main_title_font_color') :
            $r('app.color.content_sub_title_font_color'))
          .backgroundColor(this.selectedTab === '充电终端' ? $r('app.color.background_emphasize') : Color.Transparent)
          .borderRadius(20)
          .padding({
            left: 20,
            right: 20,
            top: 8,
            bottom: 8
          })
          .onClick(() => {
            this.selectedTab = '充电终端'
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ left: 16, top: 16, bottom: 16 })
      .backgroundColor($r('app.color.background_primary'))

      // 内容区
      Column() {
        ChargingStationModule()
      }
      .layoutWeight(1)
      .width('100%')

      // 悬浮按钮组
      Stack() {
        Column() {
          // 扫码充按钮
          Button() {
            Column() {
              Image($rawfile('shouye/emoji_image_1_0.png'))
                .width(20)
                .height(20)
                .margin({ bottom: 4 })
              Text('扫码充')
                .fontSize(12)
                .fontColor($r('app.color.font_on_primary'))
            }
          }
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.sky_blue_color'))
          .width(60)
          .height(60)
          .borderRadius(30)

          Blank()
            .height(16)
          // 大地图按钮
          Button() {
            Column() {
              Image($rawfile('shouye/emoji_image_2_0.png'))
                .width(20)
                .height(20)
                .margin({ bottom: 4 })
              Text('大地图')
                .fontSize(12)
                .fontColor($r('app.color.font_on_primary'))
            }
          }
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.sky_blue_color'))
          .width(60)
          .height(60)
          .borderRadius(30)
        }
        .alignItems(HorizontalAlign.End)
      }
      .align(Alignment.BottomEnd)
      .margin({ right: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_bg_color'))
  }
}