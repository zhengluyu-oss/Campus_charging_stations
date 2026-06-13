import { SpecItem_130 } from '../viewmodel/FunctionMenuModule';
import router from '@ohos.router';
@Component
export struct FunctionMenuModule {
  private specItem_130_: SpecItem_130[] = [
    { var_0: $rawfile('shouye/emoji_image_13_0.png'), var_1: '电站搜索' },
    { var_0: $rawfile('shouye/emoji_image_13_1.png'), var_1: '我的收藏' },
    { var_0: $rawfile('shouye/emoji_image_13_2.png'), var_1: '最近充电' },
    { var_0: $rawfile('shouye/emoji_image_13_3.png'), var_1: '电池卫士' },
    { var_0: $rawfile('shouye/emoji_image_13_4.png'), var_1: '我的卡券' },
    { var_0: $rawfile('shouye/emoji_image_13_5.png'), var_1: '星级站' },
    { var_0: $rawfile('shouye/emoji_image_13_6.png'), var_1: '我的订单' },
    { var_0: $rawfile('shouye/emoji_image_13_7.png'), var_1: 'PLUS会员' },
    { var_0: $rawfile('shouye/emoji_image_13_8.png'), var_1: '商城' },
    { var_0: $rawfile('shouye/emoji_image_13_9.png'), var_1: '更多' }
  ]

  @Builder
  MenuItemBuilder(item: SpecItem_130) {
    Column() {
      Image(item.var_0)
        .margin(2)
        .width('100px')
        .height('100px')
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
      Text(item.var_1)
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('20%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center).width('100%')
    .onClick(() => { // 搜索框点击事件
      if (item.var_1 === '电站搜索') {
        router.pushUrl({
          url: 'shouye/dianzhansousuo/dianzhansousuoIndex' // 你的目标搜索详情页
       })
      }
      if (item.var_1 === '更多'){
        router.pushUrl({
          url: 'shouye/Gengduoye/gengduoyeIndex' // 你的目标搜索详情页
        })
      }
      if (item.var_1 === '我的收藏'){
        router.pushUrl({
          url: 'shouye/wodeshoucang/wodeshoucangIndex' // 你的目标搜索详情页
        })
      }
      if (item.var_1 === '最近充电'){
        router.pushUrl({
          url: 'shouye/zuijinchongdian/zuijinchongdianIndex' // 你的目标搜索详情页
        })
      }
      if (item.var_1 === '电池卫士'){
        router.pushUrl({
          url: 'shouye/dianchiweishi/dianchiweishiIndex' // 你的目标搜索详情页
        })
      }
      if (item.var_1 === '我的卡券'){
        router.pushUrl({
          url: 'shouye/wodekajuan/wodekajuanIndex' // 你的目标搜索详情页
        })
      }
      if (item.var_1 === 'PLUS会员'){
        router.pushUrl({
          url: 'shouye/plushuiyuan/plushuiyuanIndex' // 你的目标搜索详情页
        })
      }
      if (item.var_1 === '我的订单'){
        router.pushUrl({
          url: 'shouye/wodedingdan/wodedingdanIndex' // 你的目标搜索详情页
        })
      }
      if (item.var_1 === '星级站'){
        router.pushUrl({
          url: 'shouye/xingjizhan/xingjizhanIndex' // 你的目标搜索详情页
        })
      }


    });
  }

  build() {
    // Grid() {
    //   ForEach(this.specItem_130_, (item: SpecItem_130) => {
    //     GridItem() {
    //       this.SpecItem_130_Builder(item)
    //     }.width('100%').borderRadius(8).clip(true)
    //     .padding({
    //       top: 5,
    //       left: 3,
    //       bottom: 5,
    //       right: 3
    //     })
    //   })
    // }
    // .width('95%')
    // .borderRadius(8)
    // .clip(true)
    // .margin({ bottom: 10 })
    // .columnsTemplate(('1fr ').repeat(5))
    // .maxCount(2)
    // .alignSelf(ItemAlign.Center)
    // .backgroundColor('#FFFFFF')
    Column() {
      Grid() {
        ForEach(this.specItem_130_, (item: SpecItem_130) => {
          GridItem() {
            this.MenuItemBuilder(item)
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr') // 严格5列
      .rowsGap(16) // 行间距
      .columnsGap(8) // 列间距
      .height(160) // 2行的高度预估
      .width('100%')
    }
    .padding({ top: 16, bottom: 16, left: 12, right: 12 })
    .backgroundColor(Color.White)
    .borderRadius(16)
    .margin({ left: 12, right: 12, bottom: 12 }) // 外间距
    .shadow({ radius: 8, color: 'rgba(0,0,0,0.03)', offsetY: 2 }) // 极轻微的阴影
  }
}