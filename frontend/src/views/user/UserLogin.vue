<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { ArrowLeft, ArrowRight, Lock, User } from '@element-plus/icons-vue'
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
    <section class="brand-panel">
      <div class="brand"><span><i></i><i></i></span><strong>CAMPUS<br>CHARGE</strong></div>
      <div class="brand-message">
        <p>ENERGY, ON YOUR TIME</p>
        <h1>连接校园，<br><em>也连接下一程。</em></h1>
        <span>查找站点、安排预约、管理记录。登录后继续你的校园充电旅程。</span>
      </div>
      <div class="energy-orbit"><i></i><i></i><i></i><b>7.0<small>kW</small></b><span>READY</span></div>
      <footer><span>校园能源服务系统</span><span>STATUS · ONLINE</span></footer>
    </section>

    <section class="form-panel">
      <div class="form-wrap">
        <header><p>用户登录</p><h2>欢迎回来</h2><span>使用你的校园充电账户继续</span></header>
        <el-form ref="formRef" :model="form" :rules="rules" label-position="top" @keyup.enter="submit">
          <el-form-item label="用户名" prop="username"><el-input v-model="form.username" size="large" placeholder="请输入用户名" :prefix-icon="User" autocomplete="username" /></el-form-item>
          <el-form-item label="密码" prop="password"><el-input v-model="form.password" size="large" type="password" show-password placeholder="请输入密码" :prefix-icon="Lock" autocomplete="current-password" /></el-form-item>
          <div class="form-meta"><el-checkbox v-model="form.remember">保持登录</el-checkbox><span>忘记密码请联系管理员</span></div>
          <el-button type="primary" size="large" :loading="loading" class="submit" @click="submit">登录 <ArrowRight /></el-button>
        </el-form>
        <p class="switch-auth">还没有账户？<router-link to="/user-register">创建校园账户</router-link></p>
      </div>
    </section>
  </main>
</template>

<style scoped>
.auth-page{min-height:100vh;position:relative;display:grid;grid-template-columns:1.08fr .92fr;background:#fff}.back-link{position:absolute;z-index:4;top:28px;left:32px;display:flex;align-items:center;gap:7px;padding:8px 10px;color:#c2c4cd;background:rgba(255,255,255,.07);border:1px solid rgba(255,255,255,.1);border-radius:7px;cursor:pointer}.back-link :deep(svg){width:16px}.brand-panel{position:relative;min-height:100vh;overflow:hidden;padding:34px 48px 32px;color:#fff;background:#0d0f15}.brand-panel::before{content:'';position:absolute;inset:0;opacity:.12;background-image:linear-gradient(rgba(255,255,255,.12) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.12) 1px,transparent 1px);background-size:52px 52px;mask-image:linear-gradient(135deg,#000,transparent 80%)}.brand{position:relative;margin-left:120px;display:flex;align-items:center;gap:10px}.brand>span{position:relative;width:30px;height:30px;background:var(--brand);border-radius:6px}.brand i{position:absolute;top:5px;width:5px;height:20px;background:#fff;transform:skew(-18deg)}.brand i:first-child{left:8px}.brand i:last-child{right:7px;opacity:.4}.brand strong{font-size:10px;line-height:1.05;letter-spacing:.14em}.brand-message{position:relative;z-index:1;margin-top:19vh;max-width:640px}.brand-message p{margin:0 0 22px;color:#8e96ff;font-size:10px;font-weight:800;letter-spacing:.15em}.brand-message h1{margin:0;font-size:clamp(48px,5vw,76px);font-weight:630;line-height:1.02;letter-spacing:-.065em}.brand-message h1 em{color:#8993ff;font-style:normal}.brand-message>span{display:block;max-width:470px;margin-top:27px;color:#aeb0ba;font-size:15px;line-height:1.8}.energy-orbit{position:absolute;width:280px;height:280px;right:-66px;bottom:70px;border:1px solid rgba(127,139,255,.35);border-radius:50%;box-shadow:0 0 90px rgba(83,98,246,.16) inset}.energy-orbit::before,.energy-orbit::after{content:'';position:absolute;border:1px solid rgba(255,255,255,.1);border-radius:50%}.energy-orbit::before{inset:35px}.energy-orbit::after{inset:74px}.energy-orbit>i{position:absolute;width:7px;height:7px;background:#8fff75;border-radius:50%;box-shadow:0 0 18px #8fff75}.energy-orbit>i:nth-child(1){left:26px;top:58px}.energy-orbit>i:nth-child(2){right:53px;top:20px;background:#7d89ff;box-shadow:0 0 18px #7d89ff}.energy-orbit>i:nth-child(3){left:40px;bottom:35px;background:#ff7650;box-shadow:0 0 18px #ff7650}.energy-orbit b{position:absolute;inset:0;display:grid;place-items:center;font-size:38px}.energy-orbit b small{margin-left:-110px;margin-top:65px;color:#8b8e98;font-size:10px}.energy-orbit>span{position:absolute;left:111px;top:180px;color:#8fff75;font-size:8px;letter-spacing:.12em}.brand-panel footer{position:absolute;left:48px;right:48px;bottom:32px;display:flex;justify-content:space-between;color:#666a74;font-size:9px;letter-spacing:.1em}.brand-panel footer span:last-child{color:#75c66d}.form-panel{display:grid;place-items:center;padding:80px 8vw;background:#fff}.form-wrap{width:min(430px,100%)}.form-wrap header{margin-bottom:38px}.form-wrap header p{margin:0;color:var(--brand);font-size:10px;font-weight:800;letter-spacing:.14em}.form-wrap header h2{margin:10px 0 9px;font-size:42px;line-height:1;letter-spacing:-.05em}.form-wrap header span{color:var(--text-muted);font-size:13px}.form-wrap :deep(.el-form-item){margin-bottom:23px}.form-wrap :deep(.el-form-item__label){font-size:12px;font-weight:700}.form-wrap :deep(.el-input__wrapper){min-height:50px;background:#f7f7f6!important}.form-meta{display:flex;justify-content:space-between;align-items:center;margin:-2px 0 24px;color:var(--text-muted);font-size:11px}.submit{width:100%;min-height:50px}.switch-auth{text-align:center;margin:25px 0 0;color:var(--text-secondary);font-size:13px}.switch-auth a{color:var(--brand);font-weight:750}
@media(max-width:850px){.auth-page{grid-template-columns:1fr}.brand-panel{min-height:310px;padding:28px}.brand{margin-left:110px}.brand-message{margin-top:92px}.brand-message h1{font-size:45px}.brand-message>span{display:none}.energy-orbit{width:230px;height:230px;right:-70px;bottom:-90px}.brand-panel footer{display:none}.form-panel{padding:58px 24px 70px}.back-link{top:24px;left:22px}}
@media(max-width:520px){.brand-panel{min-height:260px}.brand-message{margin-top:75px}.brand-message h1{font-size:38px}.form-panel{padding-inline:18px}.form-wrap header h2{font-size:34px}.brand{margin-left:100px}}
</style>
