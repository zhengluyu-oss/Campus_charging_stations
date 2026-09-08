<template>
  <div class="login-page page-enter-active">
    <!-- Login card -->
    <div class="login-card">
      <div class="login-header">
        <div class="logo-icon">
          <el-icon :size="36" color="var(--brand-cyan)"><Lightning /></el-icon>
        </div>
        <h2 class="login-title font-display">Energy Command</h2>
        <p class="login-subtitle">Sign in to manage your campus charging network</p>
      </div>

      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="0"
        size="large"
        @keyup.enter="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="form.username"
            placeholder="Username"
            class="dark-input"
          >
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="form.password"
            type="password"
            placeholder="Password"
            show-password
            class="dark-input"
          >
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item>
          <el-button
            class="login-btn"
            :loading="loading"
            @click="handleLogin"
          >
            {{ loading ? 'Signing In...' : 'Sign In' }}
          </el-button>
        </el-form-item>
      </el-form>

      <div class="login-footer">
        <span>Campus Charging Stations Admin Panel</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import request from '@/utils/request'
import { useAdminStore } from '@/stores/admin'

const router = useRouter()
const adminStore = useAdminStore()
const formRef = ref<FormInstance>()
const loading = ref(false)

const form = reactive({
  username: '',
  password: '',
})

const rules: FormRules = {
  username: [{ required: true, message: 'Please enter username', trigger: 'blur' }],
  password: [{ required: true, message: 'Please enter password', trigger: 'blur' }],
}


async function handleLogin() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    const res: any = await request.post('/admin/login', {
      username: form.username,
      password: form.password,
    })
    adminStore.setToken(res.data.token)
    if (res.data.refreshToken) {
      adminStore.setRefreshToken(res.data.refreshToken)
    }
    if (res.data.admin) {
      adminStore.setAdmin(res.data.admin)
    }
    ElMessage.success('Login successful')
    router.push('/dashboard')
  } catch {
    // Error already handled by interceptor
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
  position: relative;
  overflow: hidden;
}

/* Particle animation */
.particles {
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 0;
}

@keyframes floatParticle {
  0% {
    transform: translateY(0) translateX(0) scale(1);
    opacity: 0;
  }
  10% {
    opacity: var(--particle-opacity, 0.3);
  }
  90% {
    opacity: var(--particle-opacity, 0.3);
  }
  100% {
    transform: translateY(-100vh) translateX(50px) scale(0.5);
    opacity: 0;
  }
}

/* Login card */
.login-card {
  width: 420px;
  padding: 40px;
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  position: relative;
  z-index: 1;
  box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
}

.login-header {
  text-align: center;
  margin-bottom: 32px;
}

.logo-icon {
  width: 64px;
  height: 64px;
  margin: 0 auto 16px;
  background: rgba(0, 201, 255, 0.1);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(0, 201, 255, 0.2);
}

.login-title {
  margin: 0 0 8px;
  font-size: 22px;
  font-weight: 700;
  color: #ffffff;
  letter-spacing: 0.5px;
}

.login-subtitle {
  margin: 0;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
}

/* Deep Element Plus overrides for dark inputs */
.dark-input :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 12px !important;
  box-shadow: none !important;
  color: #ffffff;
}

.dark-input :deep(.el-input__wrapper:hover) {
  border-color: rgba(0, 201, 255, 0.4) !important;
}

.dark-input :deep(.el-input__wrapper.is-focus) {
  border-color: #00c9ff !important;
  box-shadow: 0 0 0 2px rgba(0, 201, 255, 0.15) !important;
}

.dark-input :deep(.el-input__inner) {
  color: #ffffff !important;
}

.dark-input :deep(.el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.35) !important;
}

.dark-input :deep(.el-input__prefix .el-icon) {
  color: rgba(255, 255, 255, 0.45);
}

.login-btn {
  width: 100%;
  height: 44px;
  background: linear-gradient(45deg, #00c9ff, #92fe9d) !important;
  border: none !important;
  border-radius: 12px !important;
  font-weight: 700 !important;
  font-size: 15px !important;
  color: #0f2027 !important;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 20px rgba(0, 201, 255, 0.3);
}

.login-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 25px rgba(0, 201, 255, 0.45) !important;
}

.login-footer {
  text-align: center;
  margin-top: 24px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.3);
}
</style>
