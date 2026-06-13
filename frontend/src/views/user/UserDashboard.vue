<template>
  <div class="user-dashboard">
    <header class="dashboard-header">
      <div class="header-content">
        <h1 class="header-title">校园充电站</h1>
        <p class="header-subtitle">智能充电，绿色出行</p>
      </div>
      <div class="user-actions">
        <el-button type="primary" plain size="default" @click="handleLogout" class="logout-button">
          <el-icon><SwitchButton /></el-icon>
          <span>退出登录</span>
        </el-button>
      </div>
    </header>

    <main class="dashboard-main">
      <div class="welcome-section">
        <h2 class="welcome-title">欢迎回来，{{ userInfo.username }}</h2>
        <p class="welcome-text">选择您需要的服务</p>
      </div>

      <div class="dashboard-cards">
        <div class="dashboard-card charging-service-card" @click="goToChargingStations">
          <div class="card-glow"></div>
          <div class="service-content">
            <div class="service-icon">
              <el-icon><Lightning /></el-icon>
            </div>
            <div class="service-text">
              <h3>充电服务</h3>
              <p>查找附近充电桩，预约充电时间</p>
            </div>
            <div class="card-arrow">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </div>
        </div>

        <div class="dashboard-card news-service-card" @click="goToNews('publish')">
          <div class="card-glow"></div>
          <div class="service-content">
            <div class="service-icon">
              <el-icon><Document /></el-icon>
            </div>
            <div class="service-text">
              <h3>发布资讯</h3>
              <p>了解最新的充电技术和校园动态</p>
            </div>
            <div class="card-arrow">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </div>
        </div>

        <div class="dashboard-card profile-service-card" @click="goToProfile">
          <div class="card-glow"></div>
          <div class="service-content">
            <div class="service-icon">
              <el-icon><User /></el-icon>
            </div>
            <div class="service-text">
              <h3>个人中心</h3>
              <p>管理个人信息和订单记录</p>
            </div>
            <div class="card-arrow">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </div>
        </div>
      </div>

      <div class="quick-stats">
        <div class="stat-item">
          <el-icon class="stat-icon"><Timer /></el-icon>
          <div class="stat-text">
            <span class="stat-label">今日充电</span>
            <span class="stat-value">0 次</span>
          </div>
        </div>
        <div class="stat-item">
          <el-icon class="stat-icon"><Coin /></el-icon>
          <div class="stat-text">
            <span class="stat-label">本月消费</span>
            <span class="stat-value">¥0.00</span>
          </div>
        </div>
        <div class="stat-item">
          <el-icon class="stat-icon"><TrendCharts /></el-icon>
          <div class="stat-text">
            <span class="stat-label">累计充电</span>
            <span class="stat-value">0 kWh</span>
          </div>
        </div>
      </div>

      <div class="news-sections">
        <div class="dashboard-card news-section-card" @click="goToNews('view', 'event')">
          <div class="card-glow"></div>
          <div class="service-content">
            <div class="service-icon">
              <el-icon><Calendar /></el-icon>
            </div>
            <div class="service-text">
              <h3>校园活动</h3>
              <p>查看校园充电站最新活动动态</p>
            </div>
            <div class="card-arrow">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </div>
        </div>

        <div class="dashboard-card news-section-card" @click="goToNews('view', 'policy')">
          <div class="card-glow"></div>
          <div class="service-content">
            <div class="service-icon">
              <el-icon><DocumentCopy /></el-icon>
            </div>
            <div class="service-text">
              <h3>政策法规</h3>
              <p>了解充电相关政策法规信息</p>
            </div>
            <div class="card-arrow">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </div>
        </div>

        <div class="dashboard-card news-section-card" @click="goToNews('view', 'lost')">
          <div class="card-glow"></div>
          <div class="service-content">
            <div class="service-icon">
              <el-icon><Search /></el-icon>
            </div>
            <div class="service-text">
              <h3>失物广播</h3>
              <p>查看充电站周边失物招领信息</p>
            </div>
            <div class="card-arrow">
              <el-icon><ArrowRight /></el-icon>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import { Lightning, Document, User, SwitchButton, ArrowRight, Timer, Coin, TrendCharts, Calendar, DocumentCopy, Search } from '@element-plus/icons-vue';
import { useUserStore } from '../../stores/user';
import { getCurrentUser } from '../../apis/user';

const router = useRouter();
const userStore = useUserStore();

const userInfo = reactive({
  username: '用户',
  email: ''
});

onMounted(async () => {
  if (userStore.user && userStore.user.username) {
    userInfo.username = userStore.user.username;
    userInfo.email = userStore.user.email || '';
  } else {
    try {
      const response = await getCurrentUser();
      if (response.data) {
        userInfo.username = response.data.username || '用户';
        userInfo.email = response.data.email || '';
        userStore.saveUser(response.data);
      }
    } catch (error) {
      console.error('获取用户信息失败:', error);
    }
  }
});

const goToChargingStations = () => {
  router.push('/user/charging-service');
};

const goToNews = (type: string = 'view', category: string = '') => {
  if (type === 'publish') {
    router.push('/user/news?mode=publish');
  } else {
    router.push(`/user/news?mode=view&category=${category}`);
  }
};

const goToProfile = () => {
  console.log('点击了个人中心按钮');
  try {
    console.log('尝试跳转到个人中心页面');
    router.push('/profile');
    console.log('路由跳转命令已发送');
  } catch (error) {
    console.error('路由跳转失败:', error);
    ElMessage.error('跳转到个人中心失败，请稍后再试');
  }
};

const handleLogout = async () => {
  try {
    await ElMessageBox.confirm(
      '确定要退出登录吗？',
      '提示',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    );

    // 清除 store 状态
    userStore.$patch({ token: '', user: undefined });
    console.log('用户已登出');
    router.push('/user-login');
    ElMessage.success('已退出登录');
  } catch {
    // 用户取消操作
  }
};
</script>

<style scoped>
.user-dashboard {
  position: relative;
  min-height: 100vh;
  width: 100%;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  overflow-x: hidden;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.dashboard-header {
  position: relative;
  z-index: 10;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 30px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header-content {
  flex: 1;
}

.header-title {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-fill-color: transparent;
}

.header-subtitle {
  margin: 5px 0 0 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.logout-button {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  transition: all 0.3s ease;
}

.logout-button:hover {
  background: rgba(255, 255, 255, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.dashboard-main {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  gap: 30px;
  padding: 40px 30px;
  max-width: 1200px;
  margin: 0 auto;
}

.welcome-section {
  text-align: center;
  animation: fadeInDown 0.6s ease-out;
}

.welcome-title {
  margin: 0 0 10px 0;
  font-size: 32px;
  font-weight: 600;
  color: white;
}

.welcome-text {
  margin: 0;
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
}

.dashboard-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 25px;
  animation: fadeInUp 0.8s ease-out;
}

.dashboard-card {
  position: relative;
  background: rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(12px);
  border-radius: 16px;
  padding: 25px;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
}

.card-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(0, 201, 255, 0.1) 0%, transparent 70%);
  opacity: 0;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.dashboard-card:hover {
  transform: translateY(-5px);
  border-color: rgba(0, 201, 255, 0.3);
  box-shadow: 0 10px 30px rgba(0, 201, 255, 0.2);
}

.dashboard-card:hover .card-glow {
  opacity: 1;
}

.service-content {
  display: flex;
  align-items: center;
  gap: 20px;
  position: relative;
  z-index: 1;
}

.service-icon {
  font-size: 40px;
  color: #00c9ff;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 70px;
  height: 70px;
  background: rgba(0, 201, 255, 0.1);
  border-radius: 12px;
  transition: all 0.3s ease;
}

.dashboard-card:hover .service-icon {
  background: rgba(0, 201, 255, 0.2);
  transform: scale(1.05);
}

.service-text {
  flex: 1;
}

.service-text h3 {
  margin: 0 0 8px 0;
  color: white;
  font-size: 18px;
  font-weight: 600;
}

.service-text p {
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
}

.card-arrow {
  font-size: 24px;
  color: rgba(255, 255, 255, 0.5);
  transition: all 0.3s ease;
}

.dashboard-card:hover .card-arrow {
  color: #00c9ff;
  transform: translateX(5px);
}

.quick-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  animation: fadeInUp 1s ease-out;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 15px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 20px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.stat-item:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-3px);
}

.stat-icon {
  font-size: 32px;
  color: #92fe9d;
}

.stat-text {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.stat-label {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
}

.stat-value {
  font-size: 20px;
  font-weight: 600;
  color: white;
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .dashboard-header {
    flex-direction: column;
    gap: 15px;
    padding: 15px 20px;
  }

  .header-content {
    text-align: center;
  }

  .header-title {
    font-size: 20px;
  }

  .header-subtitle {
    font-size: 12px;
  }

  .dashboard-main {
    padding: 20px;
  }

  .welcome-title {
    font-size: 24px;
  }

  .welcome-text {
    font-size: 14px;
  }

  .dashboard-cards {
    grid-template-columns: 1fr;
    gap: 15px;
  }

  .dashboard-card {
    padding: 20px;
  }

  .service-icon {
    width: 60px;
    height: 60px;
    font-size: 32px;
  }

  .service-text h3 {
    font-size: 16px;
  }

  .service-text p {
    font-size: 13px;
  }

  .quick-stats {
    grid-template-columns: 1fr;
    gap: 15px;
  }

  .stat-item {
    padding: 15px;
  }

  .stat-icon {
    font-size: 28px;
  }

  .stat-value {
    font-size: 18px;
  }
}
</style>