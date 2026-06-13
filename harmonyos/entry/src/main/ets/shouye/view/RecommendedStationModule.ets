@Component
export struct RecommendedStationModule {
  build() {
    // Column() {
    //   Row() {
    //     Image($rawfile('shouye/emoji_image_5_0.png'))
    //       .margin(2)
    //       .height('34px').objectFit(ImageFit.Cover).borderRadius(8)
    //     Text('推荐电站')
    //       .maxFontSize(18)
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //     Image($rawfile('shouye/emoji_image_5_1.png'))
    //       .margin(2)
    //       .height('31px').objectFit(ImageFit.Cover).borderRadius(8)
    //     Blank()
    //     Image($rawfile('shouye/emoji_image_5_2.png'))
    //       .margin(2)
    //       .height('34px').objectFit(ImageFit.Cover).borderRadius(8)
    //     Image($rawfile('shouye/emoji_image_5_3.png'))
    //       .margin(2)
    //       .height('34px').objectFit(ImageFit.Cover).borderRadius(8)
    //   }
    //   .width('100%')
    //   .alignItems(VerticalAlign.Center)
    //   .padding({
    //     top: '8.6px',
    //     bottom: '8.6px',
    //     left: '8.6px',
    //     right: '8.6px'
    //   })
    //
    //   Row() {
    //     Text('精选|最近')
    //       .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //     Text('特惠')
    //       .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //     Text('新上')
    //       .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //     Blank()
    //     Text('更多电站>')
    //       .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //   }
    //   .width('100%')
    //   .alignItems(VerticalAlign.Center)
    //   .padding({
    //     top: '8.6px',
    //     bottom: '8.6px',
    //     left: '8.6px',
    //     right: '8.6px'
    //   })
    //
    //   Grid() {
    //     GridItem() {
    //       Column() {
    //         Row() {
    //           Image($rawfile('shouye/emoji_image_5_4.png'))
    //             .margin(2)
    //             .height('57px').objectFit(ImageFit.Cover).borderRadius(8)
    //           Text('星级站')
    //             .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //         }
    //         .width('100%')
    //         .alignItems(VerticalAlign.Center)
    //         .padding({
    //           top: '8.6px',
    //           bottom: '8.6px',
    //           left: '8.6px',
    //           right: '8.6px'
    //         })
    //
    //         Row() {
    //           Image($rawfile('shouye/emoji_image_5_5.png'))
    //             .margin(2)
    //             .height('152px').objectFit(ImageFit.Cover).borderRadius(8)
    //           Column() {
    //             Row() {
    //               Image($rawfile('shouye/emoji_image_5_6.png'))
    //                 .margin(2)
    //                 .height('21px').objectFit(ImageFit.Cover).borderRadius(8)
    //               Text('天津市滨海新区服务外包园…')
    //                 .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //             }
    //             .width('100%')
    //             .alignItems(VerticalAlign.Center)
    //             .padding({
    //               top: '8.6px',
    //               bottom: '8.6px',
    //               left: '8.6px',
    //               right: '8.6px'
    //             })
    //
    //             Row() {
    //               Text('4.7分')
    //                 .maxFontSize(14)
    //                 .margin(2)
    //                 .minFontSize(8)
    //                 .textOverflow({ overflow: TextOverflow.Ellipsis })
    //                 .maxLines(1)
    //               Text('最近充电1分钟前')
    //                 .maxFontSize(14)
    //                 .margin(2)
    //                 .minFontSize(8)
    //                 .textOverflow({ overflow: TextOverflow.Ellipsis })
    //                 .maxLines(1)
    //               Text('对外开放')
    //                 .maxFontSize(14)
    //                 .margin(2)
    //                 .minFontSize(8)
    //                 .textOverflow({ overflow: TextOverflow.Ellipsis })
    //                 .maxLines(1)
    //               Image($rawfile('shouye/emoji_image_5_7.png'))
    //                 .margin(2)
    //                 .height('21px').objectFit(ImageFit.Cover).borderRadius(8)
    //               Text('0.9km')
    //                 .maxFontSize(14)
    //                 .margin(2)
    //                 .minFontSize(8)
    //                 .textOverflow({ overflow: TextOverflow.Ellipsis })
    //                 .maxLines(1)
    //             }
    //             .width('100%')
    //             .alignItems(VerticalAlign.Center)
    //             .padding({
    //               top: '8.6px',
    //               bottom: '8.6px',
    //               left: '8.6px',
    //               right: '8.6px'
    //             })
    //
    //             Row() {
    //               Image($rawfile('shouye/emoji_image_5_8.png'))
    //                 .margin(2)
    //                 .height('25px').objectFit(ImageFit.Cover).borderRadius(8)
    //               Text('充电绑定车牌享受停车减免2小时，…')
    //                 .maxFontSize(14)
    //                 .margin(2)
    //                 .minFontSize(8)
    //                 .textOverflow({ overflow: TextOverflow.Ellipsis })
    //                 .maxLines(1)
    //             }
    //             .width('100%')
    //             .alignItems(VerticalAlign.Center)
    //             .padding({
    //               top: '8.6px',
    //               bottom: '8.6px',
    //               left: '8.6px',
    //               right: '8.6px'
    //             })
    //
    //             Row() {
    //               Text('¥1.5684/度')
    //                 .maxFontSize(18)
    //                 .margin(2)
    //                 .minFontSize(8)
    //                 .textOverflow({ overflow: TextOverflow.Ellipsis })
    //                 .maxLines(1)
    //               Button('PLUS')
    //                 .fontSize(14)
    //                 .height(14)
    //                 .type(ButtonType.Capsule)
    //                 .fontColor('#FFFFFF')
    //                 .backgroundColor('#000000')
    //               Text('¥1.4984')
    //                 .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //               Blank()
    //               Button('快')
    //                 .fontSize(14)
    //                 .height(14)
    //                 .type(ButtonType.Capsule)
    //                 .fontColor('#FFFFFF')
    //                 .backgroundColor('#FFA500')
    //               Text('闲11/16')
    //                 .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
    //               Image($rawfile('shouye/emoji_image_5_9.png'))
    //                 .margin(2)
    //                 .height('25px').objectFit(ImageFit.Cover).borderRadius(8)
    //             }
    //             .width('100%')
    //             .alignItems(VerticalAlign.Center)
    //             .padding({
    //               top: '8.6px',
    //               bottom: '8.6px',
    //               left: '8.6px',
    //               right: '8.6px'
    //             })
    //           }
    //           .alignItems(HorizontalAlign.Center)
    //           .padding({
    //             top: '8.6px',
    //             bottom: '8.6px',
    //             left: '8.6px',
    //             right: '8.6px'
    //           })
    //           .layoutWeight(1)
    //         }
    //         .width('100%')
    //         .alignItems(VerticalAlign.Center)
    //         .padding({
    //           top: '8.6px',
    //           bottom: '8.6px',
    //           left: '8.6px',
    //           right: '8.6px'
    //         })
    //       }
    //       .alignItems(HorizontalAlign.Center)
    //       .padding({
    //         top: '8.6px',
    //         bottom: '8.6px',
    //         left: '8.6px',
    //         right: '8.6px'
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
    //   .backgroundColor('#FFFFFF')
    //   .width('95%')
    //   .margin({ bottom: 10 })
    //   .clip(true)
    //   .maxCount(1)
    //   .alignSelf(ItemAlign.Center)
    // }
    // .width('95%')
    // .borderRadius(20)
    // .backgroundColor('#FFFFFF')
    // .alignItems(HorizontalAlign.Center)
    // .padding({
    //   top: '8.6px',
    //   bottom: '8.6px',
    //   left: '8.6px',
    //   right: '8.6px'
    // })
    // .margin({ bottom: 10 })
    // .clip(true)
    Column() {
      // 1. 模块标题与筛选
      Row() {
        Row({ space: 4 }) {
          Text('推荐电站')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
          Image($rawfile('shouye/emoji_image_5_0.png')) // 装饰图标
            .width(16).height(16)
        }

        Blank()

        Row({ space: 12 }) {
          Text('精选').fontSize(12).fontColor('#666666')
          Text('特惠').fontSize(12).fontColor('#666666')
          Text('更多 >').fontSize(12).fontColor('#999999')
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })
      .alignItems(VerticalAlign.Center)

      // 2. 电站列表 (这里模拟单个卡片，实际可循环)
      Column({ space: 12 }) {
        // --- 单个电站卡片开始 ---
        Row() {
          // 左侧：电站图片
          Image($rawfile('shouye/emoji_image_5_5.png'))
            .width(100)
            .height(100)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
            .margin({ right: 12 })

          // 右侧：详情信息
          Column({ space: 6 }) {
            // 标题
            Text('天津市滨海新区服务外包园电站')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            // 评分与距离
            Row({ space: 8 }) {
              Row({ space: 2 }) {
                Image($rawfile('shouye/emoji_image_5_6.png')).width(12).height(12)
                Text('4.7分').fontSize(11).fontColor('#FF9800').fontWeight(FontWeight.Medium)
              }
              Text('|').fontSize(10).fontColor('#DDDDDD')
              Text('0.9km').fontSize(11).fontColor('#999999')
              Text('对外开放').fontSize(10).fontColor('#2196F3').backgroundColor('#E3F2FD').padding(2).borderRadius(2)
            }

            // 价格与标签
            Row() {
              Text('¥1.56').fontSize(18).fontWeight(FontWeight.Bold).fontColor('#FF4444')
              Text('/度').fontSize(11).fontColor('#FF4444').margin({ top: 4 })

              Blank()

              // 状态标签
              Row({ space: 4 }) {
                Text('快').fontSize(10).fontColor(Color.White).backgroundColor('#FF9800').padding({ left:4, right:4, top:1, bottom:1 }).borderRadius(4)
                Text('闲 11/16').fontSize(11).fontColor('#666666')
              }
            }
            .width('100%')
            .alignItems(VerticalAlign.Bottom)

            // 底部优惠条
            Row() {
              Image($rawfile('shouye/emoji_image_5_8.png')).width(12).height(12).margin({right:4})
              Text('绑定车牌享停车减免2小时')
                .fontSize(10)
                .fontColor('#999999')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .padding({ top: 4, bottom: 4 })
            .backgroundColor('#F9F9F9')
            .borderRadius(4)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(12)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .shadow({ radius: 8, color: 'rgba(0,0,0,0.04)', offsetY: 2 })
        // --- 单个电站卡片结束 ---
      }
      .padding({ left: 12, right: 12 })
    }
    .margin({ bottom: 20 })
  }
}