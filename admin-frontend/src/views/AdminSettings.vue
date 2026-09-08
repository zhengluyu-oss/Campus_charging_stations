<template>
  <div class="page-container page-enter-active">
    <el-card class="page-card" shadow="never">
      <template #header>
        <span class="font-display">系统设置</span>
      </template>
      <el-form label-width="140px" size="large">
        <el-form-item label="站点名称">
          <el-input model-value="Campus Charging Stations" disabled />
        </el-form-item>
        <el-form-item label="管理员">
          <el-input :model-value="adminStore.admin?.username || 'admin'" disabled />
        </el-form-item>
        <el-form-item label="视觉特效">
          <el-radio-group :model-value="effectsLevel" @change="onEffectsChange">
            <el-radio-button value="full">Full</el-radio-button>
            <el-radio-button value="low">Low</el-radio-button>
            <el-radio-button value="off">Off</el-radio-button>
          </el-radio-group>
          <p class="hint">弱设备会自动降级；也可在此手动切换，便于答辩/服务器演示。</p>
        </el-form-item>
        <el-form-item>
          <el-button type="danger" @click="handleLogout">退出登录</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAdminStore } from '@/stores/admin'
import { useEffects, type EffectsLevel } from '@/effects/effectsContext'

const router = useRouter()
const adminStore = useAdminStore()
const effects = useEffects()
const effectsLevel = computed(() => effects.level.value)

function onEffectsChange(val: string | number | boolean | undefined) {
  if (val === 'off' || val === 'low' || val === 'full') {
    effects.setLevel(val as EffectsLevel)
  }
}

function handleLogout() {
  adminStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.page-container { display: flex; flex-direction: column; gap: 20px; }
.page-card {
  background: var(--bg-panel);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  color: var(--text-primary);
}
.hint {
  margin: 8px 0 0;
  color: var(--text-muted);
  font-size: 12px;
  line-height: 1.5;
}
</style>
