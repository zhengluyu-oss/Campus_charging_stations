<script setup lang="ts">
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { User, Lock } from '@element-plus/icons-vue';
import {useUserStore} from "../../stores/user.ts";
import {userLogin} from "../../api/user.ts";

const userStore = useUserStore()
const router = useRouter()

// 登录按钮是否加载状态
const isLoading = ref(false)

// 登录表单数据
const loginForm = reactive({
  username: '',
  password: '',
  rememberMe: false
})

// 校验规则
const rules = reactive({
  username: [
    {required: true, message: '请输入用户名', trigger: 'blur'},
    {min: 3, max: 20, message: '用户名长度 3~20 个字符', trigger: 'blur'},
  ],
  password: [
    {required: true, message: '请输入密码', trigger: 'blur'},
    {min: 3, max: 20, message: '密码长度 3~20 个字符', trigger: 'blur'},
  ]
})

// 必须要有，不然获取不到 Form 原生的 DOM 对象
const formRef = ref()

const userHandleLogin = () => {
  if (!formRef.value) {
    return
  }
  // 一定校验
  formRef.value.validate((valid: any, fields: any) => {
    if (valid) {
      isLoading.value = true
      // 校验通过，请求后端 api
      // Promise 只处理成功的，失败和异常不用管理
      userLogin(loginForm.username, loginForm.password).then((res) => {
        // 根据后端实际返回的数据结构来处理
        // 后端返回格式为 { state: 0, message: 'jwt_token_here', data: { userInfo } }
        if (res) {
          // 存储 token - 从 res.message 中提取 token（因为后端将 JWT 放在 message 字段中）
          const token = (res as any).message || ''; // JWT token 存储在 message 字段中
          userStore.saveToken(token);

          // 存储用户信息 - 从 res.data 中获取用户信息
          if (res.data) {
            userStore.saveUser(res.data);
          }
        }

        // 跳转页面
        router.replace({
          path: '/user-dashboard' // 修改为正确的用户仪表板路径
        })
      }).catch(error => {
        console.error('登录失败:', error)
        // 拦截器已将错误转为字符串，直接使用
        ElMessage.error(typeof error === 'string' ? error : '登录失败')
      }).finally(() => {
        // 最终要 isLoading 为 false
        isLoading.value = false
      })
    } else {
      // 校验不通过
    }
  })
}

const handleReset = () => {
  if (!formRef.value) {
    return
  }
  formRef.value.resetFields()
}
</script>

<template>
  <div class="user-login-container">
    <!-- 登录卡片 -->
    <div class="login-card">
      <div class="card-header">
        <h2>校园充电系统</h2>
        <p>用户登录</p>
      </div>

      <!-- 登录表单 -->
      <el-form
        ref="formRef"
        :model="loginForm"
        :rules="rules"
        class="login-form"
        @keyup.enter="userHandleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名/邮箱/手机号"
            size="large"
            autocomplete="off"
          >
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            show-password
            size="large"
            autocomplete="current-password"
          >
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item class="form-options">
          <el-checkbox v-model="loginForm.rememberMe">记住我</el-checkbox>
          <a href="#" class="forgot-password">忘记密码？</a>
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            @click="userHandleLogin"
            :loading="isLoading"
            size="large"
            class="login-button"
          >
            <span v-if="!isLoading">登录</span>
            <span v-else>登录中...</span>
          </el-button>
        </el-form-item>
      </el-form>

      <!--底部版权所有-->
      <div class="login-footer">
        <p>© 2026 校园充电系统。版权所有.</p>
        <div class="welcome-link">
          <a href="/">← 返回欢迎页面</a>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
html, body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
}

.user-login-container {
  position: relative;
  min-height: 100vh;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  padding: 20px;
  box-sizing: border-box;
  overflow-x: hidden;
}

.login-card {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 400px;
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(12px);
  border-radius: 20px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  padding: 40px;
  animation: fadeInUp 0.8s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card-header {
  text-align: center;
  margin-bottom: 32px;
}

.card-header h2 {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 10px;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.card-header p {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
}

.login-form {
  width: 100%;
}

.login-form .el-form-item {
  margin-bottom: 24px;
}

.login-form .el-form-item:last-child {
  margin-bottom: 0;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.form-options :deep(.el-checkbox__label) {
  color: rgba(255, 255, 255, 0.7);
}

.form-options :deep(.el-checkbox__inner) {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.3);
}

.form-options :deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
  background: #00c9ff;
  border-color: #00c9ff;
}

.forgot-password {
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  font-size: 14px;
  transition: color 0.2s;
}

.forgot-password:hover {
  color: #00c9ff;
}

.login-button {
  width: 100%;
  height: 44px;
  font-size: 16px;
  font-weight: 500;
  border-radius: 8px;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  border: none;
  color: #0f2027;
  transition: all 0.3s ease;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 201, 255, 0.4);
}

.login-footer {
  text-align: center;
  margin-top: 24px;
  padding-top: 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
}

.register-link {
  color: #00c9ff;
  text-decoration: none;
  font-weight: 500;
  margin-left: 5px;
  transition: color 0.2s;
}

.register-link:hover {
  color: #92fe9d;
}

:deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.1) !important;
  border: 1px solid rgba(255, 255, 255, 0.2) !important;
  border-radius: 8px !important;
  transition: all 0.3s ease !important;
  color: white !important;
}

:deep(.el-input__inner) {
  color: white !important;
  font-size: 15px !important;
}

:deep(.el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.5) !important;
}

:deep(.el-input__wrapper):hover {
  background: rgba(255, 255, 255, 0.15) !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
}

:deep(.el-input__wrapper.is-focus) {
  background: rgba(255, 255, 255, 0.15) !important;
  border: 1px solid rgba(0, 201, 255, 0.5) !important;
  box-shadow: 0 0 0 2px rgba(0, 201, 255, 0.2) !important;
}

:deep(.el-input__prefix-inner .el-icon) {
  color: rgba(255, 255, 255, 0.7) !important;
}

:deep(.el-input__suffix-inner .el-icon) {
  color: rgba(255, 255, 255, 0.7) !important;
}

@media (max-width: 768px) {
  .login-card {
    padding: 30px 20px;
  }

  .card-header h2 {
    font-size: 20px;
  }
}
</style>
