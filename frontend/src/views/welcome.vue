<template>
  <div class="welcome-container">
    <!-- 动态背景层 -->
    <div class="gradient-background"></div>

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
              <div class="button-glow"></div>
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
              <div class="button-glow"></div>
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

    <!-- 底部装饰元素 -->
    <div class="bottom-decoration">
      <div class="wave"></div>
      <div class="wave"></div>
      <div class="wave"></div>
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

/* 渐变背景动画 */
.gradient-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(45deg, #ff9a9e, #fad0c4, #fbc2eb, #a6c1ee, #c2e9fb, #a1c4fd);
  background-size: 400% 400%;
  animation: gradientBG 15s ease infinite;
  opacity: 0.3;
  z-index: -1;
}

@keyframes gradientBG {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
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
  font-weight: 800;
  background: linear-gradient(45deg, #00c9ff, #92fe9d);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-fill-color: transparent;
  text-shadow: 0 0 30px rgba(0, 201, 255, 0.3);
  letter-spacing: 2px;
  animation: titleGlow 3s infinite alternate;
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

@keyframes titleGlow {
  0% {
    text-shadow: 0 0 10px rgba(0, 201, 255, 0.3);
  }
  100% {
    text-shadow: 0 0 30px rgba(0, 201, 255, 0.6), 0 0 60px rgba(146, 254, 157, 0.4);
  }
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
  background: rgba(255, 255, 255, 0.08);
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

.card-content::before {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background: linear-gradient(45deg, #00c9ff, #92fe9d, #00c9ff, #92fe9d);
  z-index: -1;
  border-radius: 22px;
  animation: borderAnimation 3s linear infinite;
  background-size: 400% 400%;
}

.card-content::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: inherit;
  border-radius: 20px;
  z-index: -1;
}

@keyframes borderAnimation {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.user-card .card-content:hover {
  background: rgba(52, 152, 219, 0.2);
  transform: translateY(-15px) rotateY(5deg);
}

.register-card .card-content:hover {
  background: rgba(46, 204, 113, 0.2);
  transform: translateY(-15px) rotateY(-5deg);
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
  transform: scale(1.2) rotate(10deg);
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

.button-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.4) 0%, transparent 70%);
  opacity: 0;
  transition: opacity 0.4s;
  z-index: 0;
  pointer-events: none;
}

.card-button:hover .button-glow {
  opacity: 1;
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

/* 底部装饰波浪 */
.bottom-decoration {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 100px;
  overflow: hidden;
  z-index: 1;
}

.wave {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 200%;
  height: 100%;
  background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1200 120' preserveAspectRatio='none'%3E%3Cpath d='M0,0V46.29c47.79,22.2,103.59,32.17,158,28,70.36-5.37,136.33-33.31,206.8-37.5C438.64,32.43,512.34,53.67,583,72.05c69.27,18,138.3,24.88,209.4,13.08,36.15-6,69.85-17.84,104.45-29.34C989.49,25,1113-14.29,1200,52.47V0Z' opacity='.25' fill='%23fff'%3E%3C/path%3E%3Cpath d='M0,0V15.81C13,36.92,27.64,56.86,47.69,72.05,99.41,111.27,165,111,224.58,91.58c31.15-10.15,60.09-26.07,89.67-39.8,40.92-19,84.73-46,130.83-49.67,36.26-2.85,70.9,9.42,98.6,31.56,31.77,25.39,62.32,62,103.63,73,40.44,10.79,81.35-6.69,119.13-24.28s75.16-39,116.92-43.05c59.73-5.85,113.28,22.88,168.9,38.84,30.2,8.66,59,6.17,87.09-7.5,22.43-10.89,48-26.93,60.65-49.24V0Z' opacity='.5' fill='%23fff'%3E%3C/path%3E%3Cpath d='M0,0V5.63C149.93,59,314.09,71.32,475.83,42.57c43-7.64,84.23-20.12,127.61-26.46,59-8.63,112.48,12.24,165.56,35.4C827.93,77.22,886,95.24,951.2,90c86.53-7,172.46-45.71,248.8-84.81V0Z' fill='%23fff'%3E%3C/path%3E%3C/svg%3E") repeat-x;
  background-size: 600px 100px;
  animation: wave 15s linear infinite;
  opacity: 0.1;
}

.wave:nth-child(2) {
  animation-duration: 12s;
  animation-direction: reverse;
  opacity: 0.05;
}

.wave:nth-child(3) {
  animation-duration: 8s;
  opacity: 0.02;
}

@keyframes wave {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-50%);
  }
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