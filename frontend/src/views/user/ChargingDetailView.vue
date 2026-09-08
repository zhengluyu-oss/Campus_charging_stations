<script setup lang="ts">
import { computed, onBeforeUnmount, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft, Clock, Lightning, Location, Wallet } from '@element-plus/icons-vue'
import CountUp from '@/motion/CountUp.vue'
import EnergyProgress from '@/motion/EnergyProgress.vue'
import TrendLine from '@/viz/charts/TrendLine.vue'

const route = useRoute()
const router = useRouter()
const total = Number(route.query.duration || 60) * 60
const elapsed = ref(0)
const powerSeries = ref<number[]>([3.2])
const powerCats = ref<string[]>(['0m'])

const timer = window.setInterval(() => {
  if (elapsed.value < total) {
    elapsed.value++
    if (elapsed.value % 15 === 0) {
      const kw = 4 + Math.sin(elapsed.value / 40) * 1.2 + Math.random() * 0.4
      powerSeries.value = [...powerSeries.value.slice(-19), Number(kw.toFixed(2))]
      powerCats.value = [
        ...powerCats.value.slice(-19),
        `${Math.floor(elapsed.value / 60)}m`,
      ]
    }
  }
}, 1000)
onBeforeUnmount(() => clearInterval(timer))

const percent = computed(() => Math.min(100, Math.round((elapsed.value / total) * 100)))
const remaining = computed(() => Math.ceil((total - elapsed.value) / 60))
const cost = computed(() => (elapsed.value / 3600) * 0.5)
const time = computed(
  () =>
    `${String(Math.floor(elapsed.value / 60)).padStart(2, '0')}:${String(elapsed.value % 60).padStart(2, '0')}`
)
</script>

<template>
  <div class="charge-page page-enter-active">
    <main class="charge-console">
      <header class="console-header">
        <button type="button" @click="router.push('/user-dashboard')"><ArrowLeft /> 返回工作台</button>
        <div class="session-id font-display">SESSION / #{{ route.params.id }}</div>
        <span class="live"><i /> 充电进行中</span>
      </header>

      <section class="charge-stage">
        <div class="charge-location">
          <Location /> {{ route.query.location || '校园充电区' }} <span>·</span> 充电桩 #{{ route.params.id }}
        </div>
        <div class="progress-number">
          <strong class="font-metric"><CountUp :value="percent" /></strong>
          <span>%<small>CHARGED</small></span>
        </div>
        <EnergyProgress :percent="percent" />
        <p>设备运行正常。充电完成后，请及时移走车辆并保持充电区域畅通。</p>
        <Lightning class="energy-mark" />
      </section>

      <section class="viz-block">
        <h3 class="font-display">实时功率</h3>
        <TrendLine name="kW" :categories="powerCats" :series="powerSeries" height="200px" />
      </section>

      <section class="metrics">
        <article>
          <Clock />
          <span><small>已充时长</small><strong>{{ time }}</strong></span>
          <b>ELAPSED</b>
        </article>
        <article>
          <Clock />
          <span><small>预计剩余</small><strong>{{ remaining }} 分钟</strong></span>
          <b>REMAINING</b>
        </article>
        <article>
          <Wallet />
          <span><small>当前费用</small><strong>¥{{ cost.toFixed(2) }}</strong></span>
          <b>CURRENT COST</b>
        </article>
      </section>

      <footer class="console-footer">
        <span>请勿在充电过程中强行拔出设备</span>
        <el-button @click="router.push('/user-dashboard')">返回首页</el-button>
      </footer>
    </main>
  </div>
</template>

<style scoped>
.charge-page {
  min-height: calc(100vh - 68px);
  display: grid;
  place-items: center;
  padding: 45px 24px;
  color: #fff;
  background: transparent !important;
}
.charge-console {
  width: min(1120px, 100%);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  overflow: hidden;
  background:
    radial-gradient(circle at 84% 18%, rgba(0, 229, 255, 0.18), transparent 28%),
    var(--bg-panel-solid);
  box-shadow: var(--shadow-md);
}
.console-header {
  height: 62px;
  padding: 0 26px;
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  border-bottom: 1px solid var(--border-color);
}
.console-header button {
  width: fit-content;
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 0;
  color: var(--text-secondary);
  background: none;
  border: 0;
  font-size: 10px;
  cursor: pointer;
}
.session-id {
  color: var(--text-muted);
  font-size: 10px;
  letter-spacing: 0.14em;
}
.live {
  justify-self: end;
  display: flex;
  align-items: center;
  gap: 7px;
  color: var(--brand-volt);
  font-size: 9px;
  font-weight: 750;
  letter-spacing: 0.08em;
}
.live i {
  width: 6px;
  height: 6px;
  background: currentColor;
  border-radius: 50%;
  box-shadow: 0 0 0 5px rgba(124, 255, 178, 0.12);
}
.charge-stage {
  position: relative;
  min-height: 360px;
  padding: 48px 8vw 36px;
  overflow: hidden;
}
.charge-location {
  display: flex;
  align-items: center;
  gap: 7px;
  color: var(--text-secondary);
  font-size: 10px;
}
.progress-number {
  display: flex;
  align-items: flex-end;
  margin: 48px 0 28px;
}
.progress-number > strong {
  font-size: clamp(96px, 14vw, 168px);
  font-weight: 600;
  line-height: 0.7;
  letter-spacing: 0.02em;
  color: var(--text-primary);
}
.progress-number > span {
  margin-left: 18px;
  color: var(--brand-cyan);
  font-size: 36px;
  line-height: 0.8;
}
.progress-number small {
  display: block;
  margin: 16px 0 3px;
  color: var(--text-muted);
  font-size: 8px;
  letter-spacing: 0.16em;
}
.charge-stage > p {
  max-width: 520px;
  margin: 20px 0 0;
  color: var(--text-muted);
  font-size: 11px;
  line-height: 1.7;
}
.energy-mark {
  position: absolute;
  width: 260px;
  right: 3vw;
  top: 60px;
  color: rgba(0, 229, 255, 0.06);
}
.viz-block {
  padding: 8px 28px 20px;
  border-top: 1px solid var(--border-color);
}
.viz-block h3 {
  margin: 0 0 8px;
  font-size: 12px;
  letter-spacing: 0.12em;
  color: var(--text-secondary);
}
.metrics {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  border-top: 1px solid var(--border-color);
  border-bottom: 1px solid var(--border-color);
}
.metrics article {
  position: relative;
  min-height: 115px;
  padding: 26px 30px;
  display: grid;
  grid-template-columns: 28px 1fr;
  align-items: center;
  gap: 13px;
}
.metrics article + article {
  border-left: 1px solid var(--border-color);
}
.metrics article > :deep(svg) {
  width: 21px;
  color: var(--brand-cyan);
}
.metrics small,
.metrics strong {
  display: block;
}
.metrics small {
  color: var(--text-muted);
  font-size: 8px;
  letter-spacing: 0.06em;
}
.metrics strong {
  margin-top: 7px;
  color: #fff;
  font-size: 18px;
  font-family: var(--font-display);
}
.metrics article > b {
  position: absolute;
  right: 18px;
  top: 15px;
  color: var(--text-muted);
  font-size: 7px;
  letter-spacing: 0.12em;
}
.console-footer {
  min-height: 76px;
  padding: 0 25px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
}
.console-footer > span {
  color: var(--text-muted);
  font-size: 9px;
}
@media (max-width: 700px) {
  .metrics {
    grid-template-columns: 1fr;
  }
  .metrics article + article {
    border-left: 0;
    border-top: 1px solid var(--border-color);
  }
}
</style>
