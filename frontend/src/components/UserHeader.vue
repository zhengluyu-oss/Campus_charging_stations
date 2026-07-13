<script setup lang="ts">
import { reactive } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const state = reactive({
  hasBack: true, // 是否展示返回icon
})

// 返回方法
const back = () => {
  router.back()
}

// 导航到用户仪表盘
const goToDashboard = () => {
  router.push('/user-dashboard')
}
</script>

<template>
  <div class="header">
    <div class="left">
      <el-icon class="back" v-if="state.hasBack" @click="back">
        <Back/>
      </el-icon>
      <span class="logo" @click="goToDashboard">
        <span class="logo-icon">⚡</span>
        校园充电站
      </span>
    </div>
    <div class="right">
      <el-dropdown>
        <span class="el-dropdown-link">
          <span class="user-avatar">👤</span>
          用户中心
          <el-icon class="el-icon--right">
            <arrow-down />
          </el-icon>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item @click="router.push('/profile')">个人资料</el-dropdown-item>
            <el-dropdown-item @click="router.push('/history')">历史记录</el-dropdown-item>
            <el-dropdown-item @click="router.push('/user-login')" divided>退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<style scoped>
.header {
  height: 60px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  background: rgba(15, 32, 39, 0.8);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header .left {
  display: flex;
  align-items: center;
}

.header .left .logo {
  font-size: 18px;
  font-weight: 600;
  margin-left: 12px;
  cursor: pointer;
  color: #ffffff;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}

.header .left .logo:hover {
  transform: scale(1.02);
}

.logo-icon {
  font-size: 24px;
}

.header .left .back {
  border: 1px solid rgba(255, 255, 255, 0.2);
  padding: 6px;
  border-radius: 8px;
  margin-right: 12px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.8);
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.05);
}

.header .left .back:hover {
  background: rgba(0, 201, 255, 0.2);
  border-color: var(--brand-primary);
  color: var(--brand-primary);
}

.header .right {
  display: flex;
  align-items: center;
}

.el-dropdown-link {
  cursor: pointer;
  color: rgba(255, 255, 255, 0.9);
  display: flex;
  align-items: center;
  font-size: 14px;
  transition: all 0.3s ease;
  padding: 8px 16px;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.el-dropdown-link:hover {
  color: var(--brand-primary);
  background: rgba(0, 201, 255, 0.1);
  border-color: rgba(0, 201, 255, 0.3);
}

.user-avatar {
  margin-right: 8px;
  font-size: 16px;
}
</style>
