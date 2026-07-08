<template>
  <div class="user-page">
    <!-- Decorative particles -->
    <div class="particles">
      <div v-for="n in 15" :key="n" class="particle" :style="particleStyle(n)"></div>
    </div>

    <!-- Search / Filter bar -->
    <div class="glass-card filter-bar">
      <el-row :gutter="16" align="middle">
        <el-col :xs="24" :sm="8">
          <el-input
            v-model="searchUsername"
            placeholder="Search by username..."
            clearable
            class="dark-input"
            @keyup.enter="fetchUsers"
          >
            <template #prefix><el-icon><Search /></el-icon></template>
          </el-input>
        </el-col>
        <el-col :xs="24" :sm="6">
          <el-select v-model="filterType" placeholder="User Type" clearable class="dark-select" style="width: 100%">
            <el-option label="Student" value="student" />
            <el-option label="Teacher" value="teacher" />
            <el-option label="Staff" value="staff" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="10" class="filter-actions">
          <el-button class="search-btn" @click="fetchUsers">
            <el-icon><Search /></el-icon>Search
          </el-button>
          <el-button class="add-btn" @click="openAddDialog">
            <el-icon><Plus /></el-icon>Add User
          </el-button>
        </el-col>
      </el-row>
    </div>

    <!-- User table -->
    <div class="glass-card">
      <el-table :data="users" class="dark-table" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="username" label="Username" min-width="120" />
        <el-table-column prop="phone" label="Phone" min-width="120" />
        <el-table-column prop="email" label="Email" min-width="160" />
        <el-table-column prop="userType" label="Type" width="100">
          <template #default="{ row }">
            <el-tag :type="typeTag(row.userType)" size="small" effect="dark" round>{{ row.userType || '--' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="Status" width="100">
          <template #default>
            <el-tag type="success" size="small" effect="dark" round>Active</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdTime" label="Created" min-width="150">
          <template #default="{ row }">
            {{ formatTime(row.createdTime) }}
          </template>
        </el-table-column>
        <el-table-column label="Actions" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" text @click="openEditDialog(row)">Edit</el-button>
            <el-button size="small" type="info" text @click="viewUser(row)">View</el-button>
            <el-button size="small" type="danger" text @click="deleteUser(row)">Delete</el-button>
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
          @size-change="fetchUsers"
          @current-change="fetchUsers"
        />
      </div>
    </div>

    <!-- Add / Edit dialog -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? 'Edit User' : 'Add User'"
      width="500px"
      class="dark-dialog"
      :close-on-click-modal="false"
    >
      <el-form ref="dialogFormRef" :model="dialogForm" :rules="dialogRules" label-width="90px">
        <el-form-item label="Username" prop="username">
          <el-input v-model="dialogForm.username" :disabled="isEdit" placeholder="Enter username" />
        </el-form-item>
        <el-form-item label="Password" prop="password" v-if="!isEdit">
          <el-input v-model="dialogForm.password" type="password" show-password placeholder="Enter password" />
        </el-form-item>
        <el-form-item label="Phone" prop="phone">
          <el-input v-model="dialogForm.phone" placeholder="Enter phone number" />
        </el-form-item>
        <el-form-item label="Email" prop="email">
          <el-input v-model="dialogForm.email" placeholder="Enter email" />
        </el-form-item>
        <el-form-item label="Type" prop="userType">
          <el-select v-model="dialogForm.userType" placeholder="Select type" style="width: 100%">
            <el-option label="Student" value="student" />
            <el-option label="Teacher" value="teacher" />
            <el-option label="Staff" value="staff" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">Cancel</el-button>
        <el-button class="submit-btn" :loading="submitLoading" @click="submitForm">
          {{ isEdit ? 'Update' : 'Create' }}
        </el-button>
      </template>
    </el-dialog>

    <!-- View dialog -->
    <el-dialog v-model="viewDialogVisible" title="User Details" width="450px" class="dark-dialog">
      <div class="user-detail" v-if="viewData.id">
        <div class="detail-row"><span class="detail-label">ID:</span><span>{{ viewData.id }}</span></div>
        <div class="detail-row"><span class="detail-label">Username:</span><span>{{ viewData.username }}</span></div>
        <div class="detail-row"><span class="detail-label">Phone:</span><span>{{ viewData.phone || '--' }}</span></div>
        <div class="detail-row"><span class="detail-label">Email:</span><span>{{ viewData.email || '--' }}</span></div>
        <div class="detail-row"><span class="detail-label">Type:</span><span>{{ viewData.userType || '--' }}</span></div>
        <div class="detail-row"><span class="detail-label">Created:</span><span>{{ formatTime(viewData.createdTime) }}</span></div>
        <div class="detail-row"><span class="detail-label">Updated:</span><span>{{ formatTime(viewData.updatedTime) }}</span></div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import request from '@/utils/request'

interface User {
  id: number
  username: string
  phone: string
  email: string
  userType: string
  avatarPath: string
  createdTime: string
  updatedTime: string
}

const users = ref<User[]>([])
const loading = ref(false)
const searchUsername = ref('')
const filterType = ref('')
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

// Dialog state
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitLoading = ref(false)
const dialogFormRef = ref<FormInstance>()
const editingId = ref<number | null>(null)

const dialogForm = reactive({
  username: '',
  password: '',
  phone: '',
  email: '',
  userType: '',
})

const dialogRules: FormRules = {
  username: [{ required: true, message: 'Username is required', trigger: 'blur' }],
  password: [{ required: true, message: 'Password is required', trigger: 'blur' }],
  userType: [{ required: true, message: 'User type is required', trigger: 'change' }],
}

// View dialog
const viewDialogVisible = ref(false)
const viewData = reactive<User>({
  id: 0, username: '', phone: '', email: '', userType: '', avatarPath: '', createdTime: '', updatedTime: '',
})

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

function typeTag(type: string): string {
  switch (type?.toLowerCase()) {
    case 'student': return 'success'
    case 'teacher': return 'warning'
    case 'staff': return 'info'
    default: return ''
  }
}

async function fetchUsers() {
  loading.value = true
  try {
    const res: any = await request.post('/user/page', {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      username: searchUsername.value || '',
    })
    if (res?.data) {
      let records = res.data.records || []
      if (filterType.value) {
        records = records.filter((u: User) => u.userType === filterType.value)
      }
      users.value = records
      total.value = res.data.total || 0
    }
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}

function openAddDialog() {
  isEdit.value = false
  editingId.value = null
  dialogForm.username = ''
  dialogForm.password = ''
  dialogForm.phone = ''
  dialogForm.email = ''
  dialogForm.userType = ''
  dialogVisible.value = true
}

function openEditDialog(user: User) {
  isEdit.value = true
  editingId.value = user.id
  dialogForm.username = user.username
  dialogForm.password = ''
  dialogForm.phone = user.phone || ''
  dialogForm.email = user.email || ''
  dialogForm.userType = user.userType || ''
  dialogVisible.value = true
}

function viewUser(user: User) {
  Object.assign(viewData, user)
  viewDialogVisible.value = true
}

async function submitForm() {
  const valid = await dialogFormRef.value?.validate().catch(() => false)
  if (!valid) return

  submitLoading.value = true
  try {
    if (isEdit.value && editingId.value) {
      await request.put('/user/update', {
        userId: editingId.value,
        username: dialogForm.username,
        phone: dialogForm.phone,
        email: dialogForm.email,
        userType: dialogForm.userType,
      })
      ElMessage.success('User updated successfully')
    } else {
      await request.post('/user/add', {
        username: dialogForm.username,
        password: dialogForm.password,
        phone: dialogForm.phone,
        email: dialogForm.email,
        userType: dialogForm.userType,
      })
      ElMessage.success('User created successfully')
    }
    dialogVisible.value = false
    fetchUsers()
  } catch {
    // handled by interceptor
  } finally {
    submitLoading.value = false
  }
}

async function deleteUser(user: User) {
  try {
    await ElMessageBox.confirm(`Delete user "${user.username}"? This cannot be undone.`, 'Confirm Delete', {
      confirmButtonText: 'Delete',
      cancelButtonText: 'Cancel',
      type: 'warning',
    })
    await request.delete(`/user/delete/${user.id}`)
    ElMessage.success('User deleted')
    fetchUsers()
  } catch {
    // cancelled or error
  }
}

onMounted(() => {
  fetchUsers()
})
</script>

<style scoped>
.user-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
  position: relative;
}

/* Particles */
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

/* Filter bar */
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

/* Dark input */
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

/* Dark select */
.dark-select :deep(.el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
  border: 1px solid rgba(255, 255, 255, 0.1) !important;
  border-radius: 8px !important;
  box-shadow: none !important;
}

.dark-select :deep(.el-input__inner) {
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

/* Pagination */
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

:global(.dark-dialog .el-dialog__header) {
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

:global(.dark-dialog .el-dialog__title) {
  color: #ffffff !important;
}

:global(.dark-dialog .el-dialog__body) {
  color: rgba(255, 255, 255, 0.75);
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

:global(.dark-dialog .el-select .el-input__wrapper) {
  background: rgba(255, 255, 255, 0.06) !important;
}

.submit-btn {
  background: linear-gradient(45deg, #00c9ff, #92fe9d) !important;
  border: none !important;
  color: #0f2027 !important;
  font-weight: 600 !important;
}

/* User detail */
.user-detail {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.detail-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  font-size: 14px;
}

.detail-label {
  width: 80px;
  color: rgba(255, 255, 255, 0.5);
  flex-shrink: 0;
}
</style>
