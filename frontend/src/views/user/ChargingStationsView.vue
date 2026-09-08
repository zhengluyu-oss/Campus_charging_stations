<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ArrowRight, Lightning, Location, Refresh, Search } from '@element-plus/icons-vue'
import { getAllChargingStations } from '@/api/chargingStationsApi'

const router=useRouter(),loading=ref(false),stations=ref<any[]>([]),keyword=ref(''),status=ref('all'),sort=ref('available')
const normalize=(s:any)=>String(s)==='0'||s==='available'?0:String(s)==='1'||s==='occupied'?1:2
const filtered=computed(()=>stations.value.filter(s=>(!keyword.value||`${s.stationName}${s.location}`.toLowerCase().includes(keyword.value.toLowerCase()))&&(status.value==='all'||normalize(s.status)===Number(status.value))).sort((a,b)=>sort.value==='price'?Number(a.pricePerHour||0)-Number(b.pricePerHour||0):normalize(a.status)-normalize(b.status)))
const available=computed(()=>stations.value.filter(s=>normalize(s.status)===0).length)
const load=async()=>{loading.value=true;try{const r:any=await getAllChargingStations();stations.value=Array.isArray(r?.data)?r.data:[]}finally{loading.value=false}}
onMounted(load)
const meta=(s:any)=>normalize(s)===0?{label:'空闲',class:'available'}:normalize(s)===1?{label:'使用中',class:'busy'}:{label:'维护中',class:'offline'}
</script>

<template>
  <div class="station-page page-enter-active">
    <header class="page-header hero-header">
      <div class="header-copy">
        <p>CHARGING NETWORK / LIVE</p>
        <h1>找到下一站电量</h1>
        <span>全校站点状态实时同步，选择空闲设备即可预约。</span>
      </div>
      <div class="network-count" aria-label="站点实时统计">
        <div><strong class="font-metric">{{ available }}</strong><span>AVAILABLE</span></div>
        <i />
        <div><strong class="font-metric">{{ stations.length }}</strong><span>TOTAL</span></div>
      </div>
    </header>
    <main class="stations-main">
      <section class="toolbar">
        <div class="search-field"><el-input v-model="keyword" :prefix-icon="Search" clearable placeholder="搜索站点或校内位置" /></div>
        <el-segmented v-model="status" :options="[{label:'全部',value:'all'},{label:'空闲',value:'0'},{label:'使用中',value:'1'},{label:'维护',value:'2'}]" />
        <div class="toolbar-actions">
          <el-select v-model="sort" aria-label="排序"><el-option label="空闲优先" value="available"/><el-option label="价格优先" value="price"/></el-select>
          <button type="button" class="refresh-button" aria-label="刷新站点状态" @click="load"><Refresh /></button>
        </div>
      </section>
      <section v-loading="loading" class="station-list">
        <div class="list-labels" aria-hidden="true"><span>状态 / 站点</span><span>位置</span><span>功率</span><span>价格</span><span>操作</span></div>
        <article v-for="(station,index) in filtered" :key="station.stationId">
          <div class="station-identity">
            <span class="row-number">{{ String(index + 1).padStart(2, '0') }}</span>
            <span class="state-light" :class="meta(station.status).class"><i /></span>
            <div><h2>{{ station.stationName }}</h2><small :class="meta(station.status).class">{{ meta(station.status).label }}</small></div>
          </div>
          <p class="location"><Location />{{ station.location || '校园充电区' }}</p>
          <div class="metric"><small>POWER</small><strong>{{ station.powerRating||7 }}<i> kW</i></strong></div>
          <div class="metric"><small>RATE</small><strong>¥{{ Number(station.pricePerHour||.5).toFixed(2) }}<i> / h</i></strong></div>
          <button type="button" class="select-button" :disabled="normalize(station.status)!==0" @click="router.push(`/booking/detail/${station.stationId}`)">
            <span>{{ normalize(station.status)===0?'选择':'不可用' }}</span><ArrowRight />
          </button>
        </article>
        <el-empty v-if="!loading&&!filtered.length" description="没有符合条件的充电站" />
      </section>
    </main>
  </div>
</template>

<style scoped>
.station-page{min-height:calc(100vh - 64px);padding-bottom:64px;background:var(--surface-muted)}
.hero-header{display:flex;align-items:flex-end;justify-content:space-between;gap:40px;padding-top:58px!important;padding-bottom:36px!important}
.header-copy p,.header-copy h1,.header-copy span{margin:0}.header-copy p{color:var(--brand);font-size:11px;font-weight:800;letter-spacing:.18em}.header-copy h1{margin:13px 0 14px;font-size:clamp(42px,6vw,68px);font-weight:650;line-height:1;letter-spacing:-.06em}.header-copy>span{color:var(--text-secondary);font-size:14px}
.network-count{display:flex;align-items:center;gap:24px;padding:8px 0 5px}.network-count>div{display:flex;align-items:flex-end;gap:8px}.network-count strong{font-size:36px;line-height:.9;letter-spacing:-.05em}.network-count span{color:var(--text-muted);font-size:9px;font-weight:800;letter-spacing:.14em}.network-count i{width:1px;height:34px;background:var(--border-color)}
.toolbar{display:grid;grid-template-columns:minmax(240px,1fr) auto auto;gap:12px;align-items:center;padding:10px;margin-bottom:14px;background:var(--surface);border:1px solid var(--border-color);border-radius:12px}.search-field{max-width:420px}.toolbar :deep(.el-input__wrapper),.toolbar :deep(.el-select__wrapper){background:var(--surface-muted)!important;border-radius:8px!important;box-shadow:none!important}.toolbar :deep(.el-segmented){--el-segmented-item-selected-bg-color:var(--text-primary);--el-segmented-item-selected-color:#fff;background:var(--surface-muted);border-radius:8px}.toolbar-actions{display:flex;align-items:center;gap:7px}.toolbar-actions .el-select{width:126px}.refresh-button{width:40px;height:40px;display:grid;place-items:center;color:var(--text-primary);background:var(--surface-muted);border:0;border-radius:8px;cursor:pointer;transition:color .2s,background .2s}.refresh-button:hover{color:#fff;background:var(--brand)}.refresh-button :deep(svg){width:16px}
.station-list{min-height:260px;background:var(--surface);border:1px solid var(--border-color);border-radius:14px;overflow:hidden}.list-labels,.station-list>article{display:grid;grid-template-columns:minmax(260px,1.45fr) minmax(170px,1fr) 110px 120px 116px;align-items:center;gap:18px}.list-labels{min-height:44px;padding:0 20px;color:var(--text-muted);background:#f8f8f9;border-bottom:1px solid var(--border-color);font-size:9px;font-weight:800;letter-spacing:.13em;text-transform:uppercase}.station-list>article{position:relative;min-height:92px;padding:16px 20px;border-bottom:1px solid var(--border-color);transition:background .2s}.station-list>article:last-of-type{border-bottom:0}.station-list>article:hover{background:#f8f9fb}.station-list>article::before{content:'';position:absolute;left:0;top:0;bottom:0;width:3px;background:var(--brand);transform:scaleY(0);transition:transform .2s}.station-list>article:hover::before{transform:scaleY(1)}
.station-identity{display:grid;grid-template-columns:28px 10px 1fr;align-items:center;gap:12px}.row-number{color:#a4a8b0;font-size:10px;font-weight:750;font-variant-numeric:tabular-nums}.state-light{width:8px;height:26px;background:currentColor;border-radius:2px}.state-light.available{color:var(--success)}.state-light.busy{color:var(--warning)}.state-light.offline{color:var(--info)}.station-identity h2,.station-identity small{display:block;margin:0}.station-identity h2{font-size:15px;font-weight:680;letter-spacing:-.02em}.station-identity small{margin-top:5px;font-size:10px;font-weight:700}.station-identity small.available{color:var(--success)}.station-identity small.busy{color:var(--warning)}.station-identity small.offline{color:var(--info)}
.location{display:flex;align-items:center;gap:7px;margin:0;color:var(--text-secondary);font-size:12px}.location :deep(svg){width:14px;color:var(--text-muted)}.metric small,.metric strong{display:block}.metric small{color:var(--text-muted);font-size:8px;font-weight:750;letter-spacing:.12em}.metric strong{margin-top:5px;font-size:14px;font-variant-numeric:tabular-nums}.metric i{color:var(--text-muted);font-size:9px;font-style:normal;font-weight:550}
.select-button{height:40px;display:flex;align-items:center;justify-content:center;gap:9px;color:#fff;background:var(--text-primary);border:0;border-radius:8px;font-size:12px;font-weight:700;cursor:pointer;transition:background .2s,transform .2s}.select-button:hover:not(:disabled){background:var(--brand);transform:translateX(2px)}.select-button:disabled{color:var(--text-muted);background:#eceef1;cursor:not-allowed}.select-button :deep(svg){width:14px}
@media(max-width:940px){.list-labels{display:none}.station-list>article{grid-template-columns:1fr 96px 104px}.station-list .location{grid-column:1}.station-identity{grid-row:1}.metric{grid-row:1}.station-list .select-button{grid-column:3;grid-row:2}.station-list>article>.metric:nth-of-type(2){grid-column:2;grid-row:2}}
@media(max-width:720px){.hero-header{align-items:flex-start;flex-direction:column}.toolbar{grid-template-columns:1fr}.search-field{max-width:none}.toolbar :deep(.el-segmented){overflow-x:auto}.toolbar-actions{display:grid;grid-template-columns:1fr 42px}.toolbar-actions .el-select{width:auto}.station-list{background:transparent;border:0;border-radius:0;overflow:visible}.station-list>article{grid-template-columns:1fr auto;gap:14px;margin-bottom:10px;padding:18px;background:var(--surface);border:1px solid var(--border-color);border-radius:12px}.station-list .location{grid-column:1/-1;grid-row:2}.station-list>article>.metric{grid-row:3}.station-list>article>.metric:nth-of-type(2){grid-column:2;grid-row:3;text-align:right}.station-list .select-button{grid-column:1/-1;grid-row:4}.network-count{width:100%;justify-content:flex-start}}
</style>
