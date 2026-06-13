import { SpecItem_51 } from '../viewmodel/BatteryHealthCheckModule';

@Component
export struct BatteryHealthCheckModule {
  private specItem_51_: SpecItem_51[] = [
    { var_0: '体检项' },
    { var_0: '检测值' },
    { var_0: '参考值' },
    { var_0: '结果' },
    { var_0: '停充原因' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '最大温差' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '最大温升速率' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '动力蓄电池最高温度' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: 'SOC变化率' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '单体蓄电池电压极差' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '单体蓄电池最高电压' },
    { var_0: '--' },
    { var_0: '--' },
    { var_0: '--' }
  ]

  @Builder
  SpecItem_51_Builder(item: SpecItem_51) {
    Column() {
      Text(item.var_0)
        .maxFontSize(14)
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('25%')
    .backgroundColor('#ffffff')
    .alignItems(HorizontalAlign.Center)
    .padding({
      top: '4.3px',
      bottom: '4.3px',
      left: '4.3px',
      right: '4.3px'
    })
    .width('100%')
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.specItem_51_, (item: SpecItem_51) => {
          GridItem() {
            this.SpecItem_51_Builder(item)
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
      .columnsTemplate(('1fr ').repeat(4))
      .maxCount(8)
      .alignSelf(ItemAlign.Center)
      .backgroundColor('#ffffff')
    }
    .width('95%')
    .backgroundColor('#ffffff')
    .alignItems(HorizontalAlign.Center)
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