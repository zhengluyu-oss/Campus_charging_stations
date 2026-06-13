<template>
  <div class="page-container">
    <el-card class="page-card" shadow="hover">
      <template #header>
        <div class="card-header">
          <span>News Management</span>
          <el-button type="primary" size="small">Publish News</el-button>
        </div>
      </template>
      <el-table :data="[]" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="Title" />
        <el-table-column prop="author" label="Author" />
        <el-table-column prop="status" label="Status" />
        <el-table-column prop="publishAt" label="Published" />
        <el-table-column label="Actions" width="180">
          <template #default>
            <el-button size="small" type="primary" text>Edit</el-button>
            <el-button size="small" type="danger" text>Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.page-container { display: flex; flex-direction: column; gap: 20px; }
.page-card {
  background: rgba(15, 25, 35, 0.6);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 12px;
  color: #e0e0e0;
}
.card-header { display: flex; align-items: center; justify-content: space-between; }
</style>
