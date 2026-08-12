<template>
  <footer class="app-footer">
    <div class="footer-inner">
      <span>校园充电服务平台</span>
      <span>安全充电 · 绿色校园</span>
      <span>服务时间 07:00—23:00</span>
    </div>
  </footer>
</template>

<style scoped>
.app-footer { margin-top: auto; padding: 34px 0 96px; color: var(--text-muted); background: var(--surface-muted); font-size: 13px; }
.footer-inner { width: min(var(--content-width), calc(100% - 40px)); margin: auto; display: flex; justify-content: space-between; gap: 20px; padding-top: 22px; border-top: 1px solid var(--border-color); }
@media (min-width: 821px) { .app-footer { padding-bottom: 34px; } }
@media (max-width: 600px) { .footer-inner { flex-direction: column; gap: 7px; } }
</style>
