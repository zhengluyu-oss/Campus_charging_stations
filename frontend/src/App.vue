<script setup lang="ts">
import {useRouter, useRoute} from 'vue-router'
import { ref, watch } from 'vue'
import Header from './components/UserHeader.vue'
import Footer from './components/Footer.vue'
import AmbientParticles from './components/AmbientParticles.vue'

const router = useRouter()
const route = useRoute()

const showNav = ref(true)

const updateShowNav = () => {
  const hiddenRoutes = ['/welcome', '/user-login', '/user-register']
  const isHiddenPath = hiddenRoutes.includes(route.path)

  if (route.path === '/user/news') {
    const mode = route.query.mode
    showNav.value = mode === 'publish'
  } else {
    showNav.value = !isHiddenPath
  }
}

watch(
  () => route.fullPath,
  () => {
    updateShowNav()
  },
  { immediate: true }
)
</script>

<template>
  <div class="layout">
    <AmbientParticles />
    <el-container class="container">
      <Header v-if="showNav"/>
      <div class="main" :class="{ 'no-nav': !showNav }">
        <router-view/>
      </div>
      <Footer v-if="showNav"/>
    </el-container>
  </div>
</template>

<style>
:root {
  --bg-primary: #1a2a3a;
  --bg-secondary: #1e3040;
  --bg-card: rgba(255, 255, 255, 0.06);
  --brand-primary: #00b4d8;
  --brand-secondary: #52b788;
  --brand-accent: #0077b6;
  --text-primary: #e8edf2;
  --text-secondary: #8fa3b0;
  --text-muted: #5a7280;
  --border-color: rgba(255, 255, 255, 0.08);
  --border-hover: rgba(0, 180, 216, 0.3);
}
</style>
<style scoped>
.layout {
  min-height: 100vh;
  background: var(--bg-primary);
  color: #ffffff;
}

.container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  position: relative;
  z-index: 1;
}

.main {
  flex: 1;
  overflow: auto;
  padding: 10px;
}

.main.no-nav {
  padding: 0;
}
</style>
