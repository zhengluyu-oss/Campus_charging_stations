<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { ArrowLeft, CircleCheck, Lock, User } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'
import { userLogin } from '@/api/user'

const router = useRouter()
const store = useUserStore()
const formRef = ref<FormInstance>()
const loading = ref(false)
const form = reactive({ username: '', password: '', remember: true })
const rules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

const submit = async () => {
  if (!formRef.value || !(await formRef.value.validate().catch(() => false))) return
  loading.value = true
  try {
    const result = await userLogin(form.username, form.password) as any
    store.saveToken(result?.message || '')
    if (result?.data) store.saveUser(result.data)
    ElMessage.success('登录成功')
    await router.replace('/user-dashboard')
  } catch (error) {
    ElMessage.error(typeof error === 'string' ? error : '登录失败，请检查账号信息')
  } finally { loading.value = false }
}
</script>

<template>
  <main class="auth-page">
    <button class="back-link" type="button" @click="router.push('/welcome')"><ArrowLeft /> 返回首页</button>
    <section class="auth-layout">
      <div class="auth-intro">
        <span class="brand-icon">⚡</span>
        <p class="eyebrow">CAMPUS CHARGE</p>
        <h1>欢迎回来</h1>
        <p>登录后查看校园充电桩状态、管理预约，并跟踪每一次充电记录。</p>
        <ul><li><CircleCheck /> 实时查看空闲状态</li><li><CircleCheck /> 快速预约校园站点</li><li><CircleCheck /> 个人记录集中管理</li></ul>
      </div>
      <div class="auth-card">
        <div class="card-title"><h2>账户登录</h2><p>使用你的校园充电账户继续</p></div>
        <el-form ref="formRef" :model="form" :rules="rules" label-position="top" @keyup.enter="submit">
          <el-form-item label="用户名" prop="username"><el-input v-model="form.username" size="large" placeholder="请输入用户名" :prefix-icon="User" autocomplete="username" /></el-form-item>
          <el-form-item label="密码" prop="password"><el-input v-model="form.password" size="large" type="password" show-password placeholder="请输入密码" :prefix-icon="Lock" autocomplete="current-password" /></el-form-item>
          <div class="form-meta"><el-checkbox v-model="form.remember">保持登录</el-checkbox><span>忘记密码请联系管理员</span></div>
          <el-button type="primary" size="large" :loading="loading" class="submit" @click="submit">登录</el-button>
        </el-form>
        <p class="switch-auth">还没有账户？<router-link to="/user-register">立即注册</router-link></p>
      </div>
    </section>
  </main>
</template>

<style scoped>
.auth-page { min-height: 100vh; position: relative; display: grid; place-items: center; padding: 70px 24px; background: #f4f7f4; }
.back-link { position: absolute; top: 28px; left: max(28px, calc((100% - 1080px)/2)); display: flex; align-items: center; gap: 7px; color: var(--text-secondary); background: none; border: 0; cursor: pointer; }.back-link :deep(svg){width:17px}
.auth-layout { width: min(1080px,100%); display: grid; grid-template-columns: 1fr 440px; gap: 100px; align-items: center; }
.brand-icon { width: 52px; height: 52px; display: grid; place-items: center; color: white; background: var(--brand); border-radius: 16px; font-size: 25px; }.eyebrow{margin:24px 0 10px!important;color:var(--brand)!important;font-size:12px!important;font-weight:800;letter-spacing:.14em}.auth-intro h1{margin:0;font-size:58px;letter-spacing:-.05em}.auth-intro>p{max-width:510px;margin:20px 0;color:var(--text-secondary);font-size:17px;line-height:1.8}.auth-intro ul{display:grid;gap:13px;margin:32px 0 0;padding:0;list-style:none;color:#425249}.auth-intro li{display:flex;align-items:center;gap:10px}.auth-intro li :deep(svg){width:18px;color:var(--brand)}
.auth-card{padding:38px;background:#fff;border:1px solid var(--border-color);border-radius:24px;box-shadow:var(--shadow-md)}.card-title{margin-bottom:28px}.card-title h2{margin:0;font-size:28px;letter-spacing:-.03em}.card-title p{margin:8px 0 0;color:var(--text-muted)}.form-meta{display:flex;justify-content:space-between;align-items:center;margin:-2px 0 22px;color:var(--text-muted);font-size:12px}.submit{width:100%;min-height:48px}.switch-auth{text-align:center;margin:24px 0 0;color:var(--text-secondary);font-size:14px}.switch-auth a{color:var(--brand);font-weight:700}
@media(max-width:850px){.auth-layout{grid-template-columns:1fr;gap:38px;max-width:480px}.auth-intro{text-align:center}.brand-icon{margin:auto}.auth-intro ul{display:none}.auth-intro h1{font-size:42px}.auth-intro>p{font-size:15px}.eyebrow{margin-inline:auto!important}.auth-card{padding:28px}}@media(max-width:500px){.auth-page{padding:90px 14px 30px}.auth-intro>p{display:none}.auth-card{padding:24px 18px}.back-link{left:18px}}
</style>
