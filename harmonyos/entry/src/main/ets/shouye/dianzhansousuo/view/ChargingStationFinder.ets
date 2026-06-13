@Component
export struct ChargingStationFinder {
  build() {
    Column() {
      Row() {
        Button('距离/区域')
          .fontSize(14)
          .height(30)
          .type(ButtonType.Normal)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
        Button('综合排序')
          .fontSize(14)
          .height(30)
          .type(ButtonType.Normal)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
        Button('充电站')
          .fontSize(14)
          .height(30)
          .type(ButtonType.Normal)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
        Button('偏好')
          .fontSize(14)
          .height(30)
          .type(ButtonType.Normal)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: '8.6px',
        bottom: '8.6px',
        left: '8.6px',
        right: '8.6px'
      })

      Scroll() {
        Row() {
          Button('星级站')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor('#000000')
            .backgroundColor('#F0F0F0')
            .margin({ right: 8 })
          Button('停车减免')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor('#000000')
            .backgroundColor('#F0F0F0')
            .margin({ right: 8 })
          Button('重卡可用')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor('#000000')
            .backgroundColor('#F0F0F0')
            .margin({ right: 8 })
          Button('快充')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor('#000000')
            .backgroundColor('#F0F0F0')
            .margin({ right: 8 })
          Button('对外开放')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor('#000000')
            .backgroundColor('#E6F7FF')
            .margin({ right: 8 })
        }
        .width('auto')
        .backgroundColor('#FFFFFF')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .padding({
          top: '8.6px',
          bottom: '8.6px',
          left: '8.6px',
          right: '8.6px'
        })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(50)

      Grid() {
        GridItem() {
          Column() {
            Text('兰干乡')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .backgroundColor('#FFFFFF')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: '8.6px',
            bottom: '8.6px',
            left: '8.6px',
            right: '8.6px'
          })
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        GridItem() {
          Column() {
            Text('0.9830元')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('0.7700元')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('1.0447元')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('楞蒙')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('治州')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .backgroundColor('#FFFFFF')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: '8.6px',
            bottom: '8.6px',
            left: '8.6px',
            right: '8.6px'
          })
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        GridItem() {
          Column() {
            Text('G216')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('库尔勒站')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('库尔勒民俗文化博物馆')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('巴音郭楞蒙古自治州博')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('库尔勒市')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .backgroundColor('#FFFFFF')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: '8.6px',
            bottom: '8.6px',
            left: '8.6px',
            right: '8.6px'
          })
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })
      }
      .backgroundColor('#FFFFFF')
      .width('95%')
      .borderRadius(20)
      .margin({ bottom: 10 })
      .clip(true)
      .columnsTemplate(('1fr ').repeat(3))
      .maxCount(1)
      .alignSelf(ItemAlign.Center)

      Button('大地图')
        .fontSize(14)
        .height(30)
        .type(ButtonType.Normal)
        .fontColor('#000000')
        .backgroundColor('#FFFFFF')
        .constraintSize({ 'minWidth': 80 })
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '8.6px',
      bottom: '8.6px',
      left: '8.6px',
      right: '8.6px'
    })
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}