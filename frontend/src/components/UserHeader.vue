<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowDown, Clock, Grid, Lightning, Document, User } from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const store = useUserStore()

const username = computed(() => store.user?.username || '校园用户')
const initial = computed(() => username.value.slice(0, 1).toUpperCase())
const isActive = (path: string) => route.path === path || (path !== '/user-dashboard' && route.path.startsWith(path))

const navItems = [
  { label: '首页', path: '/user-dashboard', icon: Grid },
  { label: '充电服务', path: '/user/charging-service', icon: Lightning },
  { label: '充电记录', path: '/history', icon: Clock },
  { label: '校园资讯', path: '/user/news?mode=view', icon: Document },
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
        <span class="brand-mark"><Lightning /></span>
        <span><strong>校园充电</strong><small>Campus Charge</small></span>
      </button>

      <nav class="desktop-nav" aria-label="主导航">
        <button
          v-for="item in navItems"
          :key="item.path"
          type="button"
          :class="{ active: isActive(item.path.split('?')[0] || item.path) }"
          @click="router.push(item.path)"
        >
          <el-icon><component :is="item.icon" /></el-icon>{{ item.label }}
        </button>
      </nav>

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
  </header>
</template>

<style scoped>
.app-header { position: sticky; top: 0; z-index: 100; height: 72px; background: rgba(255,255,255,.94); border-bottom: 1px solid var(--border-color); backdrop-filter: blur(14px); }
.header-inner { width: min(var(--content-width), calc(100% - 40px)); height: 100%; margin: auto; display: flex; align-items: center; justify-content: space-between; gap: 28px; }
.brand, .account-button, .desktop-nav button { border: 0; background: none; cursor: pointer; color: inherit; }
.brand { display: flex; align-items: center; gap: 11px; padding: 0; text-align: left; }
.brand-mark { width: 38px; height: 38px; display: grid; place-items: center; color: white; background: var(--brand); border-radius: 12px; }
.brand-mark :deep(svg) { width: 21px; }
.brand strong, .brand small { display: block; }
.brand strong { font-size: 16px; letter-spacing: -.02em; }
.brand small { margin-top: 1px; color: var(--text-muted); font-size: 10px; letter-spacing: .08em; text-transform: uppercase; }
.desktop-nav { height: 100%; display: flex; align-items: center; gap: 4px; margin-left: auto; }
.desktop-nav button { position: relative; height: 100%; display: flex; align-items: center; gap: 7px; padding: 0 15px; color: var(--text-secondary); font-weight: 600; }
.desktop-nav button::after { content: ''; position: absolute; left: 15px; right: 15px; bottom: 0; height: 3px; background: var(--brand); border-radius: 3px 3px 0 0; transform: scaleX(0); transition: transform .2s; }
.desktop-nav button:hover, .desktop-nav button.active { color: var(--brand-dark); }
.desktop-nav button.active::after { transform: scaleX(1); }
.account-button { display: flex; align-items: center; gap: 9px; padding: 7px 10px 7px 7px; border-radius: 12px; }
.account-button:hover { background: var(--surface-muted); }
.avatar { width: 32px; height: 32px; display: grid; place-items: center; color: #fff; background: #20392a; border-radius: 10px; font-size: 13px; font-weight: 750; }
.account-name { max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 650; }
@media (max-width: 820px) { .header-inner { width: calc(100% - 24px); } .desktop-nav { position: fixed; left: 12px; right: 12px; bottom: 12px; z-index: 120; height: 60px; justify-content: space-around; gap: 0; padding: 5px; background: rgba(255,255,255,.96); border: 1px solid var(--border-color); border-radius: 18px; box-shadow: var(--shadow-md); backdrop-filter: blur(16px); } .desktop-nav button { height: 50px; flex: 1; flex-direction: column; justify-content: center; gap: 3px; padding: 0; font-size: 10px; border-radius: 12px; } .desktop-nav button::after { display: none; } .desktop-nav button.active { background: var(--brand-soft); } }
@media (max-width: 520px) { .account-name { display: none; } .brand small { display: none; } }
</style>
