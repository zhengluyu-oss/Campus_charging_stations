<script setup lang="ts">
import { computed, defineAsyncComponent, watch } from 'vue'
import { useRoute } from 'vue-router'
import Header from './components/UserHeader.vue'
import Footer from './components/Footer.vue'
import { provideEffects } from './effects/effectsContext'
import { ambientPresetForUserPath } from './effects/routePresets'

const AmbientCanvas = defineAsyncComponent(() => import('./effects/AmbientCanvas.vue'))

const route = useRoute()
const effects = provideEffects()

const showNav = computed(() => {
  const hiddenRoutes = ['/welcome', '/user-login', '/user-register']
  return !hiddenRoutes.includes(route.path)
})

const motionName = computed(() => (effects.motionEnabled.value ? 'route-fade' : ''))

watch(
  () => route.path,
  (path) => {
    effects.setAmbientPreset(ambientPresetForUserPath(path))
  },
  { immediate: true }
)
</script>

<template>
  <AmbientCanvas />
  <div class="layout">
    <el-container class="container">
      <Header v-if="showNav" />
      <div class="main" :class="{ 'no-nav': !showNav }">
        <router-view v-slot="{ Component }">
          <transition :name="motionName" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </div>
      <Footer v-if="showNav" />
    </el-container>
  </div>
</template>

<style>
html, body, #app { min-height: 100%; }
</style>
<style scoped>
.layout {
  min-height: 100vh;
  background: transparent;
  color: var(--text-primary);
  position: relative;
  z-index: 1;
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
