@Component
export struct ProductListModule {
  build() {
    Column() {
      List({ space: 10 }) {
        ListItem() {
          Row() {
            Image($r('app.media.emoji_image_0_0'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电新能源电动汽车充电桩7kW/11k...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('保时捷内购链接--裸机款无任何安装；0...')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥2399')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥1999 已售 2')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.emoji_image_0_1'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电22KW欧标交流充电桩新品上市 ...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('商用版22kW')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥99999')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥3969')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.emoji_image_0_2'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('190元购200元通抵代金券（有效期30...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥200')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥190 已售 665')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.emoji_image_0_3'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('95元购100元通抵代金券（有效期30天...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('可以抵扣电费、服务费哦!!!')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥100')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥95 已售 2215')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.emoji_image_0_4'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电新品7kW小直流快充充电桩9孔...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥3999')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥2750 已售 9')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.emoji_image_0_5'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电2代ECO 50KW模块 特来劲2代...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('测试单 拍下不发货')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥99999 已售 3020')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.lib_icon_37'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电家用充电桩7kW壁挂式充电器...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('家用充电桩 7kW功率')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥2999')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥2499 已售 128')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.lib_icon_182'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电直流快充桩120kW超级充电站...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('商用直流快充 120kW功率')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥89999')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥79999 已售 45')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.lib_icon_181'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电智能充电桩APP会员年卡...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('APP会员年卡 享受优惠')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥199')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥159 已售 892')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })

        ListItem() {
          Row() {
            Image($r('app.media.lib_icon_173'))
              .margin(2)
              .height('138px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('特来电充电桩安装服务套餐...')
                .maxFontSize(14)
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('专业安装服务 包工包料')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥999')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('￥799 已售 312')
                .maxFontSize(14)
                .fontColor('#FF5722')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })
      }
      .listDirection(Axis.Vertical)
      .backgroundColor('#FFFFFF')
      .width('95%')
      .borderRadius(20)
      .margin({ bottom: 10 })
      .clip(true)
      .divider({
        strokeWidth: 1,
        startMargin: 10,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
    }
    .width('95%')
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Start)
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}