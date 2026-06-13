/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import { CommonConstants } from "../common/CommonConstants";

interface OrderItem {
  id: string;
  title: string;
  orderTime: string;
  price: string;
  status: string;
  function1Text: string;
  function2Text: string;
}

@Component
export struct OrderListModule {
  @Link currentTabIndex: number;
  @State allOrders: OrderItem[] = [
    {
      id: '1',
      title: '南山科技园充电站',
      orderTime: '2023-10-25 14:30',
      price: '25.60',
      status: '进行中',
      function1Text: '结束充电',
      function2Text: ''
    },
    {
      id: '2',
      title: '福田中心区充电站',
      orderTime: '2023-10-24 10:15',
      price: '18.90',
      status: '已完成',
      function1Text: '查看详情',
      function2Text: '再次充电'
    },
    {
      id: '3',
      title: '宝安机场充电站',
      orderTime: '2023-10-23 16:45',
      price: '32.10',
      status: '已取消',
      function1Text: '重新预约',
      function2Text: ''
    },
    {
      id: '4',
      title: '龙华商业中心充电站',
      orderTime: '2023-10-22 09:20',
      price: '15.80',
      status: '进行中',
      function1Text: '结束充电',
      function2Text: ''
    },
    {
      id: '5',
      title: '罗湖火车站充电站',
      orderTime: '2023-10-21 13:10',
      price: '28.50',
      status: '已完成',
      function1Text: '查看详情',
      function2Text: '再次充电'
    }
  ];
  @Consume('appPathStack') appPathStack: NavPathStack;

  jump(pageName: string = 'EmptyPagePathStack'): void {
    this.appPathStack.pushPathByName(pageName, null);
  }

  // 根据当前标签索引过滤订单
  filterOrdersByStatus(): OrderItem[] {
    const statusMap = ['全部', '进行中', '已完成', '已取消'];
    const currentStatus = statusMap[this.currentTabIndex];
    if (currentStatus === '全部') {
      return this.allOrders;
    }
    return this.allOrders.filter(order => order.status === currentStatus);
  }

  build() {
    Column() {
      ForEach(this.filterOrdersByStatus(), (item: OrderItem) => {
        Stack({ alignContent: Alignment.TopEnd }) {
          Column() {
            Column() {
              Text(item.title)
                .fontColor($r('app.color.font_primary'))
                .fontSize($r('app.integer.subtitle_text_M'))
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 4 })
            }
            .alignItems(HorizontalAlign.Start)
            .width(CommonConstants.FULL_PERCENT)

            Row() {
              Text(item.orderTime)
                .fontColor($r('app.color.font_tertiary'))
                .fontSize($r('app.integer.body_text_S'))
                .fontWeight('Regular')
              Row() {
                Text('¥')
                  .fontColor($r('app.color.font_primary'))
                  .fontSize($r('app.integer.body_text_S'))
                  .fontWeight('Regular')
                  .alignSelf(ItemAlign.End)
                  .margin({ bottom: 2 })
                Text(item.price)
                  .fontColor($r('app.color.font_primary'))
                  .fontSize($r('app.integer.subtitle_text_L'))
                  .fontWeight(FontWeight.Bold)
              }
            }
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ bottom: 16 })

            Row() {
              Blank()
              Button(item.function1Text)
                .height(32)
                .borderRadius($r('sys.float.corner_radius_level4'))
                .controlSize(ControlSize.SMALL)
                .fontColor($r('sys.color.font_primary'))
                .backgroundColor(Color.Transparent)
                .border({ width: 1, color: $r('app.color.comp_background_secondary'), style: BorderStyle.Solid })
                .margin({ right: 12 })
                .padding({ left: 12, right: 12 })
                .onClick(() => {
                  this.jump()
                })
              if (item.function2Text !== '') {
                Button(item.function2Text)
                  .height(32)
                  .borderRadius($r('sys.float.corner_radius_level4'))
                  .controlSize(ControlSize.SMALL)
                  .fontColor($r('sys.color.font_primary'))
                  .backgroundColor(Color.Transparent)
                  .border({ width: 1, color: $r('app.color.comp_background_secondary'), style: BorderStyle.Solid })
                  .padding({ left: 12, right: 12 })
                  .onClick(() => {
                    this.jump()
                  })
              }
            }
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.End)
          }
          .width('100%')
          .padding({
            top: 16,
            bottom: 16,
            left: 16,
            right: 16
          })

          Text(item.status)
            .fontColor($r('app.color.font_emphasize'))
            .fontSize($r('app.integer.body_text_S'))
            .fontWeight('Regular')
            .backgroundColor($r('app.color.comp_emphasize_secondary'))
            .borderRadius({
              topRight: $r('sys.float.corner_radius_level8'),
              bottomLeft: $r('sys.float.corner_radius_level8')
            })
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4
            })
            .margin({ top: 0, right: 0 })
        }
        .width('92%')
        .backgroundColor($r('app.color.background_primary_SimpleOrderInformationDisplayModule'))
        .borderRadius($r('sys.float.corner_radius_level8'))
        .margin({ bottom: 8 })
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }
}