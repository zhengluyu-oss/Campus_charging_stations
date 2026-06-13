<template>
  <div class="page-container">
    <el-card class="page-card" shadow="hover">
      <template #header>
        <span>Admin Settings</span>
      </template>
      <el-form label-width="140px" size="large">
        <el-form-item label="Site Name">
          <el-input model-value="Campus Charging Stations" disabled />
        </el-form-item>
        <el-form-item label="Admin Username">
          <el-input :model-value="adminStore.admin?.username || 'admin'" disabled />
        </el-form-item>
        <el-form-item label="Dark Mode">
          <el-switch :model-value="true" disabled />
        </el-form-item>
        <el-form-item>
          <el-button type="danger" @click="handleLogout">Logout</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useAdminStore } from '@/stores/admin'

const router = useRouter()
const adminStore = useAdminStore()

function handleLogout() {
  adminStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.page-container { display: flex; flex-direction: column; gap: 20px; }
.page-card {
  background: rgba(15, 25, 35, 0.6);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 12px;
  color: #e0e0e0;
}
</style>
