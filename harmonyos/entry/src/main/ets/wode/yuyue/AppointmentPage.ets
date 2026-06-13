// import router from '@ohos.router';
// import promptAction from '@ohos.promptAction';
//
// // --- 1. 定义数据接口 ---
//
// interface GunInfo {
//   id: string;
//   name: string;
//   type: string;
//   power: string;
//   status: '空闲' | '占用';
// }
//
// interface TimeSlot {
//   time: string;
//   hour: number;
//   status: number; // 0:可选, 1:占用, 2:已选, 3:已预约
// }
//
// // 导出此接口
// export interface AppointmentRecord {
//   id: string;
//   gunId: string;
//   gunName: string;
//   dateStr: string;
//   timeStr: string;
//   hour: number;
//   price: string;
//   createTime: number;
// }
//
// // --- 2. 我的预约弹窗组件 ---
// @CustomDialog
// struct MyAppointmentsDialog {
//   // 使用 @Link 双向绑定，子组件修改会同步给父组件
//   @Link appointments: AppointmentRecord[];
//   controller?: CustomDialogController;
//
//   // 处理取消逻辑 (直接在组件内处理)
//   handleCancel(record: AppointmentRecord) {
//     AlertDialog.show({
//       title: '取消预约',
//       message: '确定取消该预约吗？取消后费用将原路退回。',
//       primaryButton: { value: '再想想', action: () => {} },
//       secondaryButton: {
//         value: '确定取消',
//         fontColor: '#FF4444',
//         action: () => {
//           // 核心修复：直接修改 @Link 数据，父组件会自动感知
//           this.appointments = this.appointments.filter(item => item.id !== record.id);
//           promptAction.showToast({ message: '预约已取消' });
//         }
//       }
//     });
//   }
//
//   build() {
//     Column() {
//       Text('我的预约记录')
//         .fontSize(18)
//         .fontWeight(FontWeight.Bold)
//         .margin({ top: 20, bottom: 16 })
//
//       if (this.appointments.length === 0) {
//         Column() {
//           Text('暂无预约记录')
//             .fontSize(14)
//             .fontColor('#999999')
//             .margin({ top: 40 })
//         }
//         .height(150)
//         .width('100%')
//       } else {
//         List({ space: 12 }) {
//           ForEach(this.appointments, (item: AppointmentRecord) => {
//             ListItem() {
//               Row() {
//                 Column() {
//                   Text(item.gunName)
//                     .fontSize(16)
//                     .fontWeight(FontWeight.Bold)
//                     .fontColor('#333333')
//                   Text(`${item.dateStr} ${item.timeStr}`)
//                     .fontSize(14)
//                     .fontColor('#666666')
//                     .margin({ top: 4 })
//                 }
//                 .alignItems(HorizontalAlign.Start)
//
//                 Blank()
//
//                 Button('取消')
//                   .type(ButtonType.Normal)
//                   .fontSize(12)
//                   .fontColor('#FF4444')
//                   .backgroundColor('#FFF0F0')
//                   .borderRadius(14)
//                   .height(28)
//                   .onClick(() => {
//                     this.handleCancel(item);
//                   })
//               }
//               .width('100%')
//               .padding(12)
//               .backgroundColor('#F9F9F9')
//               .borderRadius(8)
//             }
//           })
//         }
//         .width('100%')
//         .height(300)
//         .padding({ left: 16, right: 16 })
//       }
//
//       Button('关闭')
//         .fontColor('#0A59F7')
//         .backgroundColor(Color.Transparent)
//         .margin({ top: 10, bottom: 10 })
//         .onClick(() => {
//           if (this.controller) {
//             this.controller.close();
//           }
//         })
//     }
//     .width('90%')
//     .backgroundColor(Color.White)
//     .borderRadius(16)
//   }
// }
//
// @Entry
// @Component
// struct AppointmentPage {
//   // --- 3. 状态变量 ---
//   @State selectedDateIndex: number = 0;
//   @State selectedGunIndex: number = 0;
//   @State timeSlots: TimeSlot[] = [];
//
//   // 核心修复：添加 @Watch 监听器
//   // 当 myAppointments 发生变化（包括在弹窗中被删除）时，自动调用 onAppointmentsChange
//   @State @Watch('onAppointmentsChange') myAppointments: AppointmentRecord[] = [];
//
//   private pileScheduleMap: Map<string, number[]> = new Map();
//
//   // 核心修复：移除 builder 中的回调函数，解决 this 访问错误
//   dialogController: CustomDialogController = new CustomDialogController({
//     builder: MyAppointmentsDialog({
//       appointments: $myAppointments // 只传递数据绑定
//     }),
//     autoCancel: true,
//     alignment: DialogAlignment.Center
//   });
//
//   private dateOptions: string[] = ['今天 02.04', '明天 02.05', '后天 02.06'];
//   private gunOptions: GunInfo[] = [
//     { id: '101', name: '1号桩', type: 'DC快充', power: '120kW', status: '空闲' },
//     { id: '102', name: '2号桩', type: 'DC快充', power: '120kW', status: '占用' },
//     { id: '103', name: '3号桩', type: 'AC慢充', power: '7kW', status: '空闲' },
//     { id: '104', name: '4号桩', type: 'AC慢充', power: '7kW', status: '空闲' }
//   ];
//
//   // --- 4. 生命周期与逻辑 ---
//
//   aboutToAppear() {
//     this.initMockData();
//     this.refreshTimeSlots();
//   }
//
//   // 监听器回调：数据变化时刷新网格状态
//   onAppointmentsChange() {
//     this.refreshTimeSlots();
//   }
//
//   initMockData() {
//     this.pileScheduleMap.set('101', [18, 19]);
//     this.pileScheduleMap.set('102', [10, 11, 12, 13, 14]);
//     this.pileScheduleMap.set('103', []);
//     this.pileScheduleMap.set('104', [8, 9]);
//   }
//
//   refreshTimeSlots() {
//     let currentGunId = this.gunOptions[this.selectedGunIndex].id;
//     let occupiedHours = this.pileScheduleMap.get(currentGunId) || [];
//     let currentDateStr = this.dateOptions[this.selectedDateIndex];
//
//     let slots: TimeSlot[] = [];
//     for (let i = 0; i < 24; i++) {
//       let timeStr = `${i.toString().padStart(2, '0')}:00`;
//
//       let status = 0;
//       if (occupiedHours.includes(i)) {
//         status = 1;
//       }
//
//       // 检查是否被自己预约
//       let isBookedByMe = this.myAppointments.some(app =>
//       app.gunId === currentGunId &&
//         app.dateStr === currentDateStr &&
//         app.hour === i
//       );
//
//       if (isBookedByMe) {
//         status = 3;
//       }
//
//       slots.push({
//         time: timeStr,
//         hour: i,
//         status: status
//       });
//     }
//     this.timeSlots = slots;
//   }
//
//   toggleTimeSlot(index: number) {
//     let slot = this.timeSlots[index];
//     if (slot.status === 1) {
//       promptAction.showToast({ message: '该时段已被他人占用' });
//       return;
//     }
//     if (slot.status === 3) {
//       promptAction.showToast({ message: '您已预约该时段，请在“我的预约”中查看' });
//       return;
//     }
//
//     let newSlots = [...this.timeSlots];
//     if (newSlots[index].status === 2) {
//       newSlots[index].status = 0;
//     } else {
//       newSlots.forEach(t => {
//         if (t.status === 2) t.status = 0;
//       });
//       newSlots[index].status = 2;
//     }
//     this.timeSlots = newSlots;
//   }
//
//   // 提交预约
//   handleBookAppointment() {
//     // 1. 查找选中的 slot
//     let selectedSlot = this.timeSlots.find(t => t.status === 2);
//
//     // 2. 空值检查
//     if (!selectedSlot) {
//       promptAction.showToast({ message: '请先选择预约时段' });
//       return;
//     }
//
//     // ✅ 关键修复：定义一个确定不为空的常量，供后面的回调函数安全使用
//     // 这样编译器就知道 bookSlot 在闭包中是绝对安全的 TimeSlot 类型
//     const bookSlot = selectedSlot;
//
//     let currentGun = this.gunOptions[this.selectedGunIndex];
//     let currentDate = this.dateOptions[this.selectedDateIndex];
//
//     AlertDialog.show({
//       title: '预约确认',
//       message: `确定预约 ${currentGun.name} \n时间：${currentDate} ${bookSlot.time} 吗？`,
//       primaryButton: {
//         value: '取消',
//         action: () => {}
//       },
//       secondaryButton: {
//         value: '确定支付',
//         fontColor: '#0A59F7',
//         action: () => {
//           let newRecord: AppointmentRecord = {
//             id: new Date().getTime().toString(),
//             gunId: currentGun.id,
//             gunName: currentGun.name,
//             dateStr: currentDate,
//             // ✅ 使用安全的 bookSlot 变量
//             timeStr: bookSlot.time,
//             hour: bookSlot.hour,
//             price: '35.00',
//             createTime: new Date().getTime()
//           };
//           // 触发 UI 刷新
//           this.myAppointments.push(newRecord);
//           promptAction.showToast({ message: '预约成功！' });
//         }
//       }
//     });
//   }
//   // --- 5. UI 构建 ---
//
//   build() {
//     Column() {
//       // --- 顶部导航栏 ---
//       Stack({ alignContent: Alignment.Top }) {
//         Column()
//           .width('100%')
//           .height(220)
//           .linearGradient({
//             direction: GradientDirection.Bottom,
//             colors: [['#0A59F7', 0.0], ['#F5F7FA', 1.0]]
//           })
//
//         Row() {
//           Text('<')
//             .fontSize(24)
//             .fontColor(Color.White)
//             .fontWeight(FontWeight.Bold)
//             .onClick(() => {
//               router.back();
//             })
//             .padding({ right: 16 })
//
//           Text('预约充电')
//             .fontSize(18)
//             .fontWeight(FontWeight.Bold)
//             .fontColor(Color.White)
//             .layoutWeight(1)
//             .textAlign(TextAlign.Center)
//
//           Text('我的预约')
//             .fontSize(14)
//             .fontColor(Color.White)
//             .onClick(() => {
//               this.dialogController.open();
//             })
//         }
//         .width('100%')
//         .height(56)
//         .padding({ left: 16, right: 16 })
//         .alignItems(VerticalAlign.Center)
//       }
//       .height(60)
//       .zIndex(100)
//
//       Scroll() {
//         Column({ space: 12 }) {
//           this.StationInfoCard()
//           this.ConnectorSelectionCard()
//           this.TimeSelectionCard()
//           this.PriceDetailCard()
//           Blank().height(80)
//         }
//         .width('100%')
//         .padding({ left: 12, right: 12, top: 12 })
//       }
//       .layoutWeight(1)
//       .scrollBar(BarState.Off)
//       .edgeEffect(EdgeEffect.Spring)
//
//       this.BottomActionBar()
//     }
//     .width('100%')
//     .height('100%')
//     .backgroundColor('#F5F7FA')
//   }
//
//   @Builder
//   StationInfoCard() {
//     Column() {
//       Text('天津市滨海新区服务外包园电站')
//         .fontSize(18)
//         .fontWeight(FontWeight.Bold)
//         .fontColor('#333333')
//         .margin({ bottom: 8 })
//
//       Row() {
//         Circle({ width: 8, height: 8 })
//           .fill('#999999')
//           .margin({ right: 6 })
//
//         Text('天津市滨海新区黄海路19号 | 距您 2.5km')
//           .fontSize(12)
//           .fontColor('#666666')
//           .layoutWeight(1)
//           .maxLines(1)
//           .textOverflow({ overflow: TextOverflow.Ellipsis })
//       }
//       .width('100%')
//       .margin({ bottom: 12 })
//
//       Row({ space: 8 }) {
//         Text('对外开放')
//           .fontSize(10)
//           .fontColor('#0A59F7')
//           .backgroundColor('#E6F0FF')
//           .padding({ left: 6, right: 6, top: 2, bottom: 2 })
//           .borderRadius(4)
//         Text('免停车费')
//           .fontSize(10)
//           .fontColor('#FF6600')
//           .backgroundColor('#FFF0E5')
//           .padding({ left: 6, right: 6, top: 2, bottom: 2 })
//           .borderRadius(4)
//       }
//     }
//     .width('100%')
//     .padding(16)
//     .backgroundColor(Color.White)
//     .borderRadius(16)
//     .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
//   }
//
//   @Builder
//   ConnectorSelectionCard() {
//     Column() {
//       Row() {
//         Rect().width(4).height(16).fill('#0A59F7').radius(2).margin({ right: 8 })
//         Text('选择终端')
//           .fontSize(16)
//           .fontWeight(FontWeight.Bold)
//       }
//       .width('100%')
//       .margin({ bottom: 12 })
//
//       List({ space: 10 }) {
//         ForEach(this.gunOptions, (item: GunInfo, index: number) => {
//           ListItem() {
//             Column() {
//               Text(item.status)
//                 .fontSize(10)
//                 .fontColor(item.status === '空闲' ? '#19B668' : '#999999')
//                 .backgroundColor(item.status === '空闲' ? '#E8F8F0' : '#F5F5F5')
//                 .padding({ left: 6, right: 6, top: 2, bottom: 2 })
//                 .borderRadius({ bottomRight: 8, topLeft: 8 })
//                 .alignSelf(ItemAlign.Start)
//
//               Column({ space: 4 }) {
//                 Text(item.name)
//                   .fontSize(16)
//                   .fontWeight(FontWeight.Bold)
//                   .fontColor(this.selectedGunIndex === index ? '#0A59F7' : '#333333')
//                 Text(item.type)
//                   .fontSize(12)
//                   .fontColor('#666666')
//                 Text(item.power)
//                   .fontSize(12)
//                   .fontColor('#999999')
//               }
//               .margin({ top: 8, bottom: 8 })
//               .alignItems(HorizontalAlign.Center)
//               .width('100%')
//
//               if (this.selectedGunIndex === index) {
//                 Text('✓')
//                   .fontSize(14)
//                   .fontColor('#0A59F7')
//                   .position({ x: '80%', y: '80%' })
//               }
//             }
//             .width(100)
//             .height(110)
//             .backgroundColor(this.selectedGunIndex === index ? '#F0F6FF' : '#F9F9F9')
//             .border({
//               width: 1.5,
//               color: this.selectedGunIndex === index ? '#0A59F7' : 'transparent'
//             })
//             .borderRadius(12)
//             .onClick(() => {
//               this.selectedGunIndex = index;
//               this.refreshTimeSlots();
//             })
//           }
//         })
//       }
//       .width('100%')
//       .listDirection(Axis.Horizontal)
//       .scrollBar(BarState.Off)
//     }
//     .width('100%')
//     .padding(16)
//     .backgroundColor(Color.White)
//     .borderRadius(16)
//     .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
//   }
//
//   @Builder
//   TimeSelectionCard() {
//     Column() {
//       Row() {
//         Row() {
//           Rect().width(4).height(16).fill('#0A59F7').radius(2).margin({ right: 8 })
//           Text('预约时段')
//             .fontSize(16)
//             .fontWeight(FontWeight.Bold)
//         }
//         Blank()
//         Row({ space: 12 }) {
//           this.LegendItem('#F5F7FA', '可选')
//           this.LegendItem('#E0E0E0', '占用')
//           this.LegendItem('#0A59F7', '已选')
//           this.LegendItem('#E8F8F0', '已预约')
//         }
//       }
//       .width('100%')
//       .margin({ bottom: 16 })
//
//       Row() {
//         ForEach(this.dateOptions, (date: string, index: number) => {
//           Column() {
//             Text(date)
//               .fontSize(14)
//               .fontWeight(this.selectedDateIndex === index ? FontWeight.Bold : FontWeight.Normal)
//               .fontColor(this.selectedDateIndex === index ? '#0A59F7' : '#666666')
//
//             if (this.selectedDateIndex === index) {
//               Rect().width(20).height(3).fill('#0A59F7').radius(1.5).margin({ top: 4 })
//             } else {
//               Rect().width(20).height(3).fill('transparent').margin({ top: 4 })
//             }
//           }
//           .layoutWeight(1)
//           .onClick(() => {
//             this.selectedDateIndex = index;
//             this.refreshTimeSlots();
//           })
//         })
//       }
//       .width('100%')
//       .margin({ bottom: 16 })
//
//       Grid() {
//         ForEach(this.timeSlots, (item: TimeSlot, index: number) => {
//           GridItem() {
//             Text(item.time)
//               .fontSize(14)
//               .fontColor(this.getTimeSlotColor(item.status))
//               .fontWeight(FontWeight.Medium)
//               .width('100%')
//               .height(40)
//               .textAlign(TextAlign.Center)
//               .backgroundColor(this.getTimeSlotBgColor(item.status))
//               .borderRadius(8)
//               .decoration({
//                 type: item.status === 1 ? TextDecorationType.LineThrough : TextDecorationType.None,
//                 color: '#999999'
//               })
//               .onClick(() => {
//                 this.toggleTimeSlot(index);
//               })
//           }
//         })
//       }
//       .columnsTemplate('1fr 1fr 1fr 1fr')
//       .columnsGap(10)
//       .rowsGap(10)
//       .height(300)
//     }
//     .width('100%')
//     .padding(16)
//     .backgroundColor(Color.White)
//     .borderRadius(16)
//     .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
//   }
//
//   getTimeSlotColor(status: number): ResourceColor {
//     if (status === 2) return Color.White;
//     if (status === 3) return '#19B668';
//     if (status === 1) return '#BBBBBB';
//     return '#333333';
//   }
//
//   getTimeSlotBgColor(status: number): ResourceColor {
//     if (status === 2) return '#0A59F7';
//     if (status === 3) return '#E8F8F0';
//     if (status === 1) return '#F0F0F0';
//     return '#F5F7FA';
//   }
//
//   @Builder
//   LegendItem(bgColor: string, text: string) {
//     Row() {
//       Rect().width(12).height(12).fill(bgColor).radius(2).margin({ right: 4 })
//       Text(text).fontSize(10).fontColor('#666666')
//     }
//   }
//
//   @Builder
//   PriceDetailCard() {
//     Column({ space: 12 }) {
//       Row() {
//         Text('预约服务费')
//           .fontSize(14)
//           .fontColor('#333333')
//         Blank()
//         Text('¥5.00')
//           .fontSize(14)
//           .fontColor('#333333')
//           .fontWeight(FontWeight.Medium)
//       }
//
//       Row() {
//         Text('充电预付金')
//           .fontSize(14)
//           .fontColor('#333333')
//         Row() {
//           Text('?')
//             .fontSize(10)
//             .fontColor('#999999')
//             .textAlign(TextAlign.Center)
//             .width(14)
//             .height(14)
//             .border({ width: 1, color: '#999999', radius: 7 })
//             .margin({ left: 4 })
//         }
//         Blank()
//         Text('¥30.00')
//           .fontSize(14)
//           .fontColor('#333333')
//           .fontWeight(FontWeight.Medium)
//       }
//
//       Divider().color('#F5F5F5').strokeWidth(1)
//
//       Row() {
//         Text('超时占用费')
//           .fontSize(12)
//           .fontColor('#999999')
//         Blank()
//         Text('¥1.00/分钟')
//           .fontSize(12)
//           .fontColor('#999999')
//       }
//     }
//     .width('100%')
//     .padding(16)
//     .backgroundColor(Color.White)
//     .borderRadius(16)
//     .shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
//   }
//
//   @Builder
//   BottomActionBar() {
//     Row() {
//       Column() {
//         Row() {
//           Text('合计:')
//             .fontSize(14)
//             .fontColor('#333333')
//             .margin({ bottom: 2 })
//           Text('¥35.00')
//             .fontSize(20)
//             .fontWeight(FontWeight.Bold)
//             .fontColor('#FF4444')
//             .margin({ left: 4 })
//         }
//         Text('含预约费 ¥5.00')
//           .fontSize(10)
//           .fontColor('#999999')
//       }
//       .alignItems(HorizontalAlign.Start)
//
//       Blank()
//
//       Button('立即预约')
//         .type(ButtonType.Capsule)
//         .backgroundColor('#0A59F7')
//         .width(140)
//         .height(44)
//         .fontSize(16)
//         .fontWeight(FontWeight.Bold)
//         .onClick(() => {
//           this.handleBookAppointment();
//         })
//     }
//     .width('100%')
//     .height(80)
//     .backgroundColor(Color.White)
//     .padding({ left: 20, right: 20 })
//     .shadow({ radius: 10, color: 'rgba(0,0,0,0.1)', offsetY: -2 })
//     .alignItems(VerticalAlign.Center)
//   }
// }
// ets/pages/AppointmentPage.ets
// ets/pages/AppointmentPage.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { getAllStations, getStationReservations, getUserReservations, reserve, cancelReservation } from '../../apis/ReservationApi';
import { ChargingStation, Reservation, ReserveParam, CancelParam } from '../../viewmodel/ReservationModel';
import { User } from '../../viewmodel/UserModel'; // 确保路径正确
import { JsonResult } from '../../utils/HttpUtil';

// --- 接口定义 ---

// 页面内部使用的充电桩信息结构，适配 UI
interface GunInfo {
  id: string;
  name: string;
  type: string;
  power: string;
  status: '空闲' | '占用';
  originalId: number; // 原始ID用于API
}

// 时间段结构
interface TimeSlot {
  time: string;
  hour: number;
  status: number; // 0:可选, 1:占用, 2:已选, 3:已预约
}

// 预约记录视图结构
interface AppointmentRecordView {
  id: string;
  gunId: string;
  gunName: string;
  dateStr: string;
  timeStr: string;
  hour: number;
  price: string;
  createTime: number;
  originalId: number;
}

// --- 弹窗组件 ---
@CustomDialog
struct MyAppointmentsDialog {
  @Link appointments: AppointmentRecordView[];
  // 接收父组件传入的用户ID
  @Prop currentUserId: number;
  controller?: CustomDialogController;

  // 内部处理取消逻辑
  handleCancel(record: AppointmentRecordView) {
    if (!this.currentUserId) {
      promptAction.showToast({ message: '用户信息异常' });
      return;
    }

    AlertDialog.show({
      title: '取消预约',
      message: '确定取消该预约吗？',
      primaryButton: { value: '再想想', action: () => {} },
      secondaryButton: {
        value: '确定取消',
        fontColor: '#FF4444',
        action: () => {
          // 调用 API
          const param: CancelParam = {
            reservationId: record.originalId,
            userId: this.currentUserId
          };

          cancelReservation(param).then((res: JsonResult<null>) => {
            if (res.state === 0) { // 0 表示成功
              promptAction.showToast({ message: '预约已取消' });
              // 更新本地列表 (触发父组件 @Watch)
              this.appointments = this.appointments.filter(item => item.id !== record.id);
            } else {
              promptAction.showToast({ message: res.message || '取消失败' });
            }
          }).catch((err: Error) => {
            promptAction.showToast({ message: '网络请求失败' });
          });
        }
      }
    });
  }

  build() {
    Column() {
      Text('我的预约记录')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 16 })

      if (this.appointments.length === 0) {
        Column() {
          Text('暂无预约记录')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 40 })
        }
        .height(150)
        .width('100%')
      } else {
        List({ space: 12 }) {
          ForEach(this.appointments, (item: AppointmentRecordView) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item.gunName)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#333333')
                  Text(`${item.dateStr} ${item.timeStr}`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)

                Blank()

                Button('取消')
                  .type(ButtonType.Normal)
                  .fontSize(12)
                  .fontColor('#FF4444')
                  .backgroundColor('#FFF0F0')
                  .borderRadius(14)
                  .height(28)
                  .onClick(() => {
                    this.handleCancel(item);
                  })
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#F9F9F9')
              .borderRadius(8)
            }
          })
        }
        .width('100%')
        .height(300)
        .padding({ left: 16, right: 16 })
      }

      Button('关闭')
        .fontColor('#0A59F7')
        .backgroundColor(Color.Transparent)
        .margin({ top: 10, bottom: 10 })
        .onClick(() => {
          if (this.controller) {
            this.controller.close();
          }
        })
    }
    .width('90%')
    .backgroundColor(Color.White)
    .borderRadius(16)
  }
}

@Entry
@Component
struct AppointmentPage {
  @State selectedDateIndex: number = 0;
  @State selectedGunIndex: number = 0;
  @State timeSlots: TimeSlot[] = [];

  // 监听预约变化，刷新时间表
  @State @Watch('onAppointmentsChange') myAppointments: AppointmentRecordView[] = [];
  @State gunOptions: GunInfo[] = [];

  // 获取全局用户对象
  @StorageLink('user') currentUser: User = { id: 0 } as User;

  // 初始化弹窗控制器
  dialogController: CustomDialogController = new CustomDialogController({
    builder: MyAppointmentsDialog({
      appointments: $myAppointments,
      // 传递 ID 而非回调，解决 this 访问错误
      currentUserId: this.currentUser ? this.currentUser.id : 0
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center
  });

  private dateOptions: string[] = this.generateDateOptions();

  aboutToAppear() {
    // 检查登录
    if (!this.currentUser || !this.currentUser.id) {
      promptAction.showToast({ message: '未登录，请先登录' });
    }
    this.initData();
  }

  async initData() {
    await this.fetchStations();
    await this.fetchMyReservations();
    this.refreshTimeSlots();
  }

  // 1. API: 获取电站列表
  async fetchStations() {
    try {
      const res = await getAllStations();
      if (res.state === 0 && res.data) {
        this.gunOptions = res.data.map((station: ChargingStation) => {
          // 兼容处理 ID
          const sId = station.stationId;
          const sName = station.stationName || '未知桩';
          return {
            id: sId.toString(),
            originalId: sId,
            name: sName,
            type: station.type || '快充', // 假设后端数据无此字段则默认
            power: station.powerRating || '120kW', // 使用 powerRating
            status: station.status === 'FREE' ? '空闲' : '占用' // 假设 FREE 为空闲
          } as GunInfo;
        });
      }
    } catch (error) {
      console.error('Fetch stations failed');
    }
  }

  // 2. API: 获取我的预约
  async fetchMyReservations() {
    if (!this.currentUser?.id) return;
    try {
      const res = await getUserReservations(this.currentUser.id);
      if (res.state === 0 && res.data) {
        this.myAppointments = res.data.map((r: Reservation) => {
          const gun = this.gunOptions.find(g => g.originalId === r.stationId);
          // 简单的时间格式化
          const d = new Date(r.reservedStartTime);
          const dateStr = `${d.getMonth() + 1}月${d.getDate()}日`;
          const timeStr = `${d.getHours().toString().padStart(2, '0')}:00`;

          return {
            id: r.reservationId.toString(),
            originalId: r.reservationId,
            gunId: r.stationId.toString(),
            gunName: gun ? gun.name : `桩#${r.stationId}`,
            dateStr: dateStr,
            timeStr: timeStr,
            hour: d.getHours(),
            price: '35.00',
            createTime: new Date().getTime()
          } as AppointmentRecordView;
        });
      }
    } catch (error) {
      console.error('Fetch my reservations failed');
    }
  }

  // 3. 逻辑: 刷新时间表状态
  async refreshTimeSlots() {
    if (this.gunOptions.length === 0) return;

    const currentGun = this.gunOptions[this.selectedGunIndex];
    const targetDateStr = this.getSelectedDateStr(); // 格式: yyyy-MM-dd
    let occupiedHours: number[] = [];

    try {
      // API: 获取该桩的所有预约
      const res = await getStationReservations(currentGun.originalId);
      if (res.state === 0 && res.data) {
        res.data.forEach((r: Reservation) => {
          if (r.status === 'cancelled') return;

          const d = new Date(r.reservedStartTime);
          // 格式化为 yyyy-MM-dd 对比
          const rDate = `${d.getFullYear()}-${(d.getMonth()+1).toString().padStart(2,'0')}-${d.getDate().toString().padStart(2,'0')}`;

          if (rDate === targetDateStr) {
            occupiedHours.push(d.getHours());
          }
        });
      }
    } catch (e) {}

    // 生成状态网格
    let slots: TimeSlot[] = [];
    for (let i = 0; i < 24; i++) {
      let timeStr = `${i.toString().padStart(2, '0')}:00`;
      let status = 0; // 0:可选

      // 如果后端说被占用了
      if (occupiedHours.includes(i)) status = 1;

      // 检查是不是“我”占用的 (本地数据比对)
      const isMine = this.myAppointments.some(app =>
      app.gunId === currentGun.id &&
        app.hour === i &&
      this.isSameDate(app.dateStr, targetDateStr)
      );

      if (isMine) status = 3; // 3:我的预约

      slots.push({ time: timeStr, hour: i, status: status });
    }
    this.timeSlots = slots;
  }

  // 日期对比辅助方法
  isSameDate(displayDate: string, fullDateStr: string): boolean {
    // displayDate: "2月4日", fullDateStr: "2025-02-04"
    const parts = fullDateStr.split('-'); // [2025, 02, 04]
    const m = parseInt(parts[1]);
    const d = parseInt(parts[2]);
    return displayDate === `${m}月${d}日`;
  }

  // @Watch 回调
  onAppointmentsChange() {
    this.refreshTimeSlots();
  }

  // 4. API: 执行预约
  async executeReserve(gun: GunInfo, dateStr: string, slot: TimeSlot) {
    if (!this.currentUser || !this.currentUser.id) {
      promptAction.showToast({ message: '请先登录' });
      return;
    }

    const startTime = `${dateStr} ${slot.time}:00`;
    const nextH = (slot.hour + 1).toString().padStart(2, '0');
    const endTime = `${dateStr} ${nextH}:00:00`;

    const param: ReserveParam = {
      stationId: gun.originalId,
      userId: this.currentUser.id,
      startTime: startTime,
      endTime: endTime
    };

    try {
      const res = await reserve(param);
      if (res.state === 0) {
        promptAction.showToast({ message: '预约成功' });
        await this.fetchMyReservations(); // 刷新列表
        // refreshTimeSlots 会自动触发
      } else {
        promptAction.showToast({ message: res.message || '预约失败' });
      }
    } catch (e) {
      promptAction.showToast({ message: '请求超时' });
    }
  }

  // 点击“立即预约”
  handleBookAppointment() {
    const slot = this.timeSlots.find(t => t.status === 2);
    if (!slot) {
      promptAction.showToast({ message: '请先选择时间' });
      return;
    }
    const bookSlot = slot;
    const currentGun = this.gunOptions[this.selectedGunIndex];
    const dateStr = this.getSelectedDateStr();

    AlertDialog.show({
      title: '预约确认',
      message: `确定预约 ${currentGun.name} ${bookSlot.time}?`,
      primaryButton: { value: '取消', action: () => {} },
      secondaryButton: {
        value: '确定',
        fontColor: '#0A59F7',
        action: () => {
          this.executeReserve(currentGun, dateStr, bookSlot);
        }
      }
    });
  }

  toggleTimeSlot(index: number) {
    const slot = this.timeSlots[index];
    if (slot.status === 1) {
      promptAction.showToast({ message: '该时段已被占用' });
      return;
    }
    if (slot.status === 3) {
      promptAction.showToast({ message: '您已预约该时段' });
      return;
    }
    let newSlots = [...this.timeSlots];
    newSlots.forEach(t => { if(t.status === 2) t.status = 0; });
    if (this.timeSlots[index].status !== 2) {
      newSlots[index].status = 2;
    }
    this.timeSlots = newSlots;
  }

  // --- 辅助方法 ---
  generateDateOptions(): string[] {
    const arr: string[] = [];
    const d = new Date();
    for(let i=0; i<3; i++) {
      const temp = new Date(d);
      temp.setDate(d.getDate() + i);
      const prefix = i===0?'今天':(i===1?'明天':'后天');
      arr.push(`${prefix} ${(temp.getMonth()+1).toString().padStart(2,'0')}.${temp.getDate().toString().padStart(2,'0')}`);
    }
    return arr;
  }

  getSelectedDateStr(): string {
    const d = new Date();
    d.setDate(d.getDate() + this.selectedDateIndex);
    return `${d.getFullYear()}-${(d.getMonth()+1).toString().padStart(2,'0')}-${d.getDate().toString().padStart(2,'0')}`;
  }

  getTimeSlotColor(status: number): ResourceColor {
    if (status === 2) return Color.White;
    if (status === 3) return '#19B668';
    if (status === 1) return '#BBBBBB';
    return '#333333';
  }

  getTimeSlotBgColor(status: number): ResourceColor {
    if (status === 2) return '#0A59F7';
    if (status === 3) return '#E8F8F0';
    if (status === 1) return '#F0F0F0';
    return '#F5F7FA';
  }

  // --- UI 构建 ---
  build() {
    Column() {
      // 顶部
      Stack({ alignContent: Alignment.Top }) {
        Column().width('100%').height(220)
          .linearGradient({ direction: GradientDirection.Bottom, colors: [['#0A59F7', 0.0], ['#F5F7FA', 1.0]] })
        Row() {
          Text('<').fontSize(24).fontColor(Color.White).fontWeight(FontWeight.Bold).onClick(() => router.back()).padding({ right: 16 })
          Text('预约充电').fontSize(18).fontWeight(FontWeight.Bold).fontColor(Color.White).layoutWeight(1).textAlign(TextAlign.Center)
          Text('我的预约').fontSize(14).fontColor(Color.White).onClick(() => this.dialogController.open())
        }.width('100%').height(56).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)
      }.height(60).zIndex(100)

      Scroll() {
        Column({ space: 12 }) {
          this.StationInfoCard()
          this.ConnectorSelectionCard()
          this.TimeSelectionCard()
          this.PriceDetailCard()
          Blank().height(80)
        }.width('100%').padding({ left: 12, right: 12, top: 12 })
      }.layoutWeight(1).scrollBar(BarState.Off).edgeEffect(EdgeEffect.Spring)

      this.BottomActionBar()
    }.width('100%').height('100%').backgroundColor('#F5F7FA')
  }

  @Builder StationInfoCard() {
    Column() {
      Text(this.gunOptions.length > 0 ? this.gunOptions[0].name : '加载中...')
        .fontSize(18).fontWeight(FontWeight.Bold).fontColor('#333333').margin({ bottom: 8 })
      Row() {
        Circle({ width: 8, height: 8 }).fill('#999999').margin({ right: 6 })
        Text('天津市滨海新区黄海路19号 | 距您 2.5km').fontSize(12).fontColor('#666666')
      }.width('100%').margin({ bottom: 12 })
      Row({ space: 8 }) {
        Text('对外开放').fontSize(10).fontColor('#0A59F7').backgroundColor('#E6F0FF').padding({ left: 6, right: 6, top: 2, bottom: 2 }).borderRadius(4)
        Text('免停车费').fontSize(10).fontColor('#FF6600').backgroundColor('#FFF0E5').padding({ left: 6, right: 6, top: 2, bottom: 2 }).borderRadius(4)
      }
    }.width('100%').padding(16).backgroundColor(Color.White).borderRadius(16).shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }

  @Builder ConnectorSelectionCard() {
    Column() {
      Row() {
        Rect().width(4).height(16).fill('#0A59F7').radius(2).margin({ right: 8 })
        Text('选择终端').fontSize(16).fontWeight(FontWeight.Bold)
      }.width('100%').margin({ bottom: 12 })

      List({ space: 10 }) {
        ForEach(this.gunOptions, (item: GunInfo, index: number) => {
          ListItem() {
            Column() {
              Text(item.status).fontSize(10).fontColor(item.status === '空闲' ? '#19B668' : '#999999')
                .backgroundColor(item.status === '空闲' ? '#E8F8F0' : '#F5F5F5')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 }).borderRadius(4).alignSelf(ItemAlign.Start)
              Column({ space: 4 }) {
                Text(item.name).fontSize(16).fontWeight(FontWeight.Bold).fontColor(this.selectedGunIndex === index ? '#0A59F7' : '#333333')
                Text(item.type).fontSize(12).fontColor('#666666')
                Text(item.power).fontSize(12).fontColor('#999999')
              }.margin({ top: 8, bottom: 8 }).alignItems(HorizontalAlign.Center).width('100%')
              if (this.selectedGunIndex === index) {
                Text('✓').fontSize(14).fontColor('#0A59F7').position({ x: '80%', y: '80%' })
              }
            }.width(100).height(110).backgroundColor(this.selectedGunIndex === index ? '#F0F6FF' : '#F9F9F9')
            .border({ width: 1.5, color: this.selectedGunIndex === index ? '#0A59F7' : 'transparent' })
            .borderRadius(12).onClick(() => { this.selectedGunIndex = index; this.refreshTimeSlots(); })
          }
        })
      }.listDirection(Axis.Horizontal).width('100%').scrollBar(BarState.Off)
    }.width('100%').padding(16).backgroundColor(Color.White).borderRadius(16).shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }

  @Builder TimeSelectionCard() {
    Column() {
      Row() {
        Row() { Rect().width(4).height(16).fill('#0A59F7').radius(2).margin({ right: 8 }); Text('预约时段').fontSize(16).fontWeight(FontWeight.Bold) }
        Blank()
        Row({ space: 12 }) { this.LegendItem('#F5F7FA', '可选'); this.LegendItem('#E0E0E0', '占用'); this.LegendItem('#0A59F7', '已选'); this.LegendItem('#E8F8F0', '已预约') }
      }.width('100%').margin({ bottom: 16 })

      Row() {
        ForEach(this.dateOptions, (date: string, index: number) => {
          Column() {
            Text(date).fontSize(14).fontWeight(this.selectedDateIndex === index ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.selectedDateIndex === index ? '#0A59F7' : '#666666')
            if (this.selectedDateIndex === index) Rect().width(20).height(3).fill('#0A59F7').radius(1.5).margin({ top: 4 })
            else Rect().width(20).height(3).fill('transparent').margin({ top: 4 })
          }.layoutWeight(1).onClick(() => { this.selectedDateIndex = index; this.refreshTimeSlots(); })
        })
      }.width('100%').margin({ bottom: 16 })

      Grid() {
        ForEach(this.timeSlots, (item: TimeSlot, index: number) => {
          GridItem() {
            Text(item.time).fontSize(14).fontColor(this.getTimeSlotColor(item.status)).fontWeight(FontWeight.Medium)
              .width('100%').height(40).textAlign(TextAlign.Center).backgroundColor(this.getTimeSlotBgColor(item.status)).borderRadius(8)
              .onClick(() => this.toggleTimeSlot(index))
          }
        })
      }.columnsTemplate('1fr 1fr 1fr 1fr').columnsGap(10).rowsGap(10).height(300)
    }.width('100%').padding(16).backgroundColor(Color.White).borderRadius(16).shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }

  @Builder LegendItem(bgColor: string, text: string) {
    Row() { Rect().width(12).height(12).fill(bgColor).radius(2).margin({ right: 4 }); Text(text).fontSize(10).fontColor('#666666') }
  }

  @Builder PriceDetailCard() {
    Column({ space: 12 }) {
      Row() { Text('预约服务费').fontSize(14).fontColor('#333333'); Blank(); Text('¥5.00').fontSize(14).fontColor('#333333').fontWeight(FontWeight.Medium) }
      Row() { Text('充电预付金').fontSize(14).fontColor('#333333'); Blank(); Text('¥30.00').fontSize(14).fontColor('#333333').fontWeight(FontWeight.Medium) }
      Divider().color('#F5F5F5').strokeWidth(1)
      Row() { Text('超时占用费').fontSize(12).fontColor('#999999'); Blank(); Text('¥1.00/分钟').fontSize(12).fontColor('#999999') }
    }.width('100%').padding(16).backgroundColor(Color.White).borderRadius(16).shadow({ radius: 8, color: 'rgba(0,0,0,0.05)', offsetY: 2 })
  }

  @Builder BottomActionBar() {
    Row() {
      Column() {
        Row() { Text('合计:').fontSize(14).fontColor('#333333').margin({ bottom: 2 }); Text('¥35.00').fontSize(20).fontWeight(FontWeight.Bold).fontColor('#FF4444').margin({ left: 4 }) }
        Text('含预约费 ¥5.00').fontSize(10).fontColor('#999999')
      }.alignItems(HorizontalAlign.Start)
      Blank()
      Button('立即预约').type(ButtonType.Capsule).backgroundColor('#0A59F7').width(140).height(44).fontSize(16).fontWeight(FontWeight.Bold)
        .onClick(() => this.handleBookAppointment())
    }.width('100%').height(80).backgroundColor(Color.White).padding({ left: 20, right: 20 }).shadow({ radius: 10, color: 'rgba(0,0,0,0.1)', offsetY: -2 }).alignItems(VerticalAlign.Center)
  }
}