import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

// 安全风险提示：
// 1. token 存储在 localStorage 中，存在 XSS 攻击风险
// 2. 建议使用 httpOnly cookie 存储 token，或实现 token 刷新机制
// 3. persist: true 配置会将敏感信息持久化到本地存储
// 4. 生产环境应考虑使用更安全的存储方案

export interface AdminInfo {
  id: number
  username: string
  nickname: string
  avatar: string
  role: string
}

export const useAdminStore = defineStore('admin', () => {
  const token = ref('')
  const admin = ref<AdminInfo | undefined>(undefined)
  const sidebarCollapsed = ref(false)

  const getToken = computed(() => token.value)

  function setToken(newToken: string) {
    token.value = newToken
  }

  function setAdmin(info: AdminInfo) {
    admin.value = info
  }

  function toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  function logout() {
    token.value = ''
    admin.value = undefined
  }

  return {
    token,
    admin,
    sidebarCollapsed,
    getToken,
    setToken,
    setAdmin,
    toggleSidebar,
    logout,
  }
}, {
  persist: true,
})
