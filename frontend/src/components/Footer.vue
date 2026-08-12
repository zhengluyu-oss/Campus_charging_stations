<template>
  <footer class="app-footer">
    <div class="footer-inner">
      <div class="footer-brand"><i></i><strong>CAMPUS CHARGE</strong></div>
      <p>校园能源服务系统 · 查询、预约与充电记录</p>
      <span>服务时间 07:00—23:00</span>
    </div>
  </footer>
</template>

<style scoped>
.app-footer { margin-top: auto; padding: 58px 0 38px; color: #858891; background: transparent; font-size: 12px; }
.footer-inner { width: min(var(--content-width), calc(100% - 48px)); margin: auto; display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; gap: 24px; padding-top: 22px; border-top: 1px solid var(--border-color); }
.footer-brand { display: flex; align-items: center; gap: 9px; color: var(--ink); font-size: 10px; letter-spacing: .12em; }
.footer-brand i { width: 9px; height: 9px; display: block; background: var(--brand); border-radius: 2px; }
.footer-inner p { margin: 0; }.footer-inner > span { justify-self: end; }
@media (max-width: 900px) { .app-footer { padding-bottom: 100px; } }
@media (max-width: 680px) { .footer-inner { width: calc(100% - 28px); grid-template-columns: 1fr; gap: 8px; }.footer-inner > span { justify-self: start; } }
</style>
