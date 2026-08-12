<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { ArrowLeft, ArrowRight, Lock, Message, Phone, User } from '@element-plus/icons-vue'
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
    <aside class="register-intro">
      <div class="brand"><span><i></i><i></i></span><strong>CAMPUS<br>CHARGE</strong></div>
      <div class="intro-copy"><p>JOIN THE CAMPUS NETWORK</p><h1>一个账户，<br><em>连接完整旅程。</em></h1><span>创建账户后，你可以查询站点状态、预约充电时间并统一管理每次记录。</span></div>
      <ol><li><b>01</b><span>查找空闲站点</span></li><li><b>02</b><span>安排充电时间</span></li><li><b>03</b><span>查看历史记录</span></li></ol>
    </aside>
    <section class="form-panel">
      <div class="form-wrap">
        <header><p>账户注册</p><h2>创建校园账户</h2><span>请填写真实可用的联系信息</span></header>
        <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
          <div class="form-grid">
            <el-form-item label="用户名" prop="username"><el-input v-model="form.username" :prefix-icon="User" placeholder="3—20 个字符" /></el-form-item>
            <el-form-item label="电子邮箱" prop="email"><el-input v-model="form.email" :prefix-icon="Message" placeholder="name@example.com" /></el-form-item>
            <el-form-item label="手机号码" prop="phone"><el-input v-model="form.phone" :prefix-icon="Phone" placeholder="用于接收服务通知" /></el-form-item>
            <el-form-item label="设置密码" prop="password"><el-input v-model="form.password" :prefix-icon="Lock" type="password" show-password placeholder="至少 6 个字符" /></el-form-item>
            <el-form-item label="确认密码" prop="confirmPassword" class="span-two"><el-input v-model="form.confirmPassword" :prefix-icon="Lock" type="password" show-password placeholder="再次输入密码" /></el-form-item>
          </div>
          <el-checkbox v-model="form.agree">我已阅读并同意《服务条款》和《隐私说明》</el-checkbox>
          <el-button type="primary" size="large" class="submit" :loading="loading" @click="submit">创建账户 <ArrowRight /></el-button>
        </el-form>
        <p class="switch-auth">已有账户？<router-link to="/user-login">返回登录</router-link></p>
      </div>
    </section>
  </main>
</template>

<style scoped>
.register-page{min-height:100vh;position:relative;display:grid;grid-template-columns:.75fr 1.25fr;background:#fff}.back-link{position:absolute;z-index:3;top:28px;left:32px;display:flex;align-items:center;gap:7px;padding:8px 10px;color:#c2c4cd;background:rgba(255,255,255,.07);border:1px solid rgba(255,255,255,.1);border-radius:7px;cursor:pointer}.back-link :deep(svg){width:16px}.register-intro{position:relative;overflow:hidden;padding:34px 48px;color:#fff;background:radial-gradient(circle at 120% 78%,rgba(83,98,246,.35),transparent 40%),#0d0f15}.register-intro::before{content:'';position:absolute;inset:0;opacity:.12;background-image:linear-gradient(rgba(255,255,255,.12) 1px,transparent 1px),linear-gradient(90deg,rgba(255,255,255,.12) 1px,transparent 1px);background-size:52px 52px;mask-image:linear-gradient(135deg,#000,transparent 82%)}.brand{position:relative;margin-left:120px;display:flex;align-items:center;gap:10px}.brand>span{position:relative;width:30px;height:30px;background:var(--brand);border-radius:6px}.brand i{position:absolute;top:5px;width:5px;height:20px;background:#fff;transform:skew(-18deg)}.brand i:first-child{left:8px}.brand i:last-child{right:7px;opacity:.4}.brand strong{font-size:10px;line-height:1.05;letter-spacing:.14em}.intro-copy{position:relative;margin-top:20vh}.intro-copy p{margin:0 0 20px;color:#8993ff;font-size:9px;font-weight:800;letter-spacing:.14em}.intro-copy h1{margin:0;font-size:clamp(44px,4.5vw,67px);font-weight:630;line-height:1.03;letter-spacing:-.063em}.intro-copy em{color:#8c96ff;font-style:normal}.intro-copy>span{display:block;max-width:440px;margin-top:25px;color:#acaeb7;font-size:14px;line-height:1.8}.register-intro ol{position:absolute;left:48px;right:48px;bottom:45px;margin:0;padding:0;display:grid;grid-template-columns:repeat(3,1fr);border-top:1px solid rgba(255,255,255,.14);list-style:none}.register-intro li{padding-top:15px}.register-intro li b,.register-intro li span{display:block}.register-intro li b{color:#72757f;font-size:9px}.register-intro li span{margin-top:5px;font-size:10px}.form-panel{display:grid;place-items:center;padding:76px 6vw}.form-wrap{width:min(680px,100%)}.form-wrap header{margin-bottom:32px}.form-wrap header p{margin:0;color:var(--brand);font-size:10px;font-weight:800;letter-spacing:.14em}.form-wrap header h2{margin:10px 0 9px;font-size:39px;line-height:1;letter-spacing:-.05em}.form-wrap header span{color:var(--text-muted);font-size:13px}.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:0 20px}.span-two{grid-column:1/-1}.form-wrap :deep(.el-form-item){margin-bottom:20px}.form-wrap :deep(.el-form-item__label){font-size:12px;font-weight:700}.form-wrap :deep(.el-input__wrapper){min-height:48px;background:#f7f7f6!important}.submit{width:100%;min-height:50px;margin-top:23px}.switch-auth{text-align:center;margin:22px 0 0;color:var(--text-secondary);font-size:13px}.switch-auth a{color:var(--brand);font-weight:750}
@media(max-width:930px){.register-page{grid-template-columns:1fr}.register-intro{min-height:300px;padding:28px}.brand{margin-left:105px}.intro-copy{margin-top:95px}.intro-copy h1{font-size:42px}.intro-copy>span,.register-intro ol{display:none}.form-panel{padding:54px 24px 70px}.back-link{top:24px;left:20px}}
@media(max-width:600px){.form-grid{grid-template-columns:1fr}.span-two{grid-column:auto}.form-panel{padding-inline:18px}.form-wrap header h2{font-size:32px}.register-intro{min-height:250px}.intro-copy{margin-top:75px}.intro-copy h1{font-size:36px}}
</style>
