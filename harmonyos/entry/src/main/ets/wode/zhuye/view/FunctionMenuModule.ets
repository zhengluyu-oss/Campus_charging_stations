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
import {
  DataSource, Data
} from '../viewmodel/FunctionMenuModuleData';
import { LoadingStatus } from '../common/CommonEnums';
import { LoadingFailedView } from '../view/LoadingFailedView';
import { BreakpointConstants } from '../common/BreakpointConstants';
import { BreakpointType } from '../util/BreakpointType';
import LazyDataSource from '../util/LazyDataSource';
import { CommonConstants } from '../common/CommonConstants';

@Component
export struct FunctionMenuModule {
  @State itemModel: Data =
    Data.getInstance();
  @Prop listDirection: Axis = Axis.Vertical
  @State moduleTitle: string = "我的功能菜单";
  @State moduleRedirectContent: string = "查看更多";
  @State loadingStatus: LoadingStatus = LoadingStatus.OFF;
  @State lazyDataSource: LazyDataSource<DataSource> =
    this.itemModel.lazyDataSource;
  private spaceArray: string[] = ['12vp', '20vp', '24vp'];
  private lanesArray: number[] = [1, 3, 4];
  @Consume('appPathStack') appPathStack: NavPathStack;
  @StorageLink('currentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  jump(pageName: string = 'EmptyPagePathStack'): void {
    this.appPathStack.pushPathByName(pageName, null);
  }

  aboutToAppear() {
    this.loadResources();
  }

  loadResources(): void {
    this.loadingStatus = LoadingStatus.LOADING;
    this.itemModel.getResources().then(() => {
      this.loadingStatus = LoadingStatus.SUCCESS;
    }).catch(() => {
      this.loadingStatus = LoadingStatus.FAILED;
    });
  }

  build() {
    Column() {
      Column() {
        FunctionMenuModuleTitleInfo({
          title: this.moduleTitle,
          moduleRedirectContent: this.moduleRedirectContent,
          onJump: () => {
            this.jump()
          }
        })
        if (this.loadingStatus === LoadingStatus.FAILED) {
          LoadingFailedView(() => this.loadResources())
        }
        if (this.loadingStatus === LoadingStatus.SUCCESS) {
          // 使用Flex布局来单独排列功能组件，而不是使用LazyForEach
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Stretch }) {
            // 第一行：订单、钱包、优惠券
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
              // 订单组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_44.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('订单')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('查看订单')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.getUIContext().getRouter().pushUrl({url:"wode/dingdan/Index"}) // 跳转到订单页面
                })
              }
              .width("30%")

              // 钱包组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_202.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('我的钱包')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('前往充值')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.jump("WalletPage") // 跳转到钱包页面
                })
              }
              .width("30%")

              // 优惠券组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_216.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('优惠券')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('领取优惠')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.getUIContext().getRouter().pushUrl({url:"wode/youhuiquan/Index"}) // 跳转到优惠券页面
                })
              }
              .width("30%")
            }
            .height("75vp") // 降低行高
            .width('100%')
            .margin({ bottom: "10vp" }) // 减少底部间距

            // 第二行：客服中心、充电桩保修、申请建桩
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
              // 客服中心组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_82.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('客服中心')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('联系客服')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.jump("CustomerServicePage") // 跳转到客服中心页面
                })
              }
              .width("30%")

              // 充电桩保修组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_176.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('充电桩保修')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('申请保修')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.getUIContext().getRouter().pushUrl({url:"wode/baoxiu/Index"})// 跳转到保修页面
                })
              }
              .width("30%")

              // 申请建桩组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_1.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('申请建桩')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('申请建桩')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.getUIContext().getRouter().pushUrl({url:"wode/jianzhuang/Index"})// 跳转到申请建桩页面
                })
              }
              .width("30%")
            }
            .height("75vp") // 降低行高
            .width('100%')
            .margin({ bottom: "10vp" }) // 减少底部间距

            // 第三行：充电账单、预约充电、设置
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
              // 充电账单组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_8.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('充电账单')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('查看账单')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.getUIContext().getRouter().pushUrl({url:"wode/zhangdan/Index"}) // 跳转到账单页面
                })
              }
              .width("30%")

              // 预约充电组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_30.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('预约充电')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('预约充电')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.getUIContext().getRouter().pushUrl({url:"wode/yuyue/AppointmentPage"})
                })
              }
              .width("30%")

              // 设置组件
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Row() {
                  Image($rawfile("wode/lib_icon_3.svg"))
                    .height("24vp")
                    .width("24vp")
                    .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角

                  Column() {
                    Text('设置')
                      .fontColor($r('app.color.font_primary'))
                      .fontSize($r('app.integer.body_text_S'))
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text('进入设置')
                      .fontColor($r('app.color.font_secondary'))
                      // .fontSize($r('app.integer.body_text_XS'))
                      .fontWeight(FontWeight.Regular)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .margin({ left: "6vp" })

                  Image($rawfile("wode/ic_public_arrow_right.svg"))
                    .width("10vp")
                    .height("10vp")
                    .fillColor($r('app.color.comp_background_neutral'))
                    .opacity(0.6)
                    .margin({ left: "auto" })
                }
                .height("60vp") // 降低高度
                .width("100%")
                .padding({ left: "10vp", right: "10vp", top: "8vp", bottom: "8vp" }) // 减少内边距
                .borderRadius($r('sys.float.corner_radius_level4')) // 减小圆角
                .backgroundColor($r('app.color.comp_background_primary'))
                .onClick(() => {
                  this.jump("SettingPage") // 跳转到设置页面
                })
              }
              .width("30%")
            }
            .height("75vp") // 降低行高
            .width('100%')
            .margin({ bottom: "10vp" }) // 减少底部间距
          }
          .width('100%')
          .height('auto')
        }
      }
      .width('92%')
      .margin({ bottom: "14vp" }) // 增加底部间距
      .backgroundColor(Color.Transparent)
    }
    .width(CommonConstants.FULL_PERCENT)
  }
}

@Component
export struct FunctionMenuModuleTitleInfo {
  @StorageLink('currentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  public title: string = '';
  public moduleRedirectContent: string = "查看更多";
  @Consume('appPathStack') appPathStack: NavPathStack;
  public onJump?: () => void;

  jump(): void {
    this.appPathStack.pushPathByName('EmptyPagePathStack', null);
  }

  build() {
    if (this.title.length) {
      Row() {
        Text(this.title)
          .fontSize($r('app.integer.subtitle_text_L'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_primary'))
        Text(this.moduleRedirectContent)
          .fontColor($r('app.color.font_secondary'))
          .fontSize($r('app.integer.body_text_S'))
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            if (this.onJump) {
              this.onJump()
            } else {
              this.jump()
            }
          })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height("44vp")
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius($r('sys.float.corner_radius_level4')) // 减小标题区域圆角
    }
  }
}