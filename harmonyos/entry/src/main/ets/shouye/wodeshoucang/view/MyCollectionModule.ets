import router from '@ohos.router';
@Component
export struct MyCollectionModule {
  @State selectedButton: number = 1 // 1表示充电站，2表示充电终端

  build() {
    Column() {
      Row() {
        Button('<')
          .fontSize(16)
          .width(40)
          .height(40)
          .type(ButtonType.Normal)
          .fontColor('#333333')
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
          .onClick(() => { // 搜索框点击事件
            router.pushUrl({
              url: 'shouye/shouyeIndex' // 你的目标搜索详情页
            })
          });
        Blank()
        Text('我的收藏')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1A1A1A')
        Blank()
        Button('<')
          .fontSize(16)
          .width(40)
          .height(40)
          .type(ButtonType.Normal)
          .fontColor('#FFFFFF')
          .backgroundColor('#FFFFFF')
          .opacity(0)
      }
      .width('100%')
      .height(56)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16 })
      .border({ width: { bottom: 1 }, color: '#F0F0F0' })

      Row() {
        Button('充电站')
          .fontSize(14)
          .height(32)
          .type(ButtonType.Capsule)
          .fontColor(this.selectedButton === 1 ? '#FFFFFF' : '#666666')
          .backgroundColor(this.selectedButton === 1 ? '#1890FF' : '#F5F5F5')
          .border({ width: 1, color: this.selectedButton === 1 ? '#1890FF' : '#E0E0E0' })
          .padding({ left: 20, right: 20 })
          .onClick(() => {
            this.selectedButton = 1
          })
        Blank()
          .width(12)
        Button('充电终端')
          .fontSize(14)
          .height(32)
          .type(ButtonType.Capsule)
          .fontColor(this.selectedButton === 2 ? '#FFFFFF' : '#666666')
          .backgroundColor(this.selectedButton === 2 ? '#1890FF' : '#F5F5F5')
          .border({ width: 1, color: this.selectedButton === 2 ? '#1890FF' : '#E0E0E0' })
          .padding({ left: 20, right: 20 })
          .onClick(() => {
            this.selectedButton = 2
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .padding({
        left: 16,
        right: 16,
        top: 16,
        bottom: 16
      })

      Column() {
        Image($rawfile('shouye/emoji_image_2_0.png'))
          .width(120)
          .height(120)
          .objectFit(ImageFit.Contain)
          .margin({ bottom: 16 })
        Text('暂无收藏的终端')
          .fontSize(14)
          .fontColor('#999999')
          .lineHeight(20)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ top: 80, bottom: 80 })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(0)
    .margin({ bottom: 0 })
    .clip(true)
  }
}