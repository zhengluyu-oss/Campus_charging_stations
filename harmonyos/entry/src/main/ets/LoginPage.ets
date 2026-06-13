import { AxiosError } from '@ohos/axios';
import { login } from './apis/UserApi';
import { LoginParam } from './params/request/UserParam';
import { JsonResult } from './utils/HttpUtil';
import { User } from './viewmodel/UserModel';
import { thirdPaymentService } from '@kit.PaymentKit';

@Entry
@Component
struct LoginPage {
  @State message: string = 'Hello World';
  @State
  username:string='学生1'
  @State
  password:string='123456'
  @State
  buttonText:string='登录'
  @State
  isButttonEnable:boolean=true

  //定义异步函数
  //async用在函数上，这个函数执行是异步的（不阻塞代码）
  async processLogin(param:LoginParam){
    //同步操作
    //地狱回调
    //await表示等待 就会形成同步执行，注意：await必须用在async定义的函数内
    // await promise1()
    // await promise2()
    // await promise2()
    //可以使用try catch捕获异常
    try{
      //await promise() 返回的结果是 then() 中回调函数参数值对象，也就是response为200的data数据
      const res:JsonResult<User>= await login(param)
      console.log(`res=${JSON.stringify(res)}`);
      //把token全局存储
      const token:string=res.message
      AppStorage.setOrCreate("token",token)
      //用户对象素具全局存储
      const user:User=res.data
      AppStorage.setOrCreate("user",user)
      //跳转首页
      this.getUIContext().getRouter().replaceUrl({url:'Index'})

      this.buttonText='登录'
      this.isButttonEnable=true
    }catch (error){
      console.log(`error=${JSON.stringify(error)}`);
      //异常错误 处理
      this.buttonText='登录'
      this.isButttonEnable=true
    }
  }
  //登录按钮click事件的回调函数(处理登录逻辑)
  handleLogin=()=>{
    console.log("登录按钮被点击了...")
    this.buttonText='登录中...'
    this.isButttonEnable=false

    console.log(`username=${this.username}`);
    console.log(`password=${this.password}`);

    //登录参数对象（后期所有的请求参数 全部是对象）
    const param:LoginParam={
      username:this.username,
      password:this.password
    }
    /**
    //调用login登录函数，
    // 所有写的请求返回值都是Promise<T> 类型对象
    const promise:Promise<JsonResult<User>>=login(param)

    //有2种方式处理promise对象
    //1、promise.then((响应的结果对象)=>{处理http正常响应}.catch((error)=>{处理异常错误}))
    promise.then((res:JsonResult<User>)=>{
      //打印下结果
      console.log(`res=${JSON.stringify(res)}`);
      this.buttonText='登录'
      this.isButttonEnable=true
      //把token全局存储
      const token:string=res.message
      AppStorage.setOrCreate("token",token)
      //用户对象素具全局存储
      const user:User=res.data
      AppStorage.setOrCreate("user",user)
      //跳转首页
      this.getUIContext().getRouter().replaceUrl({url:'pages/Index'})
    }).catch((error:AxiosError)=>{
      console.log(`error=${JSON.stringify(error)}`);
      this.buttonText='登录'
      this.isButttonEnable=true
    });
    // promise.then((res:JsonResult<User>)=>{
    //   //打印下结果
    //   console.log(`res=${JSON.stringify(res)}`);
    //   this.buttonText='登录'
    //   this.isButttonEnable=true
    // }).catch(()=>{
    //   //不处理错误，吞掉错误
    //   this.buttonText='登录'
    //   this.isButttonEnable=true
    // });
      */
    //2、方式二
    this.processLogin(param)

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

      Button(`${this.buttonText}`)
        .onClick(()=>{
            this.handleLogin()
        })
        .enabled(this.isButttonEnable)

      Text('跳转注册')
        .onClick(()=>{
          this.getUIContext().getRouter().pushUrl({url:"RegisterPage"})
        })

    }
    .height('100%')
    .width('100%')
  }
}