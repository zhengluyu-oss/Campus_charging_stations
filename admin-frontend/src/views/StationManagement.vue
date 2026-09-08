<template>
  <div class="station-page">
</div>

    <!-- Filter bar -->
    <div class="glass-card filter-bar">
      <el-row :gutter="16" align="middle">
        <el-col :xs="24" :sm="6">
          <el-select v-model="filterLocation" placeholder="Filter by Location" clearable class="dark-select" style="width: 100%">
            <el-option v-for="loc in locationOptions" :key="loc" :label="loc" :value="loc" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="6">
          <el-select v-model="filterStatus" placeholder="Filter by Status" clearable class="dark-select" style="width: 100%">
            <el-option label="Available" value="available" />
            <el-option label="Occupied" value="occupied" />
            <el-option label="Offline" value="offline" />
            <el-option label="0" value="0" />
            <el-option label="1" value="1" />
            <el-option label="2" value="2" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="12" class="filter-actions">
          <el-button class="search-btn" @click="fetchStations">
            <el-icon><Search /></el-icon>Search
          </el-button>
          <el-button class="add-btn" @click="openAddDialog">
            <el-icon><Plus /></el-icon>Add Station
          </el-button>
        </el-col>
      </el-row>
    </div>

    <!-- Station cards grid -->
    <div class="station-grid" v-loading="loading">
      <div
        v-for="station in filteredStations"
        :key="station.stationId"
        class="station-card glass-card"
      >
        <div class="station-card-header">
          <h4 class="station-name">{{ station.stationName }}</h4>
          <el-tag
            :type="stationStatusType(station.status)"
            size="small"
            effect="dark"
            round
          >
            {{ stationStatusLabel(station.status) }}
          </el-tag>
        </div>

        <div class="station-info">
          <div class="info-row">
            <el-icon><Location /></el-icon>
            <span>{{ station.location || '--' }}</span>
          </div>
          <div class="info-row">
            <el-icon><Lightning /></el-icon>
            <span>{{ station.powerRating || '--' }} kW</span>
          </div>
          <div class="info-row">
            <el-icon><Money /></el-icon>
            <span>¥{{ station.pricePerHour?.toFixed(2) || '--' }} / hour</span>
          </div>
        </div>

        <div class="station-actions">
          <el-button size="small" text class="action-edit" @click="openEditDialog(station)">
            <el-icon><Edit /></el-icon>Edit
          </el-button>
          <el-button size="small" text class="action-toggle" @click="toggleStatus(station)">
            <el-icon><Switch /></el-icon>Toggle
          </el-button>
          <el-button size="small" text class="action-delete" @click="deleteStation(station)">
            <el-icon><Delete /></el-icon>Delete
          </el-button>
        </div>
      </div>

      <div v-if="filteredStations.length === 0 && !loading" class="empty-state">
        <el-icon :size="48" color="rgba(255,255,255,0.2)"><Lightning /></el-icon>
        <p>No stations found</p>
      </div>
    </div>

    <!-- Add / Edit dialog -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? 'Edit Station' : 'Add Station'"
      width="500px"
      class="dark-dialog"
      :close-on-click-modal="false"
    >
      <el-form ref="dialogFormRef" :model="dialogForm" :rules="dialogRules" label-width="110px">
        <el-form-item label="Station Name" prop="stationName">
          <el-input v-model="dialogForm.stationName" placeholder="e.g. CZ_001" />
        </el-form-item>
        <el-form-item label="Location" prop="location">
          <el-select v-model="dialogForm.location" placeholder="Select location" style="width: 100%">
            <el-option v-for="loc in locationOptions" :key="loc" :label="loc" :value="loc" />
          </el-select>
        </el-form-item>
        <el-form-item label="Status" prop="status">
          <el-select v-model="dialogForm.status" placeholder="Select status" style="width: 100%">
            <el-option label="Available" value="available" />
            <el-option label="Occupied" value="occupied" />
            <el-option label="Offline" value="offline" />
          </el-select>
        </el-form-item>
        <el-form-item label="Power (kW)" prop="powerRating">
          <el-input-number v-model="dialogForm.powerRating" :min="0" :step="0.5" :precision="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="Price (¥/hr)" prop="pricePerHour">
          <el-input-number v-model="dialogForm.pricePerHour" :min="0" :step="0.5" :precision="2" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button class="submit-btn" :loading="submitLoading" @click="submitForm">
          {{ isEdit ? 'Update' : 'Create' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import request from '@/utils/request'

interface Station {
  stationId: number
  stationName: string
  location: string
  status: string
  powerRating: number
  pricePerHour: number
  createdTime: string
  updatedTime: string
}

const stations = ref<Station[]>([])
const loading = ref(false)
const filterLocation = ref('')
const filterStatus = ref('')

const locationOptions = ref<string[]>(['North Campus', 'East Campus', 'South Campus', 'Huayanlu Campus'])

const filteredStations = computed(() => {
  return stations.value.filter(s => {
    if (filterLocation.value && s.location !== filterLocation.value) return false
    if (filterStatus.value && s.status !== filterStatus.value) return false
    return true
  })
})

// Dialog
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitLoading = ref(false)
const dialogFormRef = ref<FormInstance>()
const editingId = ref<number | null>(null)

const dialogForm = reactive({
  stationName: '',
  location: '',
  status: 'available',
  powerRating: 7.0,
  pricePerHour: 1.0,
})

const dialogRules: FormRules = {
  stationName: [{ required: true, message: 'Station name is required', trigger: 'blur' }],
  location: [{ required: true, message: 'Location is required', trigger: 'change' }],
  status: [{ required: true, message: 'Status is required', trigger: 'change' }],
}


function stationStatusType(status: string): string {
  switch (status?.toLowerCase()) {
    case 'available': case '0': return 'success'
    case 'occupied': case '1': return 'warning'
    case 'offline': case '2': return 'danger'
    default: return 'info'
  }
}

function stationStatusLabel(status: string): string {
  switch (status?.toLowerCase()) {
    case 'available': case '0': return 'Available'
    case 'occupied': case '1': return 'Occupied'
    case 'offline': case '2': return 'Offline'
    default: return status || 'Unknown'
  }
}

async function fetchStations() {
  loading.value = true
  try {
    const res: any = await request.post('/chargingStation/page', { pageNum: 1, pageSize: 100 })
    if (res?.data?.records) {
      stations.value = res.data.records
    }
  } catch {
    // handled
  } finally {
    loading.value = false
  }
}

function openAddDialog() {
  isEdit.value = false
  editingId.value = null
  dialogForm.stationName = ''
  dialogForm.location = ''
  dialogForm.status = 'available'
  dialogForm.powerRating = 7.0
  dialogForm.pricePerHour = 1.0
  dialogVisible.value = true
}

function openEditDialog(station: Station) {
  isEdit.value = true
  editingId.value = station.stationId
  dialogForm.stationName = station.stationName
  dialogForm.location = station.location
  dialogForm.status = station.status
  dialogForm.powerRating = station.powerRating
  dialogForm.pricePerHour = station.pricePerHour
  dialogVisible.value = true
}

async function submitForm() {
  const valid = await dialogFormRef.value?.validate().catch(() => false)
  if (!valid) return

  submitLoading.value = true
  try {
    if (isEdit.value && editingId.value) {
      await request.post('/chargingStation/update', {
        stationId: editingId.value,
        stationName: dialogForm.stationName,
        location: dialogForm.location,
        status: dialogForm.status,
        powerRating: dialogForm.powerRating,
        pricePerHour: dialogForm.pricePerHour,
      })
      ElMessage.success('Station updated')
    } else {
      await request.post('/chargingStation/add', {
        stationName: dialogForm.stationName,
        location: dialogForm.location,
        status: dialogForm.status,
        powerRating: dialogForm.powerRating,
        pricePerHour: dialogForm.pricePerHour,
      })
      ElMessage.success('Station created')
    }
    dialogVisible.value = false
    fetchStations()
  } catch {
    // handled
  } finally {
    submitLoading.value = false
  }
}

async function toggleStatus(station: Station) {
  const statusCycle: Record<string, string> = {
    'available': 'occupied', 'occupied': 'offline', 'offline': 'available',
    '0': '1', '1': '2', '2': '0',
  }
  const newStatus = statusCycle[station.status] || 'available'
  try {
    await request.post('/chargingStation/update', {
      stationId: station.stationId,
      status: newStatus,
    })
    ElMessage.success(`Status changed to ${stationStatusLabel(newStatus)}`)
    fetchStations()
  } catch {
    // handled
  }
}

async function deleteStation(station: Station) {
  try {
    await ElMessageBox.confirm(`Delete station "${station.stationName}"?`, 'Confirm Delete', {
      confirmButtonText: 'Delete',
      cancelButtonText: 'Cancel',
      type: 'warning',
    })
    await request.post(`/chargingStation/delete/${station.stationId}`)
    ElMessage.success('Station deleted')
    fetchStations()
  } catch {
    // cancelled
  }
}

onMounted(() => {
  fetchStations()
})
</script>

<style scoped>
.station-page {
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

.add-btn {
  background: linear-gradient(45deg, #00c9ff, #92fe9d) !important;
  border: none !important;
  color: #0f2027 !important;
  font-weight: 600 !important;
  border-radius: 8px !important;
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

/* Station cards grid */
.station-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
  position: relative;
  z-index: 1;
  min-height: 200px;
}

.station-card {
  transition: all 0.3s ease;
  cursor: default;
}

.station-card:hover {
  transform: translateY(-3px);
  border-color: rgba(0, 201, 255, 0.2);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
}

.station-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}

.station-name {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #ffffff;
}

.station-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 16px;
}

.info-row {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
}

.info-row .el-icon {
  color: rgba(255, 255, 255, 0.4);
  font-size: 15px;
}

.station-actions {
  display: flex;
  gap: 4px;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
  padding-top: 12px;
}

.action-edit {
  color: #00c9ff !important;
}

.action-toggle {
  color: #ffd89b !important;
}

.action-delete {
  color: #f5576c !important;
}

.empty-state {
  grid-column: 1 / -1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
  gap: 12px;
}

.empty-state p {
  color: rgba(255, 255, 255, 0.35);
  font-size: 14px;
}

/* Dark dialog overrides */
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

:global(.dark-dialog .el-form-item__label) {
  color: rgba(255, 255, 255, 0.65) !important;
}

:global(.dark-dialog .el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  box-shadow: none !important;
}

:global(.dark-dialog .el-input__inner) {
  color: #ffffff !important;
}

:global(.dark-dialog .el-input-number .el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
}

.submit-btn {
  background: linear-gradient(45deg, #00c9ff, #92fe9d) !important;
  border: none !important;
  color: #0f2027 !important;
  font-weight: 600 !important;
}
</style>
