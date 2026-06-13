import { SpecItem_120 } from '../viewmodel/LegalDocumentsModule';

@Component
export struct LegalDocumentsModule {
  private specItem_120_: SpecItem_120[] = [
    { var_0: '营业执照' },
    { var_0: '经营许可证' },
    { var_0: '唐山学院校园充电商城用户使用协议' },
    { var_0: '唐山学院校园充电商城隐私政策' },
    { var_0: '商城投诉与举报规则' }
  ]

  @Builder
  SpecItem_120_Builder(item: SpecItem_120) {
    Column() {
      Text(item.var_0)
        .maxFontSize(14)
        .fontColor('black')
        .margin(2)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('100%')
    .backgroundColor('white')
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: '8.4px',
      bottom: '8.4px',
      left: '16.9px',
      right: '16.9px'
    })
    .width('100%')
  }

  build() {
    List() {
      ForEach(this.specItem_120_, (item: SpecItem_120) => {
        ListItem() {
          this.SpecItem_120_Builder(item)
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
    .divider({
      strokeWidth: 1,
      startMargin: 10,
      endMargin: 10,
      color: '#ffe9f0f0'
    })
    .backgroundColor('white')
  }
}