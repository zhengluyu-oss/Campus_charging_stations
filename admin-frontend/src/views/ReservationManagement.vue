<template>
  <div class="reservation-page">
    <!-- Decorative particles -->
    <div class="particles">
      <div v-for="n in 15" :key="n" class="particle" :style="particleStyle(n)"></div>
    </div>

    <!-- Filter bar -->
    <div class="glass-card filter-bar">
      <el-row :gutter="16" align="middle">
        <el-col :xs="24" :sm="6">
          <el-select v-model="filterStatus" placeholder="Reservation Status" clearable class="dark-select" style="width: 100%">
            <el-option label="Confirmed" value="confirmed" />
            <el-option label="Used" value="used" />
            <el-option label="Cancelled" value="cancelled" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="6">
          <el-input
            v-model="filterUserId"
            placeholder="User ID"
            clearable
            class="dark-input"
            @keyup.enter="fetchReservations"
          >
            <template #prefix><el-icon><User /></el-icon></template>
          </el-input>
        </el-col>
        <el-col :xs="24" :sm="6">
          <el-date-picker
            v-model="filterDate"
            type="date"
            placeholder="Filter by Date"
            class="dark-datepicker"
            style="width: 100%"
          />
        </el-col>
        <el-col :xs="24" :sm="6" class="filter-actions">
          <el-button class="search-btn" @click="fetchReservations">
            <el-icon><Search /></el-icon>Search
          </el-button>
        </el-col>
      </el-row>
    </div>

    <!-- Reservation table -->
    <div class="glass-card">
      <el-table :data="reservations" class="dark-table" style="width: 100%" v-loading="loading">
        <el-table-column prop="reservationId" label="Reservation ID" width="130" />
        <el-table-column prop="userId" label="User ID" width="100" />
        <el-table-column prop="stationId" label="Station ID" width="100" />
        <el-table-column prop="reservedStartTime" label="Start Time" min-width="160">
          <template #default="{ row }">
            {{ formatTime(row.reservedStartTime) }}
          </template>
        </el-table-column>
        <el-table-column prop="reservedEndTime" label="End Time" min-width="160">
          <template #default="{ row }">
            {{ formatTime(row.reservedEndTime) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="Status" width="120">
          <template #default="{ row }">
            <el-tag :type="statusType(row.status)" size="small" effect="dark" round>
              {{ row.status || 'unknown' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="Actions" width="180" fixed="right">
          <template #default="{ row }">
            <el-button
              size="small"
              type="success"
              text
              :disabled="row.status !== 'confirmed'"
              @click="updateStatus(row, 'used')"
            >
              Confirm
            </el-button>
            <el-button
              size="small"
              type="danger"
              text
              :disabled="row.status !== 'confirmed'"
              @click="updateStatus(row, 'cancelled')"
            >
              Cancel
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
          @size-change="fetchReservations"
          @current-change="fetchReservations"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'

interface Reservation {
  reservationId: number
  userId: number
  stationId: number
  reservedStartTime: string
  reservedEndTime: string
  status: string
  createdAt: string
}

const reservations = ref<Reservation[]>([])
const loading = ref(false)
const filterStatus = ref('')
const filterUserId = ref('')
const filterDate = ref<Date | null>(null)
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

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
    case 'confirmed': return 'success'
    case 'used': return 'info'
    case 'cancelled': return 'danger'
    default: return 'warning'
  }
}

async function fetchReservations() {
  loading.value = true
  try {
    if (filterUserId.value) {
      const res: any = await request.post('/reservation/page/user', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        userId: Number(filterUserId.value),
      })
      if (res?.data) {
        reservations.value = res.data.records || []
        total.value = res.data.total || 0
      }
    } else if (filterStatus.value) {
      const res: any = await request.post('/reservation/page/status', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        status: filterStatus.value,
      })
      if (res?.data) {
        reservations.value = res.data.records || []
        total.value = res.data.total || 0
      }
    } else {
      const res: any = await request.post('/reservation/page/status', {
        pageNum: pageNum.value,
        pageSize: pageSize.value,
        status: '',
      })
      if (res?.data) {
        reservations.value = res.data.records || []
        total.value = res.data.total || 0
      }
    }
  } catch {
    // handled
  } finally {
    loading.value = false
  }
}

async function updateStatus(reservation: Reservation, newStatus: string) {
  const actionLabel = newStatus === 'used' ? 'confirm' : 'cancel'
  try {
    await ElMessageBox.confirm(
      `${actionLabel.charAt(0).toUpperCase() + actionLabel.slice(1)} reservation #${reservation.reservationId}?`,
      `Confirm ${actionLabel.charAt(0).toUpperCase() + actionLabel.slice(1)}`,
      { confirmButtonText: 'Yes', cancelButtonText: 'No', type: 'warning' }
    )
    await request.put('/reservation/status', {
      id: reservation.reservationId,
      status: newStatus,
    })
    ElMessage.success(`Reservation ${actionLabel}ed`)
    fetchReservations()
  } catch {
    // cancelled or error
  }
}

onMounted(() => {
  fetchReservations()
})
</script>

<style scoped>
.reservation-page {
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

.dark-datepicker :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 8px !important;
  box-shadow: none !important;
}

.dark-datepicker :deep(.el-input__inner) {
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
