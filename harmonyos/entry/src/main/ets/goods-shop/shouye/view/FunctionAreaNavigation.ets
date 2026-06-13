import { SpecItem_100 } from '../viewmodel/FunctionAreaNavigation';
import { router } from '@kit.ArkUI';

@Component
export struct FunctionAreaNavigation {
  private specItem_100_: SpecItem_100[] = [
    { var_0: $r('app.media.emoji_image_10_0'), var_1: '新品专区' ,router:"goods-shop/shouye/A_fenyemian/B_xinpinzhuanqu/pages/ScreenShot"},
    { var_0: $r('app.media.emoji_image_10_1'), var_1: '特价专区' ,router:"goods-shop/shouye/A_fenyemian/C_tejiazhuanqu/pages/ScreenShot"},
    { var_0: $r('app.media.emoji_image_10_2'), var_1: 'PLUS专区' ,router:"goods-shop/shouye/A_fenyemian/D_huiyuanzhuanqu/pages/ScreenShot"},
    { var_0: $r('app.media.emoji_image_10_3'), var_1: '店铺公告' ,router:"goods-shop/shouye/A_fenyemian/E_dianpugonggao/pages/ScreenShot"},
    { var_0: $r('app.media.emoji_image_10_4'), var_1: '关于店铺' ,router:"goods-shop/shouye/A_fenyemian/F_guanyudianpu/pages/ScreenShot"}
  ]

  @Builder
  SpecItem_100_Builder(item: SpecItem_100) {
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
    .onClick(() => {
      router.pushUrl({url:item.router})
    })
    .width('20%')
    .backgroundColor('#ffffff')
    .alignItems(HorizontalAlign.Center).width('100%')
  }

  build() {
    Grid() {
      ForEach(this.specItem_100_, (item: SpecItem_100) => {
        GridItem() {
          this.SpecItem_100_Builder(item)
        }.width('100%').borderRadius(8).clip(true)
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })
      })
    }
    .width('95%')
    .borderRadius(8)
    .clip(true)
    .margin({ bottom: 10 })
    .columnsTemplate(('1fr ').repeat(5))
    .maxCount(1)
    .alignSelf(ItemAlign.Center)
    .backgroundColor('#ffffff')
  }
}