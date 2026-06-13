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

export class DataSource {
  private static instance: DataSource;
  lazyDataSource: LazyDataSource<DataSourceStyleAStyleA> = new LazyDataSource();
  static readonly IMAGES: Resource[] =
    [
      $rawfile("wode/background.png"),
      $rawfile("wode/background.png"),
     $rawfile("wode/background.png")];
  static readonly TITLES: string[] = ['开具发票', '导出账单', '联系客服'];
  static readonly CONTENTS: string[] = ['申请电子或纸质发票', '下载账单明细文件', '获取在线帮助支持'];
  static readonly PAGES: string[] = ['EmptyPagePathStack', 'EmptyPagePathStack', 'EmptyPagePathStack'];

  constructor() {
  }

  public static getInstance(): DataSource {
    if (!DataSource.instance) {
      DataSource.instance =
        new DataSource();
    }
    return DataSource.instance;
  }

  /**
   * Data loaded on current view converts network data into rendering data
   */
  getResources(): Promise<void> {
    /**
     * use your web request here
     */
    return new Promise((resolve: Function) => {
      const modelList: Array<DataSourceStyleAStyleA> = [];
      for (let index = 0; index < DataSource.IMAGES.length;
        index++) {
        modelList.push(new DataSourceStyleAStyleA(
          DataSource.IMAGES[index],
          DataSource.TITLES[index],
          DataSource.CONTENTS[index],
          DataSource.PAGES[index])
        );
      }
      this.lazyDataSource.pushArrayData(modelList);
      resolve();
    });
  }
}

export class DataSourceStyleAStyleA {
  private image: Resource;
  private title: string;
  private content: string;
  private page: string;

  constructor(image: Resource, title: string, content: string, page: string) {
    this.image = image;
    this.title = title;
    this.content = content;
    this.page = page;
  }

  getImage(): Resource {
    return this.image;
  }

  getTitle(): string {
    return this.title;
  }

  getContent(): string {
    return this.content;
  }

  getPage(): string {
    return this.page;
  }
}