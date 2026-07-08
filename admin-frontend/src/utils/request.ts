import axios from 'axios'
import { ElMessage } from 'element-plus'
import qs from 'qs'
import { useAdminStore } from '@/stores/admin'

export interface JsonResult<T> {
  state: number
  message: string
  data: T
}

const loginUrlPath = '/login'
const refreshUrlPath = '/admin/refresh'

const getAuthToken = (): string => {
  return useAdminStore().getToken
}

const service = axios.create({
  baseURL: '/admin-api',
  withCredentials: false,
  headers: {
    'Content-Type': 'application/json;charset=UTF-8',
    'Cache-Control': 'no-cache, no-store, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0',
  },
  paramsSerializer: (params) => {
    if (params) {
      return qs.stringify(params, { arrayFormat: 'repeat' })
    }
    return ''
  },
  timeout: 30000,
  transformRequest: (data, headers) => {
    if (headers['Content-Type']) {
      const ct = headers['Content-Type'] as string
      if (ct.indexOf('multipart/form-data') > -1) {
        headers['Content-Type'] = ''
        const formData = new FormData()
        for (const key in data) {
          formData.append(key, data[key])
        }
        return formData
      } else if (ct.indexOf('application/json') > -1) {
        return JSON.stringify(data)
      } else {
        return qs.stringify(data, { arrayFormat: 'repeat' })
      }
    }
    return JSON.stringify(data)
  },
})

/** 标记是否正在刷新 Token，防止并发刷新 */
let isRefreshing = false
/** 等待刷新结果期间排队的请求 */
let pendingRequests: Array<{
  resolve: (token: string) => void
  reject: (err: Error) => void
}> = []

service.interceptors.request.use(
  (config) => {
    const token = getAuthToken()
    if (token) {
      config.headers['token'] = token
    }
    Object.assign(config.headers, {
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
    })
    return config
  },
  (error) => {
    console.error('Request interceptor error:', error)
    ElMessage.error(error.message)
    return Promise.reject(new Error('Request interceptor error'))
  },
)

service.interceptors.response.use(
  async (response) => {
    const res = response.data
    const isLoginRequest = response.config.url?.includes('/login')
    const isRefreshRequest = response.config.url?.includes('/admin/refresh')

    if (res.state > 0) {
      ElMessage.error(res.message || 'System error')
      return Promise.reject(new Error(res.message))
    } else if (res.state === -1 && !isLoginRequest && !isRefreshRequest) {
      // Token 过期，尝试自动刷新
      const store = useAdminStore()
      const storedRefreshToken = store.getRefreshToken

      if (!storedRefreshToken) {
        // 没有 Refresh Token，直接跳转登录
        redirectToLogin()
        return Promise.reject(new Error('Session expired'))
      }

      if (!isRefreshing) {
        isRefreshing = true
        try {
          const refreshRes = await axios.post(refreshUrlPath, {
            refreshToken: storedRefreshToken,
          })
          const refreshData = refreshRes.data
          if (refreshData.state === 0 && refreshData.data) {
            // 刷新成功，更新 Token
            store.setToken(refreshData.data.token)
            store.setRefreshToken(refreshData.data.refreshToken)
            if (refreshData.data.admin) {
              store.setAdmin(refreshData.data.admin)
            }
            // 重放所有排队的请求
            pendingRequests.forEach(({ resolve }) => resolve(refreshData.data.token))
            pendingRequests = []
            // 重放当前请求
            response.config.headers['token'] = refreshData.data.token
            return service(response.config)
          } else {
            // 刷新失败，清空状态
            throw new Error('Refresh failed')
          }
        } catch {
          // Refresh Token 也失效了，跳转登录
          pendingRequests.forEach(({ reject }) => reject(new Error('Session expired')))
          pendingRequests = []
          redirectToLogin()
          return Promise.reject(new Error('Session expired'))
        } finally {
          isRefreshing = false
        }
      } else {
        // 正在刷新中，将当前请求加入队列等待新 Token
        return new Promise((resolve, reject) => {
          pendingRequests.push({
            resolve: (newToken: string) => {
              response.config.headers['token'] = newToken
              resolve(service(response.config))
            },
            reject: (err: Error) => {
              reject(err)
            },
          })
        })
      }
    } else {
      return res
    }
  },
  (error) => {
    console.error('Response error:', error)
    if (error.response) {
      if (error.response.status === 401) {
        redirectToLogin()
      } else {
        ElMessage.error(error.response.data?.message || `Request failed: ${error.response.status}`)
      }
    } else if (error.request) {
      ElMessage.error('Network connection failed')
    } else {
      ElMessage.error(`Request error: ${error.message}`)
    }
    return Promise.reject(error)
  },
)

/**
 * 跳转到登录页并清除登录状态
 */
function redirectToLogin() {
  const adminStore = useAdminStore()
  adminStore.logout()
  window.location.href = loginUrlPath
}

export default service
