import axios from 'axios'
import { ElMessageBox, ElMessage } from 'element-plus'
import qs from 'qs'
import { useAdminStore } from '@/stores/admin'

export interface JsonResult<T> {
  state: number
  message: string
  data: T
}

const loginUrlPath = '/login'

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
  (response) => {
    const res = response.data
    const isLoginRequest = response.config.url?.includes('/login')

    if (res.state > 0) {
      ElMessage.error(res.message || 'System error')
      return Promise.reject(new Error(res.message))
    } else if (res.state === -1 && !isLoginRequest) {
      ElMessageBox.alert('Session expired, please log in again', 'Session Expired', {
        confirmButtonText: 'Re-login',
      }).then(() => {
        const adminStore = useAdminStore()
        adminStore.$patch({ token: '', admin: undefined })
        window.location.href = loginUrlPath
      }).catch(() => {
        const adminStore = useAdminStore()
        adminStore.$reset()
      })
      return Promise.reject(new Error('Session expired'))
    } else {
      return res
    }
  },
  (error) => {
    console.error('Response error:', error)
    if (error.response) {
      if (error.response.status === 401) {
        ElMessageBox.alert('Session expired, please log in again', 'Session Expired', {
          confirmButtonText: 'Re-login',
        }).then(() => {
          const adminStore = useAdminStore()
          adminStore.$patch({ token: '', admin: undefined })
          window.location.href = loginUrlPath
        })
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

export default service
