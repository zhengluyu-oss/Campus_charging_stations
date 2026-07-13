<template>
  <AmbientParticles />
  <div v-if="route.path === '/login'" class="login-wrapper">
    <router-view />
  </div>
  <div v-else class="admin-layout">
    <aside class="sidebar" :class="{ collapsed: adminStore.sidebarCollapsed }">
      <div class="sidebar-header">
        <el-icon :size="24" color="#00c9ff"><Lightning /></el-icon>
        <span v-show="!adminStore.sidebarCollapsed" class="sidebar-title">Charging Admin</span>
      </div>
      <el-menu
        :default-active="route.path"
        :collapse="adminStore.sidebarCollapsed"
        router
        background-color="transparent"
        text-color="rgba(255, 255, 255, 0.65)"
        active-text-color="#00c9ff"
        class="sidebar-menu"
      >
        <el-menu-item index="/dashboard">
          <el-icon><DataLine /></el-icon>
          <template #title>Dashboard</template>
        </el-menu-item>
        <el-menu-item index="/users">
          <el-icon><User /></el-icon>
          <template #title>Users</template>
        </el-menu-item>
        <el-menu-item index="/stations">
          <el-icon><Lightning /></el-icon>
          <template #title>Stations</template>
        </el-menu-item>
        <el-menu-item index="/orders">
          <el-icon><Document /></el-icon>
          <template #title>Orders</template>
        </el-menu-item>
        <el-menu-item index="/payments">
          <el-icon><Money /></el-icon>
          <template #title>Payments</template>
        </el-menu-item>
        <el-menu-item index="/reservations">
          <el-icon><Calendar /></el-icon>
          <template #title>Reservations</template>
        </el-menu-item>
        <el-menu-item index="/news">
          <el-icon><Notification /></el-icon>
          <template #title>News</template>
        </el-menu-item>
        <el-menu-item index="/settings">
          <el-icon><Setting /></el-icon>
          <template #title>Settings</template>
        </el-menu-item>
      </el-menu>
    </aside>
    <div class="main-area">
      <header class="main-header">
        <div class="header-left">
          <el-icon
            class="collapse-btn"
            :size="20"
            @click="adminStore.toggleSidebar"
          >
            <Fold v-if="!adminStore.sidebarCollapsed" />
            <Expand v-else />
          </el-icon>
          <span class="page-title">{{ route.meta.title }}</span>
        </div>
        <div class="header-right">
          <span class="admin-name">{{ adminStore.admin?.nickname || 'Administrator' }}</span>
          <el-avatar :size="32" :src="adminStore.admin?.avatar" class="admin-avatar">
            <el-icon><UserFilled /></el-icon>
          </el-avatar>
        </div>
      </header>
      <main class="main-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useAdminStore } from '@/stores/admin'
import AmbientParticles from '@/components/AmbientParticles.vue'

const route = useRoute()
const adminStore = useAdminStore()

onMounted(() => {
  document.documentElement.classList.add('dark')
})

</script>


<style>
:root {
  --bg-primary: #1a2a3a;
  --bg-secondary: #1e3040;
  --bg-card: rgba(255, 255, 255, 0.06);
  --brand-primary: #00b4d8;
  --brand-secondary: #52b788;
  --brand-accent: #0077b6;
  --text-primary: #e8edf2;
  --text-secondary: #8fa3b0;
  --text-muted: #5a7280;
  --border-color: rgba(255, 255, 255, 0.08);
  --border-hover: rgba(0, 180, 216, 0.3);
}
</style>

<style scoped>
.login-wrapper {
  width: 100vw;
  height: 100vh;
  position: relative;
  z-index: 1;
}

.admin-layout {
  display: flex;
  width: 100vw;
  height: 100vh;
  position: relative;
  z-index: 1;
  background: var(--bg-primary);
}

.sidebar {
  width: 250px;
  height: 100vh;
  background: rgba(15, 25, 35, 0.85);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  transition: width 0.3s ease;
  overflow: hidden;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
}

.sidebar.collapsed {
  width: 64px;
}

.sidebar-header {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  padding: 0 16px;
  flex-shrink: 0;
}

.sidebar-title {
  font-size: 16px;
  font-weight: 700;
  color: #ffffff;
  white-space: nowrap;
  letter-spacing: 0.5px;
}

.sidebar-menu {
  flex: 1;
  border-right: none;
  overflow-y: auto;
}

.sidebar-menu::-webkit-scrollbar {
  width: 0;
}

.main-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.main-header {
  height: 60px;
  background: rgba(15, 25, 35, 0.7);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.collapse-btn {
  cursor: pointer;
  color: rgba(255, 255, 255, 0.65);
  transition: color 0.2s;
}

.collapse-btn:hover {
  color: #00c9ff;
}

.page-title {
  font-size: 16px;
  font-weight: 500;
  color: #e0e0e0;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.admin-name {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.65);
}

.admin-avatar {
  background: linear-gradient(135deg, #00c9ff, #92fe9d);
  cursor: pointer;
}

.main-content {
  flex: 1;
  overflow: auto;
  padding: 24px;
  color: #e0e0e0;
}

.main-content::-webkit-scrollbar {
  width: 6px;
}

.main-content::-webkit-scrollbar-track {
  background: transparent;
}

.main-content::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.15);
  border-radius: 3px;
}

.main-content::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.25);
}
</style>
