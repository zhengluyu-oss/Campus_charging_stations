import axios, { AxiosError, AxiosInstance, AxiosResponse, FormData, InternalAxiosRequestConfig} from '@ohos/axios'
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

//网络请求返回统一的数据格式约束（根据实际情况修改）
export interface JsonResult<T> {
  //业务状态码，0表示成功，-1 表示未登录  正整数表示失败
  state: number
  //错误消息
  message: string
  //查询的数据
  data: T
}

//处理x-www-form-urlencoded 数据格式
//把对象转换成form-urlencoded 数据格式（k1=v1&k2=v2....）
export class Qs {
  public static stringify(params: object) {
    // 将对象转换为键值对字符串
    let formData = Object.keys(params).map(key => {
      const parts: string[] = [];
      if (Array.isArray(params[key])) {
        const arrayValue: Array<string> = params[key] as Array<string>
        arrayValue.forEach((item: string) => {
          parts.push(`${key}=${encodeURIComponent(item)}`)
        })
      } else {
        parts.push(`${key}=${encodeURIComponent(params[key])}`)
      }
      return parts.join('&');
    }).join("&")
    return formData
  }
}


//导出配置请求后端api的ip+端口
export const serverIpAndPort: string = 'http://192.168.120.135:8080'

/**
 * HTTP请求工具类
 */
export class HttpUtil {
  private static instance: HttpUtil;
  private axiosInstance: AxiosInstance;
  //请求的基本地址：ip+端口 （根据实际情况修改）
  private baseURL: string = `${serverIpAndPort}`
  //请求过期时间（根据实际情况修改）
  private timeout: number = 10000

  // 获取认证令牌（根据实际场景修改）
  private getAuthToken(): string | undefined {
    // 实际应用中可能从Storage或全局状态中获取
    const token: string | undefined = AppStorage.get<string>('token')
    return token;
  }

  /**
   * 导航到登录页面（根据实际场景修改登录页面路径）
   */
  private navigateToLogin(): void {
    //跳转到登录页面 不能退回（replaceUrl）
    router.replaceUrl({
      url: 'LoginPage'
    });
  }

  /**
   * 显示提示框（如果不喜欢，可以可以修改）
   */
  public  showToast(message: string): void {
    promptAction.showToast({
      message,
      duration: 2000
    });
  }

  // 私有构造函数
  private constructor() {
    // 创建Axios实例
    this.axiosInstance = axios.create({
      baseURL: this.baseURL,
      timeout: this.timeout,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
      }
    });

    // 添加请求拦截器
    this.axiosInstance.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        // 在发送请求之前做些什么
        console.info('请求拦截器执行');
        console.log(`data:   ${JSON.stringify(config.data)}`)
        console.log(`params:   ${JSON.stringify(config.params)}`)
        console.log(`url:   ${config.url}`)
        console.log(`headers['Content-Type']:  ${config.headers['Content-Type']}`)
        // 添加认证信息token
        config.headers['token'] = this.getAuthToken();
        console.log(`headers['token']:  ${config.headers['token']}`)
        return config;
      },
      (error: AxiosError) => {
        // 处理请求错误
        console.error('请求错误:', error.message);
        this.showToast(error.message || "请求错误");
        return Promise.reject(error);
      }
    );

    // 添加响应拦截器
    this.axiosInstance.interceptors.response.use(
      (response: AxiosResponse) => {
        // 处理响应数据
        console.info('响应拦截器执行');
        //response断言为AxiosResponse<JsonResult<object>> 类型
        const res: JsonResult<object> = (response as AxiosResponse<JsonResult<object>>).data;
        console.log(`resopnse:   ${JSON.stringify(res)}`)
        if (res.state > 0) { //业务错误
          console.log(res.message)
          this.showToast(res.message || "系统出错")
          return Promise.reject(res.message);
        } else if (res.state === -1) { // 未登录或者登录过期
          this.showToast('登录已经过期，请重新登录');
          //跳转登录页
          this.navigateToLogin();
          return Promise.reject(res.message);
        } else {
          //成功 正确数据
          return response.data;
        }
      },
      (error: AxiosError) => {
        // 处理响应错误
        console.error('响应错误:', error.message);

        // 处理常见错误类型
        if (error.response) {
          // 已收到响应，但状态码超出2xx范围
          const status = error.response.status;
          switch (status) {
            case 401:
              console.error('认证失败，请重新登录');
              break;
            case 403:
              console.error('权限不足，无法访问');
              break;
            case 404:
              console.error('请求资源不存在');
              break;
            case 500:
              console.error('服务器内部错误');
              break;
          }
        } else if (error.request) {
          // 已发送请求，但没有收到响应
          console.error('网络请求超时或无响应');
        } else {
          // 其他错误
          console.error('请求错误:', error.message);
        }
        this.showToast(error.message || "网络错误");
        return Promise.reject(error);
      }
    );
  }

  // 获取单例实例
  public static getInstance(): HttpUtil {
    if (!HttpUtil.instance) {
      HttpUtil.instance = new HttpUtil();
    }
    return HttpUtil.instance;
  }

  // 封装GET请求
  //R 表示 返回值数据约束   D表示请求数据参数类型约束
  public get<R, D>(url: string, params?: D): Promise<R> {
    return this.axiosInstance.get(this.baseURL + url, {
      params,
      paramsSerializer: {
        serialize: (params: Record<string, D>): string => {
          return Qs.stringify(params as object)
        }
      }
    }) as Promise<R>;
  }

  // 封装POST请求
  //如果是请求json数据格式 config对象是 {headers:new AxiosHeaders().set("Content-Type",'application/json;charset=utf-8;')}
  public post<R, D>(url: string, data?: D, config?: InternalAxiosRequestConfig): Promise<R> {
    if (data) { //data数据不为undefined、null等
      if (config && config.headers['Content-Type']) {
        if ((config.headers['Content-Type'] as string).indexOf('multipart/form-data') > -1) { //上传文件
          const formData: FormData = new FormData()
          Object.keys(data).forEach((key) => {
            formData.append(key, (data as object)[key])
          })
          return this.axiosInstance.post(this.baseURL + url, formData, config) as Promise<R>;
        } else if ((config.headers['Content-Type'] as string).indexOf('application/json') > -1) { //数据格式是json
          return this.axiosInstance.post(this.baseURL + url, data, config) as Promise<R>;
        } else { //其他情况数据格式为 x-www-form-urlencoded 数据格式处理
          return this.axiosInstance.post(this.baseURL + url, Qs.stringify(data as object), config) as Promise<R>;
        }
      } else { //不存在时，按照 x-www-form-urlencoded 数据格式处理
        return this.axiosInstance.post(this.baseURL + url, Qs.stringify(data as object), config) as Promise<R>;
      }
    } else { //data数据为undefined、null等
      return this.axiosInstance.post(this.baseURL + url, data, config) as Promise<R>;
    }
  }

  // 封装PUT请求
  // public put<R, D>(url: string, data?: D): Promise<R> {
  //   return this.axiosInstance.put(url, data) as Promise<R>;
  // }

  // 封装DELETE请求
  // public delete<R, D>(url: string, params?: D): Promise<R> {
  //   return this.axiosInstance.delete(url, { params }) as Promise<R>;
  // }
}

// 导出单例实例
export const httpRequest = HttpUtil.getInstance();