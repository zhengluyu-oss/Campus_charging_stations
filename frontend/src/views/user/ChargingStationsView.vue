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
  <div class="station-page">
    <header class="page-header hero-header"><div><p>CHARGING NETWORK</p><h1>校园充电站</h1><span>共 {{ stations.length }} 个站点，当前 {{ available }} 个空闲</span></div><el-button :icon="Refresh" @click="load">刷新状态</el-button></header>
    <main class="stations-main">
      <section class="toolbar">
        <el-input v-model="keyword" :prefix-icon="Search" clearable placeholder="搜索站点名称或位置" />
        <el-segmented v-model="status" :options="[{label:'全部',value:'all'},{label:'空闲',value:'0'},{label:'使用中',value:'1'},{label:'维护中',value:'2'}]" />
        <el-select v-model="sort" aria-label="排序"><el-option label="空闲优先" value="available"/><el-option label="价格从低到高" value="price"/></el-select>
      </section>
      <section v-loading="loading" class="station-grid">
        <article v-for="station in filtered" :key="station.stationId">
          <div class="card-top"><span class="charger-icon"><Lightning /></span><span class="state" :class="meta(station.status).class"><i/>{{ meta(station.status).label }}</span></div>
          <h2>{{ station.stationName }}</h2><p class="location"><Location />{{ station.location || '校园充电区' }}</p>
          <div class="specs"><div><small>充电功率</small><strong>{{ station.powerRating||7 }} kW</strong></div><div><small>计费标准</small><strong>¥{{ Number(station.pricePerHour||.5).toFixed(2) }}<i>/小时</i></strong></div></div>
          <button type="button" :disabled="normalize(station.status)!==0" @click="router.push(`/booking/detail/${station.stationId}`)">{{ normalize(station.status)===0?'选择站点':'暂不可用' }}<ArrowRight /></button>
        </article>
        <el-empty v-if="!loading&&!filtered.length" description="没有符合条件的充电站" />
      </section>
    </main>
  </div>
</template>

<style scoped>
.station-page{min-height:calc(100vh - 72px);padding-bottom:40px;background:var(--surface-muted)}.hero-header{display:flex;align-items:flex-end;justify-content:space-between}.hero-header p,.hero-header h1,.hero-header span{margin:0}.hero-header p{color:var(--brand);font-size:11px;font-weight:800;letter-spacing:.11em}.hero-header h1{margin:7px 0 9px}.hero-header span{color:var(--text-secondary)}.toolbar{display:grid;grid-template-columns:minmax(250px,1fr) auto 180px;gap:14px;align-items:center;padding:16px;margin-bottom:20px;background:#fff;border:1px solid var(--border-color);border-radius:16px}.station-grid{min-height:260px;display:grid;grid-template-columns:repeat(3,1fr);gap:16px}.station-grid>article{padding:23px;background:#fff;border:1px solid var(--border-color);border-radius:18px;box-shadow:var(--shadow-sm);transition:transform .2s,border-color .2s,box-shadow .2s}.station-grid>article:hover{transform:translateY(-3px);border-color:var(--border-hover);box-shadow:var(--shadow-md)}.card-top{display:flex;align-items:center;justify-content:space-between}.charger-icon{width:44px;height:44px;display:grid;place-items:center;color:var(--brand);background:var(--brand-soft);border-radius:13px}.charger-icon :deep(svg){width:23px}.state{display:flex;align-items:center;gap:6px;padding:6px 9px;border-radius:999px;font-size:11px;font-weight:700}.state i{width:6px;height:6px;background:currentColor;border-radius:50%}.state.available{color:var(--success);background:#e9f6ee}.state.busy{color:var(--warning);background:#fff3e1}.state.offline{color:var(--info);background:#edf1ef}.station-grid h2{margin:20px 0 8px;font-size:18px;letter-spacing:-.02em}.location{display:flex;align-items:center;gap:6px;margin:0;color:var(--text-muted);font-size:13px}.location :deep(svg){width:14px}.specs{display:grid;grid-template-columns:1fr 1fr;margin:22px 0;padding:15px 0;border-block:1px solid #edf1ee}.specs>div+div{padding-left:18px;border-left:1px solid #edf1ee}.specs small,.specs strong{display:block}.specs small{color:var(--text-muted);font-size:10px}.specs strong{margin-top:6px;font-size:14px}.specs i{color:var(--text-muted);font-size:10px;font-style:normal;font-weight:500}.station-grid article>button{width:100%;display:flex;align-items:center;justify-content:center;gap:7px;padding:12px;color:#fff;background:var(--brand);border:0;border-radius:10px;font-weight:700;cursor:pointer}.station-grid article>button:disabled{color:var(--text-muted);background:#edf1ef;cursor:not-allowed}.station-grid article>button :deep(svg){width:15px}@media(max-width:950px){.station-grid{grid-template-columns:1fr 1fr}.toolbar{grid-template-columns:1fr 180px}.toolbar .el-segmented{grid-column:1/-1;grid-row:2}}@media(max-width:640px){.hero-header{align-items:flex-start;flex-direction:column;gap:18px}.toolbar{grid-template-columns:1fr}.toolbar .el-segmented{grid-column:auto;grid-row:auto;overflow:auto}.station-grid{grid-template-columns:1fr}}
</style>
