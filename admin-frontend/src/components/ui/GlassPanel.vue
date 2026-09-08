<template>
  <div class="glass-panel" :class="[`tone-${tone}`]">
    <slot />
  </div>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    tone?: 'default' | 'strong' | 'subtle'
  }>(),
  { tone: 'default' }
)
</script>

<style scoped>
.glass-panel {
  color: var(--text-primary);
  background: var(--bg-panel);
  border: 1px solid var(--border-color);
  border-radius: var(--radius);
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.06),
    var(--shadow-sm);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
}
.tone-strong {
  background: rgba(12, 22, 36, 0.88);
  border-color: var(--border-hover);
}
.tone-subtle {
  background: rgba(12, 22, 36, 0.45);
}
</style>
