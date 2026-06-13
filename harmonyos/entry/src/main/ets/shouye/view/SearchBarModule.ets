import router from '@ohos.router';

@Component
export struct SearchBarModule {
  build() {
    // 外层浅蓝背景容器
    Row() {
      // 核心白色搜索栏容器（胶囊型）
      Row() {
        // 左侧：天津 + 下拉箭头（复用原有图片）
        Row() {
          Text('天津')
            .margin({ right: 4 })
            .minFontSize(8)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontSize(14)
          // 放大：下拉箭头（原12×8 → 现16×11，等比例放大，适配文字高度）
        Image($rawfile('shouye/xiajiantou.png'))
            .margin(2)
            .width(16)  // 统一使用vp数值，适配不同设备
            .height(11)
            .objectFit(ImageFit.Contain)
            .borderRadius(0)
        }
        .alignItems(VerticalAlign.Center)
        .layoutWeight(1)

        // 中间：搜索框 + 放大镜（修复placeholderFont无color问题）
        Row() {
          // 放大：放大镜图标（原16×16 → 现22×22，与搜索框文字更协调且更醒目）
          Image($rawfile('shouye/emoji_image_6_0.png'))
            .margin({ right: 6 })
            .width(22)
            .height(22)
            .objectFit(ImageFit.Contain)
            .borderRadius(0)
          Search({ placeholder: '目的地/电站名/功能' })
          // 修复点1：placeholderFont仅保留size（移除color）
            .placeholderFont({ size: 14 })
            // 修复点2：占位符颜色通过placeholderColor单独设置
            .placeholderColor('#999999')

            .backgroundColor('transparent')

            .layoutWeight(1)
            .textFont({ size: 14 })
            .onClick(() => { // 搜索框点击事件
            router.pushUrl({
              url: 'shouye/Sousuoye/sousuoyeIndex' // 你的目标搜索详情页
            })
          });
        }
        .layoutWeight(3)
        .alignItems(VerticalAlign.Center)


        // 右侧：麦克风/耳机/消息图标
        Row() {
          // 放大：麦克风图标（原20×20 → 现28×28，三个图标统一放大，视觉整齐）
          Image($rawfile('shouye/emoji_image_6_1.png'))
            .margin({ right: 8 })
            .width(28)
            .height(28)
            .objectFit(ImageFit.Contain)
            .borderRadius(0)
          // 放大：耳机图标（与麦克风尺寸统一，保持视觉协调）
          Image($rawfile('shouye/emoji_image_6_2.png'))
            .margin({ right: 8 })
            .width(28)
            .height(28)
            .objectFit(ImageFit.Contain)
            .borderRadius(0)
          // 放大：消息图标（与其他两个图标尺寸统一，点击区域更舒适）
          Image($rawfile('shouye/emoji_image_6_3.png'))
            .margin(2)
            .width(28)
            .height(28)
            .objectFit(ImageFit.Contain)
            .borderRadius(0)
        }
        .alignItems(VerticalAlign.Center)
        .layoutWeight(1.5)
      }
      .width('100%')
      .padding({
        left: 12,
        right: 12,
        top: 7,
        bottom: 7
      })
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .alignItems(VerticalAlign.Center)

    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .padding({
      top: 8.6,
      bottom: 8.6,
      left: 8.6,
      right: 8.6
    })
    .backgroundColor('#E6F7FF')
    .margin({ bottom: 10 })
    .clip(true)
    .constraintSize({ minHeight: '4.72%' })
  }
}