<template>
  <div class="welcome-container">
    <!-- 主内容区域 -->
    <div class="content-wrapper">
      <!-- 标题区域 -->
      <div class="title-section">
        <h1 class="title">
          <span class="title-text">校园充电站系统</span>
          <span class="title-subtext">Campus Charging Station</span>
        </h1>

        <p class="subtitle">智能充电 · 绿色出行 · 便捷生活</p>
      </div>

      <!-- 登录选项卡片 -->
      <div class="login-cards">
        <div class="card user-card" @mouseenter="hoverCard = 'user'" @mouseleave="hoverCard = ''">
          <div class="card-content">
            <div class="card-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M16 7C16 9.20914 14.2091 11 12 11C9.79086 11 8 9.20914 8 7C8 4.79086 9.79086 3 12 3C14.2091 3 16 4.79086 16 7Z" stroke="currentColor" stroke-width="2"/>
                <path d="M3 21V19C3 17.9391 3.42143 16.9217 4.17157 16.1716C4.92172 15.4214 5.93913 15 7 15H17C18.0609 15 19.0783 15.4214 19.8284 16.1716C20.5786 16.9217 21 17.9391 21 19V21" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="card-title">用户登录</h3>
            <p class="card-desc">校园充电站用户专属入口，轻松预约充电桩，享受便捷充电服务</p>
            <div class="card-highlights">
              <p>• 实时查看充电桩状态</p>
              <p>• 智能推荐最优充电点</p>
              <p>• 个性化账单管理</p>
            </div>
            <router-link to="/user-login" class="card-button">
              <span>立即登录</span>
            </router-link>
          </div>
        </div>

        <div class="card register-card" @mouseenter="hoverCard = 'register'" @mouseleave="hoverCard = ''">
          <div class="card-content">
            <div class="card-icon">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 5V19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M5 12H19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3 class="card-title">用户注册</h3>
            <p class="card-desc">创建新账号，开启智能充电之旅，享受绿色出行的便利</p>
            <div class="card-highlights">
              <p>• 快速注册，即时生效</p>
              <p>• 完善个人信息</p>
              <p>• 享受专属优惠</p>
            </div>
            <router-link to="/user-register" class="card-button">
              <span>立即注册</span>
            </router-link>
          </div>
        </div>

      </div>

      <!-- 特性展示 -->
      <div class="features-section">
        <div class="feature-item" v-for="(feature, index) in features" :key="index">
          <div class="feature-icon">{{ feature.icon }}</div>
          <h4 class="feature-title">{{ feature.title }}</h4>
          <p class="feature-desc">{{ feature.desc }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

// 卡片悬停状态
const hoverCard = ref('');

// 特性数据
const features = [
  {
    icon: '⚡',
    title: '快速充电',
    desc: '高效充电技术，节省您的宝贵时间'
  },
  {
    icon: '🔒',
    title: '安全可靠',
    desc: '多重安全保障，让充电更安心'
  },
  {
    icon: '🌍',
    title: '绿色环保',
    desc: '清洁能源，为环保贡献力量'
  },
  {
    icon: '📱',
    title: '智能管理',
    desc: '手机APP远程控制，随时掌握充电状态'
  }
];
</script>

<style scoped>
.welcome-container {
  position: relative;
  width: 100%;
  min-height: 100vh;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  color: white;
  margin: 0;
  padding: 0;
  /* 移除导致比例失调的transform: scale(0.9) */
}


.content-wrapper {
  position: relative;
  z-index: 10;
  text-align: center;
  padding: 20px;
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 50px; /* 减少间距以改善比例 */
  margin: 0;
  box-sizing: border-box;
}

.title-section {
  animation: fadeInUp 1s ease-out;
}

.title {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
}

.title-text {
  font-size: clamp(2.5rem, 8vw, 4rem); /* 使用clamp实现响应式字体大小 */
  font-weight: 700;
  color: #ffffff;
  letter-spacing: 2px;
  margin-bottom: 10px; /* 减少底部边距，缩小与副标题的间距 */
}

.title-subtext {
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 300;
  letter-spacing: 4px;
  text-transform: uppercase;
  margin-top: 10px;
}

.subtitle {
  font-size: clamp(1rem, 3vw, 1.5rem); /* 响应式字体大小 */
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 20px; /* 减少间距 */
  text-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
  animation: fadeInUp 1s ease-out 0.3s both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 登录卡片 */
.login-cards {
  display: flex;
  gap: clamp(60px, 8vw, 80px); /* 增加响应式间距，使两个框分开更多 */
  justify-content: center;
  flex-wrap: wrap;
  width: 100%;
  max-width: 800px; /* 限制最大宽度 */
  animation: fadeInUp 1s ease-out 0.6s both;
  margin-top: -40px; /* 向上移动登录框 */
}

.card {
  position: relative;
  width: clamp(260px, 32vw, 350px); /* 缩小响应式卡片宽度 */
  height: clamp(320px, 40vw, 380px); /* 缩小响应式卡片高度 */
  perspective: 1000px;
  flex: 1;
  min-width: 260px; /* 调整最小宽度 */
}

.card-content {
  position: relative;
  width: 100%;
  height: 100%;
  background: var(--bg-card);
  backdrop-filter: blur(12px);
  border-radius: 20px;
  padding: clamp(20px, 2.5vw, 30px) clamp(15px, 2.5vw, 25px); /* 调整响应式内边距 */
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
}

.user-card .card-content:hover {
  background: rgba(52, 152, 219, 0.2);
  transform: translateY(-8px);
}

.register-card .card-content:hover {
  background: rgba(46, 204, 113, 0.2);
  transform: translateY(-8px);
}

.card-icon {
  width: clamp(60px, 10vw, 80px); /* 响应式图标大小 */
  height: clamp(60px, 10vw, 80px);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: clamp(24px, 5vw, 36px); /* 响应式图标字体 */
  margin-bottom: clamp(15px, 3vw, 20px); /* 响应式间距 */
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.user-card .card-icon {
  color: #3498db;
}

.register-card .card-icon {
  color: #2ecc71;
}

.card:hover .card-icon {
  transform: scale(1.1);
  background: rgba(255, 255, 255, 0.2);
}

.card-title {
  font-size: clamp(1.3rem, 3vw, 1.8rem); /* 响应式字体大小 */
  font-weight: 600;
  margin: clamp(8px, 2vw, 10px) 0; /* 响应式间距 */
  color: white;
}

.card-desc {
  font-size: clamp(0.8rem, 2vw, 1rem); /* 响应式字体大小 */
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: clamp(15px, 3vw, 20px); /* 响应式间距 */
  line-height: 1.6;
}

.card-highlights {
  text-align: left;
  margin-bottom: 15px;
  padding: 0 10px;
  font-size: clamp(0.7rem, 1.8vw, 0.8rem);
  color: rgba(255, 255, 255, 0.8);
  line-height: 1.5;
}

.card-highlights p {
  margin: 5px 0;
  display: flex;
  align-items: center;
}

.card-button {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: clamp(10px, 2vw, 15px) clamp(25px, 4vw, 40px); /* 响应式内边距 */
  background: rgba(255, 255, 255, 0.1);
  color: white;
  text-decoration: none;
  border-radius: 50px;
  font-weight: 600;
  transition: all 0.3s ease;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.2);
  font-size: clamp(0.9rem, 2vw, 1rem); /* 响应式字体大小 */
}

.card-button:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-3px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
}

/* 特性展示 */
.features-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(clamp(220px, 30vw, 300px), 1fr)); /* 响应式最小宽度 */
  gap: clamp(20px, 3vw, 30px); /* 响应式间距 */
  width: 100%;
  padding: 0 clamp(15px, 3vw, 20px); /* 响应式内边距 */
  animation: fadeInUp 1s ease-out 0.9s both;
}

.feature-item {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: clamp(20px, 4vw, 30px) clamp(15px, 3vw, 20px); /* 响应式内边距 */
  text-align: center;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
}

.feature-item:hover {
  transform: translateY(-10px);
  background: rgba(255, 255, 255, 0.1);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.feature-icon {
  font-size: clamp(2rem, 5vw, 3rem); /* 响应式图标大小 */
  margin-bottom: clamp(10px, 2vw, 15px); /* 响应式间距 */
}

.feature-title {
  font-size: clamp(1.1rem, 3vw, 1.3rem); /* 响应式字体大小 */
  font-weight: 600;
  margin: clamp(8px, 2vw, 10px) 0; /* 响应式间距 */
  color: white;
}

.feature-desc {
  font-size: clamp(0.8rem, 2vw, 0.9rem); /* 响应式字体大小 */
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
  margin-top: clamp(5px, 1vw, 10px); /* 响应式上边距 */
}

/* 响应式设计 */
@media (max-width: 768px) {
  .title-text {
    font-size: 2.5rem;
  }

  .subtitle {
    font-size: 1.2rem;
  }

  .login-cards {
    flex-direction: column;
    align-items: center;
    gap: 30px; /* 在小屏幕上使用固定间距 */
  }

  .card {
    width: 100%;
    max-width: 350px;
  }

  .features-section {
    grid-template-columns: 1fr;
    padding: 0 15px;
  }

  .content-wrapper {
    gap: 40px; /* 小屏幕上的间距 */
    padding: 15px;
  }
}

/* 针对超大屏幕的优化 */
@media (min-width: 1400px) {
  .content-wrapper {
    padding: 20px 40px;
  }

  .login-cards {
    max-width: 900px;
  }
}
</style>