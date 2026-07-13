<script setup lang="ts">
</script>

<template>
  <div class="footer">
    <div class="left">
      <span class="footer-logo">⚡ 校园充电站</span>
      <span class="divider">|</span>
      <span>Copyright © 2023-2026 All rights reserved.</span>
    </div>
    <div class="right">
      <a target="_blank" href="#">关于我们</a>
      <a target="_blank" href="#">使用条款</a>
      <a target="_blank" href="#">隐私政策</a>
    </div>
  </div>
</template>

<style scoped>
.footer {
  height: 56px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  background: rgba(15, 32, 39, 0.8);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
}

.footer .left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.footer-logo {
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
}

.divider {
  color: rgba(255, 255, 255, 0.2);
}

.footer .right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.footer a {
  color: rgba(255, 255, 255, 0.6);
  text-decoration: none;
  transition: all 0.3s ease;
}

.footer a:hover {
  color: var(--brand-primary);
}
</style>
