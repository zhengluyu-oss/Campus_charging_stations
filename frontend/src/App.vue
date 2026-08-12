<script setup lang="ts">
import {useRouter, useRoute} from 'vue-router'
import { ref, watch } from 'vue'
import Header from './components/UserHeader.vue'
import Footer from './components/Footer.vue'

const router = useRouter()
const route = useRoute()

const showNav = ref(true)

const updateShowNav = () => {
  const hiddenRoutes = ['/welcome', '/user-login', '/user-register']
  const isHiddenPath = hiddenRoutes.includes(route.path)

  showNav.value = !isHiddenPath
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
html, body, #app { min-height: 100%; }
</style>
<style scoped>
.layout {
  min-height: 100vh;
  background: var(--surface-muted);
  color: var(--text-primary);
}

.container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  position: relative;
  z-index: 1;
}

.main {
  flex: 1;
  padding: 0;
}

.main.no-nav {
  padding: 0;
}
</style>
