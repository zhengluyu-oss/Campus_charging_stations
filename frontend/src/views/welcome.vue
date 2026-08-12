<script setup lang="ts">
import { useRouter } from 'vue-router'
import { ArrowRight, Calendar, CircleCheck, Clock, Lightning, Location, TrendCharts } from '@element-plus/icons-vue'
const router = useRouter()
const features = [
  { icon: Location, title: '查看站点', desc: '按校区位置和实时状态快速筛选' },
  { icon: Calendar, title: '提前预约', desc: '规划充电时间，减少现场等待' },
  { icon: TrendCharts, title: '记录清晰', desc: '充电时长与费用记录随时可查' },
]
</script>

<template>
  <main class="landing">
    <nav class="landing-nav">
      <div class="landing-brand"><span><Lightning /></span><strong>校园充电</strong></div>
      <div class="nav-actions"><el-button text @click="router.push('/user-login')">登录</el-button><el-button type="primary" @click="router.push('/user-register')">创建账户</el-button></div>
    </nav>

    <section class="hero">
      <div class="hero-copy">
        <div class="eyebrow"><CircleCheck /> 校园绿色出行服务</div>
        <h1>让每一次充电<br><em>简单、安心、可掌控</em></h1>
        <p>统一查看校园充电桩状态，快速开始充电或提前预约。少一些等待，多一点从容。</p>
        <div class="hero-actions">
          <el-button type="primary" size="large" @click="router.push('/user-login')">开始使用 <el-icon><ArrowRight /></el-icon></el-button>
          <el-button size="large" @click="router.push('/user-register')">注册校园账户</el-button>
        </div>
        <div class="trust-row"><span><CircleCheck /> 状态实时更新</span><span><CircleCheck /> 账户安全保护</span><span><CircleCheck /> 充电记录可追溯</span></div>
      </div>

      <div class="hero-preview" aria-label="系统功能预览">
        <div class="preview-top"><span>站点概览</span><span class="live"><i /> 实时</span></div>
        <div class="availability"><div><small>当前可用</small><strong>12</strong><span>个充电桩</span></div><span class="bolt"><Lightning /></span></div>
        <div class="mini-stations">
          <article><span class="status available" /><div><strong>图书馆充电区</strong><small><Location /> 北院 · 7kW</small></div><b>可用</b></article>
          <article><span class="status busy" /><div><strong>综合楼充电区</strong><small><Location /> 南院 · 14kW</small></div><b class="busy-text">使用中</b></article>
          <article><span class="status available" /><div><strong>学生公寓充电区</strong><small><Location /> 东院 · 7kW</small></div><b>可用</b></article>
        </div>
        <button type="button" @click="router.push('/user-login')">查看全部站点 <ArrowRight /></button>
      </div>
    </section>

    <section class="feature-strip">
      <article v-for="feature in features" :key="feature.title"><span><component :is="feature.icon" /></span><div><h2>{{ feature.title }}</h2><p>{{ feature.desc }}</p></div></article>
      <div class="service-time"><Clock /><div><small>每日服务时间</small><strong>07:00—23:00</strong></div></div>
    </section>
  </main>
</template>

<style scoped>
.landing { min-height: 100vh; overflow: hidden; background: #f8faf8; }
.landing-nav { width: min(1220px, calc(100% - 48px)); height: 82px; margin: auto; display: flex; align-items: center; justify-content: space-between; }
.landing-brand { display: flex; align-items: center; gap: 11px; font-size: 18px; }
.landing-brand span { width: 38px; height: 38px; display: grid; place-items: center; color: #fff; background: var(--brand); border-radius: 12px; }
.nav-actions { display: flex; gap: 8px; }
.hero { width: min(1220px, calc(100% - 48px)); min-height: 650px; margin: auto; display: grid; grid-template-columns: 1.05fr .95fr; align-items: center; gap: 80px; padding: 64px 0 90px; }
.eyebrow { width: fit-content; display: flex; align-items: center; gap: 8px; padding: 8px 12px; color: var(--brand-dark); background: var(--brand-soft); border-radius: 999px; font-size: 13px; font-weight: 700; }
.eyebrow :deep(svg) { width: 16px; }
h1 { margin: 26px 0 24px; font-size: clamp(44px, 6.2vw, 76px); line-height: 1.06; letter-spacing: -.065em; font-weight: 780; }
h1 em { color: var(--brand); font-style: normal; }
.hero-copy > p { max-width: 600px; margin: 0; color: var(--text-secondary); font-size: 18px; line-height: 1.8; }
.hero-actions { display: flex; gap: 12px; margin-top: 36px; }
.hero-actions .el-button { min-height: 50px; padding-inline: 24px; }
.trust-row { display: flex; flex-wrap: wrap; gap: 18px; margin-top: 36px; color: var(--text-secondary); font-size: 13px; }
.trust-row span { display: flex; align-items: center; gap: 6px; }.trust-row :deep(svg) { width: 15px; color: var(--brand); }
.hero-preview { position: relative; padding: 26px; background: #fff; border: 1px solid var(--border-color); border-radius: 28px; box-shadow: 0 30px 80px rgba(25,68,43,.14); }
.hero-preview::before { content: ''; position: absolute; z-index: -1; width: 380px; height: 380px; right: -150px; top: -120px; background: #dff1e6; border-radius: 50%; filter: blur(3px); }
.preview-top { display: flex; justify-content: space-between; font-weight: 700; }.live { display: flex; align-items: center; gap: 6px; color: var(--success); font-size: 12px; }.live i { width: 7px; height: 7px; background: currentColor; border-radius: 50%; }
.availability { margin: 22px 0; padding: 24px; display: flex; align-items: center; justify-content: space-between; color: #fff; background: #183c29; border-radius: 20px; }.availability small,.availability strong,.availability div span { display: block; }.availability small { color: #b8d1c0; }.availability strong { margin: 4px 0 0; font-size: 48px; line-height: 1; }.availability div span { margin-top: -15px; margin-left: 62px; color: #b8d1c0; font-size: 12px; }.bolt { width: 62px; height: 62px; display: grid; place-items: center; color: #173e29; background: #b9e36e; border-radius: 18px; }.bolt :deep(svg) { width: 32px; }
.mini-stations { display: grid; gap: 4px; }.mini-stations article { display: grid; grid-template-columns: 12px 1fr auto; align-items: center; gap: 12px; padding: 15px 10px; border-bottom: 1px solid #edf1ee; }.status { width: 9px; height: 9px; border-radius: 50%; }.status.available { background: var(--success); box-shadow: 0 0 0 4px #e4f4ea; }.status.busy { background: var(--warning); box-shadow: 0 0 0 4px #f9eedc; }.mini-stations strong,.mini-stations small { display: block; }.mini-stations strong { font-size: 14px; }.mini-stations small { margin-top: 5px; display: flex; align-items: center; gap: 4px; color: var(--text-muted); font-size: 11px; }.mini-stations small :deep(svg) { width: 12px; }.mini-stations b { color: var(--success); font-size: 12px; }.mini-stations .busy-text { color: var(--warning); }.hero-preview > button { width: 100%; margin-top: 18px; padding: 13px; display: flex; align-items: center; justify-content: center; gap: 8px; color: var(--brand-dark); background: var(--brand-soft); border: 0; border-radius: 11px; font-weight: 700; cursor: pointer; }.hero-preview > button :deep(svg) { width: 15px; }
.feature-strip { width: min(1220px, calc(100% - 48px)); margin: 0 auto 48px; padding: 24px 0; display: grid; grid-template-columns: repeat(3, 1fr) 1.1fr; gap: 20px; border-top: 1px solid var(--border-color); }.feature-strip article,.service-time { display: flex; align-items: center; gap: 13px; padding: 10px 18px; }.feature-strip article > span { width: 42px; height: 42px; flex: 0 0 auto; display: grid; place-items: center; color: var(--brand); background: var(--brand-soft); border-radius: 12px; }.feature-strip article > span :deep(svg) { width: 21px; }.feature-strip h2,.feature-strip p { margin: 0; }.feature-strip h2 { font-size: 14px; }.feature-strip p { margin-top: 5px; color: var(--text-muted); font-size: 11px; line-height: 1.4; }.service-time { justify-content: center; border-left: 1px solid var(--border-color); }.service-time > :deep(svg) { width: 23px; color: var(--brand); }.service-time small,.service-time strong { display: block; }.service-time small { color: var(--text-muted); font-size: 11px; }.service-time strong { margin-top: 4px; font-size: 14px; }
@media(max-width:900px){.hero{grid-template-columns:1fr;gap:50px;padding-top:40px}.hero-copy{text-align:center}.hero-copy>p{margin-inline:auto}.eyebrow,.hero-actions{margin-inline:auto}.hero-actions,.trust-row{justify-content:center}.hero-preview{max-width:600px;margin:auto}.feature-strip{grid-template-columns:1fr 1fr}.service-time{border-left:0}}
@media(max-width:600px){.landing-nav,.hero,.feature-strip{width:calc(100% - 28px)}.landing-nav{height:70px}.nav-actions .el-button:first-child{display:none}.hero{padding:38px 0 64px}.hero-actions{flex-direction:column}.trust-row{align-items:flex-start;flex-direction:column}.hero-preview{padding:16px;border-radius:20px}.feature-strip{grid-template-columns:1fr}.service-time{justify-content:flex-start}.availability{padding:20px}}
</style>
