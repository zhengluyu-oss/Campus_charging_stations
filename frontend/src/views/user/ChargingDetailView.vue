<template>
  <div class="charging-detail-page">
    <div class="page-background">
      <div class="background-grid">
        <div v-for="(p, i) in particles" :key="i" class="grid-cell" :style="{
          left: p.left,
          top: p.top,
          animationDelay: p.animationDelay,
          '--size': p.size
        }"></div>
      </div>
      <div class="gradient-overlay"></div>
    </div>

    <header class="page-header">
      <h1>充电详情</h1>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item :to="{ path: '/user/charging-service' }">充电服务</el-breadcrumb-item>
        <el-breadcrumb-item :to="{ path: '/user/use-charger' }">使用充电桩</el-breadcrumb-item>
        <el-breadcrumb-item>充电详情</el-breadcrumb-item>
      </el-breadcrumb>
    </header>

    <main class="detail-main">
      <el-card class="charging-card">
        <template #header>
          <div class="card-header">
            <span>充电进行中</span>
          </div>
        </template>

        <div class="charging-info">
          <div class="station-info">
            <h3>{{ station.name }}</h3>
            <p class="station-address">
              <el-icon><Location /></el-icon>
              {{ station.address }}
            </p>
            <p class="charger-type">
              <el-tag :type="station.type === 'fast' ? 'warning' : station.type === 'ultra-fast' ? 'danger' : 'success'">
                {{ getChargerTypeLabel(station.type) }}
              </el-tag>
            </p>
          </div>

          <div class="charging-progress">
            <div class="progress-circle">
              <div class="progress-value">{{ chargingProgress.toFixed(1) }}%</div>
              <svg class="progress-ring" height="150" width="150">
                <circle
                  class="progress-ring-circle-bg"
                  stroke="rgba(255,255,255,0.2)"
                  stroke-width="8"
                  fill="transparent"
                  r="65"
                  cx="75"
                  cy="75"
                />
                <circle
                  class="progress-ring-circle"
                  stroke="#409EFF"
                  stroke-width="8"
                  fill="transparent"
                  r="65"
                  cx="75"
                  cy="75"
                  :stroke-dasharray="circumference"
                  :stroke-dashoffset="strokeDashoffset"
                />
              </svg>
            </div>
            <p class="progress-text">充电进度</p>
          </div>

          <div class="charging-stats">
            <div class="stat-item">
              <div class="stat-label">已充电量</div>
              <div class="stat-value">{{ chargedAmount.toFixed(2) }} kWh</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">充电时长</div>
              <div class="stat-value">{{ chargingDuration }}</div>
            </div>
            <div class="stat-item">
              <div class="stat-label">预计费用</div>
              <div class="stat-value">¥{{ estimatedCost.toFixed(2) }}</div>
            </div>
          </div>
        </div>
      </el-card>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { ElMessage } from 'element-plus';
import { Location } from '@element-plus/icons-vue';

const router = useRouter();
const route = useRoute();

// 预计算粒子位置，避免模板中 Math.random() 导致重渲染跳动
const particles = Array.from({ length: 50 }, () => ({
  left: `${Math.random() * 100}%`,
  top: `${Math.random() * 100}%`,
  animationDelay: `${Math.random() * 5}s`,
  size: `${Math.random() * 6 + 2}px`
}));

// 获取路由参数
const stationId = parseInt(route.params.id as string);
const userSelectedDuration = parseInt(route.query.duration as string) || 60; // 默认60分钟

const station = ref({
  id: 1,
  name: '校园北区充电站',
  address: '北区教学楼旁',
  type: 'fast',
  pricePerKwh: 1.5
});

// 模拟根据ID获取充电站信息
const chargingStations = [
  {
    id: 1,
    name: '校园北区充电站',
    address: '北区教学楼旁',
    type: 'fast',
    pricePerKwh: 1.5
  },
  {
    id: 2,
    name: '宿舍区充电站',
    address: '学生宿舍楼下',
    type: 'slow',
    pricePerKwh: 1.2
  },
  {
    id: 3,
    name: '图书馆充电站',
    address: '图书馆停车场',
    type: 'fast',
    pricePerKwh: 1.8
  },
  {
    id: 4,
    name: '实验楼充电站',
    address: '实验楼东侧',
    type: 'fast',
    pricePerKwh: 1.6
  },
  {
    id: 5,
    name: '南区综合充电站',
    address: '南区学生活动中心',
    type: 'ultra-fast',
    pricePerKwh: 2.0
  }
];

// 根据ID查找充电站信息
const foundStation = chargingStations.find(s => s.id === stationId);
if (foundStation) {
  station.value = {
    id: foundStation.id,
    name: foundStation.name,
    address: foundStation.address,
    type: foundStation.type,
    pricePerKwh: foundStation.pricePerKwh
  };
} else {
  // 如果未找到对应充电站，则使用默认值
  const defaultStation = chargingStations.length > 0 ? chargingStations[0] : {
    id: 1,
    name: '默认充电站',
    address: '未知地址',
    type: 'fast',
    pricePerKwh: 1.5
  };

  // 使用类型断言确保类型安全
  station.value = {
    id: (defaultStation as typeof chargingStations[0]).id,
    name: (defaultStation as typeof chargingStations[0]).name,
    address: (defaultStation as typeof chargingStations[0]).address,
    type: (defaultStation as typeof chargingStations[0]).type,
    pricePerKwh: (defaultStation as typeof chargingStations[0]).pricePerKwh
  };

  // 并且跳转回充电服务页面
  router.push('/user/charging-service');
  ElMessage.error('未找到指定的充电站');
}

// 充电相关数据
const chargingProgress = ref(25);
const chargedAmount = ref(5.2); // 已充电量
const chargingDuration = ref('00:25:10'); // 充电时长
const estimatedCost = ref(7.8); // 预计费用

// 圆形进度条相关
const radius = 65;
const circumference = 2 * Math.PI * radius;

const strokeDashoffset = computed(() => {
  return circumference - (chargingProgress.value / 100) * circumference;
});

// 获取充电桩类型标签
const getChargerTypeLabel = (type: string) => {
  switch(type) {
    case 'fast': return '快充';
    case 'slow': return '慢充';
    case 'ultra-fast': return '超快充';
    default: return type;
  }
};

// 模拟充电过程
let chargingInterval: any = null;

onMounted(() => {
  // 模拟充电过程
  chargingInterval = setInterval(() => {
    if (chargingProgress.value < 100) {
      chargingProgress.value += 0.1;
      chargedAmount.value += 0.02;
      estimatedCost.value = chargedAmount.value * station.value.pricePerKwh;
      
      // 更新充电时长 (格式化为 HH:MM:SS)
      const totalSeconds = Math.floor(chargingProgress.value * 100 / 10); // 假设总时长100分钟
      const hours = Math.floor(totalSeconds / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;
      chargingDuration.value = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    }
  }, 1000);
});

onUnmounted(() => {
  if (chargingInterval) {
    clearInterval(chargingInterval);
  }
});
</script>

<style scoped>
.charging-detail-page {
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  margin: 0;
  padding: 0;
  padding-bottom: 40px;
}

.page-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 1;
}

.background-grid {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.grid-cell {
  position: absolute;
  width: var(--size);
  height: var(--size);
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  animation: floatGrid 15s infinite linear;
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
}

@keyframes floatGrid {
  0% {
    transform: translateY(0) translateX(0) rotate(0deg);
    opacity: 0;
  }
  10% {
    opacity: 0.5;
  }
  90% {
    opacity: 0.5;
  }
  100% {
    transform: translateY(-100vh) translateX(100px) rotate(360deg);
    opacity: 0;
  }
}

.gradient-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at center, transparent 0%, rgba(0, 0, 0, 0.7) 100%);
  z-index: 2;
}

.page-header {
  margin-bottom: 30px;
  padding: 0 20px;
  z-index: 3;
  position: relative;
  width: 100%;
  box-sizing: border-box;
}

.page-header h1 {
  margin: 0 0 15px 0;
  color: white;
  font-size: 24px;
  font-weight: 600;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  background: linear-gradient(45deg, #ffffff, #a0d2eb);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.detail-main {
  display: flex;
  justify-content: center;
  padding: 0 20px 20px;
  z-index: 3;
  position: relative;
  width: 100%;
  box-sizing: border-box;
}

.charging-card {
  width: 100%;
  max-width: 600px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  padding: 30px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: white;
  margin-bottom: 20px;
}

.charging-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 30px;
}

.station-info {
  text-align: center;
  margin-bottom: 20px;
}

.station-info h3 {
  margin: 0 0 10px 0;
  color: white;
  font-size: 22px;
}

.station-address {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: rgba(255, 255, 255, 0.8);
  margin: 10px 0;
}

.charger-type {
  margin-top: 10px;
}

.charging-progress {
  text-align: center;
  position: relative;
}

.progress-circle {
  position: relative;
  display: inline-block;
}

.progress-ring {
  transform: rotate(-90deg);
}

.progress-ring-circle {
  transition: stroke-dashoffset 0.5s ease-out;
  transform-origin: 50% 50%;
}

.progress-ring-circle-bg {
  stroke-linecap: round;
}

.progress-value {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 24px;
  font-weight: bold;
  color: white;
}

.progress-text {
  color: rgba(255, 255, 255, 0.9);
  margin-top: 15px;
  font-size: 16px;
}

.charging-stats {
  display: flex;
  justify-content: space-around;
  width: 100%;
  margin: 20px 0;
  flex-wrap: wrap;
  gap: 15px;
}

.stat-item {
  text-align: center;
  min-width: 100px;
}

.stat-label {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
  margin-bottom: 5px;
}

.stat-value {
  color: white;
  font-size: 18px;
  font-weight: bold;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .charging-detail-page {
    padding: 0 10px 20px;
  }

  .page-header {
    padding: 0 10px;
  }

  .charging-card {
    padding: 20px;
  }

  .charging-stats {
    flex-direction: column;
    align-items: center;
  }

  .stat-item {
    width: 100%;
  }

  .page-header h1 {
    font-size: 20px;
  }
}
</style>