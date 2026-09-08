<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Calendar, Location, Search } from '@element-plus/icons-vue'
import { getAllChargingStations, reserveChargingStation } from '@/api/chargingStationsApi'
import { useUserStore } from '@/stores/user'
import HeatStrip from '@/viz/charts/HeatStrip.vue'

const router = useRouter()
const store = useUserStore()
const loading = ref(false)
const stations = ref<any[]>([])
const keyword = ref('')
const occupancy = ref([0.2, 0.35, 0.55, 0.7, 0.85, 0.6, 0.4, 0.25, 0.15, 0.3, 0.5, 0.65])
const labels = ['8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19']

const free = (s: any) => String(s) === '0' || s === 'available'
const filtered = computed(() =>
  stations.value.filter(
    (s) => free(s.status) && (!keyword.value || `${s.stationName}${s.location}`.includes(keyword.value))
  )
)

onMounted(async () => {
  loading.value = true
  try {
    const r: any = await getAllChargingStations()
    stations.value = Array.isArray(r?.data) ? r.data : []
  } finally {
    loading.value = false
  }
})

const reserve = async (s: any) => {
  if (!store.user?.id) {
    router.push('/user-login')
    return
  }
  try {
    const delay = await ElMessageBox.prompt('多少分钟后开始充电？', '预约开始时间', {
      inputValue: '30',
      inputPattern: /^([1-9]|[1-9]\d|[1-9]\d{2}|1[0-3]\d{2}|1440)$/,
      inputErrorMessage: '请输入 1—1440 分钟',
    })
    const duration = await ElMessageBox.prompt('计划充电多长时间？', '设置充电时长', {
      inputValue: '60',
      inputPattern: /^([1-9]|[1-9]\d|1[0-7]\d|180)$/,
      inputErrorMessage: '请输入 1—180 分钟',
    })
    await reserveChargingStation(store.user.id, s.stationId, Number(delay.value), Number(duration.value))
    ElMessage.success('预约成功')
    router.push('/user-dashboard')
  } catch (e) {
    if (e !== 'cancel' && e !== 'close') console.error(e)
  }
}
</script>

<template>
  <div class="book-page page-enter-active">
    <header class="page-header">
      <p>RESERVATION</p>
      <h1>预约充电</h1>
      <span>提前选择空闲站点，规划你的充电时间</span>
    </header>
    <main class="booking-main">
      <div class="notice">
        <Calendar />
        <div>
          <strong>预约说明</strong>
          <span>选择站点后依次填写开始等待时间与充电时长，最长可提前 24 小时预约。</span>
        </div>
      </div>

      <section class="heat-card glass-panel">
        <div class="heat-head">
          <strong class="font-display">今日时段热力</strong>
          <small>示意占用强度（8:00—19:00）</small>
        </div>
        <HeatStrip :values="occupancy" :labels="labels" />
      </section>

      <el-input
        v-model="keyword"
        class="search"
        :prefix-icon="Search"
        clearable
        placeholder="搜索站点名称或位置"
      />
      <section v-loading="loading" class="list">
        <article v-for="s in filtered" :key="s.stationId">
          <span class="icon"><Calendar /></span>
          <div>
            <h2>{{ s.stationName }}</h2>
            <p><Location />{{ s.location || '校园充电区' }}</p>
          </div>
          <span class="price"
            >¥{{ Number(s.pricePerHour || 0.5).toFixed(2) }}<small>/小时</small></span
          >
          <el-button type="primary" plain @click="reserve(s)">预约</el-button>
        </article>
        <el-empty v-if="!loading && !filtered.length" description="暂无可预约站点" />
      </section>
    </main>
  </div>
</template>

<style scoped>
.book-page {
  min-height: calc(100vh - 68px);
  padding-bottom: 50px;
  background: transparent;
}
.page-header p,
.page-header h1,
.page-header span {
  margin: 0;
}
.page-header p {
  color: var(--brand-cyan);
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 0.13em;
}
.page-header h1 {
  margin: 8px 0 9px;
}
.page-header span {
  color: var(--text-secondary);
}
.notice {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 17px 19px;
  color: var(--text-primary);
  background: rgba(0, 229, 255, 0.08);
  border: 1px solid rgba(0, 229, 255, 0.22);
  border-radius: 10px;
}
.notice > :deep(svg) {
  width: 21px;
  color: var(--brand-cyan);
}
.notice strong,
.notice span {
  display: block;
}
.notice span {
  margin-top: 4px;
  color: var(--text-secondary);
  font-size: 11px;
}
.heat-card {
  margin-top: 16px;
  padding: 14px 16px 16px;
}
.heat-head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 10px;
}
.heat-head strong {
  font-size: 12px;
  letter-spacing: 0.08em;
}
.heat-head small {
  color: var(--text-muted);
  font-size: 11px;
}
.search {
  max-width: 480px;
  margin: 20px 0;
}
.list {
  min-height: 220px;
  border-top: 1px solid var(--border-color);
}
.list article {
  display: grid;
  grid-template-columns: 42px 1fr 120px 88px;
  align-items: center;
  gap: 16px;
  min-height: 92px;
  padding: 15px 12px;
  border-bottom: 1px solid var(--border-color);
  transition: background 0.18s;
}
.list article:hover {
  background: rgba(0, 229, 255, 0.05);
}
.icon {
  width: 38px;
  height: 38px;
  display: grid;
  place-items: center;
  color: var(--brand-cyan);
  background: var(--brand-soft);
  border-radius: 8px;
}
.list h2,
.list p {
  margin: 0;
}
.list h2 {
  font-size: 14px;
}
.list p {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-top: 6px;
  color: var(--text-muted);
  font-size: 10px;
}
.price {
  font-size: 13px;
  font-weight: 750;
  font-family: var(--font-display);
}
.price small {
  color: var(--text-muted);
  font-size: 9px;
  font-weight: 500;
}
@media (max-width: 600px) {
  .list article {
    grid-template-columns: 38px 1fr;
  }
  .price {
    grid-column: 2;
  }
  .list .el-button {
    grid-column: 1 / -1;
  }
}
</style>
