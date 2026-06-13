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
      <span class="logo" @click="goToDashboard">校园充电站</span>
    </div>
    <div class="right">
      <el-dropdown>
        <span class="el-dropdown-link">
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
  height: 50px;
  border-bottom: 1px solid #e4e7ed;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  background-color: #fff;
}

.header .left {
  display: flex;
  align-items: center;
}

.header .left .logo {
  font-size: 16px;
  font-weight: 500;
  margin-left: 10px;
  cursor: pointer;
  color: #303133;
}

.header .left .back {
  border: 1px solid #dcdfe6;
  padding: 4px;
  border-radius: 4px;
  margin-right: 10px;
  cursor: pointer;
  color: #606266;
  transition: all 0.2s;
}

.header .left .back:hover {
  background-color: #f5f7fa;
  border-color: #409EFF;
  color: #409EFF;
}

.header .right {
  display: flex;
  align-items: center;
}

.el-dropdown-link {
  cursor: pointer;
  color: #606266;
  display: flex;
  align-items: center;
  font-size: 14px;
  transition: color 0.2s;
}

.el-dropdown-link:hover {
  color: #409EFF;
}
</style>