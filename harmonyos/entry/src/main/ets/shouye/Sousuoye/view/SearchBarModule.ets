
import router from '@ohos.router';
@Component
export struct SearchBarModule {
  build() {
    // Row() {
    //   // 城市选择文本
    //   Text('天津')
    //     .margin(5)
    //     .minFontSize(8)
    //     .textOverflow({ overflow: TextOverflow.Ellipsis })
    //     .maxLines(1)
    //
    //   Blank() // 占位，分隔城市与搜索框
    //
    //   // 搜索框（自带“取消”按钮）
    //   Search({ placeholder: '目的地/电站名/功能' })
    //     .searchButton('取消', { fontSize: 14, fontColor: '#000000' })// 搜索框右侧的取消按钮
    //
    //     .backgroundColor('#F0F0F0')
    //     .layoutWeight(1) // 让搜索框占满剩余空间
    //    .onClick(() => {
    //     router.pushUrl({
    //     url: 'shouye/shouyeIndex' // 你的目标搜索详情页
    //    })
    //   });
    // }
    // .width('95%')
    // .backgroundColor('#FFFFFF')
    // .alignItems(VerticalAlign.Center)
    // .justifyContent(FlexAlign.SpaceBetween)
    // .padding({
    //   top: '8.6px',
    //   bottom: '8.6px',
    //   left: '8.6px',
    //   right: '8.6px'
    // })
    // .borderRadius(20)
    // .margin({ bottom: 10 })
    // .clip(true)
    Column() {
      Row() {
        // 1. 左侧定位区
        Row() {
          Text('天津')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .margin({ right: 4 })

          Image($rawfile('shouye/xiajiantou.png'))
            .width(12)
            .height(12)
            .fillColor('#333333')
            .objectFit(ImageFit.Contain)
        }
        .alignItems(VerticalAlign.Center)
        .margin({ right: 12 })

        // 2. 中间搜索框 (胶囊样式)
        Row() {
          Image($rawfile('shouye/emoji_image_6_0.png')) // 放大镜
            .width(18)
            .height(18)
            .margin({ right: 8 })
            .fillColor('#999999')

          Text('目的地 / 电站名 / 功能')
            .fontSize(14)
            .fontColor('#999999')
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .height(40)
        .backgroundColor('#F5F7FA') // 浅灰背景，形成层次
        .borderRadius(20)
        .padding({ left: 12, right: 12 })
        .layoutWeight(1) // 占据剩余空间
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.pushUrl({ url: 'shouye/Sousuoye/sousuoyeIndex' })
        })

        // 3. 右侧功能区 (图标群)
        Row({ space: 16 }) { // 使用 space 自动控制间距
          Image($rawfile('shouye/emoji_image_6_1.png'))
            .width(24)
            .height(24)
          Image($rawfile('shouye/emoji_image_6_2.png'))
            .width(24)
            .height(24)
          Image($rawfile('shouye/emoji_image_6_3.png'))
            .width(24)
            .height(24)
        }
        .margin({ left: 12 })
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .backgroundColor(Color.White)
    }
    .width('100%')
    .shadow({ radius: 10, color: 'rgba(0,0,0,0.05)', offsetY: 2 }) // 关键：底部柔和阴影
    .zIndex(100) // 保证层级最高
  }
}