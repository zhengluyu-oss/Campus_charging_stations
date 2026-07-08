<template>
  <div class="order-page">
    <!-- Decorative particles -->
    <div class="particles">
      <div v-for="n in 15" :key="n" class="particle" :style="particleStyle(n)"></div>
    </div>

    <!-- Filter bar -->
    <div class="glass-card filter-bar">
      <el-row :gutter="16" align="middle">
        <el-col :xs="24" :sm="6">
          <el-select v-model="filterStatus" placeholder="Payment Status" clearable class="dark-select" style="width: 100%">
            <el-option label="Pending" value="pending" />
            <el-option label="Paid" value="paid" />
            <el-option label="Failed" value="failed" />
            <el-option label="Refunded" value="refunded" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="6">
          <el-input
            v-model="filterUserId"
            placeholder="User ID"
            clearable
            class="dark-input"
            @keyup.enter="fetchOrders"
          >
            <template #prefix><el-icon><User /></el-icon></template>
          </el-input>
        </el-col>
        <el-col :xs="24" :sm="6">
          <el-date-picker
            v-model="filterDateRange"
            type="daterange"
            range-separator="to"
            start-placeholder="Start Date"
            end-placeholder="End Date"
            class="dark-datepicker"
            style="width: 100%"
          />
        </el-col>
        <el-col :xs="24" :sm="6" class="filter-actions">
          <el-button class="search-btn" @click="fetchOrders">
            <el-icon><Search /></el-icon>Search
          </el-button>
          <el-button class="export-btn" @click="handleExport">
            <el-icon><Download /></el-icon>Export
          </el-button>
        </el-col>
      </el-row>
    </div>

    <!-- Order table -->
    <div class="glass-card">
      <el-table :data="orders" class="dark-table" style="width: 100%" v-loading="loading">
        <el-table-column prop="orderId" label="Order ID" width="95" />
        <el-table-column prop="userId" label="User" width="80" />
        <el-table-column prop="stationId" label="Station" width="80" />
        <el-table-column prop="startTime" label="Start Time" min-width="150">
          <template #default="{ row }">
            {{ formatTime(row.startTime) }}
          </template>
        </el-table-column>
        <el-table-column prop="durationMinutes" label="Duration" width="100">
          <template #default="{ row }">
            {{ row.durationMinutes ? row.durationMinutes + ' min' : '--' }}
          </template>
        </el-table-column>
        <el-table-column prop="totalAmount" label="Amount" width="100">
          <template #default="{ row }">
            <span class="amount">¥{{ row.totalAmount?.toFixed(2) || '0.00' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="paymentStatus" label="Status" width="110">
          <template #default="{ row }">
            <el-tag :type="statusType(row.paymentStatus)" size="small" effect="dark" round>
              {{ row.paymentStatus || 'unknown' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="Actions" width="120" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" text @click="viewOrderDetail(row)">View</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- Pagination -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50]"
          :total="total"
          layout="total, sizes, prev, pager, next"
          background
          @size-change="fetchOrders"
          @current-change="fetchOrders"
        />
      </div>
    </div>

    <!-- Order detail dialog -->
    <el-dialog v-model="detailVisible" title="Order Details" width="550px" class="dark-dialog">
      <div class="order-detail" v-if="detailData">
        <div class="detail-row">
          <span class="detail-label">Order ID:</span>
          <span class="detail-value">#{{ detailData.orderId }}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">User ID:</span>
          <span class="detail-value">{{ detailData.userId }}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Station ID:</span>
          <span class="detail-value">{{ detailData.stationId }}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Start Time:</span>
          <span class="detail-value">{{ formatTime(detailData.startTime) }}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">End Time:</span>
          <span class="detail-value">{{ formatTime(detailData.endTime) }}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Duration:</span>
          <span class="detail-value">{{ detailData.durationMinutes || '--' }} minutes</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Amount:</span>
          <span class="detail-value amount">¥{{ detailData.totalAmount?.toFixed(2) || '0.00' }}</span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Status:</span>
          <span class="detail-value">
            <el-tag :type="statusType(detailData.paymentStatus)" size="small" effect="dark" round>
              {{ detailData.paymentStatus || 'unknown' }}
            </el-tag>
          </span>
        </div>
        <div class="detail-row">
          <span class="detail-label">Created:</span>
          <span class="detail-value">{{ formatTime(detailData.createdTime) }}</span>
        </div>
      </div>
      <template #footer>
        <el-button @click="detailVisible = false">Close</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
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

const orders = ref<Order[]>([])
const loading = ref(false)
const filterStatus = ref('')
const filterUserId = ref('')
const filterDateRange = ref<[Date, Date] | null>(null)
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

const detailVisible = ref(false)
const detailData = ref<Order | null>(null)

function particleStyle(_n: number) {
  return {
    width: `${Math.random() * 3 + 1}px`,
    height: `${Math.random() * 3 + 1}px`,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    animationDelay: `${Math.random() * 15}s`,
    animationDuration: `${Math.random() * 15 + 10}s`,
    opacity: Math.random() * 0.2 + 0.05,
  }
}

function formatTime(time: string | null | undefined): string {
  if (!time) return '--'
  return time.replace('T', ' ').substring(0, 19)
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

async function fetchOrders() {
  loading.value = true
  try {
    if (filterUserId.value) {
      const res: any = await request.post('/order/page/user', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        userId: Number(filterUserId.value),
      })
      if (res?.data) {
        orders.value = res.data.records || []
        total.value = res.data.total || 0
      }
    } else {
      const res: any = await request.post('/order/page/payment-status', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        paymentStatus: filterStatus.value || '',
      })
      if (res?.data) {
        orders.value = res.data.records || []
        total.value = res.data.total || 0
      }
    }
  } catch {
    // handled
  } finally {
    loading.value = false
  }
}

async function viewOrderDetail(order: Order) {
  try {
    const res: any = await request.get(`/order/detail/${order.orderId}`)
    if (res?.data) {
      detailData.value = res.data
    } else {
      detailData.value = order
    }
  } catch {
    detailData.value = order
  }
  detailVisible.value = true
}

function handleExport() {
  ElMessage.info('Export functionality will be implemented soon')
}

onMounted(() => {
  fetchOrders()
})
</script>

<style scoped>
.order-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: relative;
}

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
  10% { opacity: 0.15; }
  90% { opacity: 0.15; }
  100% { transform: translateY(-80vh) translateX(30px); opacity: 0; }
}

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

.filter-bar {
  padding: 16px 20px;
}

.filter-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}

.search-btn {
  background: rgba(255, 255, 255, 0.08) !important;
  border: 1px solid rgba(255, 255, 255, 0.12) !important;
  color: rgba(255, 255, 255, 0.75) !important;
  border-radius: 8px !important;
}

.search-btn:hover {
  border-color: #00c9ff !important;
  color: #00c9ff !important;
}

.export-btn {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  color: rgba(255, 255, 255, 0.65) !important;
  border-radius: 8px !important;
}

.export-btn:hover {
  border-color: #92fe9d !important;
  color: #92fe9d !important;
}

.dark-input :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 8px !important;
  box-shadow: none !important;
}

.dark-input :deep(.el-input__wrapper:hover) {
  border-color: rgba(0, 201, 255, 0.4) !important;
}

.dark-input :deep(.el-input__wrapper.is-focus) {
  border-color: #00c9ff !important;
}

.dark-input :deep(.el-input__inner) {
  color: #ffffff !important;
}

.dark-input :deep(.el-input__inner::placeholder) {
  color: rgba(255, 255, 255, 0.35) !important;
}

.dark-select :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 8px !important;
  box-shadow: none !important;
}

.dark-select :deep(.el-input__inner) {
  color: #ffffff !important;
}

/* Dark datepicker */
.dark-datepicker :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 8px !important;
  box-shadow: none !important;
}

.dark-datepicker :deep(.el-input__inner) {
  color: #ffffff !important;
}

.dark-datepicker :deep(.el-range-separator) {
  color: rgba(255, 255, 255, 0.4) !important;
}

.dark-datepicker :deep(.el-range-input) {
  color: #ffffff !important;
}

/* Dark table */
.dark-table {
  background: transparent !important;
  --el-table-bg-color: transparent !important;
  --el-table-tr-bg-color: transparent !important;
  --el-table-header-bg-color: transparent !important;
  --el-table-border-color: rgba(255, 255, 255, 0.06) !important;
  --el-table-text-color: rgba(255, 255, 255, 0.75) !important;
  --el-table-header-text-color: rgba(255, 255, 255, 0.6) !important;
  --el-table-row-hover-bg-color: rgba(255, 255, 255, 0.04) !important;
}

.dark-table :deep(.el-table__header-wrapper th) {
  font-size: 12px;
  font-weight: 600;
}

.dark-table :deep(td) {
  font-size: 13px;
}

.amount {
  color: #92fe9d;
  font-weight: 600;
}

.pagination-wrapper {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

.pagination-wrapper :deep(.el-pagination) {
  --el-pagination-bg-color: rgba(255, 255, 255, 0.06);
  --el-pagination-text-color: rgba(255, 255, 255, 0.6);
  --el-pagination-button-bg-color: rgba(255, 255, 255, 0.06);
  --el-pagination-button-color: rgba(255, 255, 255, 0.6);
  --el-pagination-hover-color: #00c9ff;
}

/* Dark dialog */
:global(.dark-dialog .el-dialog) {
  background: rgba(15, 25, 40, 0.95) !important;
  backdrop-filter: blur(20px) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 16px !important;
}

:global(.dark-dialog .el-dialog__title) {
  color: #ffffff !important;
}

:global(.dark-dialog .el-dialog__header) {
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

/* Order detail */
.order-detail {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.detail-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  font-size: 14px;
}

.detail-label {
  width: 100px;
  color: rgba(255, 255, 255, 0.5);
  flex-shrink: 0;
}

.detail-value {
  color: rgba(255, 255, 255, 0.85);
}
</style>
