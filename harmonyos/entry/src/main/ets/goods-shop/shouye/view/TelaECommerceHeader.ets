@Component
export struct TelaECommerceHeader {
  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      // 1. 背景图：增加覆盖层让文字更清晰
      Image($rawfile('shangcheng/B_shouye/beijing.png'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .borderRadius({ bottomLeft: 24, bottomRight: 24 }) // 底部圆角增加设计感

      // 2. 渐变遮罩，防止背景太花干扰文字
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['#00000000', 0.0], ['#80000000', 1.0]]
        })
        .borderRadius({ bottomLeft: 24, bottomRight: 24 })

      // 3. 内容区域
      Row() {
        Column({ space: 4 }) {
          Text('唐山学院')
            .fontColor(Color.White)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .textShadow({ radius: 10, color: '#40000000', offsetX: 2, offsetY: 2 })

          Text('校园生活服务 · 充电商城')
            .fontColor('#EEEEEE')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 20, bottom: 25 })
    }
    .width('100%')
    .height(180) // 增加高度
    .margin({ bottom: 12 })

    // Row() {
    //   Stack() {
    //     // 背景图：占满全屏
    //     Image($rawfile('shangcheng/B_shouye/beijing.png')) // 推荐用 $r 而非 $rawfile
    //       .width('100%')
    //       .height('100%')
    //       .objectFit(ImageFit.Cover) // 关键：保持比例覆盖
    //       .position({ x: 0, y: 0 })
    //
    //     // 页面内容
    //     Row() {
    //       Column() {
    //         Text('唐山学院充电商城')
    //           .fontColor(Color.White)
    //           .fontSize(24)
    //       }
    //       .width('100%')
    //       .height('100%')
    //       .justifyContent(FlexAlign.Center)
    //     }
    //   }
    //   .width('100%')
    //   .height(150)
    // }.padding({bottom:10})
  }
}