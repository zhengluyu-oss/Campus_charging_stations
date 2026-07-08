<template>
  <div class="station-overview">
    <div class="overview-header">
      <h2 class="overview-title">
        <el-icon><Monitor /></el-icon>
        充电桩实时监控
      </h2>
      <div class="overview-actions">
        <el-button-group>
          <el-button
            :type="filter === 'all' ? 'primary' : 'default'"
            @click="filter = 'all'"
            class="filter-btn"
          >
            全部 ({{ stations.length }})
          </el-button>
          <el-button
            :type="filter === 'idle' ? 'primary' : 'default'"
            @click="filter = 'idle'"
            class="filter-btn"
          >
            空闲 ({{ idleCount }})
          </el-button>
          <el-button
            :type="filter === 'charging' ? 'primary' : 'default'"
            @click="filter = 'charging'"
            class="filter-btn"
          >
            使用中 ({{ chargingCount }})
          </el-button>
        </el-button-group>
        <el-button :icon="Refresh" @click="refreshData" class="refresh-btn" :loading="loading">
          刷新
        </el-button>
      </div>
    </div>

    <div class="stats-bar">
      <div class="stat-card">
        <div class="stat-icon idle">
          <el-icon><CircleCheck /></el-icon>
        </div>
        <div class="stat-content">
          <span class="stat-value">{{ idleCount }}</span>
          <span class="stat-label">空闲可用</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon charging">
          <el-icon><Loading /></el-icon>
        </div>
        <div class="stat-content">
          <span class="stat-value">{{ chargingCount }}</span>
          <span class="stat-label">充电中</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon total">
          <el-icon><DataBoard /></el-icon>
        </div>
        <div class="stat-content">
          <span class="stat-value">{{ stations.length }}</span>
          <span class="stat-label">总计</span>
        </div>
      </div>
    </div>

    <div class="stations-grid" v-loading="loading">
      <StationStatusCard
        v-for="station in filteredStations"
        :key="station.stationId"
        :station="station"
        @charge="handleCharge"
      />
      <div class="empty-state" v-if="filteredStations.length === 0 && !loading">
        <el-icon><InfoFilled /></el-icon>
        <p>暂无符合条件的充电桩</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import {
  Monitor, Refresh, CircleCheck, Loading,
  DataBoard, InfoFilled
} from '@element-plus/icons-vue';
import { getAllChargingStations } from '../api/charging';
import StationStatusCard from './StationStatusCard.vue';

interface ChargingStation {
  stationId: number;
  stationName: string;
  location: string;
  status: string;
  powerRating: number;
  pricePerHour: number;
}

const router = useRouter();
const stations = ref<ChargingStation[]>([]);
const loading = ref(false);
const filter = ref('all');
let refreshTimer: ReturnType<typeof setInterval> | null = null;

const isIdle = (s: ChargingStation) => s.status === '0' || s.status === 'available';
const isCharging = (s: ChargingStation) => s.status === '1' || s.status === 'occupied';

const idleCount = computed(() => stations.value.filter(isIdle).length);
const chargingCount = computed(() => stations.value.filter(isCharging).length);

const filteredStations = computed(() => {
  if (filter.value === 'all') return stations.value;
  if (filter.value === 'idle') return stations.value.filter(isIdle);
  if (filter.value === 'charging') return stations.value.filter(isCharging);
  return stations.value;
});

const fetchStations = async () => {
  loading.value = true;
  try {
    const res = await getAllChargingStations();
    stations.value = res.data || [];
  } catch {
    ElMessage.error('获取充电桩数据失败');
  } finally {
    loading.value = false;
  }
};

const refreshData = () => fetchStations();

const handleCharge = (station: ChargingStation) => {
  router.push(`/user/charging-service?stationId=${station.stationId}`);
};

onMounted(() => {
  fetchStations();
  refreshTimer = setInterval(fetchStations, 30000);
});

onUnmounted(() => {
  if (refreshTimer) clearInterval(refreshTimer);
});
</script>

<style scoped>
.station-overview {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(12px);
  border-radius: 20px;
  padding: 30px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  animation: fadeInUp 0.8s ease-out;
}

.overview-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  flex-wrap: wrap;
  gap: 15px;
}

.overview-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 0;
  font-size: 22px;
  font-weight: 600;
  color: white;
}

.overview-title .el-icon {
  color: #00c9ff;
}

.overview-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

.filter-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: rgba(255, 255, 255, 0.8);
}

.filter-btn:hover {
  background: rgba(255, 255, 255, 0.12);
  border-color: rgba(255, 255, 255, 0.25);
}

.filter-btn.el-button--primary {
  background: linear-gradient(135deg, #00c9ff, #92fe9d);
  border-color: transparent;
  color: #0f2027;
  font-weight: 600;
}

.refresh-btn {
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: rgba(255, 255, 255, 0.8);
}

.refresh-btn:hover {
  background: rgba(0, 201, 255, 0.2);
  border-color: #00c9ff;
  color: #00c9ff;
}

.stats-bar {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 15px;
  margin-bottom: 25px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 15px;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 12px;
  padding: 18px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-3px);
  border-color: rgba(255, 255, 255, 0.15);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

.stat-icon.idle {
  background: rgba(146, 254, 157, 0.15);
  color: #92fe9d;
}

.stat-icon.charging {
  background: rgba(255, 107, 107, 0.15);
  color: #ff6b6b;
}

.stat-icon.total {
  background: rgba(0, 201, 255, 0.15);
  color: #00c9ff;
}

.stat-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: white;
}

.stat-label {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
}

.stations-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  min-height: 200px;
}

.empty-state {
  grid-column: 1 / -1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: rgba(255, 255, 255, 0.5);
}

.empty-state .el-icon {
  font-size: 48px;
  margin-bottom: 15px;
}

.empty-state p {
  margin: 0;
  font-size: 16px;
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 768px) {
  .station-overview {
    padding: 20px;
  }

  .overview-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .overview-actions {
    width: 100%;
    flex-wrap: wrap;
  }

  .stats-bar {
    grid-template-columns: repeat(2, 1fr);
  }

  .stations-grid {
    grid-template-columns: 1fr;
  }
}
</style>
