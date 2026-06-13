import { SpecItem_216, SpecItem_211 } from '../viewmodel/ChargingPileServiceModule';

/**
 * 充电桩服务模块组件
 * @description 展示充电桩相关服务分类的UI界面
 * @component
 * @entry 作为应用入口组件
 */
@Component
@Entry
export struct ChargingPileServiceModule {
  /**
   * 充电桩基础服务列表
   * @type {Array<SpecItem_211>}
   * @example
  * [
   *   { var_0: '交流桩' },
   *   { var_0: '直流桩' },
   *   { var_0: '充电桩配件' }
   * ]
   */
  private specItem_211_: SpecItem_211[] = [
    { var_0: '交流桩' },
    { var_0: '直流桩' },
    { var_0: '充电桩配件' }
  ]
  /**
   * 充电桩增值服务列表
   * @type {Array<SpecItem_216>}
   * @example
  * [
   *   { var_0: '安装服务' },
   *   { var_0: '延保服务' }
   * ]
   */
  private specItem_216_: SpecItem_216[] = [
    { var_0: '安装服务' },
    { var_0: '延保服务' }
  ]

  /**
   * 构建基础服务项按钮
   * @builder 用于在ForEach中复用UI结构
   * @param item 服务项数据对象
   * @returns 按钮组件
   */
  @Builder
  SpecItem_211_Builder(item: SpecItem_211) {
    Button(item.var_0)
      .fontSize(14)                  // 字体大小14px
      .height(30)                    // 按钮高度30px
      .type(ButtonType.Normal)       // 普通按钮类型
      .fontColor('#000000')          // 黑色文字
      .backgroundColor('#F0F0F0')    // 浅灰色背景
      // .constraintSize({ 'minWidth': 100 }) // 最小宽度100px
      .width('100%') // 宽度占满父容器
  }

  /**
   * 构建增值服务项按钮
   * @builder 用于在ForEach中复用UI结构
   * @param item 服务项数据对象
   * @returns 按钮组件（样式与基础服务按钮相同）
   */
  @Builder
  SpecItem_216_Builder(item: SpecItem_216) {
    Button(item.var_0)
      .fontSize(14)
      .height(30)
      .type(ButtonType.Normal)
      .fontColor('#000000')
      .backgroundColor('#F0F0F0')
      .constraintSize({ 'minWidth': 100 })
      .width('100%')
  }

  /**
   * 组件UI构建方法
   * @description 构建整个充电服务模块的界面布局
   */
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        // 返回按钮
        Text('<')
          .maxFontSize(14)
          .margin(2)  // 外边距2px
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis }) // 文本溢出省略
          .maxLines(1) // 最大1行

        // 页面标题
        Text('分类导航')
          .margin(2)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)

        // 装饰性图标
        Image($r('app.media.emoji_image_2_0')) // 资源引用
          .margin(2)
          .height('20px')
          .objectFit(ImageFit.Cover) // 图片填充方式
          .borderRadius(8) // 圆角8px
      }
      .alignItems(VerticalAlign.Center) // 垂直居中对齐
      .justifyContent(FlexAlign.SpaceBetween) // 两端对齐
      .padding({
        // 内边距
        top: '8.4px',
        bottom: '8.4px',
        left: '0.5px',
        right: '8.4px'
      })
      .width('100%') // 宽度100%

      // 服务分类网格容器
      Grid() {
        // 左侧导航栏
        GridItem() {
          Column() {
            // 充电桩分类标题
            Text('充电桩')
              .maxFontSize(14)
              .fontColor('#8C8F9A') // 灰色文字（注意：原代码有笔误，已修正）
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
              .padding({
                bottom: 15
              })

            // 充电卡券分类标题
            Text('充电卡券')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .alignItems(HorizontalAlign.Start) // 左对齐
          .padding({ left: '1px' }) // 左内边距
        }
        .width('20') // 占网格20%宽度
        .height('100%')
        .backgroundColor('#F0F0F0') // 浅灰色背景
        .padding({
          // 内边距
          top: 0,
          left: 0,
          bottom: 5,
          right: 0
        })

        // 右侧内容区域
        GridItem() {
          Column() {
            // 充电桩服务标题
            Text('充电桩')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)

            // 基础服务网格
            Grid() {
              ForEach(this.specItem_211_, (item: SpecItem_211) => {
                GridItem() {
                  this.SpecItem_211_Builder(item) // 使用构建器生成按钮
                }
                .width('100%')
                .borderRadius(8) // 圆角

                .clip(true) // 裁剪溢出内容
                .padding({
                  // 项目内边距
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
            .margin({ bottom: 10 }) // 底部外边距
            .columnsTemplate(('1fr ').repeat(3)) // 3列等宽布局
            .maxCount(1) // 最大行数1
            .alignSelf(ItemAlign.Center) // 水平居中
            .backgroundColor('#FFFFFF') // 白色背景

            // 电桩服务标题
            Text('电桩服务')
              .maxFontSize(14)
              .margin(2)
              .minFontSize(8)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)

            // 电桩服务网格
            Grid() {
              ForEach(this.specItem_216_, (item: SpecItem_216) => {
                GridItem() {
                  this.SpecItem_216_Builder(item) // 使用构建器生成按钮
                }
                .width('100%')
                .borderRadius(8)
                .clip(true)
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
            .columnsTemplate(('1fr ').repeat(2)) // 2列等宽布局
            .maxCount(1)
            .alignSelf(ItemAlign.Center)
            .backgroundColor('#FFFFFF')
          }
          .backgroundColor('#FFFFFF')
          .alignItems(HorizontalAlign.Start) // 内容左对齐
          .padding({ left: '8.4px' }) // 左内边距
        }
        .padding({
          // 右侧内容区域内边距
          top: 5,
          left: 3,
          bottom: 5,
          right: 3
        })
      }
      .backgroundColor('#FFFFFF') // 白色背景
      .width('95%') // 宽度95%
      .borderRadius(20) // 大圆角
      .margin({ bottom: 10 }) // 底部外边距
      .clip(true) // 裁剪溢出内容
      .columnsTemplate(('30% 1fr ')) // 2列网格布局
      .maxCount(2) // 最大2列
      .alignSelf(ItemAlign.Center) // 水平居中
    }
    .width('95%') // 外层宽度95%
    .backgroundColor('#FFFFFF') // 白色背景
    .alignItems(HorizontalAlign.Start) // 内容左对齐
    .borderRadius(20) // 大圆角
    .margin({ bottom: 10 }) // 底部外边距
    .clip(true) // 裁剪圆角外内容
  }
}