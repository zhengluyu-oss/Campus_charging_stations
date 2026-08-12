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
const recommended=computed(()=>stations.value.filter(s=>String(s.status)==='0'||s.status==='available').slice(0,4))
const availabilityRate=computed(()=>stations.value.length?Math.round(available.value/stations.value.length*100):0)
const fetchStations=async()=>{loading.value=true;try{const r:any=await getAllChargingStations();stations.value=Array.isArray(r?.data)?r.data:[]}finally{loading.value=false}}
onMounted(fetchStations)
const statusLabel=(s:any)=>String(s)==='0'||s==='available'?'空闲':'使用中'
</script>

<template>
  <div class="dashboard-page">
    <main class="dashboard-main">
      <section class="dashboard-hero">
        <div class="hero-copy">
          <p>{{ new Date().getHours()<12?'早上好':new Date().getHours()<18?'下午好':'晚上好' }}，{{ username }}</p>
          <h1>校园能源<br>随时待命。</h1>
          <span>找到合适的充电位，然后出发。</span>
          <div class="hero-actions"><el-button type="primary" size="large" @click="router.push('/user/use-charger')"><Lightning /> 立即充电</el-button><button @click="router.push('/booking')">预约时间 <ArrowRight /></button></div>
        </div>
        <div class="network-status">
          <header><span><i></i> CAMPUS NETWORK</span><b>实时概览</b></header>
          <div class="availability-number"><strong>{{ available }}</strong><span>/ {{ stations.length || 0 }}<small>当前空闲</small></span></div>
          <div class="availability-track"><i :style="{ width: availabilityRate + '%' }"></i></div>
          <div class="network-meta"><span><small>使用中</small><b>{{ busy }}</b></span><span><small>空闲率</small><b>{{ availabilityRate }}%</b></span><span><small>服务至</small><b>23:00</b></span></div>
          <Lightning class="network-mark" />
        </div>
      </section>

      <section class="command-grid">
        <div class="stations-workbench">
          <div class="section-heading"><div><p>LIVE STATIONS</p><h2>推荐充电位置</h2></div><button @click="router.push('/user/charging-stations')">所有站点 <ArrowRight /></button></div>
          <div class="table-head"><span>状态</span><span>站点</span><span>功率</span><span>价格</span><span></span></div>
          <div v-loading="loading" class="station-table">
            <article v-for="station in recommended" :key="station.stationId" @click="router.push(`/booking/detail/${station.stationId}`)">
              <span class="status-cell"><i></i>{{ statusLabel(station.status) }}</span>
              <div class="station-copy"><h3>{{ station.stationName }}</h3><p><Location /> {{ station.location || '校园充电区' }}</p></div>
              <strong>{{ station.powerRating || 7 }} <small>kW</small></strong>
              <strong>¥{{ Number(station.pricePerHour||0.5).toFixed(2) }} <small>/h</small></strong>
              <ArrowRight class="row-arrow" />
            </article>
            <el-empty v-if="!loading&&!recommended.length" description="暂无可用站点" :image-size="70" />
          </div>
        </div>

        <aside class="action-console">
          <header><p>QUICK CONTROL</p><h2>下一步做什么？</h2></header>
          <button class="primary-action" @click="router.push('/user/use-charger')"><span><Lightning /></span><div><strong>开始充电</strong><small>选择空闲设备并设置时长</small></div><ArrowRight /></button>
          <button @click="router.push('/booking')"><span><Calendar /></span><div><strong>预约充电</strong><small>提前安排站点和时间</small></div><ArrowRight /></button>
          <button @click="router.push('/history')"><span><Clock /></span><div><strong>查看记录</strong><small>历史时长与订单费用</small></div><ArrowRight /></button>
        </aside>
      </section>

      <nav class="utility-links" aria-label="其他功能">
        <button @click="router.push('/user/news?mode=view')"><b>01</b><Reading /><span>校园资讯<small>服务通知与校园动态</small></span><ArrowRight /></button>
        <button @click="router.push('/profile')"><b>02</b><User /><span>个人资料<small>账户与联系方式</small></span><ArrowRight /></button>
      </nav>
    </main>
  </div>
</template>

<style scoped>
.dashboard-page{min-height:calc(100vh - 68px);padding:46px 0 20px;background:transparent}.dashboard-hero{display:grid;grid-template-columns:1fr .86fr;gap:70px;align-items:stretch;padding:32px 0 46px;border-bottom:1px solid #cfcec8}.hero-copy{padding:18px 0}.hero-copy>p,.hero-copy h1,.hero-copy>span{margin:0}.hero-copy>p{color:var(--brand);font-size:10px;font-weight:800;letter-spacing:.11em}.hero-copy h1{margin:15px 0 18px;font-size:clamp(52px,6vw,78px);font-weight:650;line-height:.98;letter-spacing:-.066em}.hero-copy>span{color:var(--text-secondary);font-size:15px}.hero-actions{display:flex;align-items:center;gap:24px;margin-top:34px}.hero-actions :deep(.el-button){min-height:48px;padding-inline:22px}.hero-actions>button{display:flex;align-items:center;gap:7px;padding:10px 0;color:var(--ink);background:none;border:0;font-weight:700;cursor:pointer}.hero-actions>button :deep(svg){width:15px}.network-status{position:relative;overflow:hidden;padding:30px;color:#fff;background:radial-gradient(circle at 95% 0,rgba(101,88,250,.35),transparent 34%),linear-gradient(145deg,#11131a,#1a1d28);border:1px solid #272a36;border-radius:14px;box-shadow:0 25px 60px rgba(17,19,26,.16)}.network-status header{display:flex;justify-content:space-between;color:#9296a5;font-size:9px;letter-spacing:.1em}.network-status header span{display:flex;align-items:center;gap:7px}.network-status header i{width:6px;height:6px;background:#8fff75;border-radius:50%;box-shadow:0 0 0 5px rgba(143,255,117,.08)}.network-status header b{color:#b7bac4;font-weight:500}.availability-number{display:flex;align-items:flex-end;margin:40px 0 19px}.availability-number>strong{font-size:90px;font-weight:620;line-height:.78;letter-spacing:-.08em}.availability-number>span{margin-left:14px;color:#747885;font-size:18px}.availability-number small{display:block;margin:7px 0 3px;color:#b5b8c2;font-size:9px;letter-spacing:.08em}.availability-track{height:3px;background:#343744;border-radius:3px}.availability-track i{display:block;height:100%;background:linear-gradient(90deg,#6c79ff,#9a6cf4,#ff7d55);border-radius:3px;transition:width .5s}.network-meta{display:grid;grid-template-columns:repeat(3,1fr);margin-top:29px}.network-meta span{padding-left:14px;border-left:1px solid #30333f}.network-meta small,.network-meta b{display:block}.network-meta small{color:#777b89;font-size:8px}.network-meta b{margin-top:5px;font-size:13px}.network-mark{position:absolute;width:90px;right:22px;top:80px;color:rgba(255,255,255,.035)}
.command-grid{display:grid;grid-template-columns:1.55fr .75fr;gap:26px;padding-top:48px}.stations-workbench{padding:0;background:#fff;border:1px solid var(--border-color);border-radius:12px}.section-heading{display:flex;justify-content:space-between;align-items:flex-end;padding:25px 25px 20px}.section-heading p,.section-heading h2{margin:0}.section-heading p{color:var(--brand);font-size:9px;font-weight:800;letter-spacing:.13em}.section-heading h2{margin-top:6px;font-size:22px;letter-spacing:-.035em}.section-heading>button{display:flex;align-items:center;gap:6px;padding:0;color:var(--brand);background:none;border:0;font-size:11px;font-weight:700;cursor:pointer}.section-heading>button :deep(svg){width:13px}.table-head,.station-table article{display:grid;grid-template-columns:90px 1fr 78px 95px 18px;align-items:center;gap:12px}.table-head{padding:11px 25px;color:#989aa1;background:#f6f5f2;border-top:1px solid #e5e4df;border-bottom:1px solid #e5e4df;font-size:8px;letter-spacing:.08em}.station-table article{min-height:86px;padding:12px 25px;border-bottom:1px solid #e9e8e4;cursor:pointer;transition:background .18s}.station-table article:last-child{border-bottom:0}.station-table article:hover{background:#f7f7ff}.status-cell{display:flex;align-items:center;gap:7px;color:var(--success);font-size:10px;font-weight:700}.status-cell i{width:7px;height:7px;background:currentColor;border-radius:50%}.station-copy h3,.station-copy p{margin:0}.station-copy h3{font-size:13px}.station-copy p{display:flex;align-items:center;gap:4px;margin-top:6px;color:var(--text-muted);font-size:9px}.station-copy p :deep(svg){width:11px}.station-table article>strong{font-size:12px}.station-table article>strong small{color:var(--text-muted);font-size:8px}.row-arrow{width:14px;color:#9a9ca4}
.action-console{padding:28px 25px;color:#fff;background:#11131a;border:1px solid #262936;border-radius:12px}.action-console header{padding-bottom:21px;border-bottom:1px solid #30323c}.action-console header p,.action-console header h2{margin:0}.action-console header p{color:#7d87ff;font-size:9px;font-weight:800;letter-spacing:.12em}.action-console header h2{margin-top:6px;font-size:21px}.action-console>button{width:100%;display:grid;grid-template-columns:38px 1fr 14px;align-items:center;gap:11px;padding:17px 0;color:#fff;background:none;border:0;border-bottom:1px solid #2b2e38;text-align:left;cursor:pointer}.action-console>button>span{width:36px;height:36px;display:grid;place-items:center;color:#8d96ff;background:#24283b;border-radius:8px}.action-console>button>span :deep(svg){width:17px}.action-console>button strong,.action-console>button small{display:block}.action-console>button strong{font-size:12px}.action-console>button small{margin-top:4px;color:#797d89;font-size:9px}.action-console>button>:deep(svg){width:13px;color:#696d78}.action-console>button:hover strong{color:#9ea6ff}.action-console>button.primary-action>span{color:#11131a;background:#8fff75}
.utility-links{display:grid;grid-template-columns:1fr 1fr;margin-top:26px;border-top:1px solid #cfcec8;border-bottom:1px solid #cfcec8}.utility-links button{min-height:95px;display:grid;grid-template-columns:34px 32px 1fr 18px;align-items:center;gap:14px;padding:12px 25px;color:inherit;background:none;border:0;text-align:left;cursor:pointer}.utility-links button+button{border-left:1px solid #cfcec8}.utility-links b{color:#9b9da4;font-size:9px}.utility-links button>:deep(svg){width:20px;color:var(--brand)}.utility-links button>span{font-size:13px;font-weight:700}.utility-links small{display:block;margin-top:5px;color:var(--text-muted);font-size:9px;font-weight:400}.utility-links button>:deep(svg:last-child){width:14px;color:#989aa2}.utility-links button:hover{background:#fff}
@media(max-width:950px){.dashboard-hero{grid-template-columns:1fr;gap:30px}.network-status{max-width:660px}.command-grid{grid-template-columns:1fr}.action-console{display:grid;grid-template-columns:repeat(3,1fr);gap:0 18px}.action-console header{grid-column:1/-1}.action-console>button{grid-template-columns:38px 1fr}.action-console>button>:deep(svg){display:none}}
@media(max-width:650px){.dashboard-page{padding-top:22px}.dashboard-hero{gap:20px;padding-bottom:32px}.hero-copy h1{font-size:49px}.network-status{padding:23px}.availability-number>strong{font-size:72px}.command-grid{padding-top:32px}.table-head{display:none}.station-table article{grid-template-columns:70px 1fr 18px;padding:14px 18px}.station-table article>strong{display:none}.section-heading{padding-inline:18px}.action-console{display:block}.utility-links{grid-template-columns:1fr}.utility-links button+button{border-left:0;border-top:1px solid #cfcec8}}
</style>
