import { AxiosHeaders, InternalAxiosRequestConfig } from "@ohos/axios";
import { LoginParam } from "../params/request/UserParam";
import { httpRequest, JsonResult } from "../utils/HttpUtil";
import { User } from "../viewmodel/UserModel";
//登录
export function login(loginParam:LoginParam){
  //请求url地址
  const url:string='/login'
  //发起post的异步网络请求（异步：不阻塞代码，继续执行后面的代码），当请求后获取响应的数据（数据回来了），
  // 继续处理数据（另起一个线程），所以不会影响主线程，这个过程使用Promise对象来操作
  return httpRequest.post<JsonResult<User>,LoginParam>(url,loginParam)
}

//注册
export function register(user:User){
  const url:string='/register'
  const config:InternalAxiosRequestConfig ={headers:new AxiosHeaders().set("Content-Type",'application/json;charset=utf-8;')}
  //请求是json数据格式
  return httpRequest.post<JsonResult<null>,User>(url,user,config)
}

//根据用户id查询（get请求，无参）
export function findById(id:number){
 const url:string=`/user/${id}`
  return httpRequest.get<JsonResult<User>,null>(url,null)
}

//根据用户id查询（get请求，有参数）
export function findById2(id:number){
  const url:string='/user/find-by-id'
  //组装get请求的参数对象
  const param:Record<string,number>={'id':id}
  return httpRequest.get<JsonResult<User>,Record<string,number>>(url,param)
}