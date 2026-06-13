import { register } from '../ets/apis/UserApi'
import { httpRequest, HttpUtil, JsonResult } from '../ets/utils/HttpUtil'
import { User } from '../ets/viewmodel/UserModel'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { promptAction } from '@kit.ArkUI'
import fs from '@ohos.file.fs';
import { uploadImage } from '../ets/apis/UploadImageApi'


@Entry
@Component
struct RegisterPage {
  @State
  username:string=''
  @State
  password:string=''
  @State
  avatarPath:string='/image/2.png'

  // 图片URI
  // @State selectedImageUri: string = '';
  // 上传状态 (避免上后端多次发送请求)
  @State isUploading: boolean = false;
  //图片选择器实例
  // private photoPicker = new photoAccessHelper.PhotoViewPicker();

  //打开相册，选择图片
  // async selectImage() {
  //   const options: photoAccessHelper.PhotoSelectOptions = {
  //     MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE, // 只选择图片
  //     maxSelectNumber: 1, // 最多选择张数
  //     isSearchSupported: true, // 显示搜索
  //     isPhotoTakingSupported: true, // 支持拍照
  //     // singleSelectionMode: photoAccessHelper.SingleSelectionMode.BROWSER_MODE, //选择模式
  //     isPreviewForSingleSelectionSupported: true, // 单选是否支持预览
  //     isOriginalSupported: false //是否支持选择原图
  //   };
  //
  //   try {
  //     const result = await this.photoPicker.select(options);
  //     if (result?.photoUris?.length > 0) {
  //       this.selectedImageUri = result.photoUris[0];
  //       //调用上传（请求后端api）
  //       await this.handleUpload()
  //     }
  //   } catch (err) {
  //     promptAction.showToast({ message: `选择图片失败: ${err.message}` });
  //   }
  // }
  //请求后端api上传图片
  // async handleUpload() {
  //   this.isUploading = true
  //   try {
  //     //打开原始文件用于拷贝图片资源
  //     const fileSource = fs.openSync(this.selectedImageUri, fs.OpenMode.READ_ONLY);
  //     // 从原始uri中获取文件名
  //     const originalFileName =
  //       this.selectedImageUri.substring(this.selectedImageUri.lastIndexOf('/') + 1) || `image_${Date.now()}.jpg`;
  //     //沙箱缓存图片路径(模拟器不让直接使用原始资源)
  //     const cacheFilePath = `${this.getUIContext().getHostContext()?.cacheDir}/${originalFileName}`;
  //     //打开缓存图片路径 把原始图片读取到沙箱缓存路径中
  //     let fileDes = fs.openSync(cacheFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  //     fs.copyFileSync(fileSource.fd, fileDes.fd);
  //     fs.closeSync(fileSource);
  //     fs.closeSync(fileDes);
  //
  //     //使用沙箱缓存图片路径 上传后端api
  //     const jsonResult: JsonResult<string> = await uploadImage(cacheFilePath);
  //     //获取上传图片后的结果，主要获图片显示的路径
  //     console.log(`jsonResult=${JSON.stringify(jsonResult)}`)
  //     //todo 把图片路径（jsonResult.data） 请求后端api 更新数据库
  //     this.avatarPath=jsonResult.data
  //
  //   } catch (err) {
  //     promptAction.showToast({ message: `读取文件失败: ${err.message}` });
  //     console.error(`File read error: ${JSON.stringify(err)}`);
  //   } finally {
  //     this.isUploading = false;
  //   }
  // }
  handleRegister=()=>{
    const user:User={
      id:0,
      username:this.username,
      password:this.password,
      avatarPath:this.avatarPath,
      updateTime:new Date(),
      createTime:new Date()
    }
    //请求后端
    register(user)
      .then((res:JsonResult<null>)=>{
        //then的回调一定是请求 httpcode是200，JsonResult的state一定是0是业务成功了
        httpRequest.showToast(res.message)
        //注册成功，跳转到登录页面
        this.getUIContext().getRouter().pushUrl({url:'LoginPage'})


      })
      .catch(()=>{

      })

  }
  build() {
    Column() {
      Row(){
        Text("用户名：")
        //双向绑定 $$变量名称
        TextInput({placeholder:"请输入用户名",text:$$this.username})
      }
      Row(){
        Text("密码：")
        //双向绑定
        TextInput({placeholder:"请输入密码",text:$$this.password})
          .type(InputType.Password)
      }
      // Row() {
      //   Text("头像:")
      //   Column() {
      //     Image(this.selectedImageUri)
      //       .objectFit(ImageFit.Contain)
      //       .borderRadius(50)
      //       .height('90%')
      //       .width("80%")
      //       .border({ width: 1, color: Color.Red, style: BorderStyle.Dotted })
      //     Text('选择图片')
      //   }
      // }
      // .height(200)
      // .width('100%')
      // .margin({ bottom: 20 })
      // .onClick(() => this.selectImage())

      Button('注册')
        .onClick(() => {
          this.handleRegister()
      })
    }
    .height('100%')
    .width('100%')
  }
}