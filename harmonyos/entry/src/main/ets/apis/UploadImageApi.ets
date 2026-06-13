import { AxiosHeaders, InternalAxiosRequestConfig } from '@ohos/axios';
import { httpRequest, JsonResult } from '../utils/HttpUtil';


//上传图片
export function uploadImage(uri: string) :Promise<JsonResult<string>>{
  //请求的数据格式上传文件
  const config: InternalAxiosRequestConfig = {
    headers: new AxiosHeaders().set("Content-Type", 'multipart/form-data')
  }
  const url: string = '/upload/image'
  const data: Record<string, string> = { "image": uri }
  return httpRequest.post<JsonResult<string>, Record<string, string>>(url, data, config)
}