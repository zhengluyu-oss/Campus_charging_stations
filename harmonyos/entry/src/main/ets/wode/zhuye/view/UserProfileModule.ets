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

@Component
export struct UserProfileModule {
  @State userName: string = "我的";
  @State description: string = "黄金会员";
  @State userIcon: Resource = $rawfile("wode/user_photo.svg");
  @State points: string = "1280";
  @State pointsName: string = "积分";
  @Consume('appPathStack') appPathStack: NavPathStack;

  jump(pageName: string = 'EmptyPagePathStack'): void {
    this.appPathStack.pushPathByName(pageName, null);
  }

  build() {
    Row() {
      /**
       * TODO:
       * please modify it according to the actual situation.
       * modify {@link AccountPointsDisplayModule#userIcon}
       */
      Image(this.userIcon)
        .height("60vp")
        .width("60vp")
        .borderRadius(30)
        .margin({ left: "24vp" })
        .onClick(()=>{
          this.getUIContext().getRouter().pushUrl({url:"wode/ziliao/Index"})
        })
      Column() {
        /**
         * TODO:
         * please modify it according to the actual situation.
         * modify {@link AccountPointsDisplayModule#userName}
         */
        Text(this.userName)
          .font({ size: $r('app.integer.title_text_L'), weight: FontWeight.Bold })
          .fontColor($r('app.color.font_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .onClick(()=>{
            this.getUIContext().getRouter().pushUrl({url:"wode/ziliao/Index"})
          })
        /**
         * TODO:
         * please modify it according to the actual situation.
         * modify {@link AccountPointsDisplayModule#userId}
         */
        Text(this.description)
          .font({ size: $r('app.integer.body_text_M'), weight: FontWeight.Medium })
          .fontColor($r('app.color.font_emphasize'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .margin({ top: "4vp" })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .margin({ left: "16vp" })
      .height(CommonConstants.FULL_PERCENT)
      .layoutWeight(1)

      Row() {
        Column() {
          Text(this.points)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_emphasize'))
          Text(this.pointsName)
            .fontSize($r('sys.float.Body_S'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.font_secondary'))
        }
        .alignItems(HorizontalAlign.End)

        // Image($r('sys.media.ohos_ic_public_arrow_right'))
        Image($rawfile("wode/ic_public_arrow_right.svg"))
          .height(16)
          .width(16)
          .margin({ left: "8vp" })
      }.alignItems(VerticalAlign.Center)
      .margin({ right: "24vp" })
    }
    .onClick(() => {
      this.jump()
    })
    .height("100vp")
    .width('92%')
    .justifyContent(FlexAlign.Start)
    .borderRadius($r('sys.float.corner_radius_level12'))
    .backgroundColor($r('app.color.comp_background_primary'))
    .margin({ top: "16vp", bottom: "16vp" })
    .padding({ top: "12vp", bottom: "12vp" })
  }
}