<template>
  <div class="viz-shell">
    <div v-if="loading" class="viz-state">加载中…</div>
    <div v-else-if="empty" class="viz-state">暂无数据</div>
    <div ref="el" class="chart" v-show="!loading && !empty" />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import * as echarts from 'echarts/core'
import { PieChart } from 'echarts/charts'
import { TooltipComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import type { EChartsOption } from 'echarts'
import { useEffectsOptional } from '@/effects/effectsContext'
import { energyChartTheme, withMotion } from '../theme'

echarts.use([PieChart, TooltipComponent, LegendComponent, CanvasRenderer])
echarts.registerTheme('campus-energy', energyChartTheme())

const props = withDefaults(
  defineProps<{
    data: { name: string; value: number }[]
    loading?: boolean
    height?: string
  }>(),
  { loading: false, height: '220px' }
)

const effects = useEffectsOptional()
const el = ref<HTMLDivElement | null>(null)
let chart: echarts.ECharts | null = null
const empty = computed(() => !props.loading && props.data.every((d) => d.value === 0))

function buildOption(): EChartsOption {
  const animate = effects?.motionEnabled.value ?? true
  return withMotion(
    {
      tooltip: { trigger: 'item' },
      series: [
        {
          type: 'pie',
          radius: ['58%', '78%'],
          avoidLabelOverlap: true,
          label: { color: '#e8f1f8', formatter: '{b}\n{d}%' },
          data: props.data,
        },
      ],
    },
    animate
  )
}

function render() {
  if (!el.value || empty.value) return
  if (!chart) chart = echarts.init(el.value, 'campus-energy')
  chart.setOption(buildOption(), true)
}

onMounted(() => {
  render()
  window.addEventListener('resize', () => chart?.resize())
})
onUnmounted(() => {
  chart?.dispose()
  chart = null
})
watch(() => [props.data, props.loading, effects?.level.value], render, { deep: true })
</script>

<style scoped>
.viz-shell { width: 100%; min-height: v-bind(height); }
.chart { width: 100%; height: v-bind(height); }
.viz-state {
  height: v-bind(height);
  display: grid;
  place-items: center;
  color: var(--text-muted);
  border: 1px dashed var(--border-color);
  border-radius: var(--radius);
  background: rgba(0, 229, 255, 0.03);
  font-size: 13px;
}
</style>
