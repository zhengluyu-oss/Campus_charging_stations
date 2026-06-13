@Component
export struct ChargeStationPromotionModule {
  build() {
    // Column() {
    //   Row() {
    //     Text('全部')
    //       .maxFontSize(14)
    //       .fontColor('#FF6666')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //     Text('充电桩')
    //       .maxFontSize(14)
    //       .fontColor('#666666')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //     Text('充电卡券')
    //       .maxFontSize(14)
    //       .fontColor('#666666')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //     Blank()
    //     Image($r('app.media.emoji_image_0_0'))
    //       .margin(2)
    //       .height('26px').objectFit(ImageFit.Cover).borderRadius(8)
    //   }
    //   .width('100%')
    //   .alignItems(VerticalAlign.Center)
    //   .justifyContent(FlexAlign.SpaceBetween)
    //
    //   Grid() {
    //     GridItem() {
    //       Column() {
    //         Image($r('app.media.emoji_image_0_1'))
    //           .margin(2)
    //           .width('282px')
    //           .height('228px')
    //           .objectFit(ImageFit.Cover)
    //           .borderRadius(8)
    //         Text('190元购200元通抵代金...')
    //           .maxFontSize(14)
    //           .fontColor('#333333')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥200')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥190')
    //           .maxFontSize(14)
    //           .fontColor('#FF6666')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('已售 641')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //       }
    //       .borderRadius(5)
    //       .backgroundColor('#FFFFFF')
    //       .alignItems(HorizontalAlign.Center)
    //       .padding({
    //         top: '8.4px',
    //         bottom: '8.4px',
    //         left: '8.4px',
    //         right: '8.4px'
    //       })
    //     }
    //     .padding({
    //       top: 5,
    //       left: 3,
    //       bottom: 5,
    //       right: 3
    //     })
    //
    //     GridItem() {
    //       Column() {
    //         Image($r('app.media.emoji_image_0_2'))
    //           .margin(2)
    //           .width('282px')
    //           .height('228px')
    //           .objectFit(ImageFit.Cover)
    //           .borderRadius(8)
    //         Text('95元购100元通抵代金券...')
    //           .maxFontSize(14)
    //           .fontColor('#333333')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('可以抵扣电费、服务费哦!!!')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥100')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥95')
    //           .maxFontSize(14)
    //           .fontColor('#FF6666')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('已售 2162')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //       }
    //       .borderRadius(5)
    //       .backgroundColor('#FFFFFF')
    //       .alignItems(HorizontalAlign.Center)
    //       .padding({
    //         top: '8.4px',
    //         bottom: '8.4px',
    //         left: '8.4px',
    //         right: '8.4px'
    //       })
    //     }
    //     .padding({
    //       top: 5,
    //       left: 3,
    //       bottom: 5,
    //       right: 3
    //     })
    //
    //     GridItem() {
    //       Column() {
    //         Image($r('app.media.emoji_image_0_3'))
    //           .margin(2)
    //           .width('282px')
    //           .height('270px')
    //           .objectFit(ImageFit.Cover)
    //           .borderRadius(8)
    //         Text('特来电家用新能源7kw、...')
    //           .maxFontSize(14)
    //           .fontColor('#333333')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥2199')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥1399')
    //           .maxFontSize(14)
    //           .fontColor('#FF6666')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('已售 928')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Button()
    //           .fontSize(14)
    //           .height(30)
    //           .type(ButtonType.Circle)
    //           .fontColor('#FFFFFF')
    //           .backgroundColor('#FF6666')
    //           .constraintSize({ 'minWidth': 30 })
    //       }
    //       .borderRadius(5)
    //       .backgroundColor('#FFFFFF')
    //       .alignItems(HorizontalAlign.Center)
    //       .padding({
    //         top: '8.4px',
    //         bottom: '8.4px',
    //         left: '8.4px',
    //         right: '8.4px'
    //       })
    //     }
    //     .padding({
    //       top: 5,
    //       left: 3,
    //       bottom: 5,
    //       right: 3
    //     })
    //
    //     GridItem() {
    //       Column() {
    //         Image($r('app.media.emoji_image_0_4'))
    //           .margin(2)
    //           .width('282px')
    //           .height('270px')
    //           .objectFit(ImageFit.Cover)
    //           .borderRadius(8)
    //         Text('特来电新品启航7kW刷...')
    //           .maxFontSize(14)
    //           .fontColor('#333333')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥1999')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('¥929')
    //           .maxFontSize(14)
    //           .fontColor('#FF6666')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Text('已售 111')
    //           .maxFontSize(12)
    //           .fontColor('#999999')
    //           .margin(2)
    //           .minFontSize(8)
    //           .textOverflow({ overflow: TextOverflow.Ellipsis })
    //           .maxLines(1)
    //         Button()
    //           .fontSize(14)
    //           .height(30)
    //           .type(ButtonType.Circle)
    //           .fontColor('#FFFFFF')
    //           .backgroundColor('#FF6666')
    //           .constraintSize({ 'minWidth': 30 })
    //       }
    //       .borderRadius(5)
    //       .backgroundColor('#FFFFFF')
    //       .alignItems(HorizontalAlign.Center)
    //       .padding({
    //         top: '8.4px',
    //         bottom: '8.4px',
    //         left: '8.4px',
    //         right: '8.4px'
    //       })
    //     }
    //     .padding({
    //       top: 5,
    //       left: 3,
    //       bottom: 5,
    //       right: 3
    //     })
    //   }
    //   .borderRadius(20)
    //   .backgroundColor('#F5F5F5')
    //   .width('95%')
    //   .margin({ bottom: 10 })
    //   .clip(true)
    //   .columnsTemplate(('1fr ').repeat(2))
    //   .maxCount(2)
    //   .alignSelf(ItemAlign.Center)
    // }
    // .width('95%')
    // .borderRadius(20)
    // .backgroundColor('#FFFFFF')
    // .alignItems(HorizontalAlign.Center)
    // .margin({ bottom: 10 })
    // .clip(true)
    Column() {
      // 1. 标题栏优化
      Row() {
        Text('热门推荐')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Row() {
          Text('查看全部')
            .fontSize(12)
            .fontColor('#999999')
          Image($r('app.media.emoji_image_0_0')) // 假设这是箭头图标
            .width(12)
            .height(12)
            .fillColor('#999999')
            .margin({ left: 4 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })

      // 2. 商品网格优化
      Grid() {
        // 示例：这里只展示一个GridItem的优化结构，循环时请应用此结构
        // ForEach(...) {
        GridItem() {
          Column() {
            // 商品图
            Image($r('app.media.emoji_image_0_1')) // 替换为具体数据
              .width('100%')
              .aspectRatio(1) // 保持正方形
              .objectFit(ImageFit.Cover)
              .borderRadius({ topLeft: 12, topRight: 12 })

            // 内容区
            Column({ space: 6 }) {
              Text('190元购200元通抵代金券')
                .fontSize(14)
                .fontColor('#333333')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontWeight(FontWeight.Medium)
                .lineHeight(20)

              // 价格标签区
              Row() {
                Text('¥')
                  .fontSize(10)
                  .fontColor('#FF6666')
                  .baselineOffset(-2)
                Text('190')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF6666')
                Text('¥200')
                  .fontSize(10)
                  .fontColor('#CCCCCC')
                  .decoration({ type: TextDecorationType.LineThrough, color: '#CCCCCC' })
                  .margin({ left: 6 })
              }
              .alignItems(VerticalAlign.Bottom)

              // 销量
              Text('已售 641')
                .fontSize(10)
                .fontColor('#999999')
            }
            .padding(12)
            .alignItems(HorizontalAlign.Start)
            .width('100%')
          }
          .backgroundColor(Color.White)
          .borderRadius(12)
          .shadow({ radius: 8, color: '#1A000000', offsetY: 4 }) // 关键：柔和阴影
        }
        // }
      }
      .columnsTemplate('1fr 1fr') // 双列
      .columnsGap(10)
      .rowsGap(10)
      .padding({ left: 16, right: 16, bottom: 20 })
      .height('100%') // 根据实际情况调整
    }
    .backgroundColor('#F5F7FA') // 整体背景色微灰，突显卡片

  }
}