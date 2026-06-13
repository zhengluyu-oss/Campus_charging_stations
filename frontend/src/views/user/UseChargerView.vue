<template>
  <div class="charging-stations-page">
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
      <h1>使用充电桩</h1>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item :to="{ path: '/user/charging-service' }">充电服务</el-breadcrumb-item>
        <el-breadcrumb-item>使用充电桩</el-breadcrumb-item>
      </el-breadcrumb>
    </header>

    <main class="stations-main">
      <!-- 筛选区域 -->
      <el-card class="filter-card">
        <div class="filter-options">
          <el-space wrap :size="20">
            <div class="filter-group">
              <label>区域:</label>
              <el-select v-model="filters.area" placeholder="全部区域" clearable @change="applyFilters">
                <el-option label="南院" value="南院" />
                <el-option label="北院" value="北院" />
                <el-option label="东院" value="东院" />
                <el-option label="华岩路校区" value="华岩路校区" />
              </el-select>
            </div>


            <div class="filter-group">
              <label>状态:</label>
              <el-select v-model="filters.status" placeholder="全部状态" clearable @change="applyFilters">
                <el-option label="可充电" value="0" />
                <el-option label="使用中" value="1" />
                <el-option label="维修中" value="2" />
              </el-select>
            </div>
          </el-space>
        </div>
      </el-card>

      <!-- 充电站列表 -->
      <div class="stations-container">
        <div class="list-section-full">
          <el-card class="list-card">
<!--            充电桩列表-->
            <template #header>
              <div class="card-header">
                <span>充电桩列表 ({{ filteredStations.length }})</span>
                <el-radio-group v-model="sortOption" @change="applyFilters" size="small">
                </el-radio-group>
              </div>
            </template>

            <div v-loading="loading" class="stations-list">
              <div
                v-for="station in paginatedStations"
                :key="station.stationId"
                class="station-item"
                :class="{ 'selected': selectedStation?.stationId === station.stationId }"
                @mouseenter="highlightStationOnMap(station)"
                @mouseleave="clearHighlightOnMap"
              >
<!--                卡片头部-->
                <div class="station-header">
                  <div class="station-name-section">
                    <h3>{{ station.stationName }}</h3>
                  </div>

                </div>
                <div class="station-tags">
                  <el-tag size="small" type="info">{{ station.location }}</el-tag>
                </div>

<!--                小时的价格 位置和功率
                <div class="station-details">
                  <div class="station-tags">
                    <el-tag size="small" type="info">{{ station.location }}</el-tag>
                  </div>
                  <div class="station-price">
                    <span>每小时收费</span>
                    <span>¥{{ station.pricePerHour }}/小时</span>
                  </div>
                  <div class="station-power">
                    <span>功率等级</span>
                    <span>{{ station.powerRating }} kW/h</span>
                  </div>
                </div>-->

                <div class="station-stats">
                  <div class="stat">
                    <div class="stat-value">¥{{ station.pricePerHour }}/小时</div>
                    <div class="stat-label">充电桩价格</div>
                  </div>
                  <div class="stat">
                    <div class="stat-value">{{ station.powerRating || '未知' }}</div>
                    <div class="stat-label">功率(kW)</div>
                  </div>
                  <div class="stat">
                    <div class="stat-value">{{ Number(station.status) === 0 ? '可用' : Number(station.status) === 1 ? '使用中' : '维护中' }}</div>
                    <div class="stat-label">状态</div>
                  </div>
                </div>



<!--                点击开始充电按钮-->
                <div class="station-actions">
                  <el-button
                    v-if="Number(station.status) === 0"
                    type="primary"
                    @click="startCharging(station)"
                  >
                    可充电
                  </el-button>
                  <el-button
                    v-else-if="Number(station.status) === 1"
                    type="warning"
                    @click="viewStationDetails(station)"
                  >
                    查看详情
                  </el-button>
                  <el-button
                    v-else-if="Number(station.status) === 2"
                    type="info"
                    disabled
                  >
                    维修中
                  </el-button>
                </div>
              </div>

              <!-- 分页 -->
              <div class="pagination-section">
                <el-pagination
                  v-model:current-page="currentPage"
                  v-model:page-size="pageSize"
                  :total="filteredStations.length"
                  layout="prev, pager, next, jumper"
                  @current-change="handlePageChange"
                />
              </div>
            </div>
          </el-card>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import { useUserStore } from '@/stores/user';
import {
  getAllChargingStations,
  getChargingStationsByLocation,
  getChargingStationsByStatus,
  startCharging as startChargingAPI,
} from '@/api/chargingStationsApi';
import type { ChargingStation } from '@/viewmodel/ChargingStationModel';

const router = useRouter();

// 预计算粒子位置，避免模板中 Math.random() 导致重渲染跳动
const particles = Array.from({ length: 50 }, () => ({
  left: `${Math.random() * 100}%`,
  top: `${Math.random() * 100}%`,
  animationDelay: `${Math.random() * 5}s`,
  size: `${Math.random() * 6 + 2}px`
}));

// 筛选条件
const filters = reactive({
  area: '',
  status: ''
});

// 排序选项
const sortOption = ref('price');

// 分页
const currentPage = ref(1);
const pageSize = ref(6);

// 当前选中的站点
const selectedStation = ref<ChargingStation | null>(null);

// 充电站数据
const stations = ref<ChargingStation[]>([]);
const loading = ref(false);

// 获取所有充电桩
const fetchAllStations = async () => {
  try {
    loading.value = true;
    const response = await getAllChargingStations();
    console.log('后端返回的完整响应:', response);
    
    if (response && Array.isArray(response)) {
      stations.value = response.map((station: any) => {
        console.log('充电桩原始数据:', station);
        
        const convertedStation: ChargingStation = {
          stationId: station.stationId || station.station_id,
          stationName: station.stationName || station.station_name,
          location: station.location,
          status: station.status,
          powerRating: station.powerRating || station.power_rating,
          pricePerHour: station.pricePerHour || station.price_per_hour,
          createdTime: station.createdTime || station.created_time,
          updatedTime: station.updatedTime || station.updated_time
        };
        console.log('转换后的充电桩数据:', convertedStation);
        return convertedStation;
      });
    } else if (response && response.data && Array.isArray(response.data)) {
      stations.value = response.data.map((station: any) => {
        console.log('充电桩原始数据:', station);
        
        const convertedStation: ChargingStation = {
          stationId: station.stationId || station.station_id,
          stationName: station.stationName || station.station_name,
          location: station.location,
          status: station.status,
          powerRating: station.powerRating || station.power_rating,
          pricePerHour: station.pricePerHour || station.price_per_hour,
          createdTime: station.createdTime || station.created_time,
          updatedTime: station.updatedTime || station.updated_time
        };
        console.log('转换后的充电桩数据:', convertedStation);
        return convertedStation;
      });
    } else {
      console.log('响应数据格式:', response);
      ElMessage.error('获取充电桩数据失败：响应格式不正确');
    }
  } catch (error) {
    console.error('获取充电桩数据失败:', error);
    ElMessage.error('获取充电桩数据失败');
  } finally {
    loading.value = false;
  }
};

// 根据位置筛选充电桩
const fetchStationsByLocation = async (location: string) => {
  try {
    loading.value = true;
    const response = await getChargingStationsByLocation(location);
    // 检查响应是否包含预期的数据结构
    if (response && response.data) {
      // 检查是否是包装过的响应（包含state/message/data结构）
      if ('state' in response && response.state !== undefined) {
        // 如果是包装过的响应
        if (response.state === 0 || response.state === 200) {
          stations.value = response.data.map((station: any) => {
            // 将后端的响应数据转换为前端使用的ChargingStation格式
            // 直接使用后端返回的字段，因为现在使用的是与后端一致的ChargingStation模型
            const convertedStation: ChargingStation = {
              stationId: station.station_id,
              stationName: station.station_name,
              location: station.location,
              status: station.status,
              powerRating: station.power_rating,
              pricePerHour: station.price_per_hour,
              createdTime: station.created_time,
              updatedTime: station.updated_time
            };
            return convertedStation;
          });
        } else {
          ElMessage.error((response as any).message || '获取充电桩数据失败');
        }
      } else {
        // 如果是直接的数据响应
        stations.value = response.data.map((station: any) => {
          // 将后端的下划线命名转换为前端的驼峰命名
          const convertedStation: ChargingStation = {
            stationId: station.station_id,
            stationName: station.station_name,
            location: station.location,
            status: station.status,
            powerRating: station.power_rating,
            pricePerHour: station.price_per_hour,
            createdTime: station.created_time,
            updatedTime: station.updated_time
          };
          return convertedStation;
        });
      }
    } else {
      ElMessage.error('获取充电桩数据失败：响应格式不正确');
    }
  } catch (error) {
    console.error('获取充电桩数据失败:', error);
    ElMessage.error('获取充电桩数据失败');
  } finally {
    loading.value = false;
  }
};

// 根据状态筛选充电桩
const fetchStationsByStatus = async (status: number) => {
  try {
    loading.value = true;
    console.log('按状态筛选充电桩，状态值:', status);
    const response = await getChargingStationsByStatus(status);
    console.log('按状态筛选返回的完整响应:', response);
    console.log('按状态筛选返回的数据:', response.data);
    
    // 检查响应是否包含预期的数据结构
    if (response && response.data) {
      // 检查是否是包装过的响应（包含state/message/data结构）
      if ('state' in response && response.state !== undefined) {
        // 如果是包装过的响应
        if (response.state === 0 || response.state === 200) {
          stations.value = response.data.map((station: any) => {
            console.log('充电桩原始数据:', station);
            console.log('充电桩status值:', station.status, '类型:', typeof station.status);
            
            // 将后端的下划线命名转换为前端的驼峰命名
            const convertedStation: ChargingStation = {
              stationId: station.station_id,
              stationName: station.station_name,
              location: station.location,
              status: station.status,
              powerRating: station.power_rating,
              pricePerHour: station.price_per_hour,
              createdTime: station.created_time,
              updatedTime: station.updated_time
            };
            console.log('转换后的充电桩数据:', convertedStation);
            return convertedStation;
          });
        } else {
          ElMessage.error((response as any).message || '获取充电桩数据失败');
        }
      } else {
        // 如果是直接的数据响应
        stations.value = response.data.map((station: any) => {
          console.log('充电桩原始数据:', station);
          console.log('充电桩status值:', station.status, '类型:', typeof station.status);
          
          // 将后端的下划线命名转换为前端的驼峰命名
          const convertedStation: ChargingStation = {
            stationId: station.station_id,
            stationName: station.station_name,
            location: station.location,
            status: station.status,
            powerRating: station.power_rating,
            pricePerHour: station.price_per_hour,
            createdTime: station.created_time,
            updatedTime: station.updated_time
          };
          console.log('转换后的充电桩数据:', convertedStation);
          return convertedStation;
        });
      }
    } else {
      ElMessage.error('获取充电桩数据失败：响应格式不正确');
    }
  } catch (error) {
    console.error('获取充电桩数据失败:', error);
    ElMessage.error('获取充电桩数据失败');
  } finally {
    loading.value = false;
  }
};

// 页面加载时获取所有充电桩
onMounted(() => {
  fetchAllStations();
});

// 计算属性：筛选后的站点
const filteredStations = computed(() => {
  // 如果同时有位置和状态筛选，需要在前端再次过滤
  let result = stations.value;
  if (filters.area && filters.status) {
    result = stations.value.filter(station => {
      // 区域过滤
      const matchesArea = !filters.area || station.location === filters.area;

      // 状态过滤 - 直接比较数字状态
      const matchesStatus = !filters.status || station.status.toString() === filters.status;

      return matchesArea && matchesStatus;
    });
  }

  // 排序
  switch (sortOption.value) {
    case 'price':
      result.sort((a, b) => (a.pricePerHour ?? 0) - (b.pricePerHour ?? 0));
      break;
    case 'availability':
      result.sort((a, b) => b.status - a.status); // 按状态排序，优先显示可充电的充电桩
      break;
  }

  return result;
});

// 计算属性：当前页显示的站点
const paginatedStations = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  return filteredStations.value.slice(start, start + pageSize.value);
});


// 应用筛选
const applyFilters = async () => {
  currentPage.value = 1; // 重置到第一页

  // 如果没有筛选条件，则获取所有充电桩
  if (!filters.area && !filters.status) {
    await fetchAllStations();
    return;
  }

  // 如果只选择了位置筛选
  if (filters.area && !filters.status) {
    await fetchStationsByLocation(filters.area);
    return;
  }

  // 如果只选择了状态筛选
  if (!filters.area && filters.status) {
    // 将状态字符串转换为数字（后端使用数字表示状态）
    const statusNum = parseInt(filters.status);

    await fetchStationsByStatus(statusNum);
    return;
  }

  // 如果同时选择了位置和状态筛选，我们先按位置筛选，然后在前端进行二次筛选
  if (filters.area && filters.status) {
    await fetchStationsByLocation(filters.area);
  }
};

// 获取充电桩类型标签
// const getChargerTypeLabel = (type: string | undefined) => {
//   if (!type) return '未知';
//   switch(type) {
//     case 'fast': return '快充';
//     case 'slow': return '慢充';
//     case 'ultra-fast': return '超快充';
//     default: return type;
//   }
// };

// 开始充电
const startCharging = async (station: any) => {
  console.log('开始充电函数被调用，充电桩状态:', station.status, '充电桩ID:', station.stationId);
  
  const statusNum = Number(station.status);
  if (statusNum !== 0) {
    if (statusNum === 1) {
      ElMessage.warning('该充电站正在使用中，请选择其他充电站');
    } else if (statusNum === 2) {
      ElMessage.warning('该充电站正在维修中，请选择其他充电站');
    } else {
      ElMessage.warning('该充电站当前不可用，请选择其他充电站');
    }
    return;
  }

  // 检查用户是否已登录
  const userStore = useUserStore();
  if (!userStore.user) {
    ElMessage.error('请先登录后再使用充电桩');
    router.push('/user-login');
    return;
  }

  // 弹出输入框询问充电时长
  const durationInput = await ElMessageBox.prompt('请输入充电时长（分钟）', '开始充电', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputType: 'number',
    inputValue: '60',
    inputPlaceholder: '请输入充电时长（分钟）',
    inputValidator: (value) => {
      const numValue = Number(value);
      if (!value) {
        return '请输入充电时长';
      }
      if (isNaN(numValue) || numValue <= 0) {
        return '请输入有效的充电时长';
      }
      if (numValue > 1440) { // 最大值限制为一天
        return '充电时长不能超过1440分钟（24小时）';
      }
      return true;
    },
    inputErrorMessage: '输入无效'
  }).catch(() => {
    console.log('用户取消了充电操作');
    // 用户取消操作
    return;
  });

  if (durationInput) {
    try {
      const durationMinutes = Number(durationInput.value);
      
      const userId = (userStore.user as any).userId || (userStore.user as any).id;
      if (!userId) {
        ElMessage.error('无法获取用户信息，请重新登录');
        return;
      }
      
      const stationId = station.stationId || station.station_id;
      console.log('充电桩信息:', station);
      console.log('传递的stationId:', stationId);
      
      if (!stationId) {
        ElMessage.error('无法获取充电桩ID，请刷新页面重试');
        return;
      }
      
      const response = await startChargingAPI(userId, stationId, durationMinutes);

      if ('state' in response && response.state === 0) {
        ElMessage.success(`${station.stationName} 充电已开始！`);
        router.push(`/charging/${stationId}?duration=${durationMinutes}&location=${encodeURIComponent(station.location)}`);
      } else {
        ElMessage.error((response as any).message || '开始充电失败');
      }
    } catch (error) {
      console.error('开始充电失败:', error);
      ElMessage.error('开始充电失败，请稍后重试');
    }
  }
};

// 查看站点详情
const viewStationDetails = (station: any) => {
  const stationId = station.stationId || station.station_id;
  router.push(`/charging/${stationId}`);
  ElMessage.success(`正在查看 ${station.stationName} 的详情`);
};

// 处理分页变化
const handlePageChange = (page: number) => {
  currentPage.value = page;
};

// 高亮地图上的站点（模拟功能）
const highlightStationOnMap = (station: ChargingStation) => {
  selectedStation.value = station;
  // 实际项目中这里会调用地图API高亮对应站点
};

// 清除地图高亮（模拟功能）
const clearHighlightOnMap = () => {
  selectedStation.value = null;
  // 实际项目中这里会调用地图API清除高亮
};
</script>

<style scoped>
.charging-stations-page {
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

.filter-card {
  margin-bottom: 20px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  z-index: 3;
  position: relative;
  padding: 20px;
}


.filter-options {
  width: 100%;
}

.filter-group {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.filter-group label {
  margin-bottom: 5px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

.filter-group .el-select {
  min-width: 150px;
}

.stations-container {
  width: 100%;
  padding: 0 20px;
  z-index: 3;
  position: relative;
}

.list-section-full {
  width: 100%;
}

.list-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
}

.list-section {
  width: 100%;
}

.list-card {
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
  height: calc(100vh - 250px);
  min-height: 500px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: white;
}

.stations-list {
  height: calc(100% - 60px);
  overflow-y: auto;
  padding-right: 10px;
}

.stations-list::-webkit-scrollbar {
  width: 6px;
}

.stations-list::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.stations-list::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 3px;
}

.station-item {
  padding: 20px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 15px;
  border-left: 4px solid transparent;
}

.station-item:hover,
.station-item.selected {
  transform: translateY(-3px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.3);
  background: rgba(255, 255, 255, 0.15);
  border-left: 4px solid #409eff;
}

.station-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 15px;
}

.station-name-section {
  flex: 1;
}

.station-name-section h3 {
  margin: 0 0 5px 0;
  color: white;
  font-size: 18px;
}

.station-tags {
  display: flex;
  gap: 8px;
  margin-top: 5px;
}

.station-rating {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.station-details {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 15px;
  color: rgba(255, 255, 255, 0.8);
}

.station-details div {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.station-stats {
  display: flex;
  justify-content: space-around;
  margin-bottom: 15px;
  padding: 15px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.stat {
  text-align: center;
}

.stat-value {
  font-size: 20px;
  font-weight: bold;
  color: white;
}

.stat-label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
}

.station-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.pagination-section {
  padding: 20px 0 0;
  text-align: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .charging-stations-page {
    padding: 0 10px 20px;
  }

  .page-header {
    padding: 0 10px;
  }

  .filter-card {
    padding: 15px;
  }

  .filter-group {
    width: 100%;
  }

  .filter-group .el-select {
    width: 100%;
  }

  .stations-container {
    gap: 15px;
    padding: 0 10px;
  }

  .station-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .station-actions {
    flex-direction: column;
  }

  .station-actions .el-button {
    width: 100%;
  }
}
</style>