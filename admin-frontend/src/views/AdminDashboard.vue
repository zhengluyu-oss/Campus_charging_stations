<template>
  <div class="dashboard-page">
    <!-- Decorative particles -->
    <div class="particles">
      <div v-for="n in 20" :key="n" class="particle" :style="particleStyle(n)"></div>
    </div>

    <!-- Stats cards row -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6" v-for="stat in stats" :key="stat.label">
        <div class="stat-card">
          <div class="stat-icon" :style="{ background: stat.gradient }">
            <el-icon :size="26"><component :is="stat.icon" /></el-icon>
          </div>
          <div class="stat-info">
            <span class="stat-value">{{ stat.value }}</span>
            <span class="stat-label">{{ stat.label }}</span>
          </div>
          <div class="stat-trend" :class="stat.trendUp ? 'up' : 'down'">
            <el-icon :size="14"><Top v-if="stat.trendUp" /><Bottom v-else /></el-icon>
            <span>{{ stat.trend }}</span>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- Middle row: Recent orders + Station overview -->
    <el-row :gutter="20">
      <el-col :xs="24" :lg="16">
        <div class="glass-card">
          <div class="card-header">
            <h3>Recent Orders</h3>
            <el-button text size="small" class="view-all-btn" @click="$router.push('/orders')">
              View All <el-icon><ArrowRight /></el-icon>
            </el-button>
          </div>
          <el-table :data="recentOrders" class="dark-table" style="width: 100%">
            <el-table-column prop="orderId" label="Order ID" width="90" />
            <el-table-column prop="userId" label="User ID" width="85" />
            <el-table-column prop="stationId" label="Station" width="80" />
            <el-table-column prop="startTime" label="Time" min-width="150">
              <template #default="{ row }">
                {{ formatTime(row.startTime) }}
              </template>
            </el-table-column>
            <el-table-column prop="totalAmount" label="Amount" width="90">
              <template #default="{ row }">
                <span class="amount">¥{{ row.totalAmount?.toFixed(2) || '0.00' }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="paymentStatus" label="Status" width="100">
              <template #default="{ row }">
                <el-tag :type="statusType(row.paymentStatus)" size="small" effect="dark" round>
                  {{ row.paymentStatus }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>

      <el-col :xs="24" :lg="8">
        <div class="glass-card">
          <div class="card-header">
            <h3>Station Status</h3>
          </div>
          <div class="station-overview">
            <div class="pie-placeholder">
              <div class="pie-ring">
                <span class="pie-total">{{ stationStats.total }}</span>
                <span class="pie-label">Total</span>
              </div>
            </div>
            <div class="station-legend">
              <div class="legend-item" v-for="item in stationLegend" :key="item.label">
                <span class="legend-dot" :style="{ background: item.color }"></span>
                <span class="legend-label">{{ item.label }}</span>
                <span class="legend-count">{{ item.count }}</span>
              </div>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- Quick actions -->
    <div class="glass-card">
      <div class="card-header">
        <h3>Quick Actions</h3>
      </div>
      <div class="quick-actions">
        <el-button class="action-btn" @click="$router.push('/users')">
          <el-icon><User /></el-icon>Manage Users
        </el-button>
        <el-button class="action-btn" @click="$router.push('/stations')">
          <el-icon><Lightning /></el-icon>Manage Stations
        </el-button>
        <el-button class="action-btn" @click="$router.push('/orders')">
          <el-icon><Document /></el-icon>View Orders
        </el-button>
        <el-button class="action-btn" @click="$router.push('/news')">
          <el-icon><Notification /></el-icon>Publish News
        </el-button>
        <el-button class="action-btn" @click="$router.push('/settings')">
          <el-icon><Setting /></el-icon>Settings
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import request from '@/utils/request'

interface Order {
  orderId: number
  userId: number
  stationId: number
  startTime: string
  endTime: string
  durationMinutes: number
  totalAmount: number
  paymentStatus: string
  createdTime: string
}

interface Station {
  stationId: number
  stationName: string
  location: string
  status: string
  powerRating: number
  pricePerHour: number
}

const recentOrders = ref<Order[]>([])
const stations = ref<Station[]>([])

const stats = reactive([
  { label: 'Total Users', value: '--', icon: 'User', gradient: 'linear-gradient(135deg, #00c9ff, #0084ff)', trend: '--', trendUp: true },
  { label: 'Active Stations', value: '--', icon: 'Lightning', gradient: 'linear-gradient(135deg, #92fe9d, #00c9ff)', trend: '--', trendUp: true },
  { label: "Today's Orders", value: '--', icon: 'Document', gradient: 'linear-gradient(135deg, #f093fb, #f5576c)', trend: '--', trendUp: true },
  { label: 'Revenue', value: '--', icon: 'Money', gradient: 'linear-gradient(135deg, #ffd89b, #19547b)', trend: '--', trendUp: true },
])

const stationStats = reactive({
  total: 0,
  available: 0,
  occupied: 0,
  offline: 0,
})

const stationLegend = reactive([
  { label: 'Available', count: 0, color: '#92fe9d' },
  { label: 'Occupied', count: 0, color: '#ffd89b' },
  { label: 'Offline', count: 0, color: '#f5576c' },
])

function particleStyle(n: number) {
  const size = Math.random() * 3 + 1
  return {
    width: `${size}px`,
    height: `${size}px`,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    animationDelay: `${Math.random() * 15}s`,
    animationDuration: `${Math.random() * 15 + 10}s`,
    opacity: Math.random() * 0.3 + 0.05,
  }
}

function formatTime(time: string | null | undefined): string {
  if (!time) return '--'
  return time.replace('T', ' ').substring(0, 16)
}

function statusType(status: string): string {
  switch (status?.toLowerCase()) {
    case 'paid': return 'success'
    case 'pending': return 'warning'
    case 'failed': return 'danger'
    case 'refunded': return 'info'
    default: return 'info'
  }
}

async function fetchDashboardData() {
  try {
    // 并行发起所有请求，减少总等待时间
    const [userRes, stationRes, orderRes, allOrderRes]: any[] = await Promise.all([
      request.post('/user/page', { pageNum: 1, pageSize: 1 }),
      request.post('/chargingStation/page', { pageNum: 1, pageSize: 100 }),
      request.post('/order/page/payment-status', { pageNum: 1, pageSize: 5, paymentStatus: '' }),
      request.post('/order/page/payment-status', { pageNum: 1, pageSize: 100, paymentStatus: 'paid' }),
    ])

    // 处理用户数
    if (userRes?.data?.total !== undefined) {
      stats[0].value = String(userRes.data.total)
    }

    // 处理充电站数据
    if (stationRes?.data?.records) {
      stations.value = stationRes.data.records
      stationStats.total = stationRes.data.total || stationRes.data.records.length
      stationStats.available = stationRes.data.records.filter((s: Station) => s.status === 'available' || s.status === '0').length
      stationStats.occupied = stationRes.data.records.filter((s: Station) => s.status === 'occupied' || s.status === '1').length
      stationStats.offline = stationRes.data.records.filter((s: Station) => s.status === 'offline' || s.status === '2').length

      stationLegend[0].count = stationStats.available
      stationLegend[1].count = stationStats.occupied
      stationLegend[2].count = stationStats.offline

      stats[1].value = String(stationStats.available)
    }

    // 处理近期订单
    if (orderRes?.data?.records) {
      recentOrders.value = orderRes.data.records
      const today = new Date().toISOString().split('T')[0]
      const todayOrders = orderRes.data.records.filter((o: Order) => o.createdTime?.startsWith(today))
      stats[2].value = String(todayOrders.length)
    }

    // 计算收入
    if (allOrderRes?.data?.records) {
      const totalRevenue = allOrderRes.data.records.reduce((sum: number, o: Order) => sum + (o.totalAmount || 0), 0)
      stats[3].value = `¥${totalRevenue.toFixed(2)}`
    }
  } catch {
    // Errors handled by interceptor
  }
}

onMounted(() => {
  fetchDashboardData()
})
</script>

<style scoped>
.dashboard-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: relative;
}

/* Decorative particles */
.particles {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.particle {
  position: absolute;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  border-radius: 50%;
  animation: dashFloat linear infinite;
  filter: blur(1px);
}

@keyframes dashFloat {
  0% { transform: translateY(0) translateX(0); opacity: 0; }
  10% { opacity: 0.2; }
  90% { opacity: 0.2; }
  100% { transform: translateY(-80vh) translateX(30px); opacity: 0; }
}

/* Stats cards */
.stats-row {
  position: relative;
  z-index: 1;
}

.stat-card {
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 16px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 14px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.stat-card:hover {
  transform: translateY(-2px);
  border-color: rgba(0, 201, 255, 0.2);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
}

.stat-icon {
  width: 50px;
  height: 50px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex: 1;
}

.stat-value {
  font-size: 22px;
  font-weight: 700;
  color: #ffffff;
}

.stat-label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
}

.stat-trend {
  position: absolute;
  top: 12px;
  right: 14px;
  font-size: 11px;
  display: flex;
  align-items: center;
  gap: 2px;
}

.stat-trend.up {
  color: #92fe9d;
}

.stat-trend.down {
  color: #f5576c;
}

/* Glass card */
.glass-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 16px;
  padding: 20px;
  position: relative;
  z-index: 1;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.card-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #ffffff;
}

.view-all-btn {
  color: rgba(255, 255, 255, 0.5) !important;
  font-size: 12px;
}

.view-all-btn:hover {
  color: #00c9ff !important;
}

/* Dark table overrides */
.dark-table :deep(.el-table__header-wrapper th) {
  background: rgba(255, 255, 255, 0.04) !important;
  color: rgba(255, 255, 255, 0.6) !important;
  border-bottom-color: rgba(255, 255, 255, 0.06) !important;
  font-size: 12px;
  font-weight: 600;
}

.dark-table :deep(.el-table__body-wrapper) {
  background: transparent !important;
}

.dark-table :deep(.el-table__body-wrapper tr) {
  background: transparent !important;
}

.dark-table :deep(.el-table__body-wrapper tr:hover > td) {
  background: rgba(255, 255, 255, 0.04) !important;
}

.dark-table :deep(td) {
  color: rgba(255, 255, 255, 0.75) !important;
  border-bottom-color: rgba(255, 255, 255, 0.04) !important;
  font-size: 13px;
}

.dark-table :deep(.el-table__empty-block) {
  background: transparent !important;
}

.dark-table {
  background: transparent !important;
  --el-table-bg-color: transparent !important;
  --el-table-tr-bg-color: transparent !important;
  --el-table-header-bg-color: transparent !important;
  --el-table-border-color: rgba(255, 255, 255, 0.06) !important;
  --el-table-text-color: rgba(255, 255, 255, 0.75) !important;
  --el-table-header-text-color: rgba(255, 255, 255, 0.6) !important;
}

.amount {
  color: #92fe9d;
  font-weight: 600;
}

/* Station overview */
.station-overview {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.pie-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
}

.pie-ring {
  width: 140px;
  height: 140px;
  border-radius: 50%;
  background: conic-gradient(
    #92fe9d 0% 40%,
    #ffd89b 40% 75%,
    #f5576c 75% 100%
  );
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  box-shadow: 0 0 30px rgba(0, 201, 255, 0.15);
}

.pie-ring::before {
  content: '';
  position: absolute;
  width: 90px;
  height: 90px;
  background: rgba(15, 32, 39, 0.95);
  border-radius: 50%;
}

.pie-total {
  position: relative;
  z-index: 1;
  font-size: 28px;
  font-weight: 700;
  color: #ffffff;
}

.pie-label {
  position: relative;
  z-index: 1;
  font-size: 11px;
  color: rgba(255, 255, 255, 0.5);
}

.station-legend {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
}

.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 3px;
  flex-shrink: 0;
}

.legend-label {
  flex: 1;
  color: rgba(255, 255, 255, 0.65);
}

.legend-count {
  font-weight: 600;
  color: #ffffff;
}

/* Quick actions */
.quick-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.action-btn {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 10px !important;
  color: rgba(255, 255, 255, 0.75) !important;
  padding: 12px 20px !important;
  font-size: 13px !important;
  transition: all 0.25s ease !important;
}

.action-btn:hover {
  background: rgba(0, 201, 255, 0.1) !important;
  border-color: rgba(0, 201, 255, 0.3) !important;
  color: #00c9ff !important;
  transform: translateY(-1px);
}

.action-btn .el-icon {
  margin-right: 6px;
}
</style>
