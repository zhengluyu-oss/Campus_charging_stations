import { router } from '@kit.ArkUI';

@Component
export  struct Shangcheng_entry {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Button('点击进入商城')
        .fontSize(50)
        .fontColor(Color.Red)
        .onClick(() => {
         router.push({
           url:"goods-shop/shangcheng"
         })
        })
    }
    .height('100%')
    .width('100%')
  }
}