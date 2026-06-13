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
import LazyDataSource from '../util/LazyDataSource';

export class Data {
  private static instance: Data;
  lazyDataSource: LazyDataSource<DataSource> = new LazyDataSource();
  // 未使用状态下的不可用优惠券（已过期和已使用的）
  static readonly UNUSED_IMAGES: Resource[] =
    [
      $rawfile("wode/realImageGen_shop_1.png"),
      $rawfile("wode/realImageGen_shop_2.png")];
  static readonly UNUSED_MAIN_TEXT: string[] = ['充电桩优惠券', '充电桩优惠券'];
  static readonly UNUSED_SUB_TEXT: string[] = ['已过期', '已使用'];
  static readonly UNUSED_DESCRIPTION_TEXT: string[] = ['优惠券已过期，无法使用', '优惠券已使用，无法再次使用'];
  static readonly UNUSED_TAG_TEXTS_LIST: string[][] = [['满50减10', '2023-12-31过期'], ['满30减5', '2023-11-15过期']];
  // 已使用状态下的不可用优惠券（已过期和未使用的）
  static readonly USED_IMAGES: Resource[] = [$rawfile("wode/realImageGen_travel_0.png")];
  static readonly USED_MAIN_TEXT: string[] = ['旅游优惠券'];
  static readonly USED_SUB_TEXT: string[] = ['已过期'];
  static readonly USED_DESCRIPTION_TEXT: string[] = ['优惠券已过期，无法使用'];
  static readonly USED_TAG_TEXTS_LIST: string[][] = [['满100减20', '2023-10-31过期']];
  // 已过期状态下的不可用优惠券（已使用和未使用的）
  static readonly EXPIRED_IMAGES: Resource[] = [$rawfile("wode/lib_icon_218.svg")];
  static readonly EXPIRED_MAIN_TEXT: string[] = ['酒店优惠券'];
  static readonly EXPIRED_SUB_TEXT: string[] = ['已使用'];
  static readonly EXPIRED_DESCRIPTION_TEXT: string[] = ['优惠券已使用，无法再次使用'];
  static readonly EXPIRED_TAG_TEXTS_LIST: string[][] = [['满150减30', '2023-09-30过期']];
  static readonly TAG_TEXT_COLORS_LIST: Color[][] =
    [[Color.Brown, Color.Green, Color.Gray], [Color.Brown, Color.Green, Color.Gray],
      [Color.Brown, Color.Green, Color.Gray], [Color.Brown, Color.Green, Color.Gray],
      [Color.Brown, Color.Green, Color.Gray], [Color.Brown, Color.Green, Color.Gray]];

  constructor() {
  }

  public static getInstance(): Data {
    if (!Data.instance) {
      Data.instance =
        new Data();
    }
    return Data.instance;
  }

  /**
   * Data loaded on current view converts network data into rendering data
   */
  getResources(status: number = 0): Promise<void> {
    /**
     * use your web request here
     */
    return new Promise((resolve: Function) => {
      const modelList: Array<DataSource> = [];
      let images: Resource[] = [];
      let mainTexts: string[] = [];
      let subTexts: string[] = [];
      let descriptionTexts: string[] = [];
      let tagTextsList: string[][] = [];
      // 根据状态选择不同的数据
      switch (status) {
        case 0: // 未使用状态，显示已过期和已使用的优惠券
          images = Data.UNUSED_IMAGES;
          mainTexts = Data.UNUSED_MAIN_TEXT;
          subTexts = Data.UNUSED_SUB_TEXT;
          descriptionTexts = Data.UNUSED_DESCRIPTION_TEXT;
          tagTextsList = Data.UNUSED_TAG_TEXTS_LIST;
          break;
        case 1: // 已使用状态，显示已过期和未使用的优惠券
          images = Data.USED_IMAGES;
          mainTexts = Data.USED_MAIN_TEXT;
          subTexts = Data.USED_SUB_TEXT;
          descriptionTexts = Data.USED_DESCRIPTION_TEXT;
          tagTextsList = Data.USED_TAG_TEXTS_LIST;
          break;
        case 2: // 已过期状态，显示已使用和未使用的优惠券
          images = Data.EXPIRED_IMAGES;
          mainTexts = Data.EXPIRED_MAIN_TEXT;
          subTexts = Data.EXPIRED_SUB_TEXT;
          descriptionTexts = Data.EXPIRED_DESCRIPTION_TEXT;
          tagTextsList = Data.EXPIRED_TAG_TEXTS_LIST;
          break;
        default:
          images = Data.UNUSED_IMAGES;
          mainTexts = Data.UNUSED_MAIN_TEXT;
          subTexts = Data.UNUSED_SUB_TEXT;
          descriptionTexts = Data.UNUSED_DESCRIPTION_TEXT;
          tagTextsList = Data.UNUSED_TAG_TEXTS_LIST;
      }
      for (let index = 0; index < images.length; index++) {
        modelList.push(new DataSource(
          images[index],
          mainTexts[index],
          subTexts[index],
          descriptionTexts[index],
          tagTextsList[index],
          Data.TAG_TEXT_COLORS_LIST[index]));
      }
      this.lazyDataSource.pushArrayData(modelList);
      resolve();
    });
  }
}

export class DataSource {
  private image: Resource;
  private mainText: string;
  private subText: string;
  private descriptionText: string;
  private tagTextList: string[];
  private tagTextColorList: Color[];

  constructor(image: Resource, mainText: string, subText: string,
    descriptionText: string, tagTextList: string[], tagTextColorList: Color[]) {
    this.image = image;
    this.mainText = mainText;
    this.subText = subText;
    this.descriptionText = descriptionText;
    this.tagTextList = tagTextList;
    this.tagTextColorList = tagTextColorList;
  }

  getImage(): Resource {
    return this.image;
  }

  getMainText(): string {
    return this.mainText;
  }

  getSubText(): string {
    return this.subText;
  }

  getDescriptionText(): string {
    return this.descriptionText;
  }

  getTagTextList(): string[] {
    return this.tagTextList;
  }

  getTagTextColorList(): Color[] {
    return this.tagTextColorList;
  }
}