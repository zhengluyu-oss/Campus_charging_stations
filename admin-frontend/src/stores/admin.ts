import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

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
