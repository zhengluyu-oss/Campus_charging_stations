import { SpecItem_07 } from '../viewmodel/ChargeRewardProgress';
import router from '@ohos.router';
@Component
export struct ChargeRewardProgress {
  private specItem_07_: SpecItem_07[] = [
    { var_0: '注册礼', var_1: '注册', var_2: '01.06' },
    { var_0: '4元券', var_1: '10度', var_2: '01.13 24点' },
    { var_0: '20元券', var_1: '50度', var_2: '01.20 24点' }
  ]

  @Builder
  // SpecItem_07_Builder(item: SpecItem_07) {
  //   Column() {
  //     Button(item.var_0)
  //       .fontSize(14)
  //       .height(20)
  //       .type(ButtonType.Capsule)
  //       .fontColor('#FF0000')
  //       .backgroundColor('#FFFFFF')
  //       .constraintSize({ 'minWidth': 80 })
  //     Text(item.var_1)
  //       .maxFontSize(14)
  //       .fontColor('#FFFFFF')
  //       .margin(2)
  //       .minFontSize(8)
  //       .textOverflow({ overflow: TextOverflow.Ellipsis })
  //       .maxLines(1)
  //     Text(item.var_2)
  //       .maxFontSize(12)
  //       .fontColor('#FFFFFF')
  //       .margin(2)
  //       .minFontSize(8)
  //       .textOverflow({ overflow: TextOverflow.Ellipsis })
  //       .maxLines(1)
  //   }
  //   .width('33%')
  //   .alignItems(HorizontalAlign.Center)
  //   .padding({
  //     top: '8.6px',
  //     bottom: '8.6px',
  //     left: '8.6px',
  //     right: '8.6px'
  //   }).width('100%')
  // }
  ProgressItem(item: SpecItem_07, index: number) {
    Column({ space: 6 }) {
      // 奖励胶囊
      Text(item.var_0)
        .fontSize(11)
        .fontColor('#FF4400')
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.White)
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .borderRadius(10)
        .shadow({ radius: 4, color: 'rgba(0,0,0,0.2)' })

      // 节点圆点 (模拟进度条节点)
      Circle({ width: 6, height: 6 })
        .fill(Color.White)
        .opacity(0.8)

      // 任务说明
      Text(item.var_1)
        .fontSize(12)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)

      // 时间
      Text(item.var_2)
        .fontSize(10)
        .fontColor('rgba(255,255,255,0.7)')
    }
    .width('33%') // 三等分
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    // Column() {
    //   Row() {
    //     Text('充电礼')
    //       .maxFontSize(20)
    //       .fontColor('#FFFFFF')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //       .onClick(() => { // 搜索框点击事件
    //         router.pushUrl({
    //           url: 'shouye/chongdianli/chongdianliIndex' // 你的目标搜索详情页
    //         })
    //       });
    //
    //     Text('| 充电10度得券>')
    //       .maxFontSize(14)
    //       .fontColor('#FFFFFF')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //     Blank()
    //     Text('剩8天')
    //       .maxFontSize(14)
    //       .fontColor('#FFFFFF')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //     Text('05:10:06')
    //       .maxFontSize(14)
    //       .fontColor('#FFFFFF')
    //       .margin(2)
    //       .minFontSize(8)
    //       .textOverflow({ overflow: TextOverflow.Ellipsis })
    //       .maxLines(1)
    //   }
    //   .width('100%')
    //   .alignItems(VerticalAlign.Center)
    //   .justifyContent(FlexAlign.SpaceBetween)
    //   .padding({
    //     top: '8.6px',
    //     bottom: '8.6px',
    //     left: '8.6px',
    //     right: '8.6px'
    //   })
    //
    //   Grid() {
    //     ForEach(this.specItem_07_, (item: SpecItem_07) => {
    //       GridItem() {
    //         this.SpecItem_07_Builder(item)
    //       }.width('100%').borderRadius(8).clip(true)
    //       .padding({
    //         top: 5,
    //         left: 3,
    //         bottom: 5,
    //         right: 3
    //       })
    //     })
    //   }
    //   .width('95%')
    //   .borderRadius(8)
    //   .clip(true)
    //   .margin({ bottom: 10 })
    //   .columnsTemplate(('1fr ').repeat(3))
    //   .maxCount(1)
    //   .alignSelf(ItemAlign.Center)
    //   .backgroundColor('#FF4444')
    // }
    // .width('95%')
    // .backgroundColor('#FF4444')
    // .alignItems(HorizontalAlign.Center)
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
      // 顶部标题栏
      Row() {
        Row({ space: 8 }) {
          Text('充电好礼')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)

          Text('充电10度得券')
            .fontSize(12)
            .fontColor('rgba(255,255,255,0.9)')
            .backgroundColor('rgba(255,255,255,0.2)') // 半透明背景
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .borderRadius(4)
        }
        .onClick(() => {
          router.pushUrl({ url: 'shouye/chongdianli/chongdianliIndex' })
        })

        // 倒计时区
        Row({ space: 4 }) {
          Text('剩8天')
            .fontSize(12)
            .fontColor(Color.White)
          Text('05:10:06')
            .fontSize(12)
            .fontColor('#FFEB3B') // 黄色强调倒计时
            .fontWeight(FontWeight.Bold)
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 16 })

      // 进度区域
      Stack({ alignContent: Alignment.Center }) {
        // 进度底线
        Divider()
          .color('rgba(255,255,255,0.3)')
          .strokeWidth(1)
          .width('80%')
          .margin({ top: -10 }) // 调整线条位置使其穿过圆点

        // 内容项
        Row() {
          ForEach(this.specItem_07_, (item: SpecItem_07, index: number) => {
            this.ProgressItem(item, index)
          })
        }
        .width('100%')
      }
    }
    .width('94%') // 左右留白
    .padding(16)
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [['#FF6B6B', 0.0], ['#FF8E53', 1.0]] // 高级暖色渐变
    })
    .borderRadius(16)
    .margin({ bottom: 12 })
    .shadow({ radius: 8, color: '#FF6B6B33', offsetY: 4 })
  }
}