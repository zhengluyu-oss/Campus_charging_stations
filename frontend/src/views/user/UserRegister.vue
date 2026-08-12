<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { ArrowLeft, Lock, Message, Phone, User } from '@element-plus/icons-vue'
import { userRegister } from '@/api/user'

const router = useRouter()
const formRef = ref<FormInstance>()
const loading = ref(false)
const form = reactive({ username:'', email:'', phone:'', password:'', confirmPassword:'', agree:false })
const validateConfirm = (_rule: unknown, value: string, callback: (error?: Error) => void) => value === form.password ? callback() : callback(new Error('两次输入的密码不一致'))
const rules: FormRules = {
  username:[{required:true,message:'请输入用户名',trigger:'blur'},{min:3,max:20,message:'长度为 3—20 个字符',trigger:'blur'}],
  email:[{required:true,message:'请输入邮箱',trigger:'blur'},{type:'email',message:'邮箱格式不正确',trigger:'blur'}],
  phone:[{required:true,message:'请输入手机号',trigger:'blur'},{pattern:/^1[3-9]\d{9}$/,message:'手机号格式不正确',trigger:'blur'}],
  password:[{required:true,message:'请输入密码',trigger:'blur'},{min:6,message:'密码至少 6 个字符',trigger:'blur'}],
  confirmPassword:[{required:true,message:'请再次输入密码',trigger:'blur'},{validator:validateConfirm,trigger:'blur'}],
}
const submit=async()=>{if(!formRef.value||!(await formRef.value.validate().catch(()=>false)))return;if(!form.agree){ElMessage.warning('请先同意服务条款与隐私说明');return}loading.value=true;try{await userRegister(form.username,form.password,form.email,form.phone,'student');ElMessage.success('注册成功，请登录');router.replace('/user-login')}catch(e:any){ElMessage.error(typeof e==='string'?e:(e?.message||'注册失败，请稍后再试'))}finally{loading.value=false}}
</script>

<template>
  <main class="register-page">
    <button class="back-link" type="button" @click="router.push('/welcome')"><ArrowLeft /> 返回首页</button>
    <section class="register-wrap">
      <header><span>⚡</span><div><p>CAMPUS CHARGE</p><h1>创建校园账户</h1><small>完成注册后即可使用充电查询、预约和记录服务</small></div></header>
      <div class="register-card">
        <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
          <div class="form-grid">
            <el-form-item label="用户名" prop="username"><el-input v-model="form.username" :prefix-icon="User" placeholder="3—20 个字符" /></el-form-item>
            <el-form-item label="电子邮箱" prop="email"><el-input v-model="form.email" :prefix-icon="Message" placeholder="name@example.com" /></el-form-item>
            <el-form-item label="手机号码" prop="phone"><el-input v-model="form.phone" :prefix-icon="Phone" placeholder="用于接收服务通知" /></el-form-item>
            <div class="grid-placeholder" />
            <el-form-item label="设置密码" prop="password"><el-input v-model="form.password" :prefix-icon="Lock" type="password" show-password placeholder="至少 6 个字符" /></el-form-item>
            <el-form-item label="确认密码" prop="confirmPassword"><el-input v-model="form.confirmPassword" :prefix-icon="Lock" type="password" show-password placeholder="再次输入密码" /></el-form-item>
          </div>
          <el-checkbox v-model="form.agree">我已阅读并同意《服务条款》和《隐私说明》</el-checkbox>
          <el-button type="primary" size="large" class="submit" :loading="loading" @click="submit">创建账户</el-button>
        </el-form>
        <p>已有账户？<router-link to="/user-login">返回登录</router-link></p>
      </div>
    </section>
  </main>
</template>

<style scoped>
.register-page{min-height:100vh;position:relative;display:grid;place-items:center;padding:78px 24px 50px;background:#f4f7f4}.back-link{position:absolute;top:26px;left:max(24px,calc((100% - 880px)/2));display:flex;align-items:center;gap:7px;color:var(--text-secondary);background:none;border:0;cursor:pointer}.back-link :deep(svg){width:17px}.register-wrap{width:min(880px,100%)}header{display:flex;align-items:center;gap:18px;margin-bottom:26px}header>span{width:54px;height:54px;display:grid;place-items:center;color:#fff;background:var(--brand);border-radius:16px;font-size:25px}header p,header h1,header small{margin:0;display:block}header p{color:var(--brand);font-size:11px;font-weight:800;letter-spacing:.14em}header h1{margin:4px 0;font-size:30px;letter-spacing:-.03em}header small{color:var(--text-muted)}.register-card{padding:36px;background:#fff;border:1px solid var(--border-color);border-radius:24px;box-shadow:var(--shadow-md)}.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:0 22px}.submit{width:100%;margin-top:24px;min-height:48px}.register-card>p{text-align:center;margin:22px 0 0;color:var(--text-secondary);font-size:14px}.register-card>p a{color:var(--brand);font-weight:700}@media(max-width:650px){.register-page{padding-inline:14px}.register-card{padding:26px 18px}.form-grid{grid-template-columns:1fr}.grid-placeholder{display:none}header small{font-size:12px}}
</style>
