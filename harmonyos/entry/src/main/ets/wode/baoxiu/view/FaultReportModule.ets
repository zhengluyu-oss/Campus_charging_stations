// @Component
// export struct FaultReportModule {
//   build() {
//     Column() {
//       List({ space: 2 }) {
//         ListItem() {
//           Row() {
//             Text('出厂编号')
//               .maxFontSize(14)
//               .fontColor('#333333')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             TextInput({ placeholder: '请输入出厂编号' })
//               .placeholderFont({ size: 14 })
//               .backgroundColor('#FFFFFF')
//               .layoutWeight(1)
//           }
//           .justifyContent(FlexAlign.SpaceBetween)
//           .padding({
//             top: '9.2px',
//             bottom: '9.2px',
//             left: '9.2px',
//             right: '9.2px'
//           })
//           .width('100%')
//         }
//         .padding({
//           top: 5,
//           left: 3,
//           bottom: 5,
//           right: 3
//         })
//
//         ListItem() {
//           Row() {
//             Text('充电桩位置')
//               .maxFontSize(14)
//               .fontColor('#333333')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             Text('请选择充电桩位置')
//               .maxFontSize(14)
//               .fontColor('#999999')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             Blank()
//             Button('>')
//               .fontSize(14)
//               .height(14)
//               .type(ButtonType.Normal)
//               .fontColor('#333333')
//               .backgroundColor('#FFFFFF')
//           }
//           .justifyContent(FlexAlign.SpaceBetween)
//           .padding({
//             top: '9.2px',
//             bottom: '9.2px',
//             left: '9.2px',
//             right: '9.2px'
//           })
//           .width('100%')
//         }
//         .padding({
//           top: 5,
//           left: 3,
//           bottom: 5,
//           right: 3
//         })
//
//         ListItem() {
//           Row() {
//             Text('联系人姓名')
//               .maxFontSize(14)
//               .fontColor('#333333')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             TextInput({ placeholder: '请输入联系人姓名' })
//               .placeholderFont({ size: 14 })
//               .backgroundColor('#FFFFFF')
//               .layoutWeight(1)
//           }
//           .justifyContent(FlexAlign.SpaceBetween)
//           .padding({
//             top: '9.2px',
//             bottom: '9.2px',
//             left: '9.2px',
//             right: '9.2px'
//           })
//           .width('100%')
//         }
//         .padding({
//           top: 5,
//           left: 3,
//           bottom: 5,
//           right: 3
//         })
//
//         ListItem() {
//           Row() {
//             Text('联系人电话')
//               .maxFontSize(14)
//               .fontColor('#333333')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             Text('15333395261')
//               .maxFontSize(14)
//               .fontColor('#333333')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             Button('×')
//               .fontSize(14)
//               .height(14)
//               .type(ButtonType.Normal)
//               .fontColor('#333333')
//               .backgroundColor('#FFFFFF')
//           }
//           .justifyContent(FlexAlign.SpaceBetween)
//           .padding({
//             top: '9.2px',
//             bottom: '9.2px',
//             left: '9.2px',
//             right: '9.2px'
//           })
//           .width('100%')
//         }
//         .padding({
//           top: 5,
//           left: 3,
//           bottom: 5,
//           right: 3
//         })
//
//         ListItem() {
//           Row() {
//             Text('故障时间')
//               .maxFontSize(14)
//               .fontColor('#333333')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             Text('请选择故障发生时间')
//               .maxFontSize(14)
//               .fontColor('#999999')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             Blank()
//             Button('>')
//               .fontSize(14)
//               .height(14)
//               .type(ButtonType.Normal)
//               .fontColor('#333333')
//               .backgroundColor('#FFFFFF')
//           }
//           .justifyContent(FlexAlign.SpaceBetween)
//           .padding({
//             top: '9.2px',
//             bottom: '9.2px',
//             left: '9.2px',
//             right: '9.2px'
//           })
//           .width('100%')
//         }
//         .padding({
//           top: 5,
//           left: 3,
//           bottom: 5,
//           right: 3
//         })
//
//         ListItem() {
//           Row() {
//             Text('故障描述')
//               .maxFontSize(14)
//               .fontColor('#333333')
//               .margin(2)
//               .minFontSize(8)
//               .textOverflow({ overflow: TextOverflow.Ellipsis })
//               .maxLines(1)
//             TextInput({ placeholder: '请输入故障描述' })
//               .placeholderFont({ size: 14 })
//               .backgroundColor('#FFFFFF')
//               .layoutWeight(1)
//           }
//           .justifyContent(FlexAlign.SpaceBetween)
//           .padding({
//             top: '9.2px',
//             bottom: '9.2px',
//             left: '9.2px',
//             right: '9.2px'
//           })
//           .width('100%')
//         }
//         .padding({
//           top: 5,
//           left: 3,
//           bottom: 5,
//           right: 3
//         })
//       }
//       .listDirection(Axis.Vertical)
//       .backgroundColor('#FFFFFF')
//       .width('95%')
//       .borderRadius(20)
//       .margin({ bottom: 10 })
//       .clip(true)
//       .divider({
//         strokeWidth: 1,
//         startMargin: 10,
//         endMargin: 10,
//         color: '#ffe9f0f0'
//       })
//
//       Row() {
//         Image($rawfile("wode/emoji_image_1_0.png"))
//           .margin(2)
//           .height('193px').objectFit(ImageFit.Cover).borderRadius(8)
//       }
//       .justifyContent(FlexAlign.Start)
//       .padding({
//         top: '9.2px',
//         bottom: '9.2px',
//         left: '9.2px',
//         right: '9.2px'
//       })
//       .width('100%')
//     }
//     .width('95%')
//     .backgroundColor('#FFFFFF')
//     .alignItems(HorizontalAlign.Start)
//     .borderRadius(20)
//     .margin({ bottom: 10 })
//     .clip(true)
//   }
// }
@Builder function DefaultFormItemContent() {}
// 1. 定义一个独立的组件 FormItem
@Component
struct FormItem {
  // 定义属性
  @Prop label: string = ''
  @Prop isLink: boolean = false

  // 关键修复：使用 @BuilderParam 接收外部传入的 UI 内容
  // 加上这个装饰器后，外部传入的 { ... } 就会被视为 Builder，可以写 UI 组件
  @BuilderParam contentBuilder: () => void= DefaultFormItemContent

  build() {
    Row() {
      Text(this.label)
        .fontSize(15)
        .fontColor('#333333')
        .width(90) // 固定标签宽度
        .fontWeight(FontWeight.Medium)

      // 内容区域
      Row() {
        if (this.contentBuilder) {
          this.contentBuilder()
        }
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.End)

      // 箭头 (如果是链接类型)
      if (this.isLink) {
        Image($rawfile("wode/youjiantou.png")) // 确保有此系统资源
          .width(16)
          .height(16)
          .fillColor('#CCCCCC')
          .margin({ left: 4 })
      }
    }
    .width('100%')
    .height(56) // 标准点击高度
    .alignItems(VerticalAlign.Center)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }
}

@Component
export struct FaultReportModule {
  @State factoryId: string = ''
  @State contactName: string = ''
  @State contactPhone: string = '15333395261'
  @State faultDesc: string = ''

  build() {
    Column() {
      // 表单区域容器
      Column() {
        // 1. 出厂编号
        // 修复后写法：直接使用 FormItem 组件，将 TextInput 写在后面的 {} 中
        FormItem({ label: '出厂编号' }) {
          TextInput({ placeholder: '请输入出厂编号', text: this.factoryId })
            .placeholderFont({ size: 14 })
            .textAlign(TextAlign.End)
            .backgroundColor(Color.Transparent)
            .height('100%')
            .width('100%')
            .padding(0)
            .onChange((value) => { this.factoryId = value })
        }
        Divider().color('#F5F5F5').strokeWidth(1).margin({ left: 16, right: 16 })

        // 2. 充电桩位置
        FormItem({ label: '充电桩位置', isLink: true }) {
          Text('请选择充电桩位置')
            .fontSize(14)
            .fontColor('#999999')
            .textAlign(TextAlign.End)
            .width('100%')
        }
        Divider().color('#F5F5F5').strokeWidth(1).margin({ left: 16, right: 16 })

        // 3. 联系人姓名
        FormItem({ label: '联系人姓名' }) {
          TextInput({ placeholder: '请输入姓名', text: this.contactName })
            .placeholderFont({ size: 14 })
            .textAlign(TextAlign.End)
            .backgroundColor(Color.Transparent)
            .height('100%')
            .width('100%')
            .padding(0)
            .onChange((value) => { this.contactName = value })
        }
        Divider().color('#F5F5F5').strokeWidth(1).margin({ left: 16, right: 16 })

        // 4. 联系人电话
        FormItem({ label: '联系人电话' }) {
          TextInput({ placeholder: '请输入电话', text: this.contactPhone })
            .placeholderFont({ size: 14 })
            .textAlign(TextAlign.End)
            .fontColor('#333333')
            .backgroundColor(Color.Transparent)
            .height('100%')
            .width('100%')
            .padding(0)
            .type(InputType.PhoneNumber)
            .onChange((value) => { this.contactPhone = value })
        }
        Divider().color('#F5F5F5').strokeWidth(1).margin({ left: 16, right: 16 })

        // 5. 故障时间
        FormItem({ label: '故障时间', isLink: true }) {
          Text('请选择故障发生时间')
            .fontSize(14)
            .fontColor('#999999')
            .textAlign(TextAlign.End)
            .width('100%')
        }
        Divider().color('#F5F5F5').strokeWidth(1).margin({ left: 16, right: 16 })

        // 6. 故障描述
        Column() {
          Text('故障描述')
            .fontSize(15)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .margin({ bottom: 8 })

          TextArea({ placeholder: '请详细描述故障情况...', text: this.faultDesc })
            .placeholderFont({ size: 14 })
            .backgroundColor('#F9F9F9')
            .borderRadius(8)
            .height(100)
            .width('100%')
            .padding(12)
            .onChange((value) => { this.faultDesc = value })
        }
        .padding(16)
        .backgroundColor(Color.White)
      }
      .width('94%')
      .backgroundColor(Color.White)
      .borderRadius(16)
      .shadow({ radius: 8, color: 'rgba(0,0,0,0.03)', offsetY: 2 })
      .margin({ top: 12, bottom: 12 })

      // 图片上传区域
      Column() {
        Text('上传照片 (可选)')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 12, left: 4 })
          .width('100%')

        Row() {
          // 模拟上传按钮
          Column() {
            Image($rawfile("wode/jiahao.png"))
              .width(32)
              .height(32)
              .fillColor('#CCCCCC')
              .margin({ bottom: 8 })
            Text('添加图片')
              .fontSize(12)
              .fontColor('#999999')
          }
          .width(100)
          .height(100)
          .backgroundColor('#F9F9F9')
          .borderRadius(8)
          .justifyContent(FlexAlign.Center)
          .border({ width: 1, color: '#EEEEEE', style: BorderStyle.Dashed })
          .onClick(() => {
            // 上传逻辑
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .width('94%')
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(16)
      .shadow({ radius: 8, color: 'rgba(0,0,0,0.03)', offsetY: 2 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
    .alignItems(HorizontalAlign.Center)
    .padding({ bottom: 20 })
  }
}