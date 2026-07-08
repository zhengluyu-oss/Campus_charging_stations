<template>
  <div class="station-card" :class="statusClass">
    <div class="card-glow"></div>
    <div class="card-header">
      <div class="station-icon">
        <el-icon><Lightning /></el-icon>
      </div>
      <div class="status-badge" :class="statusClass">
        <span class="status-dot"></span>
        {{ statusText }}
      </div>
    </div>
    <div class="card-body">
      <h3 class="station-name">{{ station.stationName }}</h3>
      <p class="station-location">
        <el-icon><Location /></el-icon>
        {{ station.location }}
      </p>
      <div class="station-info">
        <div class="info-item">
          <span class="info-label">功率</span>
          <span class="info-value">{{ station.powerRating }}kW</span>
        </div>
        <div class="info-item">
          <span class="info-label">价格</span>
          <span class="info-value">¥{{ station.pricePerHour }}/时</span>
        </div>
      </div>
    </div>
    <div class="card-footer" v-if="station.status === '0' || station.status === 'available'">
      <el-button type="primary" class="charge-btn" @click="$emit('charge', station)">
        立即充电
      </el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { Lightning, Location } from '@element-plus/icons-vue';

interface ChargingStation {
  stationId: number;
  stationName: string;
  location: string;
  status: string;
  powerRating: number;
  pricePerHour: number;
}

const props = defineProps<{
  station: ChargingStation;
}>();

defineEmits<{
  charge: [station: ChargingStation];
}>();

const statusClass = computed(() => {
  const s = props.station.status;
  if (s === '0' || s === 'available') return 'status-idle';
  if (s === '1' || s === 'occupied') return 'status-charging';
  return 'status-maintenance';
});

const statusText = computed(() => {
  const s = props.station.status;
  if (s === '0' || s === 'available') return '空闲';
  if (s === '1' || s === 'occupied') return '使用中';
  if (s === 'maintenance') return '维护中';
  return '未知';
});
</script>

<style scoped>
.station-card {
  position: relative;
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(12px);
  border-radius: 16px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  transition: all 0.3s ease;
}

.station-card:hover {
  transform: translateY(-5px);
  border-color: rgba(0, 201, 255, 0.3);
  box-shadow: 0 10px 30px rgba(0, 201, 255, 0.2);
}

.station-card.status-idle:hover {
  border-color: rgba(146, 254, 157, 0.3);
  box-shadow: 0 10px 30px rgba(146, 254, 157, 0.2);
}

.station-card.status-charging:hover {
  border-color: rgba(255, 107, 107, 0.3);
  box-shadow: 0 10px 30px rgba(255, 107, 107, 0.2);
}

.card-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(0, 201, 255, 0.1) 0%, transparent 70%);
  opacity: 0;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.station-card:hover .card-glow {
  opacity: 1;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.station-icon {
  width: 48px;
  height: 48px;
  background: rgba(0, 201, 255, 0.1);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: #00c9ff;
}

.status-badge {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

.status-idle .status-badge {
  background: rgba(146, 254, 157, 0.15);
  color: #92fe9d;
}

.status-idle .status-dot {
  background: #92fe9d;
  box-shadow: 0 0 8px #92fe9d;
}

.status-charging .status-badge {
  background: rgba(255, 107, 107, 0.15);
  color: #ff6b6b;
}

.status-charging .status-dot {
  background: #ff6b6b;
  box-shadow: 0 0 8px #ff6b6b;
}

.status-maintenance .status-badge {
  background: rgba(102, 102, 102, 0.3);
  color: #999;
}

.status-maintenance .status-dot {
  background: #666;
  box-shadow: 0 0 8px #666;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.card-body {
  margin-bottom: 15px;
}

.station-name {
  margin: 0 0 8px 0;
  font-size: 18px;
  font-weight: 600;
  color: white;
}

.station-location {
  display: flex;
  align-items: center;
  gap: 6px;
  margin: 0 0 15px 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

.station-info {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
  padding: 12px;
  background: rgba(0, 0, 0, 0.2);
  border-radius: 10px;
}

.info-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.info-label {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.5);
}

.info-value {
  font-size: 14px;
  font-weight: 600;
  color: white;
}

.card-footer {
  margin-top: 15px;
}

.charge-btn {
  width: 100%;
  height: 40px;
  background: linear-gradient(135deg, #00c9ff, #92fe9d);
  border: none;
  font-weight: 600;
  transition: all 0.3s ease;
}

.charge-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 20px rgba(0, 201, 255, 0.4);
}
</style>
