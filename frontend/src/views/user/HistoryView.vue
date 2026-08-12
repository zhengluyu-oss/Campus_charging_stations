<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import { getChargingHistory } from '@/api/chargingStationsApi'
import { useUserStore } from '@/stores/user'

const store = useUserStore()
const loading = ref(false)
const rows = ref<any[]>([])
const keyword = ref('')

const formatDate = (value: unknown) => {
  if (!value) return '—'
  const text = String(value).replace('T', ' ')
  return text.slice(0, 16)
}

const dateParts = (value: unknown) => {
  const text = formatDate(value)
  if (text === '—') return { date: '日期待确认', time: '—' }
  const [date, time] = text.split(' ')
  return { date, time: time || '—' }
}

const duration = (row: any) => Number(row.durationMinutes ?? row.duration_minutes ?? 0)
const amount = (row: any) => Number(row.totalAmount ?? row.amount ?? 0)
const stationName = (row: any) =>
  row.stationName || `充电桩 #${row.stationId ?? row.station_id ?? '—'}`

const filtered = computed(() => {
  const query = keyword.value.trim().toLowerCase()
  if (!query) return rows.value
  return rows.value.filter((row) =>
    `${stationName(row)} ${formatDate(row.startTime || row.start_time)}`
      .toLowerCase()
      .includes(query),
  )
})

const totalMinutes = computed(() =>
  rows.value.reduce((total, row) => total + duration(row), 0),
)
const totalAmount = computed(() =>
  rows.value.reduce((total, row) => total + amount(row), 0),
)
const averageMinutes = computed(() =>
  rows.value.length ? Math.round(totalMinutes.value / rows.value.length) : 0,
)

onMounted(async () => {
  if (!store.user?.id) return
  loading.value = true
  try {
    const response: any = await getChargingHistory(store.user.id)
    rows.value = Array.isArray(response?.data) ? response.data : []
  } catch {
    ElMessage.error('充电记录加载失败')
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="history-page">
    <header class="page-header history-header">
      <div>
        <p class="eyebrow">CHARGING LEDGER</p>
        <h1>充电记录</h1>
      </div>
      <p class="intro">每一次补能，都清晰可查。</p>
    </header>

    <main class="history-main">
      <section class="ledger" aria-label="充电数据概览">
        <div class="ledger-label">
          <span>账户累计</span>
          <small>已完成的充电服务</small>
        </div>
        <dl>
          <div>
            <dt>充电次数</dt>
            <dd>{{ rows.length }}<small>次</small></dd>
          </div>
          <div>
            <dt>累计时长</dt>
            <dd>{{ (totalMinutes / 60).toFixed(1) }}<small>小时</small></dd>
          </div>
          <div>
            <dt>平均时长</dt>
            <dd>{{ averageMinutes }}<small>分钟</small></dd>
          </div>
          <div>
            <dt>累计费用</dt>
            <dd><small>¥</small>{{ totalAmount.toFixed(2) }}</dd>
          </div>
        </dl>
      </section>

      <section class="activity">
        <header class="activity-head">
          <div>
            <span class="section-index">01</span>
            <div>
              <h2>历史明细</h2>
              <p>{{ filtered.length }} 条记录，按最近充电时间展示</p>
            </div>
          </div>
          <el-input
            v-model="keyword"
            :prefix-icon="Search"
            clearable
            placeholder="搜索站点或日期"
            aria-label="搜索充电记录"
          />
        </header>

        <div v-loading="loading" class="timeline">
          <article v-for="(row, index) in filtered" :key="row.id ?? index" class="timeline-row">
            <div class="timeline-date">
              <strong>{{ dateParts(row.startTime || row.start_time).date }}</strong>
              <span>{{ dateParts(row.startTime || row.start_time).time }}</span>
            </div>
            <div class="timeline-marker" aria-hidden="true"><i /></div>
            <div class="timeline-content">
              <div class="station">
                <span>已完成</span>
                <h3>{{ stationName(row) }}</h3>
              </div>
              <dl>
                <div>
                  <dt>时长</dt>
                  <dd>{{ duration(row) }} 分钟</dd>
                </div>
                <div>
                  <dt>费用</dt>
                  <dd>¥{{ amount(row).toFixed(2) }}</dd>
                </div>
              </dl>
            </div>
          </article>

          <div v-if="!loading && !filtered.length" class="empty-state">
            <span>00</span>
            <h3>{{ keyword ? '没有匹配的记录' : '还没有充电记录' }}</h3>
            <p>{{ keyword ? '试试搜索其他站点或日期。' : '完成首次充电后，明细会出现在这里。' }}</p>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<style scoped>
.history-page {
  min-height: calc(100vh - 72px);
  padding-bottom: 72px;
  background: var(--surface-muted);
}

.history-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 40px;
  padding-top: 56px !important;
  padding-bottom: 36px !important;
}

.eyebrow,
.history-header h1,
.intro {
  margin: 0;
}

.eyebrow {
  margin-bottom: 12px;
  color: var(--brand);
  font-size: 11px;
  font-weight: 800;
  letter-spacing: .18em;
}

.history-header h1 {
  font-size: clamp(42px, 6vw, 68px);
  font-weight: 720;
  letter-spacing: -.065em;
}

.intro {
  max-width: 320px;
  padding-bottom: 8px;
  color: var(--text-secondary);
  font-size: 15px;
}

.ledger {
  display: grid;
  grid-template-columns: minmax(180px, .8fr) 3fr;
  border-top: 1px solid var(--text-primary);
  border-bottom: 1px solid var(--border-color);
}

.ledger-label {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 24px 26px 24px 0;
  border-right: 1px solid var(--border-color);
}

.ledger-label span {
  font-size: 14px;
  font-weight: 700;
}

.ledger-label small {
  color: var(--text-muted);
  font-size: 11px;
}

.ledger dl {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  margin: 0;
}

.ledger dl > div {
  min-width: 0;
  padding: 24px 26px;
  border-right: 1px solid var(--border-color);
}

.ledger dl > div:last-child {
  border-right: 0;
}

.ledger dt {
  margin-bottom: 18px;
  color: var(--text-muted);
  font-size: 11px;
}

.ledger dd {
  margin: 0;
  font-size: clamp(24px, 3vw, 34px);
  font-weight: 680;
  font-variant-numeric: tabular-nums;
  letter-spacing: -.045em;
}

.ledger dd small {
  margin: 0 4px;
  color: var(--text-secondary);
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0;
}

.activity {
  margin-top: 70px;
}

.activity-head,
.activity-head > div {
  display: flex;
  align-items: center;
}

.activity-head {
  justify-content: space-between;
  gap: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--text-primary);
}

.activity-head > div {
  gap: 18px;
}

.section-index {
  color: var(--brand);
  font-size: 12px;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
}

.activity-head h2,
.activity-head p {
  margin: 0;
}

.activity-head h2 {
  font-size: 24px;
  letter-spacing: -.035em;
}

.activity-head p {
  margin-top: 4px;
  color: var(--text-muted);
  font-size: 11px;
}

.activity-head .el-input {
  width: 270px;
}

.timeline {
  min-height: 220px;
}

.timeline-row {
  display: grid;
  grid-template-columns: 150px 24px 1fr;
  min-height: 116px;
  border-bottom: 1px solid var(--border-color);
}

.timeline-date {
  display: flex;
  flex-direction: column;
  padding: 28px 20px 26px 0;
}

.timeline-date strong,
.timeline-date span {
  font-variant-numeric: tabular-nums;
}

.timeline-date strong {
  font-size: 13px;
}

.timeline-date span {
  margin-top: 7px;
  color: var(--text-muted);
  font-size: 11px;
}

.timeline-marker {
  position: relative;
}

.timeline-marker::before {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 50%;
  width: 1px;
  background: var(--border-color);
  content: '';
}

.timeline-marker i {
  position: absolute;
  top: 34px;
  left: 50%;
  z-index: 1;
  width: 9px;
  height: 9px;
  background: var(--brand);
  border: 3px solid var(--surface-muted);
  border-radius: 50%;
  box-sizing: content-box;
  transform: translateX(-50%);
}

.timeline-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 32px;
  padding: 25px 0 25px 26px;
}

.station span {
  color: var(--brand);
  font-size: 10px;
  font-weight: 750;
  letter-spacing: .08em;
}

.station h3 {
  margin: 8px 0 0;
  font-size: 17px;
  font-weight: 650;
}

.timeline-content dl {
  display: grid;
  grid-template-columns: repeat(2, minmax(100px, 1fr));
  min-width: 300px;
  margin: 0;
}

.timeline-content dl > div {
  padding-left: 24px;
  border-left: 1px solid var(--border-color);
}

.timeline-content dt {
  color: var(--text-muted);
  font-size: 10px;
}

.timeline-content dd {
  margin: 7px 0 0;
  font-size: 14px;
  font-weight: 650;
  font-variant-numeric: tabular-nums;
}

.empty-state {
  padding: 72px 20px;
  text-align: center;
}

.empty-state span {
  color: var(--brand);
  font-size: 11px;
  font-weight: 800;
}

.empty-state h3 {
  margin: 12px 0 6px;
  font-size: 20px;
}

.empty-state p {
  margin: 0;
  color: var(--text-muted);
  font-size: 12px;
}

@media (max-width: 820px) {
  .ledger {
    grid-template-columns: 1fr;
  }

  .ledger-label {
    flex-direction: row;
    padding: 18px 0;
    border-right: 0;
    border-bottom: 1px solid var(--border-color);
  }

  .ledger dl {
    grid-template-columns: repeat(2, 1fr);
  }

  .ledger dl > div:nth-child(2) {
    border-right: 0;
  }

  .ledger dl > div:nth-child(-n + 2) {
    border-bottom: 1px solid var(--border-color);
  }

  .timeline-content dl {
    min-width: 245px;
  }
}

@media (max-width: 620px) {
  .history-header {
    align-items: flex-start;
    flex-direction: column;
    gap: 14px;
    padding-top: 36px !important;
  }

  .activity {
    margin-top: 48px;
  }

  .activity-head {
    align-items: stretch;
    flex-direction: column;
  }

  .activity-head .el-input {
    width: 100%;
  }

  .timeline-row {
    grid-template-columns: 98px 18px 1fr;
  }

  .timeline-content {
    align-items: flex-start;
    flex-direction: column;
    gap: 18px;
    padding-left: 15px;
  }

  .timeline-content dl {
    width: 100%;
    min-width: 0;
  }

  .timeline-content dl > div {
    padding-left: 0;
    border-left: 0;
  }
}
</style>
