<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ArrowRight, Calendar, Clock, Lightning, Location, Reading, User } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'
import { getAllChargingStations } from '@/api/chargingStationsApi'

const router=useRouter(),store=useUserStore()
const loading=ref(false),stations=ref<any[]>([])
const username=computed(()=>store.user?.username||'校园用户')
const available=computed(()=>stations.value.filter(s=>String(s.status)==='0'||s.status==='available').length)
const busy=computed(()=>stations.value.filter(s=>String(s.status)==='1'||s.status==='occupied').length)
const recommended=computed(()=>stations.value.filter(s=>String(s.status)==='0'||s.status==='available').slice(0,3))
const fetchStations=async()=>{loading.value=true;try{const r:any=await getAllChargingStations();stations.value=Array.isArray(r?.data)?r.data:[]}finally{loading.value=false}}
onMounted(fetchStations)
const statusLabel=(s:any)=>String(s)==='0'||s==='available'?'空闲':'使用中'
</script>

<template>
  <div class="dashboard-page">
    <main class="dashboard-main">
      <section class="welcome-row">
        <div><p>{{ new Date().getHours()<12?'早上好':new Date().getHours()<18?'下午好':'晚上好' }}，{{ username }}</p><h1>今天准备在哪里充电？</h1><span>查看实时状态，选择合适的校园充电桩。</span></div>
        <el-button type="primary" size="large" @click="router.push('/user/use-charger')"><el-icon><Lightning /></el-icon>立即充电</el-button>
      </section>

      <section class="overview-grid">
        <article class="primary-stat"><div><small>全校可用充电桩</small><strong>{{ available }}</strong><span>共 {{ stations.length }} 个站点</span></div><span class="stat-icon"><Lightning /></span></article>
        <article><span class="small-icon green"><Location /></span><div><small>当前使用中</small><strong>{{ busy }} <i>个</i></strong></div></article>
        <article><span class="small-icon amber"><Clock /></span><div><small>服务时间</small><strong>07:00 <i>— 23:00</i></strong></div></article>
      </section>

      <section class="content-grid">
        <div class="stations-panel">
          <div class="section-heading"><div><p>实时站点</p><h2>推荐充电位置</h2></div><button @click="router.push('/user/use-charger')">查看全部 <ArrowRight /></button></div>
          <div v-loading="loading" class="station-list">
            <article v-for="station in recommended" :key="station.stationId" @click="router.push(`/booking/detail/${station.stationId}`)">
              <span class="station-symbol"><Lightning /></span><div class="station-copy"><h3>{{ station.stationName }}</h3><p><Location /> {{ station.location || '校园充电区' }} · {{ station.powerRating || 7 }}kW</p></div><div class="station-price"><strong>¥{{ Number(station.pricePerHour||0.5).toFixed(2) }}</strong><small>/小时</small></div><span class="status-dot"><i />{{ statusLabel(station.status) }}</span><ArrowRight class="arrow" />
            </article>
            <el-empty v-if="!loading&&!recommended.length" description="暂无可用站点" :image-size="70" />
          </div>
        </div>

        <aside class="quick-panel">
          <div class="section-heading"><div><p>常用功能</p><h2>快速入口</h2></div></div>
          <button @click="router.push('/booking')"><span><Calendar /></span><div><strong>预约充电</strong><small>提前选择站点和时间</small></div><ArrowRight /></button>
          <button @click="router.push('/history')"><span><Clock /></span><div><strong>充电记录</strong><small>查看历史时长和费用</small></div><ArrowRight /></button>
          <button @click="router.push('/user/news?mode=view')"><span><Reading /></span><div><strong>校园资讯</strong><small>服务通知与校园动态</small></div><ArrowRight /></button>
          <button @click="router.push('/profile')"><span><User /></span><div><strong>个人资料</strong><small>维护账户联系方式</small></div><ArrowRight /></button>
        </aside>
      </section>
    </main>
  </div>
</template>

<style scoped>
.dashboard-page{min-height:calc(100vh - 72px);padding:50px 0 20px;background:var(--surface-muted)}.welcome-row{display:flex;align-items:flex-end;justify-content:space-between;gap:24px;margin-bottom:34px}.welcome-row p,.welcome-row h1,.welcome-row span{margin:0}.welcome-row p{color:var(--brand);font-size:13px;font-weight:750}.welcome-row h1{margin:8px 0 10px;font-size:36px;letter-spacing:-.045em}.welcome-row span{color:var(--text-secondary)}.overview-grid{display:grid;grid-template-columns:1.45fr 1fr 1fr;gap:16px;margin-bottom:34px}.overview-grid article{min-height:140px;padding:25px;display:flex;align-items:center;gap:18px;background:#fff;border:1px solid var(--border-color);border-radius:18px;box-shadow:var(--shadow-sm)}.overview-grid small,.overview-grid strong,.overview-grid div>span{display:block}.overview-grid small{color:var(--text-muted)}.overview-grid strong{margin-top:10px;font-size:27px;letter-spacing:-.04em}.overview-grid strong i{font-size:13px;font-style:normal;font-weight:500;color:var(--text-muted)}.primary-stat{justify-content:space-between;color:#fff!important;background:#193e2a!important;border-color:#193e2a!important}.primary-stat small,.primary-stat div>span{color:#bbd2c3}.primary-stat strong{font-size:48px}.primary-stat div>span{margin-top:-15px;margin-left:56px;font-size:11px}.stat-icon{width:64px;height:64px;display:grid;place-items:center;color:#183e29;background:#bee877;border-radius:18px}.stat-icon :deep(svg){width:32px}.small-icon{width:44px;height:44px;display:grid;place-items:center;border-radius:13px}.small-icon :deep(svg){width:22px}.small-icon.green{color:var(--brand);background:var(--brand-soft)}.small-icon.amber{color:#b26b0b;background:#fff2dc}.content-grid{display:grid;grid-template-columns:1.7fr .8fr;gap:22px}.stations-panel,.quick-panel{padding:27px;background:#fff;border:1px solid var(--border-color);border-radius:20px;box-shadow:var(--shadow-sm)}.section-heading{display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:18px}.section-heading p,.section-heading h2{margin:0}.section-heading p{color:var(--brand);font-size:11px;font-weight:800;letter-spacing:.09em}.section-heading h2{margin-top:5px;font-size:21px;letter-spacing:-.03em}.section-heading>button{display:flex;align-items:center;gap:5px;color:var(--brand);background:none;border:0;font-weight:650;cursor:pointer}.section-heading>button :deep(svg){width:15px}.station-list>article{display:grid;grid-template-columns:48px 1fr auto 72px 18px;align-items:center;gap:14px;padding:17px 5px;border-top:1px solid #edf1ee;cursor:pointer}.station-list>article:hover .station-copy h3{color:var(--brand)}.station-symbol{width:44px;height:44px;display:grid;place-items:center;color:var(--brand);background:var(--brand-soft);border-radius:13px}.station-symbol :deep(svg){width:22px}.station-copy h3,.station-copy p{margin:0}.station-copy h3{font-size:14px;transition:color .2s}.station-copy p{display:flex;align-items:center;gap:4px;margin-top:6px;color:var(--text-muted);font-size:11px}.station-copy p :deep(svg){width:12px}.station-price strong,.station-price small{display:block}.station-price strong{font-size:14px}.station-price small{color:var(--text-muted);font-size:10px}.status-dot{display:flex;align-items:center;gap:6px;color:var(--success);font-size:11px;font-weight:700}.status-dot i{width:7px;height:7px;background:currentColor;border-radius:50%}.arrow{width:16px;color:#a0aaa4}.quick-panel>button{width:100%;display:grid;grid-template-columns:42px 1fr 16px;align-items:center;gap:12px;padding:14px 4px;text-align:left;color:inherit;background:none;border:0;border-top:1px solid #edf1ee;cursor:pointer}.quick-panel>button>span{width:40px;height:40px;display:grid;place-items:center;color:var(--brand);background:#f0f6f2;border-radius:11px}.quick-panel>button>span :deep(svg){width:19px}.quick-panel strong,.quick-panel small{display:block}.quick-panel strong{font-size:13px}.quick-panel small{margin-top:4px;color:var(--text-muted);font-size:10px}.quick-panel>button>:deep(svg){width:14px;color:#a0aaa4}
@media(max-width:900px){.overview-grid{grid-template-columns:1fr 1fr}.primary-stat{grid-column:1/-1}.content-grid{grid-template-columns:1fr}.quick-panel{display:grid;grid-template-columns:1fr 1fr;gap:0 16px}.quick-panel .section-heading{grid-column:1/-1}}@media(max-width:620px){.dashboard-page{padding-top:32px}.welcome-row{align-items:flex-start;flex-direction:column}.welcome-row h1{font-size:30px}.overview-grid{grid-template-columns:1fr}.primary-stat{grid-column:auto}.content-grid{display:block}.quick-panel{margin-top:16px;display:block}.stations-panel,.quick-panel{padding:20px}.station-list>article{grid-template-columns:44px 1fr auto}.station-price,.arrow{display:none}.status-dot{grid-column:2}}
</style>
