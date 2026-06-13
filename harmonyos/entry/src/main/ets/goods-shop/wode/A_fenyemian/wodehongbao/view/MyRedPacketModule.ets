import { router } from "@kit.ArkUI";

@Component
export struct MyRedPacketModule {
  @State hasRedPacket: boolean = false; // 红包状态：true表示有红包，false表示无红包

  aboutToAppear() {
    // 模拟红包数据获取，实际项目中应该从API获取
    this.checkRedPacketStatus();
  }

  checkRedPacketStatus() {
    // 这里应该调用API检查红包状态
    // 暂时模拟：随机决定是否有红包
    this.hasRedPacket = Math.random() > 0.5;
  }

  build() {
    Column() {
      Row() {
        Image($rawfile('shangcheng/A_common/zuojiantou.png'))
          .margin(2)
          .height('50px')
          .width('50px')
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .onClick(() => {
            router.back()
          })
        Text('我的红包')
          .margin(2).minFontSize(8).textOverflow({ overflow: TextOverflow.Ellipsis }).maxLines(1).offset({x: 20, y: 0})
        Blank()
        Image($rawfile('shangcheng/A_common/share.png'))
          .height('50px')
          .width('50px')
          .margin(2)
          .objectFit(ImageFit.Cover).borderRadius(8)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        Text('说明：只显示已生效和未生效的红包金额，下单时，系统自动选用已生效的最大红包金额抵扣。')
          .maxFontSize(12)
          .fontColor('#FF6633')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
        Blank()
        if (this.hasRedPacket) {
          // 有红包时的显示内容
          Column() {
            Text('您有红包可用')
              .maxFontSize(16)
              .fontColor('#FF0000') // 红字显示
              .fontWeight(FontWeight.Bold)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Text('点击查看红包详情')
              .maxFontSize(12)
              .fontColor('#666666')
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: '10%',
            bottom: '10%',
            left: '10%',
            right: '10%'
          })
        } else {
          // 没有红包时的显示内容
          Column() {
            Image($r('app.media.emoji_image_2_3'))
              .margin(2)
              .width('171px')
              .height('171px')
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
            Text('暂时没有红包哦~')
              .maxFontSize(14)
              .fontColor('#888888')
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .padding({
            top: '10%',
            bottom: '10%',
            left: '10%',
            right: '10%'
          })
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('95%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#FFFFFF')
    .borderRadius(20)
    .margin({ bottom: 10 })
    .clip(true)
  }
}