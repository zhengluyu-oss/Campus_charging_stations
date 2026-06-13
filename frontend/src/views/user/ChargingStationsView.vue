<template>
  <div class="charging-stations-page">
    <header class="page-header">
      <h1>充电服务</h1>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>充电服务</el-breadcrumb-item>
      </el-breadcrumb>
    </header>

    <main class="stations-main">
      <!-- 筛选区域 -->
      <el-card class="filter-card" shadow="never">
        <div class="filter-options">
          <el-space wrap :size="20">
            <div class="filter-group">
              <label>位置:</label>
              <el-select v-model="filters.location" placeholder="全部位置" clearable @change="applyFilters">
                <el-option label="南院" value="南院" />
                <el-option label="北院" value="北院" />
                <el-option label="东院" value="东院" />
                <el-option label="华岩路校区" value="华岩路校区" />
              </el-select>
            </div>

            <div class="filter-group">
              <label>状态:</label>
              <el-select v-model="filters.status" placeholder="全部状态" clearable @change="applyFilters">
                <el-option label="可使用" value="0" />
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
          <el-card class="list-card" shadow="never">
            <template #header>
              <div class="card-header">
                <span>充电站列表 ({{ filteredStations.length }})</span>
                <el-radio-group v-model="sortOption" @change="applyFilters" size="small">
                  <el-radio-button label="price">价格</el-radio-button>
                  <el-radio-button label="availability">可用性</el-radio-button>
                </el-radio-group>
              </div>
            </template>

            <div class="stations-list">
              <div v-if="loading" class="loading-state">
                <el-skeleton :rows="6" animated />
              </div>
              <div v-else>
                <div
                  v-for="station in paginatedStations"
                  :key="station.stationId"
                  class="station-item"
                >
                <div class="station-header">
                  <div class="station-name-section">
                    <h3>{{ station.stationName }}</h3>
                    <div class="station-tags">
                      <el-tag size="small" type="info">{{ station.location }}</el-tag>
                    </div>
                  </div>
                </div>

                <div class="station-actions">
                  <el-button
                    type="primary"
                    :disabled="station.status !== 0"
                    @click="bookStation(station)"
                  >
                    {{ station.status === 0 ? '可使用' : (station.status === 1 ? '使用中' : '维修中') }}
                  </el-button>
                </div>
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
import { ElMessage } from 'element-plus';
import { getAllChargingStations, getChargingStationsByLocation, getChargingStationsByStatus } from '@/api/chargingStationsApi';
import type { ChargingStation } from '@/viewmodel/ChargingStationModel';

const router = useRouter();

// 筛选条件
const filters = reactive({
  location: '',      // 位置
  status: ''        // 状态 (0=可使用, 1=使用中, 2=维修中)
});

// 排序选项
const sortOption = ref('price');

// 分页
const currentPage = ref(1);
const pageSize = ref(6);


// 充电站数据
const stations = ref<ChargingStation[]>([]);
const loading = ref(false);

// 从后端获取充电桩数据
const fetchChargingStations = async () => {
  try {
    loading.value = true;

    // 每次都从后端获取最新数据，不使用任何缓存
    const response = await getAllChargingStations();

    if ('state' in response && response.state === 0) { // 根据您提供的后端响应格式，使用state字段
      // 将后端数据转换为前端所需的格式
      stations.value = response.data.map((item: any) => ({
        stationId: item.stationId,
        stationName: item.stationName,
        location: item.location,
        powerRating: item.powerRating || 5.0,
        pricePerHour: item.pricePerHour || 0.5,
        createdTime: item.createdTime,
        updatedTime: item.updatedTime,
        status: item.status // 直接使用后端返回的状态值
      }));
    } else {
      ElMessage.error((response as any).message || '获取充电桩数据失败');
    }
  } catch (error) {
    console.error('获取充电桩数据时出错:', error);
    ElMessage.error('获取充电桩数据失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 组件挂载时获取数据
onMounted(() => {
  fetchChargingStations();
});

// 计算属性：筛选后的站点
const filteredStations = computed(() => {
  let result = stations.value.filter(station => {
    // 位置过滤
    const matchesLocation = !filters.location || station.location === filters.location;

    // 状态过滤
    const matchesStatus = !filters.status || station.status.toString() === filters.status;

    return matchesLocation && matchesStatus;
  });

  // 排序
  switch (sortOption.value) {
    case 'price':
      result.sort((a, b) => a.pricePerHour - b.pricePerHour);
      break;
    case 'availability':
      result.sort((a, b) => b.status - a.status); // 按状态排序，优先显示可使用的充电桩
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

  // 每次筛选时都从后端获取最新数据，然后应用筛选条件
  try {
    loading.value = true;

    let response;
    if (filters.location && !filters.status) {
      // 按位置筛选
      response = await getChargingStationsByLocation(filters.location);
    } else if (!filters.location && filters.status) {
      // 按状态筛选
      const statusNum = parseInt(filters.status);
      response = await getChargingStationsByStatus(statusNum);
    } else if (filters.location && filters.status) {
      // 同时按位置和状态筛选 - 先按位置获取，再在前端筛选状态
      response = await getChargingStationsByLocation(filters.location);
      if ('state' in response && response.state === 0) {
        const statusNum = parseInt(filters.status);
        stations.value = response.data
          .filter((item: any) => item.status === statusNum)
          .map((item: any) => ({
            stationId: item.stationId,
            stationName: item.stationName,
            location: item.location,
            powerRating: item.powerRating || 5.0,
            pricePerHour: item.pricePerHour || 0.5,
            createdTime: item.createdTime,
            updatedTime: item.updatedTime,
            status: item.status
          }));
        return; // 已经处理完数据，直接返回
      }
    } else {
      // 没有筛选条件，获取所有数据
      response = await getAllChargingStations();
    }

    if ('state' in response && response.state === 0) {
      stations.value = response.data.map((item: any) => ({
        stationId: item.stationId,
        stationName: item.stationName,
        location: item.location,
        powerRating: item.powerRating || 5.0,
        pricePerHour: item.pricePerHour || 0.5,
        createdTime: item.createdTime,
        updatedTime: item.updatedTime,
        status: item.status
      }));
    } else {
      ElMessage.error((response as any).message || '获取充电桩数据失败');
    }
  } catch (error) {
    console.error('筛选充电桩数据时出错:', error);
    ElMessage.error('筛选充电桩数据失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};


// 这个函数现在不再需要，因为我们不再使用地图标记
// 如果需要，可以保留但简化
const getMarkerClass = (station: any) => {
  if (station.status === 2) return 'inactive'; // 维修中状态
  if (station.status === 1) return 'busy'; // 使用中状态
  if (station.status === 0) return 'available'; // 可使用状态
  return 'available';
};

// 定位用户
const locateUser = () => {
  ElMessage.info('此功能暂不可用');
};

// 预约站点
const bookStation = (station: ChargingStation) => {
  if (station.status !== 0) {
    if (station.status === 1) {
      ElMessage.warning('该充电站正在使用中，请选择其他充电站');
    } else if (station.status === 2) {
      ElMessage.warning('该充电站正在维修中，请选择其他充电站');
    } else {
      ElMessage.warning('该充电站当前不可用，请选择其他充电站');
    }
    return;
  }

  // 跳转到预约详情页面
  router.push(`/booking/detail/${station.stationId}`);
  ElMessage.success(`已选择预约 ${station.stationName}`);
};

// 查看站点详情
const viewStationDetails = (station: ChargingStation) => {
  router.push(`/station/${station.stationId}`);
  ElMessage.success(`正在查看 ${station.stationName} 的详情`);
};

// 处理分页变化
const handlePageChange = (page: number) => {
  currentPage.value = page;
};

// 高亮地图上的站点（模拟功能）
// 如果不需要地图功能，可以移除这些函数
// const highlightStationOnMap = (station: ChargingStation) => {
//   selectedStation.value = station;
//   // 实际项目中这里会调用地图API高亮对应站点
// };

// 清除地图高亮（模拟功能）
// const clearHighlightOnMap = () => {
//   selectedStation.value = null;
//   // 实际项目中这里会调用地图API清除高亮
// };
</script>

<style scoped>
.charging-stations-page {
  min-height: 100vh;
  background-color: #f5f7fa;
  margin: 0;
  padding: 0;
  padding-bottom: 20px;
}

.page-header {
  margin-bottom: 20px;
  padding: 15px 20px;
  background: #fff;
  border-bottom: 1px solid #e4e7ed;
}

.page-header h1 {
  margin: 0 0 10px 0;
  color: #303133;
  font-size: 20px;
  font-weight: 500;
}

.filter-card {
  margin: 0 20px 20px;
  border-radius: 4px;
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
  color: #606266;
  font-size: 14px;
}

.filter-group .el-select {
  min-width: 150px;
}

.stations-container {
  width: 100%;
  padding: 0 20px;
  box-sizing: border-box;
}

.list-section-full {
  width: 100%;
}

.list-card {
  border-radius: 4px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #303133;
  font-weight: 500;
}

.stations-list {
  max-height: calc(100vh - 280px);
  overflow-y: auto;
  padding-right: 10px;
}

.loading-state {
  padding: 20px;
}

.station-item {
  padding: 15px;
  background: #fff;
  border-radius: 4px;
  border: 1px solid #e4e7ed;
  cursor: pointer;
  transition: all 0.2s ease;
  margin-bottom: 10px;
  border-left: 3px solid transparent;
}

.station-item:hover {
  border-left-color: #409EFF;
  background: #fafafa;
}

.station-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.station-name-section {
  flex: 1;
}

.station-name-section h3 {
  margin: 0 0 8px 0;
  color: #303133;
  font-size: 16px;
  font-weight: 500;
}

.station-tags {
  display: flex;
  gap: 8px;
}

.station-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.pagination-section {
  padding: 15px 0 0;
  text-align: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-header {
    padding: 15px;
  }

  .filter-card {
    margin: 0 15px 15px;
    padding: 15px;
  }

  .filter-group {
    width: 100%;
  }

  .filter-group .el-select {
    width: 100%;
  }

  .stations-container {
    padding: 0 15px;
  }

  .station-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }

  .station-actions {
    flex-direction: column;
    width: 100%;
  }

  .station-actions .el-button {
    width: 100%;
  }
}
</style>