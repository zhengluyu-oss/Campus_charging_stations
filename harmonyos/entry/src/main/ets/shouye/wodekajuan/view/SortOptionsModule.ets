import { SpecItem_50 } from '../viewmodel/SortOptionsModule';

@Component
export struct SortOptionsModule {
  private specItem_50_: SpecItem_50[] = [
    { var_0: '新到' },
    { var_0: '快过期' },
    { var_0: '面额大到小' },
    { var_0: '折扣大到小' }
  ]
  private selectedSort: string = '新到';

  private onSortClick(sortOption: string): void {
    this.selectedSort = sortOption;
    console.info(`排序选项被点击: ${sortOption}`);
  }

  @Builder
  SpecItem_50_Builder(item: SpecItem_50) {
    Button(item.var_0)
      .fontSize('14fp')
      //.fontColor($r('app.color.background_emphasize'))
      .padding({
        top: '8vp',
        bottom: '8vp',
        left: '12vp',
        right: '12vp'
      })
      //.backgroundColor($r('app.color.comp_emphasize_secondary'))
      .borderRadius('16vp')
      .borderWidth(0)
      .onClick(() => {
        this.onSortClick(item.var_0);
      })
  }

  build() {
    Row() {
      ForEach(this.specItem_50_, (item: SpecItem_50) => {
        this.SpecItem_50_Builder(item)
      })
    }
    .width('92%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
    //.backgroundColor($r('app.color.background_primary'))
    .borderRadius('20vp')
    .padding({ top: '12vp', bottom: '12vp' })
    .margin({ bottom: '12vp', left: '4%', right: '4%' })
    .shadow({
      radius: 4,
      color: '#08000000',
      offsetX: 0,
      offsetY: 1
    })
  }
}