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
  static readonly IMAGES: Resource[] = [$r(('app.media.realImageGen_food_1')), $r(('app.media.realImageGen_food_14'))];
  static readonly MAIN_TEXT: string[] = ['星巴克拿铁咖啡券', '肯德基早餐套餐券'];
  static readonly SUB_TEXT: string[] = ['面值50元', '面值30元'];
  static readonly DESCRIPTION_TEXT: string[] =
    ['有效期至2024年12月31日，仅限门店使用', '有效期至2024年10月31日，仅限早餐时段使用'];
  static readonly TAG_TEXTS_LIST: string[][] = [['热销', '限时'], ['新品', '限量']];
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
  getResources(): Promise<void> {
    /**
     * use your web request here
     */
    return new Promise((resolve: Function) => {
      const modelList: Array<DataSource> = [];
      for (let index = 0; index < Data.IMAGES.length;
        index++) {
        modelList.push(new DataSource(
          Data.IMAGES[index],
          Data.MAIN_TEXT[index],
          Data.SUB_TEXT[index],
          Data.DESCRIPTION_TEXT[index],
          Data.TAG_TEXTS_LIST[index],
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