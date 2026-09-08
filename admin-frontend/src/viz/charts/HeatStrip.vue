<template>
  <div class="heat-strip" role="img" :aria-label="ariaLabel">
    <div
      v-for="(cell, i) in cells"
      :key="i"
      class="cell"
      :style="{ opacity: 0.25 + cell * 0.75 }"
      :title="`${labels[i] ?? i}: ${Math.round(cell * 100)}%`"
    />
  </div>
  <div v-if="!cells.length" class="empty">暂无占用数据</div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(
  defineProps<{
    values: number[]
    labels?: string[]
  }>(),
  { labels: () => [] }
)

const cells = computed(() =>
  props.values.map((v) => Math.max(0, Math.min(1, Number.isFinite(v) ? v : 0)))
)
const ariaLabel = computed(() => `占用热力条，共 ${cells.value.length} 段`)
</script>

<style scoped>
.heat-strip {
  display: grid;
  grid-auto-flow: column;
  grid-auto-columns: 1fr;
  gap: 3px;
  height: 28px;
}
.cell {
  border-radius: 4px;
  background: linear-gradient(180deg, var(--brand-cyan), var(--brand-volt));
  border: 1px solid rgba(0, 229, 255, 0.2);
}
.empty {
  height: 28px;
  display: grid;
  place-items: center;
  color: var(--text-muted);
  font-size: 12px;
  border: 1px dashed var(--border-color);
  border-radius: 8px;
}
</style>
