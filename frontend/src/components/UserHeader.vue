<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowDown, Clock, Grid, Lightning, Location, User } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const store = useUserStore()

const username = computed(() => store.user?.username || '校园用户')
const initial = computed(() => username.value.slice(0, 1).toUpperCase())
const isActive = (path: string) => route.path === path || (path !== '/user-dashboard' && route.path.startsWith(path))

const navItems = [
  { label: '首页', path: '/user-dashboard', icon: Grid },
  { label: '站点', path: '/user/charging-stations', icon: Location },
  { label: '充电服务', path: '/user/charging-service', icon: Lightning },
  { label: '记录', path: '/history', icon: Clock },
]

const logout = () => {
  store.$patch({ token: '', user: undefined })
  router.replace('/user-login')
}
</script>

<template>
  <header class="app-header">
    <div class="header-inner">
      <button class="brand" type="button" @click="router.push('/user-dashboard')" aria-label="返回首页">
        <span class="brand-mark"><i></i><i></i></span>
        <span class="brand-copy"><strong>CAMPUS</strong><strong>CHARGE</strong></span>
      </button>

      <nav class="desktop-nav" aria-label="主导航">
        <button
          v-for="item in navItems"
          :key="item.path"
          type="button"
          :class="{ active: isActive(item.path) }"
          @click="router.push(item.path)"
        >
          <el-icon><component :is="item.icon" /></el-icon>
          <span>{{ item.label }}</span>
        </button>
      </nav>

      <div class="header-actions">
        <button class="charge-now" type="button" @click="router.push('/user/use-charger')">
          <Lightning /> <span>立即充电</span>
        </button>
        <el-dropdown trigger="click">
          <button class="account-button" type="button">
            <span class="avatar">{{ initial }}</span>
            <span class="account-name">{{ username }}</span>
            <el-icon><ArrowDown /></el-icon>
          </button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item :icon="User" @click="router.push('/profile')">个人资料</el-dropdown-item>
              <el-dropdown-item :icon="Clock" @click="router.push('/history')">充电记录</el-dropdown-item>
              <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>
  </header>
</template>

<style scoped>
.app-header {
  position: sticky;
  top: 0;
  z-index: 100;
  height: 68px;
  color: #fff;
  background: rgba(12, 14, 20, .96);
  border-bottom: 1px solid rgba(255, 255, 255, .1);
  backdrop-filter: blur(18px);
}
.header-inner {
  width: min(var(--content-width), calc(100% - 48px));
  height: 100%;
  margin: auto;
  display: flex;
  align-items: center;
  gap: 32px;
}
.brand, .account-button, .desktop-nav button, .charge-now { border: 0; font: inherit; cursor: pointer; }
.brand { display: flex; align-items: center; gap: 10px; padding: 0; color: #fff; background: none; text-align: left; }
.brand-mark { position: relative; width: 28px; height: 28px; display: block; background: var(--brand); border-radius: 6px; overflow: hidden; }
.brand-mark i { position: absolute; width: 5px; height: 20px; top: 4px; background: #fff; transform: skew(-18deg); }
.brand-mark i:first-child { left: 8px; }.brand-mark i:last-child { right: 7px; opacity: .42; }
.brand-copy { display: grid; gap: 0; font-size: 10px; line-height: 1.05; letter-spacing: .14em; }
.brand-copy strong:last-child { color: #9398ff; }
.desktop-nav { height: 100%; display: flex; align-items: center; gap: 2px; margin-left: 34px; }
.desktop-nav button { position: relative; height: 100%; display: flex; align-items: center; gap: 7px; padding: 0 15px; color: #a8abb5; background: none; font-size: 13px; font-weight: 600; }
.desktop-nav button :deep(svg) { width: 15px; }
.desktop-nav button::after { content: ''; position: absolute; left: 15px; right: 15px; bottom: 0; height: 2px; background: #818bff; transform: scaleX(0); transition: transform .18s ease; }
.desktop-nav button:hover, .desktop-nav button.active { color: #fff; }
.desktop-nav button.active::after { transform: scaleX(1); }
.header-actions { margin-left: auto; display: flex; align-items: center; gap: 10px; }
.charge-now { height: 38px; display: flex; align-items: center; gap: 7px; padding: 0 14px; color: #101116; background: #fff; border-radius: 7px; font-size: 12px; font-weight: 760; }
.charge-now :deep(svg) { width: 15px; }
.charge-now:hover { background: #e9eaff; }
.account-button { display: flex; align-items: center; gap: 8px; padding: 4px 7px 4px 4px; color: #e9e9ee; background: transparent; border-radius: 8px; }
.account-button:hover { background: rgba(255,255,255,.08); }
.avatar { width: 30px; height: 30px; display: grid; place-items: center; color: #fff; background: #5867f6; border-radius: 7px; font-size: 12px; font-weight: 800; }
.account-name { max-width: 92px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-size: 12px; font-weight: 650; }

@media (max-width: 900px) {
  .header-inner { width: calc(100% - 28px); }
  .desktop-nav {
    position: fixed;
    left: 12px;
    right: 12px;
    bottom: 12px;
    z-index: 120;
    height: 64px;
    justify-content: space-around;
    gap: 0;
    margin: 0;
    padding: 5px;
    background: rgba(10, 12, 17, .96);
    border: 1px solid rgba(255, 255, 255, .12);
    border-radius: 16px;
    box-shadow: 0 18px 45px rgba(10, 12, 17, .25);
    backdrop-filter: blur(18px);
  }
  .desktop-nav button { height: 52px; flex: 1; flex-direction: column; justify-content: center; gap: 3px; padding: 0; font-size: 10px; border-radius: 10px; }
  .desktop-nav button::after { left: 50%; right: auto; bottom: 4px; width: 4px; height: 4px; background: #8fff75; border-radius: 50%; transform: translateX(-50%) scale(0); }
  .desktop-nav button.active::after { transform: translateX(-50%) scale(1); }
}
@media (max-width: 600px) { .charge-now { display: none; } .account-name { display: none; } }
</style>
