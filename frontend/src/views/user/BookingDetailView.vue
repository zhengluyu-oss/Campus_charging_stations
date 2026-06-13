<template>
  <div class="booking-detail-page">
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
      <h1>预约详情</h1>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item :to="{ path: '/booking' }">预约充电</el-breadcrumb-item>
        <el-breadcrumb-item>预约详情</el-breadcrumb-item>
      </el-breadcrumb>
    </header>

    <main class="booking-detail-main">
      <el-card class="detail-card">
        <template #header>
          <div class="card-header">
            <span>充电站信息</span>
          </div>
        </template>

        <div class="station-info">
          <h2>{{ station.name }}</h2>
          <p class="station-address">
            <el-icon><Location /></el-icon>
            {{ station.address }}
          </p>

          <div class="station-stats">
            <div class="stat">
              <div class="stat-value">{{ station.availableCount }}</div>
              <div class="stat-label">可用充电桩</div>
            </div>
            <div class="stat">
              <div class="stat-value">{{ station.totalCount }}</div>
              <div class="stat-label">总充电桩</div>
            </div>
            <div class="stat">
              <div class="stat-value">{{ station.type === 'fast' ? '快充' : station.type === 'slow' ? '慢充' : '超快充' }}</div>
              <div class="stat-label">类型</div>
            </div>
          </div>

          <div class="station-details">
            <div class="detail-item">
              <strong>开放时间:</strong> {{ station.openingHours }}
            </div>
            <div class="detail-item">
              <strong>价格:</strong> ¥{{ station.pricePerKwh }}/kWh
            </div>
            <div class="detail-item">
              <strong>评分:</strong>
              <el-rate v-model="station.rating" disabled show-score text-color="#ff9900" score-template="{value} 星" />
            </div>
          </div>
        </div>
      </el-card>

      <el-card class="booking-form-card">
        <template #header>
          <div class="card-header">
            <span>预约信息</span>
          </div>
        </template>

        <el-form :model="bookingForm" :rules="bookingRules" ref="bookingFormRef" label-width="120px">
          <el-form-item label="预约日期" prop="date">
            <el-date-picker
              v-model="bookingForm.date"
              type="date"
              placeholder="选择日期"
              style="width: 100%;"
            />
          </el-form-item>

          <el-form-item label="开始时间" prop="startTime">
            <el-time-select
              v-model="bookingForm.startTime"
              start="08:00"
              step="00:30"
              end="22:00"
              placeholder="选择开始时间"
              style="width: 100%;"
            />
          </el-form-item>

          <el-form-item label="结束时间" prop="endTime">
            <el-time-select
              v-model="bookingForm.endTime"
              start="08:00"
              step="00:30"
              end="22:00"
              :min-time="bookingForm.startTime"
              placeholder="选择结束时间"
              style="width: 100%;"
            />
          </el-form-item>

          <el-form-item label="车辆信息">
            <el-input
              v-model="bookingForm.vehicleNumber"
              placeholder="请输入车牌号"
              maxlength="10"
            />
          </el-form-item>

          <el-form-item label="联系方式">
            <el-input
              v-model="bookingForm.contact"
              placeholder="请输入联系电话"
              maxlength="11"
            />
          </el-form-item>

          <el-form-item>
            <el-button 
              type="primary" 
              @click="submitBooking" 
              :loading="submitting"
              style="width: 100%;"
            >
              {{ submitting ? '提交中...' : '确认预约' }}
            </el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import { Location } from '@element-plus/icons-vue';

const route = useRoute();
const router = useRouter();

// 预计算粒子位置，避免模板中 Math.random() 导致重渲染跳动
const particles = Array.from({ length: 30 }, () => ({
  left: `${Math.random() * 100}%`,
  top: `${Math.random() * 100}%`,
  animationDelay: `${Math.random() * 5}s`,
  size: `${Math.random() * 8 + 2}px`
}));

// 获取传入的站点ID
const stationId = parseInt(route.params.id as string);

// 模拟站点数据
const station = ref({
  id: 1,
  name: '校园北区充电站',
  address: '北区教学楼旁',
  area: 'north',
  distance: 0.5,
  openingHours: '24小时',
  totalCount: 10,
  availableCount: 4,
  type: 'fast',
  status: 'available',
  pricePerKwh: 1.5,
  rating: 4.5
});

// 预约表单
const bookingForm = reactive({
  date: null as Date | null,
  startTime: '',
  endTime: '',
  vehicleNumber: '',
  contact: ''
});

// 表单验证规则
const bookingRules = {
  date: [
    { required: true, message: '请选择预约日期', trigger: 'change' }
  ],
  startTime: [
    { required: true, message: '请选择开始时间', trigger: 'change' }
  ],
  endTime: [
    { required: true, message: '请选择结束时间', trigger: 'change' }
  ]
};

const bookingFormRef = ref();
const submitting = ref(false);

// 加载站点信息
onMounted(() => {
  // 根据ID查找站点信息（模拟）
  const mockStations = [
    {
      id: 1,
      name: '校园北区充电站',
      address: '北区教学楼旁',
      area: 'north',
      distance: 0.5,
      openingHours: '24小时',
      totalCount: 10,
      availableCount: 4,
      type: 'fast',
      status: 'available',
      pricePerKwh: 1.5,
      rating: 4.5
    },
    {
      id: 2,
      name: '宿舍区充电站',
      address: '学生宿舍楼下',
      area: 'dormitory',
      distance: 1.2,
      openingHours: '6:00-23:00',
      totalCount: 8,
      availableCount: 2,
      type: 'slow',
      status: 'busy',
      pricePerKwh: 1.2,
      rating: 4.2
    },
    {
      id: 3,
      name: '图书馆充电站',
      address: '图书馆停车场',
      area: 'academic',
      distance: 0.8,
      openingHours: '8:00-22:00',
      totalCount: 6,
      availableCount: 6,
      type: 'fast',
      status: 'available',
      pricePerKwh: 1.8,
      rating: 4.7
    }
  ];

  const foundStation = mockStations.find(s => s.id === stationId);
  if (foundStation) {
    station.value = foundStation;
  } else {
    ElMessage.error('未找到指定的充电站');
    router.push('/booking'); // 返回预约页面
  }
});

// 提交预约
const submitBooking = async () => {
  if (!bookingForm.date || !bookingForm.startTime || !bookingForm.endTime) {
    ElMessage.error('请填写完整的预约信息');
    return;
  }

  try {
    submitting.value = true;
    
    // 模拟预约请求
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    ElMessage.success('预约成功！');
    router.push('/user-dashboard');
  } catch (error) {
    ElMessage.error('预约失败，请重试');
  } finally {
    submitting.value = false;
  }
};
</script>

<style scoped>
.booking-detail-page {
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

.booking-detail-main {
  padding: 0 20px;
  z-index: 3;
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-card, .booking-form-card {
  overflow: visible;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  z-index: 3;
  position: relative;
  width: 100%;
  box-sizing: border-box;
}

.station-info h2 {
  margin: 0 0 15px 0;
  color: white;
  font-size: 22px;
}

.station-address {
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.station-stats {
  display: flex;
  justify-content: space-around;
  margin: 20px 0;
  padding: 20px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.stat {
  text-align: center;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: white;
}

.stat-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.station-details {
  margin-top: 20px;
}

.detail-item {
  margin-bottom: 15px;
  color: rgba(255, 255, 255, 0.9);
}

.detail-item strong {
  color: white;
  margin-right: 10px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: white;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .booking-detail-page {
    padding: 0 10px 20px;
  }

  .page-header {
    padding: 0 10px;
  }

  .booking-detail-main {
    padding: 0 10px;
    gap: 15px;
  }

  .station-stats {
    flex-direction: column;
    gap: 15px;
  }
}
</style>