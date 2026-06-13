import { SpecItem_60 } from '../viewmodel/MyAccountSettings';
import { router } from '@kit.ArkUI';

@Component
export struct MyAccountSettings {
  private specItem_60_: SpecItem_60[] = [
    { var_0: '我的红包', router: "goods-shop/wode/A_fenyemian/wodehongbao/Index" },
    { var_0: '我的卡券', router:  "goods-shop/wode/A_fenyemian/wodekajuan/Index" },
    { var_0: '售后服务', router: 'pages-shop/AfterSalesService' },
    { var_0: '我的地址', router:  "goods-shop/wode/A_fenyemian/wode_wodedizhi/Index"},
    { var_0: '我的关注', router:  "goods-shop/wode/A_fenyemian/wode_guanzhu/Index"}
  ]

  @Builder
  SpecItem_60_Builder(item: SpecItem_60) {
    Column() {
      Text(item.var_0)
        .maxFontSize(14)
        .fontColor('black')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .onClick(() => {
      router.push({url:item.router})
    })
    .width('100%')
    .backgroundColor('white')
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: '12.5px',
      bottom: '12.5px',
      left: '25.0px',
      right: '25.0px'
    })
    .width('100%')
  }

  build() {
    // List() {
    //   ForEach(this.specItem_60_, (item: SpecItem_60) => {
    //     ListItem() {
    //       this.SpecItem_60_Builder(item)
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
    // .divider({
    //   strokeWidth: 1,
    //   startMargin: 10,
    //   endMargin: 10,
    //   color: '#ffe9f0f0'
    // })
    // .backgroundColor('white')
    Column() {
      List() {
        ForEach(this.specItem_60_, (item: SpecItem_60, index: number) => {
          ListItem() {
            Row() {
              // 1. 左侧文字
              Text(item.var_0)
                .fontSize(15)
                .fontColor('#333333')
                .fontWeight(FontWeight.Medium)

              Blank()

              // 2. 右侧箭头
              Image($rawfile("shangcheng/E_wode/fanhui.png")) // 建议使用系统资源或统一箭头图
                .width(16)
                .height(16)
                .fillColor('#CCCCCC')
            }
            .width('100%')
            .height(56) // 增加高度，方便点击
            .padding({ left: 16, right: 16 })
            .backgroundColor(Color.White)
          }
          .onClick(() => {
            router.pushUrl({ url: item.router })
          })
        })
      }
      .divider({
        strokeWidth: 0.5,
        color: '#F0F0F0',
        startMargin: 16,
        endMargin: 16
      })
      .borderRadius(16)
      .backgroundColor(Color.White)
      .width('100%')
    }
    .width('92%')
    .margin({ bottom: 20 })
    .shadow({ radius: 10, color: '#0D000000', offsetY: 2 }) // 极淡的阴影
  }
}