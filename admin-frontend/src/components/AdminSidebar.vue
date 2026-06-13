<template>
  <aside class="admin-sidebar" :class="{ collapsed: adminStore.sidebarCollapsed }">
    <div class="sidebar-header">
      <el-icon :size="26" color="#00c9ff"><Lightning /></el-icon>
      <transition name="fade">
        <span v-show="!adminStore.sidebarCollapsed" class="sidebar-title">Charging Admin</span>
      </transition>
    </div>

    <el-menu
      :default-active="route.path"
      :collapse="adminStore.sidebarCollapsed"
      router
      background-color="transparent"
      text-color="rgba(255,255,255,0.6)"
      active-text-color="#00c9ff"
      class="sidebar-menu"
    >
      <el-menu-item index="/dashboard">
        <el-icon><DataLine /></el-icon>
        <template #title>Dashboard</template>
      </el-menu-item>
      <el-menu-item index="/users">
        <el-icon><User /></el-icon>
        <template #title>User Management</template>
      </el-menu-item>
      <el-menu-item index="/stations">
        <el-icon><Lightning /></el-icon>
        <template #title>Station Management</template>
      </el-menu-item>
      <el-menu-item index="/orders">
        <el-icon><Document /></el-icon>
        <template #title>Order Management</template>
      </el-menu-item>
      <el-menu-item index="/payments">
        <el-icon><Money /></el-icon>
        <template #title>Payment Management</template>
      </el-menu-item>
      <el-menu-item index="/reservations">
        <el-icon><Calendar /></el-icon>
        <template #title>Reservation Management</template>
      </el-menu-item>
      <el-menu-item index="/news">
        <el-icon><Notification /></el-icon>
        <template #title>News Management</template>
      </el-menu-item>
      <el-menu-item index="/settings">
        <el-icon><Setting /></el-icon>
        <template #title>Settings</template>
      </el-menu-item>
    </el-menu>

    <div class="sidebar-footer">
      <el-icon
        class="collapse-trigger"
        :size="18"
        @click="adminStore.toggleSidebar()"
      >
        <DArrowLeft v-if="!adminStore.sidebarCollapsed" />
        <DArrowRight v-else />
      </el-icon>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router'
import { useAdminStore } from '@/stores/admin'

const route = useRoute()
const adminStore = useAdminStore()
</script>

<style scoped>
.admin-sidebar {
  width: 250px;
  height: 100vh;
  background: rgba(10, 18, 28, 0.92);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border-right: 1px solid rgba(255, 255, 255, 0.06);
  transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  position: relative;
  z-index: 100;
}

.admin-sidebar.collapsed {
  width: 64px;
}

.sidebar-header {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  padding: 0 16px;
  flex-shrink: 0;
}

.sidebar-title {
  font-size: 16px;
  font-weight: 700;
  color: #ffffff;
  white-space: nowrap;
  letter-spacing: 0.5px;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.sidebar-menu {
  flex: 1;
  border-right: none;
  overflow-y: auto;
  overflow-x: hidden;
  padding-top: 8px;
}

.sidebar-menu::-webkit-scrollbar {
  width: 0;
}

.sidebar-menu :deep(.el-menu-item) {
  height: 48px;
  line-height: 48px;
  margin: 2px 8px;
  border-radius: 10px;
  transition: all 0.25s ease;
}

.sidebar-menu :deep(.el-menu-item:hover) {
  background: rgba(255, 255, 255, 0.06) !important;
}

.sidebar-menu :deep(.el-menu-item.is-active) {
  background: rgba(0, 201, 255, 0.12) !important;
  color: #00c9ff !important;
  font-weight: 600;
}

.sidebar-menu :deep(.el-menu-item.is-active::before) {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 20px;
  background: linear-gradient(180deg, #00c9ff, #92fe9d);
  border-radius: 0 3px 3px 0;
}

.sidebar-footer {
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
  flex-shrink: 0;
}

.collapse-trigger {
  cursor: pointer;
  color: rgba(255, 255, 255, 0.45);
  transition: color 0.2s;
}

.collapse-trigger:hover {
  color: #00c9ff;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
