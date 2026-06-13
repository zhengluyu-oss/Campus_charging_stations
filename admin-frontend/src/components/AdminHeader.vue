<template>
  <header class="admin-header">
    <div class="header-left">
      <el-icon
        class="toggle-btn"
        :size="20"
        @click="adminStore.toggleSidebar()"
      >
        <Fold v-if="!adminStore.sidebarCollapsed" />
        <Expand v-else />
      </el-icon>

      <el-breadcrumb separator="/" class="breadcrumb">
        <el-breadcrumb-item :to="{ path: '/dashboard' }">Home</el-breadcrumb-item>
        <el-breadcrumb-item>{{ route.meta.title }}</el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <div class="header-right">
      <el-dropdown trigger="click" @command="handleCommand">
        <div class="admin-profile">
          <el-avatar :size="32" :src="adminStore.admin?.avatar" class="admin-avatar">
            <el-icon><UserFilled /></el-icon>
          </el-avatar>
          <span class="admin-name">{{ adminStore.admin?.nickname || adminStore.admin?.username || 'Administrator' }}</span>
          <el-icon class="dropdown-arrow"><ArrowDown /></el-icon>
        </div>
        <template #dropdown>
          <el-dropdown-menu class="dark-dropdown">
            <el-dropdown-item command="profile">
              <el-icon><User /></el-icon>Profile
            </el-dropdown-item>
            <el-dropdown-item command="settings">
              <el-icon><Setting /></el-icon>Settings
            </el-dropdown-item>
            <el-dropdown-item divided command="logout">
              <el-icon><SwitchButton /></el-icon>Logout
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </header>
</template>

<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import { useAdminStore } from '@/stores/admin'

const route = useRoute()
const router = useRouter()
const adminStore = useAdminStore()

function handleCommand(command: string) {
  switch (command) {
    case 'profile':
    case 'settings':
      router.push('/settings')
      break
    case 'logout':
      ElMessageBox.confirm('Are you sure you want to logout?', 'Logout', {
        confirmButtonText: 'Logout',
        cancelButtonText: 'Cancel',
        type: 'warning',
      }).then(() => {
        adminStore.logout()
        router.push('/login')
      }).catch(() => {})
      break
  }
}
</script>

<style scoped>
.admin-header {
  height: 60px;
  background: rgba(10, 18, 28, 0.75);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  flex-shrink: 0;
  position: relative;
  z-index: 99;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.toggle-btn {
  cursor: pointer;
  color: rgba(255, 255, 255, 0.55);
  transition: color 0.2s;
}

.toggle-btn:hover {
  color: #00c9ff;
}

.breadcrumb :deep(.el-breadcrumb__inner) {
  color: rgba(255, 255, 255, 0.55) !important;
}

.breadcrumb :deep(.el-breadcrumb__inner.is-link:hover) {
  color: #00c9ff !important;
}

.breadcrumb :deep(.el-breadcrumb__separator) {
  color: rgba(255, 255, 255, 0.25) !important;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.admin-profile {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 8px;
  transition: background 0.2s;
}

.admin-profile:hover {
  background: rgba(255, 255, 255, 0.06);
}

.admin-avatar {
  background: linear-gradient(135deg, #00c9ff, #92fe9d);
  flex-shrink: 0;
}

.admin-name {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.75);
  max-width: 120px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.dropdown-arrow {
  color: rgba(255, 255, 255, 0.4);
  font-size: 12px;
}

/* Deep override for dark dropdown */
:global(.dark-dropdown) {
  background: rgba(15, 25, 40, 0.95) !important;
  backdrop-filter: blur(20px) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 10px !important;
}

:global(.dark-dropdown .el-dropdown-menu__item) {
  color: rgba(255, 255, 255, 0.75) !important;
}

:global(.dark-dropdown .el-dropdown-menu__item:hover) {
  background: rgba(255, 255, 255, 0.08) !important;
  color: #00c9ff !important;
}

:global(.dark-dropdown .el-dropdown-menu__item.is-divided::before) {
  background-color: rgba(255, 255, 255, 0.08) !important;
}
</style>
