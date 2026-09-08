<template>
  <span class="count-up font-metric">{{ display }}{{ suffix }}</span>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from 'vue'
import { useEffectsOptional } from '@/effects/effectsContext'

const props = withDefaults(
  defineProps<{
    value: number
    duration?: number
    decimals?: number
    suffix?: string
  }>(),
  {
    duration: 900,
    decimals: 0,
    suffix: '',
  }
)

const effects = useEffectsOptional()
const display = ref(format(props.value))

function format(n: number) {
  return props.decimals > 0 ? n.toFixed(props.decimals) : String(Math.round(n))
}

function animateTo(target: number) {
  const enable = effects?.motionEnabled.value ?? true
  if (!enable) {
    display.value = format(target)
    return
  }
  const start = performance.now()
  const from = Number(display.value) || 0
  const tick = (now: number) => {
    const t = Math.min(1, (now - start) / props.duration)
    const eased = 1 - Math.pow(1 - t, 3)
    display.value = format(from + (target - from) * eased)
    if (t < 1) requestAnimationFrame(tick)
  }
  requestAnimationFrame(tick)
}

onMounted(() => animateTo(props.value))
watch(
  () => props.value,
  (v) => animateTo(v)
)
</script>

<style scoped>
.count-up {
  font-variant-numeric: tabular-nums;
}
</style>
