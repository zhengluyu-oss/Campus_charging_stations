import axios from 'axios'
import {ElMessageBox, ElMessage} from 'element-plus'
import qs from 'qs'
import {useUserStore} from '../stores/user'

//网络请求返回统一的数据格式约束（根据实际情况修改）
export interface JsonResult<T> {
    //业务状态码，0表示成功，-1 表示未登录  正整数表示失败
    state: number
    //错误消息
    message: string
    //查询的数据
    data: T
}

//跳转登录url路径
const loginUrlPath = "user-login"

//获取令牌token函数
const getAuthToken = (): string => {
    return useUserStore().getToken
}

// axios创建实例对象 axios.create()
const service = axios.create({
    // 设置baseRUL
    //baseURL: process.env.VUE_APP_BASE_API, // url = base url + request url
    // axios不带cookie
    withCredentials: false, // send cookies when cross-domain requests
    //设置header的Content-Type类型，默认为 application/json
    headers: {
        "Content-Type": "application/json;charset=UTF-8",
        // 添加禁用缓存的头部
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0'
    },
    // 主要用于序列化params（params 参数用在get请求上）
    paramsSerializer: params => {
        if (params) {
            //qs.stringify 的{arrayFormat: 'repeat'} 可以对数组转换格式处理成 ids=1&ids=2
            //ids=[11,12,13]  -> ids=11&ids=12&ids=13
            return qs.stringify(params, {arrayFormat: 'repeat'});
        } else {
            return ''
        }
    },
    /* 设置请求超时时间*/
    timeout: 30000, // request timeout
    // `transformRequest` 允许在向服务器发送前，修改请求数据
    // 只能用在 'PUT', 'POST' 和 'PATCH' 这几个请求方法
    transformRequest: (data, headers) => {
        if (headers['Content-Type']) {
            if ((headers['Content-Type'] as string).indexOf('multipart/form-data') > -1) { // 上传文件处理
                headers['Content-Type'] = ""
                const formData = new FormData()
                for (let key in data) {
                    formData.append(key, data[key])
                }
                return formData
            } else if ((headers['Content-Type'] as string).indexOf('application/json') > -1) { // 请求json数据格式处理
                return JSON.stringify(data)
            } else { // 其他都是按照 x-www-form-urlencoded数据格式处理
                //qs.stringify 的{arrayFormat: 'repeat'} 可以对数组转换格式处理成 ids=1&ids=2
                return qs.stringify(data, {arrayFormat: 'repeat'})
            }
        } else { // headers['Content-Type'] 不存在时，默认按照 application/json 数据格式处理
            return JSON.stringify(data)
        }
    }
})

// 配置axios的请求拦截器，作用是让所有axios请求携带token，后台需要token校验是否登录
service.interceptors.request.use(
    config => {
        // 1.从store中获取到token,这里的token时登录时你给用户设置token的键值
        const token = getAuthToken()
        if (token) {
            config.headers['token'] = token
        }

        // 确保请求不被缓存
        Object.assign(config.headers, {
            'Cache-Control': 'no-cache, no-store, must-revalidate',
            'Pragma': 'no-cache',
            'Expires': '0'
        });

        // 2.放行
        return config
    },
    error => {
        ElMessage.error(error.message)
        //此时的promise链停下来了
        return Promise.reject('请求拦截器错误')
    }
)

// axios的response 拦截器
service.interceptors.response.use(
    /**
     * If you want to get http information such as headers or status
     * Please return  response => response
     */

    /**
     * Determine the request status by custom code
     * Here is just an example
     * You can also judge the status by HTTP Status Code
     */
    response => {
        const res = response.data

        // 检查是否是登录请求，登录请求不应触发认证失败逻辑
        const isLoginRequest = response.config.url?.includes('/login');

        // if the custom code is not 20000, it is judged as an error.
        if (res.state > 0) {
            ElMessage.error(res.message || "系统出错");
            return Promise.reject(res.message)
        } else if (res.state === -1 && !isLoginRequest) { // 未登录或者登录过期，但排除登录请求本身
            // to re-login
            ElMessageBox.alert('登录已经过期，请重新登录', '登录过期', {
                confirmButtonText: '重新登录'
            }).then(() => {
                //清除本地存储的用户信息和token
                const userStore = useUserStore();
                userStore.$patch({ // 重置store状态
                  token: '',
                  user: undefined
                }); // 对于setup语法的store，使用$patch替代$reset

                //跳转登录页面
                window.location.href = loginUrlPath;
            }).catch(() => {
                // 用户取消登录，也可以选择重置store
                const userStore = useUserStore();
                userStore.$patch({ token: '', user: undefined });
            });
            return Promise.reject('登录已经过期，请重新登录')
        } else {
            //成功 正确数据
            return res
        }
    },
    error => {
        // 检查是否是网络错误或服务器错误
        if (error.response) {
            // 服务器返回了错误状态码
            if (error.response.status === 401) {
                // Token过期或无效
                ElMessageBox.alert('登录已经过期，请重新登录', '登录过期', {
                    confirmButtonText: '重新登录'
                }).then(() => {
                    //清除本地存储的用户信息和token
                    const userStore = useUserStore();
                    userStore.$patch({ // 重置store状态
                      token: '',
                      user: undefined
                    }); // 对于setup语法的store，使用$patch替代$reset

                    //跳转登录页面
                    window.location.href = loginUrlPath;
                });
            } else {
                ElMessage.error(error.response.data?.message || `请求失败: ${error.response.status}`);
            }
        } else if (error.request) {
            // 请求已发出但没有收到响应
            ElMessage.error('网络连接失败，请检查网络连接');
        } else {
            // 其他错误
            ElMessage.error(`请求错误: ${error.message}`);
        }
        return Promise.reject(error)
    }
)

export default service
