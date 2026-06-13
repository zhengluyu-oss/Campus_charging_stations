<script setup lang="ts">
import {useRouter, useRoute} from 'vue-router'
import { ref, watch } from 'vue'
import Header from './components/UserHeader.vue'
import Footer from './components/Footer.vue'
import HandParticleCanvas from './components/HandParticleCanvas.vue'

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
    <HandParticleCanvas />
    <el-container class="container">
      <Header v-if="showNav"/>
      <div class="main" :class="{ 'no-nav': !showNav }">
        <router-view/>
      </div>
      <Footer v-if="showNav"/>
    </el-container>
  </div>
</template>

<style scoped>
.layout {
  min-height: 100vh;
  background-color: #ffffff;
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
