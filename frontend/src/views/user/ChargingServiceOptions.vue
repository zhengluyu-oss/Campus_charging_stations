<template>
  <div class="charging-service-options">
    <header class="page-header">
      <h1>充电服务</h1>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/user-dashboard' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>充电服务</el-breadcrumb-item>
        <el-breadcrumb-item>服务选项</el-breadcrumb-item>
      </el-breadcrumb>
    </header>

    <main class="options-main">
      <div class="options-container">
        <!-- 使用充电桩卡片 -->
        <el-card class="option-card use-charger-card" @click="goToUseCharger">
          <template #header>
            <div class="card-header">
              <span>使用充电桩</span>
            </div>
          </template>
          <div class="option-content">
            <div class="option-icon">
              <el-icon><Lightning /></el-icon>
            </div>
            <div class="option-text">
              <h3>使用充电桩</h3>
              <p>查找附近的充电桩并开始充电</p>
            </div>
          </div>
        </el-card>

        <!-- 预约充电桩卡片 -->
        <el-card class="option-card booking-card" @click="goToBooking">
          <template #header>
            <div class="card-header">
              <span>预约充电桩</span>
            </div>
          </template>
          <div class="option-content">
            <div class="option-icon">
              <el-icon><Calendar /></el-icon>
            </div>
            <div class="option-text">
              <h3>预约充电桩</h3>
              <p>提前预约充电时间，避免等待</p>
            </div>
          </div>
        </el-card>

        <!-- 查看充电记录卡片 -->
        <el-card class="option-card history-card" @click="goToHistory">
          <template #header>
            <div class="card-header">
              <span>查看充电记录</span>
            </div>
          </template>
          <div class="option-content">
            <div class="option-icon">
              <el-icon><Document /></el-icon>
            </div>
            <div class="option-text">
              <h3>查看充电记录</h3>
              <p>查看历史充电订单和消费记录</p>
            </div>
          </div>
        </el-card>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import { Lightning, Calendar, Document } from '@element-plus/icons-vue';

const router = useRouter();

// 跳转到使用充电桩页面
const goToUseCharger = () => {
  router.push('/user/use-charger');
};

// 跳转到预约页面
const goToBooking = () => {
  router.push('/booking');
};

// 跳转到历史记录页面
const goToHistory = () => {
  router.push('/history');
};
</script>

<style scoped>
.charging-service-options {
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  margin: 0;
  padding: 0;
  padding-bottom: 40px;
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

.options-main {
  display: flex;
  flex-direction: column;
  gap: 15px;
  padding: 0 20px 20px;
  z-index: 3;
  position: relative;
  width: 100%;
  box-sizing: border-box;
}

.options-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 15px;
  width: 100%;
}

.option-card {
  height: 160px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 15px;
}

.option-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.3);
  background: rgba(255, 255, 255, 0.15);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: white;
}

.option-content {
  display: flex;
  align-items: center;
  gap: 15px;
  height: 100%;
}

.option-icon {
  font-size: 40px;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 70px;
  height: 70px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
}

.option-text {
  flex: 1;
}

.option-text h3 {
  margin: 0 0 8px 0;
  color: white;
  font-size: 18px;
  font-weight: 600;
}

.option-text p {
  margin: 0;
  color: rgba(255, 255, 255, 0.8);
  font-size: 13px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .charging-service-options {
    padding: 0 10px 20px;
  }

  .page-header {
    padding: 0 10px;
  }

  .options-container {
    grid-template-columns: 1fr;
  }

  .option-content {
    flex-direction: column;
    text-align: center;
    gap: 8px;
  }

  .option-text {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .page-header h1 {
    font-size: 20px;
  }

  .option-icon {
    width: 60px;
    height: 60px;
    font-size: 32px;
  }
}
</style>