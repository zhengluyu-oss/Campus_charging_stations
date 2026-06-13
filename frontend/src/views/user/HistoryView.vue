<template>
  <div class="history-page">
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




<!--充电历史记录-->
    <header class="page-header">
      <h1>充电历史</h1>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>充电历史</el-breadcrumb-item>
      </el-breadcrumb>
    </header>

    <main class="history-main">
      <el-card class="history-card">
<!--        搜索框-->
        <template #header>
          <div class="card-header">
            <span>历史记录</span>
            <el-input
              v-model="searchTerm"
              placeholder="搜索充电记录..."
              style="width: 200px;"
              clearable
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
          </div>
        </template>

        <el-table
          :data="filteredHistory"
          stripe
          style="width: 100%"
          empty-text="暂无充电历史记录"
          v-loading="loading"
        >
          <el-table-column prop="date" label="日期时间" width="180" />
          <el-table-column prop="stationName" label="充电站" width="200" />
          <el-table-column prop="chargerId" label="充电桩名称" width="120" />
          <el-table-column prop="duration" label="时长" width="100" >
<!--          <el-table-column prop="amount" label="费用" width="100" />-->
<!--          <el-table-column prop="status" label="状态" width="100">-->
<!--            <template #default="scope">-->
<!--              <el-tag :type="getStatusTagType(scope.row.status)">-->
<!--                {{ scope.row.statusText }}-->
<!--              </el-tag>-->
<!--            </template>-->
          </el-table-column>
<!--          <el-table-column label="操作" width="150">-->
<!--            <template #default="scope">-->
<!--              <el-button size="small" @click="viewDetails(scope.row)">查看详情</el-button>-->
<!--            </template>-->
<!--          </el-table-column>-->
        </el-table>

        <div class="pagination-section">
          <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="currentPage"
            :page-sizes="[5, 10, 20, 50]"
            :page-size="pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="filteredHistory.length"
          />
        </div>
      </el-card>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { ElMessage } from 'element-plus';
import { Search } from '@element-plus/icons-vue';
import { getChargingHistory } from '@/api/chargingStationsApi';
import { useUserStore } from '@/stores/user';

const userStore = useUserStore();

// 预计算粒子位置，避免模板中 Math.random() 导致重渲染跳动
const particles = Array.from({ length: 30 }, () => ({
  left: `${Math.random() * 100}%`,
  top: `${Math.random() * 100}%`,
  animationDelay: `${Math.random() * 5}s`,
  size: `${Math.random() * 8 + 2}px`
}));

// 搜索关键词
const searchTerm = ref('');

// 分页参数
const currentPage = ref(1);
const pageSize = ref(10);

// 加载状态
const loading = ref(false);

// 充电历史数据
const chargingHistory = ref<any[]>([]);

// 获取充电历史记录
const fetchChargingHistory = async () => {
  const userId = userStore.user?.id;
  if (!userId) {
    ElMessage.error('请先登录');
    return;
  }

  try {
    loading.value = true;
    const response = await getChargingHistory(userId);
    console.log('充电历史记录完整响应:', response);

    if (response && response.data) {
      chargingHistory.value = response.data.map((record: any) => {
        const startTime = record.startTime || record.start_time;
        const endTime = record.endTime || record.end_time;
        const durationMinutes = calculateDuration(startTime, endTime);
        
        return {
          id: record.orderId || record.order_id || record.id,
          date: `${startTime || ''} - ${endTime || ''}`,
          stationName: record.stationName || record.station_name || `充电桩 #${record.stationId}`,
          chargerId: record.stationId || record.station_id,
          duration: formatDuration(durationMinutes),
          amount: `¥${record.cost || record.amount || record.totalCost || 0}`,
          status: record.status || 'completed',
          statusText: getStatusText(record.status),
          details: `充电量: ${record.energy || record.chargedAmount || record.charged_amount || 0}kWh`
        };
      });
      console.log('最终充电历史数据:', chargingHistory.value);
    }
  } catch (error) {
    console.error('获取充电历史记录失败:', error);
    ElMessage.error('获取充电历史记录失败');
  } finally {
    loading.value = false;
  }
};

// 计算时长（分钟）
const calculateDuration = (startTime: string, endTime: string) => {
  if (!startTime || !endTime) return 0;
  try {
    const start = new Date(startTime).getTime();
    const end = new Date(endTime).getTime();
    return Math.round((end - start) / (1000 * 60));
  } catch {
    return 0;
  }
};

// 格式化日期时间
const formatDateTime = (dateTime: string) => {
  if (!dateTime) return '未知时间';
  return dateTime.replace('T', ' ').substring(0, 19);
};

// 格式化时长
const formatDuration = (minutes: number) => {
  if (!minutes) return '未知时长';
  const hours = Math.floor(minutes / 60);
  const mins = minutes % 60;
  if (hours > 0) {
    return `${hours}小时${mins > 0 ? mins + '分钟' : ''}`;
  }
  return `${mins}分钟`;
};

// 获取状态文本
const getStatusText = (status: string | number) => {
  if (status === 0 || status === 'completed') return '已完成';
  if (status === 1 || status === 'in-progress') return '进行中';
  if (status === 2 || status === 'cancelled') return '已取消';
  return '未知';
};

// 页面加载时获取充电历史记录
onMounted(() => {
  fetchChargingHistory();
});

// 根据搜索词过滤历史记录
const filteredHistory = computed(() => {
  const filtered = chargingHistory.value.filter(item => 
    item.stationName.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
    String(item.chargerId).toLowerCase().includes(searchTerm.value.toLowerCase())
  );
  
  // 实现分页
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return filtered.slice(start, end);
});

// 获取状态标签类型
const getStatusTagType = (status: string) => {
  switch(status) {
    case 'completed': return 'success';
    case 'cancelled': return 'danger';
    case 'in-progress': return 'primary';
    default: return 'info';
  }
};

// 查看详情
const viewDetails = (row: any) => {
  ElMessage.info(`充电详情: ${row.details}`);
};

// 分页大小改变
const handleSizeChange = (val: number) => {
  pageSize.value = val;
  currentPage.value = 1;
};

// 当前页改变
const handleCurrentChange = (val: number) => {
  currentPage.value = val;
};
</script>

<style scoped>
.history-page {
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  margin: 0;
  padding: 0;
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

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: white;
}

.history-card {
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

:deep(.el-card__header) {
  background: rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

:deep(.el-card__body) {
  background: transparent;
}

:deep(.el-table) {
  background: transparent !important;
  --el-table-bg-color: transparent;
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: rgba(255, 255, 255, 0.1);
  --el-table-row-hover-bg-color: rgba(255, 255, 255, 0.15);
  --el-table-text-color: #ffffff;
  --el-table-header-text-color: #ffffff;
}

:deep(.el-table th.el-table__cell) {
  background: rgba(255, 255, 255, 0.1) !important;
  color: #ffffff !important;
  font-weight: 600;
}

:deep(.el-table td.el-table__cell) {
  background: rgba(0, 0, 0, 0.2) !important;
  color: #ffffff !important;
}

:deep(.el-table--striped .el-table__body tr.el-table__row--striped td.el-table__cell) {
  background: rgba(0, 0, 0, 0.3) !important;
}

:deep(.el-table__body tr:hover > td.el-table__cell) {
  background: rgba(255, 255, 255, 0.15) !important;
}

:deep(.el-table .cell) {
  color: #ffffff !important;
}

:deep(.el-table__empty-text) {
  color: rgba(255, 255, 255, 0.6) !important;
}

:deep(.el-table--enable-row-hover .el-table__body tr:hover > td.el-table__cell) {
  background: rgba(255, 255, 255, 0.15) !important;
}

:deep(.el-table__inner-wrapper::before) {
  background-color: rgba(255, 255, 255, 0.1);
}

.pagination-section {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .history-page {
    padding: 0;
  }

  .card-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .el-input {
    width: 100% !important;
  }
}
</style>