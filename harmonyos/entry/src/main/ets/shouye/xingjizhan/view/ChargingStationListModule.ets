@Component
export struct ChargingStationListModule {
  @State selectedButton: string = '星级站'

  build() {
    Column() {
      Row() {
        Search({ placeholder: '距离/区域 综合排序 充电站 偏好' })
          .searchButton('搜索', { fontSize: 14, fontColor: '#000000' })
          .backgroundColor('#ffffff')
          .layoutWeight(1)
        Blank()
      }
      .width('100%')
      .backgroundColor('#ffffff')
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
            .fontColor(this.selectedButton === '星级站' ? '#ffffff' : '#000000')
            .backgroundColor(this.selectedButton === '星级站' ? '#1890ff' : '#f0f0f0')
            .border({
              width: this.selectedButton === '星级站' ? 1 : 0,
              color: this.selectedButton === '星级站' ? '#1890ff' : '#f0f0f0'
            })
            .onClick(() => {
              this.selectedButton = '星级站'
            })
            .stateEffect(this.selectedButton === '星级站')
            .margin({ right: 12 })
          Button('PLUS会员')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor(this.selectedButton === 'PLUS会员' ? '#ffffff' : '#000000')
            .backgroundColor(this.selectedButton === 'PLUS会员' ? '#1890ff' : '#f0f0f0')
            .border({
              width: this.selectedButton === 'PLUS会员' ? 1 : 0,
              color: this.selectedButton === 'PLUS会员' ? '#1890ff' : '#f0f0f0'
            })
            .onClick(() => {
              this.selectedButton = 'PLUS会员'
            })
            .stateEffect(this.selectedButton === 'PLUS会员')
            .margin({ right: 12 })
          Button('节能响应')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor(this.selectedButton === '节能响应' ? '#ffffff' : '#000000')
            .backgroundColor(this.selectedButton === '节能响应' ? '#1890ff' : '#f0f0f0')
            .border({
              width: this.selectedButton === '节能响应' ? 1 : 0,
              color: this.selectedButton === '节能响应' ? '#1890ff' : '#f0f0f0'
            })
            .onClick(() => {
              this.selectedButton = '节能响应'
            })
            .stateEffect(this.selectedButton === '节能响应')
            .margin({ right: 12 })
          Button('停车减免')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor(this.selectedButton === '停车减免' ? '#ffffff' : '#000000')
            .backgroundColor(this.selectedButton === '停车减免' ? '#1890ff' : '#f0f0f0')
            .border({
              width: this.selectedButton === '停车减免' ? 1 : 0,
              color: this.selectedButton === '停车减免' ? '#1890ff' : '#f0f0f0'
            })
            .onClick(() => {
              this.selectedButton = '停车减免'
            })
            .stateEffect(this.selectedButton === '停车减免')
            .margin({ right: 12 })
          Button('重卡')
            .fontSize(14)
            .height(30)
            .type(ButtonType.Capsule)
            .fontColor(this.selectedButton === '重卡' ? '#ffffff' : '#000000')
            .backgroundColor(this.selectedButton === '重卡' ? '#1890ff' : '#f0f0f0')
            .border({
              width: this.selectedButton === '重卡' ? 1 : 0,
              color: this.selectedButton === '重卡' ? '#1890ff' : '#f0f0f0'
            })
            .onClick(() => {
              this.selectedButton = '重卡'
            })
            .stateEffect(this.selectedButton === '重卡')
            .margin({ right: 12 })
        }
        .width('auto')
        .backgroundColor('#ffffff')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .padding({
          top: '4.3px',
          bottom: '4.3px',
          left: '8.6px',
          right: '8.6px'
        })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(40)
      .enableScrollInteraction(true)

      // 滑动指示器
      Row() {
        ForEach(['星级站', 'PLUS会员', '节能响应', '停车减免', '重卡'], (item: string) => {
          Blank()
            .width(6)
            .height(2)
            .backgroundColor(this.selectedButton === item ? '#1890ff' : '#e0e0e0')
            .borderRadius(1)
            .margin({ right: 4 })
        })
      }
      .width('100%')
      .height(4)
      .justifyContent(FlexAlign.Center)
      .margin({ top: 4 })

      List({ space: 10 }) {
        ListItem() {
          Row() {
            Image($rawfile('shouye/emoji_image_0_0.png'))
              .margin(5)
              .height('68px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('天津市滨海新区服务外包园充…')
                .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
              Text('4.7分 | 最近充电1分钟前 | 对外开放')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('充电绑定车牌享受停车减免2小时，临牌…')
                .maxFontSize(12)
                .fontColor('#ff4d4f')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Row() {
                Text('¥1.0760/度')
                  .fontColor('#ff4d4f')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Text('PLUS ¥1.0060')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Blank()
                Text('快 闲10/16')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: '4.3px',
                bottom: '4.3px',
                left: '4.3px',
                right: '4.3px'
              })
            }
            .backgroundColor('#ffffff')
            .alignItems(HorizontalAlign.Start)
            .padding({
              top: '4.3px',
              bottom: '4.3px',
              left: '4.3px',
              right: '4.3px'
            })
            .layoutWeight(1)
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .alignItems(VerticalAlign.Top)
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

        ListItem() {
          Row() {
            Image($rawfile('shouye/emoji_image_0_1.png'))
              .margin(5)
              .height('68px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('天津MSD超级充电站')
                .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
              Text('4.8分 | 最近充电1小时前 | 对外开放')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('本电站不支持使用特来电自营卖券赠券…')
                .maxFontSize(12)
                .fontColor('#ff4d4f')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('充电绑定车牌号，享两小时内免费停车…')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Row() {
                Text('¥1.3260/度')
                  .fontColor('#ff4d4f')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Text('PLUS ¥1.0860')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Blank()
                Text('超 闲2/2 快 闲25/25')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: '4.3px',
                bottom: '4.3px',
                left: '4.3px',
                right: '4.3px'
              })
            }
            .backgroundColor('#ffffff')
            .alignItems(HorizontalAlign.Start)
            .padding({
              top: '4.3px',
              bottom: '4.3px',
              left: '4.3px',
              right: '4.3px'
            })
            .layoutWeight(1)
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .alignItems(VerticalAlign.Top)
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

        ListItem() {
          Row() {
            Image($rawfile('shouye/emoji_image_0_2.png'))
              .margin(5)
              .height('68px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('天津滨海新区文化中心北停车…')
                .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
              Text('5.0分 | 最近充电1小时前 | 对外开放')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('免费停车2小时，超出按照场地方要求收费')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Row() {
                Text('¥1.1083/度')
                  .fontColor('#ff4d4f')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Blank()
                Text('快 闲16/16')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: '4.3px',
                bottom: '4.3px',
                left: '4.3px',
                right: '4.3px'
              })
            }
            .backgroundColor('#ffffff')
            .alignItems(HorizontalAlign.Start)
            .padding({
              top: '4.3px',
              bottom: '4.3px',
              left: '4.3px',
              right: '4.3px'
            })
            .layoutWeight(1)
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .alignItems(VerticalAlign.Top)
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

        ListItem() {
          Row() {
            Image($rawfile('shouye/emoji_image_0_3.png'))
              .margin(5)
              .height('68px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('天津滨海爱琴海购物公园充电站')
                .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
              Text('4.9分 | 最近充电29分钟前 | 特来电权益 | 对外开放')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('当日首次充电车辆2小时免费停车，超出…')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Row() {
                Text('¥1.4083/度')
                  .fontColor('#ff4d4f')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Text('PLUS ¥1.2283')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Blank()
                Text('快 闲13/16')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: '4.3px',
                bottom: '4.3px',
                left: '4.3px',
                right: '4.3px'
              })
            }
            .backgroundColor('#ffffff')
            .alignItems(HorizontalAlign.Start)
            .padding({
              top: '4.3px',
              bottom: '4.3px',
              left: '4.3px',
              right: '4.3px'
            })
            .layoutWeight(1)
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .alignItems(VerticalAlign.Top)
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

        ListItem() {
          Row() {
            Image($rawfile('shouye/emoji_image_0_4.png'))
              .margin(5)
              .height('68px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('天津滨海北塘邻里中心充电站')
                .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
              Text('3.7分 | 最近充电1小时前 | 对外开放')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('停车免费')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Row() {
                Text('¥1.1083/度')
                  .fontColor('#ff4d4f')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Blank()
                Text('快 闲7/8')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: '4.3px',
                bottom: '4.3px',
                left: '4.3px',
                right: '4.3px'
              })
            }
            .backgroundColor('#ffffff')
            .alignItems(HorizontalAlign.Start)
            .padding({
              top: '4.3px',
              bottom: '4.3px',
              left: '4.3px',
              right: '4.3px'
            })
            .layoutWeight(1)
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .alignItems(VerticalAlign.Top)
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

        ListItem() {
          Row() {
            Image($rawfile('shouye/emoji_image_0_5.png'))
              .margin(5)
              .height('68px').objectFit(ImageFit.Cover).borderRadius(8)
            Column() {
              Text('天津创新家居购物广场充电站')
                .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1)
              Text('4.2分 | 最近充电33分钟前 | 对外开放')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text('充电并绑定车牌享受减免2.5小时内，超…')
                .maxFontSize(12)
                .fontColor('#888888')
                .margin(2)
                .minFontSize(8)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Row() {
                Text('¥1.2083/度')
                  .fontColor('#ff4d4f')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Text('PLUS ¥1.1583')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Blank()
                Text('快 闲7/10')
                  .maxFontSize(12)
                  .fontColor('#888888')
                  .margin(2)
                  .minFontSize(8)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }
              .width('100%')
              .backgroundColor('#ffffff')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({
                top: '4.3px',
                bottom: '4.3px',
                left: '4.3px',
                right: '4.3px'
              })
            }
            .backgroundColor('#ffffff')
            .alignItems(HorizontalAlign.Start)
            .padding({
              top: '4.3px',
              bottom: '4.3px',
              left: '4.3px',
              right: '4.3px'
            })
            .layoutWeight(1)
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .alignItems(VerticalAlign.Top)
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
      .listDirection(Axis.Vertical)
      .backgroundColor('#ffffff')
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
    .backgroundColor('#ffffff')
    .alignItems(HorizontalAlign.Start)
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