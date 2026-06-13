import { SpecItem_02 } from '../viewmodel/MyOrderModule';
import { router, Router } from '@kit.ArkUI';

// import {sidatianwang} from '../B_sidatianwang/dingdanlie'
// @Entry
@Builder
function OrderItemBuilder(item: SpecItem_02) {
  // Column() {
  //   Image(item.var_0)
  //     .margin(5)
  //     .width('100px')
  //     .height('100px')
  //     .objectFit(ImageFit.Cover)
  //     .borderRadius(8)
  //   Text(item.var_1)
  //     .maxFontSize(14)
  //     .margin(5)
  //     .minFontSize(8)
  //     .textOverflow({ overflow: TextOverflow.Ellipsis })
  //     .maxLines(1)
  // }
  //
  // .width('25%')
  // .backgroundColor('#FFFFFF')
  // .alignItems(HorizontalAlign.Center).width('100%')
  Column({ space: 8 }) {
    Image(item.var_0)
      .width(28) // 统一图标大小 (vp)
      .height(28)
      .objectFit(ImageFit.Contain)

    Text(item.var_1)
      .fontSize(12)
      .fontColor('#666666')
  }
  .alignItems(HorizontalAlign.Center)
  .backgroundColor(Color.Transparent)
  .onClick(() => {
    // 路由逻辑
  })
}

@Component
export struct MyOrderModule {
  private specItem_02_: SpecItem_02[] = [
    { var_0: $rawfile('shangcheng/E_wode/quanbudingdan.png'), var_1: '全部订单' },
    { var_0: $rawfile('shangcheng/E_wode/daizhifu.png'), var_1: '待支付' },
    { var_0: $rawfile('shangcheng/E_wode/daishouhuo.png'), var_1: '待收货' },
    { var_0: $rawfile('shangcheng/E_wode/daipingjia.png'), var_1: '待评价' }
  ]

  // @Builder
  // SpecItem_02_Builder(item: SpecItem_02) {
  //   // Column() {
  //   //   Image(item.var_0)
  //   //     .margin(5)
  //   //     .width('100px')
  //   //     .height('100px')
  //   //     .objectFit(ImageFit.Cover)
  //   //     .borderRadius(8)
  //   //   Text(item.var_1)
  //   //     .maxFontSize(14)
  //   //     .margin(5)
  //   //     .minFontSize(8)
  //   //     .textOverflow({ overflow: TextOverflow.Ellipsis })
  //   //     .maxLines(1)
  //   // }
  //   //
  //   // .width('25%')
  //   // .backgroundColor('#FFFFFF')
  //   // .alignItems(HorizontalAlign.Center).width('100%')
  //   Column({ space: 8 }) {
  //     Image(item.var_0)
  //       .width(28) // 统一图标大小 (vp)
  //       .height(28)
  //       .objectFit(ImageFit.Contain)
  //
  //     Text(item.var_1)
  //       .fontSize(12)
  //       .fontColor('#666666')
  //   }
  //   .alignItems(HorizontalAlign.Center)
  //   .backgroundColor(Color.Transparent)
  //   .onClick(() => {
  //     // 路由逻辑
  //   })
  // }

  build() {
    Column() {
      // 头部标题
      Row() {
        Text('我的订单')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        // 可选：添加"查看全部"箭头
        Image($rawfile("shangcheng/E_wode/fanhui.png"))
          .width(16)
          .height(16)
          .fillColor('#CCCCCC')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 16 })

      // 订单图标行
      Row() {
        ForEach(this.specItem_02_, (item: SpecItem_02) => {
          OrderItemBuilder(item)
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('92%') // 左右留白，形成悬浮卡片感
    .backgroundColor(Color.White)
    .borderRadius(16)
    .padding(16)
    .margin({ top: -20, bottom: 12 }) // 负Margin实现向上覆盖头部的效果
    .shadow({ radius: 16, color: '#1A000000', offsetY: 2 })
    // Column() {
    //   Text('我的订单')
    //     .maxFontSize(18)
    //     .margin(10)
    //     .minFontSize(8)
    //     .textOverflow({ overflow: TextOverflow.Ellipsis })
    //     .maxLines(1)
    //   Grid() {
    //     ForEach(this.specItem_02_, (item: SpecItem_02) => {
    //       GridItem() {
    //         this.SpecItem_02_Builder(item)
    //       }
    //       .onClick(() => {
    //         router.replace({
    //           url: "goods-shop/wode/B_sidatianwang/dingdanliebaio/Index"
    //         })
    //       })
    //       .width('100%')
    //       .borderRadius(8)
    //       .clip(true)
    //       .padding({
    //         top: 5,
    //         left: 3,
    //         bottom: 5,
    //         right: 3
    //       })
    //     })
    //
    //   }
    //   .width('95%')
    //   .borderRadius(8)
    //   .clip(true)
    //   .margin({ bottom: 10 })
    //   .columnsTemplate(('1fr ').repeat(4))
    //   .maxCount(1)
    //   .alignSelf(ItemAlign.Center)
    //   .backgroundColor('#FFFFFF')
    // }
    // .width('95%')
    // .backgroundColor('#FFFFFF')
    // .alignItems(HorizontalAlign.Start)
    // .padding({
    //   top: '12.5px',
    //   bottom: '12.5px',
    //   left: '12.5px',
    //   right: '12.5px'
    // })
    // .borderRadius(20)
    // .margin({ bottom: 10 })
    // .clip(true)
  }
}