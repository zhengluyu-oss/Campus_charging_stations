<template>
  <div class="payment-page">
    <!-- Decorative particles -->
    <div class="particles">
      <div v-for="n in 15" :key="n" class="particle" :style="particleStyle(n)"></div>
    </div>

    <!-- Summary stats -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="12" :sm="6">
        <div class="mini-stat glass-card">
          <span class="mini-stat-value">{{ totalPayments }}</span>
          <span class="mini-stat-label">Total Payments</span>
        </div>
      </el-col>
      <el-col :xs="12" :sm="6">
        <div class="mini-stat glass-card">
          <span class="mini-stat-value success">{{ paidCount }}</span>
          <span class="mini-stat-label">Paid</span>
        </div>
      </el-col>
      <el-col :xs="12" :sm="6">
        <div class="mini-stat glass-card">
          <span class="mini-stat-value warning">{{ pendingCount }}</span>
          <span class="mini-stat-label">Pending</span>
        </div>
      </el-col>
      <el-col :xs="12" :sm="6">
        <div class="mini-stat glass-card">
          <span class="mini-stat-value accent">¥{{ totalAmount.toFixed(2) }}</span>
          <span class="mini-stat-label">Total Amount</span>
        </div>
      </el-col>
    </el-row>

    <!-- Filter bar -->
    <div class="glass-card filter-bar">
      <el-row :gutter="16" align="middle">
        <el-col :xs="24" :sm="6">
          <el-select v-model="filterMethod" placeholder="Payment Method" clearable class="dark-select" style="width: 100%">
            <el-option label="WeChat Pay" value="wechat" />
            <el-option label="Alipay" value="alipay" />
            <el-option label="Credit Card" value="credit_card" />
            <el-option label="Balance" value="balance" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="6">
          <el-select v-model="filterStatus" placeholder="Payment Status" clearable class="dark-select" style="width: 100%">
            <el-option label="Paid" value="paid" />
            <el-option label="Pending" value="pending" />
            <el-option label="Failed" value="failed" />
            <el-option label="Refunded" value="refunded" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="12" class="filter-actions">
          <el-button class="search-btn" @click="fetchPayments">
            <el-icon><Search /></el-icon>Search
          </el-button>
        </el-col>
      </el-row>
    </div>

    <!-- Payment table -->
    <div class="glass-card">
      <el-table :data="payments" class="dark-table" style="width: 100%" v-loading="loading">
        <el-table-column prop="paymentId" label="Payment ID" width="110" />
        <el-table-column prop="orderId" label="Order ID" width="100" />
        <el-table-column prop="amount" label="Amount" width="110">
          <template #default="{ row }">
            <span class="amount">¥{{ row.amount?.toFixed(2) || '0.00' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="paymentMethod" label="Method" width="120">
          <template #default="{ row }">
            <span>{{ formatMethod(row.paymentMethod) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="paymentStatus" label="Status" width="110">
          <template #default="{ row }">
            <el-tag :type="statusType(row.paymentStatus)" size="small" effect="dark" round>
              {{ row.paymentStatus || 'unknown' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="paidTime" label="Paid At" min-width="160">
          <template #default="{ row }">
            {{ formatTime(row.paidTime) }}
          </template>
        </el-table-column>
        <el-table-column label="Actions" width="120" fixed="right">
          <template #default="{ row }">
            <el-button
              size="small"
              type="warning"
              text
              :disabled="row.paymentStatus !== 'paid'"
              @click="handleRefund(row)"
            >
              Refund
            </el-button>
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
          @size-change="fetchPayments"
          @current-change="fetchPayments"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'

interface Payment {
  paymentId: number
  orderId: number
  amount: number
  paymentMethod: string
  paymentStatus: string
  paidTime: string
}

const payments = ref<Payment[]>([])
const loading = ref(false)
const filterMethod = ref('')
const filterStatus = ref('')
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

// Summary stats
const totalPayments = computed(() => payments.value.length)
const paidCount = computed(() => payments.value.filter(p => p.paymentStatus === 'paid').length)
const pendingCount = computed(() => payments.value.filter(p => p.paymentStatus === 'pending').length)
const totalAmount = computed(() => payments.value.reduce((sum, p) => sum + (p.amount || 0), 0))

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

function formatMethod(method: string): string {
  const map: Record<string, string> = {
    wechat: 'WeChat Pay',
    alipay: 'Alipay',
    credit_card: 'Credit Card',
    balance: 'Balance',
  }
  return map[method] || method || '--'
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

async function fetchPayments() {
  loading.value = true
  try {
    if (filterStatus.value) {
      const res: any = await request.post('/payments/page/status', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        paymentStatus: filterStatus.value,
      })
      if (res?.data) {
        payments.value = res.data.records || []
        total.value = res.data.total || 0
      }
    } else if (filterMethod.value) {
      const res: any = await request.post('/payments/page/method', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        paymentMethod: filterMethod.value,
      })
      if (res?.data) {
        payments.value = res.data.records || []
        total.value = res.data.total || 0
      }
    } else {
      const res: any = await request.post('/payments/page/status', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        paymentStatus: '',
      })
      if (res?.data) {
        payments.value = res.data.records || []
        total.value = res.data.total || 0
      }
    }
  } catch {
    // handled
  } finally {
    loading.value = false
  }
}

async function handleRefund(payment: Payment) {
  try {
    await ElMessageBox.confirm(
      `Refund ¥${payment.amount?.toFixed(2)} for Payment #${payment.paymentId}?`,
      'Confirm Refund',
      { confirmButtonText: 'Refund', cancelButtonText: 'Cancel', type: 'warning' }
    )
    await request.put('/payments/update/status-time', {
      paymentId: payment.paymentId,
      paymentStatus: 'refunded',
      paidTime: new Date().toISOString().replace('T', ' ').substring(0, 19),
    })
    ElMessage.success('Refund processed')
    fetchPayments()
  } catch {
    // cancelled or error
  }
}

onMounted(() => {
  fetchPayments()
})
</script>

<style scoped>
.payment-page {
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

.stats-row {
  position: relative;
  z-index: 1;
}

.mini-stat {
  text-align: center;
  padding: 16px;
  transition: all 0.3s ease;
}

.mini-stat:hover {
  transform: translateY(-2px);
  border-color: rgba(0, 201, 255, 0.2);
}

.mini-stat-value {
  display: block;
  font-size: 22px;
  font-weight: 700;
  color: #ffffff;
  margin-bottom: 4px;
}

.mini-stat-value.success {
  color: #92fe9d;
}

.mini-stat-value.warning {
  color: #ffd89b;
}

.mini-stat-value.accent {
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.mini-stat-label {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
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

.dark-select :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 8px !important;
  box-shadow: none !important;
}

.dark-select :deep(.el-input__inner) {
  color: #ffffff !important;
}

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
</style>
