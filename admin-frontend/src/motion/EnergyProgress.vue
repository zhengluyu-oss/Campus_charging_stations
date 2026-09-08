<template>
  <div class="energy-progress" :class="{ muted: !animated }">
    <div class="track">
      <div class="fill" :style="{ width: `${clamped}%` }">
        <span class="beam" v-if="animated" />
      </div>
    </div>
    <div class="meta" v-if="showLabel">
      <span class="font-metric">{{ clamped.toFixed(0) }}%</span>
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useEffectsOptional } from '@/effects/effectsContext'

const props = withDefaults(
  defineProps<{
    percent: number
    showLabel?: boolean
  }>(),
  { showLabel: true }
)

const effects = useEffectsOptional()
const animated = computed(() => effects?.motionEnabled.value ?? true)
const clamped = computed(() => Math.max(0, Math.min(100, props.percent)))
</script>

<style scoped>
.energy-progress {
  width: 100%;
}
.track {
  height: 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.06);
  border: 1px solid var(--border-color);
  overflow: hidden;
}
.fill {
  position: relative;
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(90deg, #00a8bd, var(--brand-cyan), var(--brand-volt));
  box-shadow: 0 0 16px rgba(0, 229, 255, 0.35);
  transition: width 320ms cubic-bezier(0.22, 1, 0.36, 1);
}
.beam {
  position: absolute;
  inset: 0 auto 0 -30%;
  width: 30%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.55), transparent);
  animation: beam-sweep 1.8s linear infinite;
}
.muted .beam {
  display: none;
}
.meta {
  margin-top: 8px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: var(--text-secondary);
  font-size: 13px;
}
@keyframes beam-sweep {
  from { left: -30%; }
  to { left: 110%; }
}
@media (prefers-reduced-motion: reduce) {
  .beam { animation: none; }
}
</style>
