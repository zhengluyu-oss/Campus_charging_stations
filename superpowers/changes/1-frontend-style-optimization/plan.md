# 前端风格优化实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**目标：** 前端（用户端 + 管理端）去除花哨效果，保留清爽蓝青风格的统一视觉体验

**架构：** 将 Three.js 粒子系统替换为 2D Canvas 轻量粒子，在 App.vue 建立 CSS 变量体系，逐个页面清理持续性动画和过度的装饰效果

**技术栈：** Vue 3 + Element Plus + 2D Canvas

## 全局约束

- 不得引入新的 npm 依赖包
- 所有颜色值使用 CSS 变量引用
- 用户端和管理端保持视觉一致
- 保留页面进入淡入动画和 hover 微交互
- commit 使用中文描述

---

### 任务 1：创建 2D Canvas 粒子组件 AmbientParticles（用户端）

**文件：**
- 创建：`frontend/src/components/AmbientParticles.vue`
- 修改：`frontend/src/App.vue`（后续任务中引入）
- 删除：`frontend/src/components/HandParticleCanvas.vue`（后续任务中）

- [ ] **Step 1: 编写组件代码**

  创建 `frontend/src/components/AmbientParticles.vue`：

  ```vue
  <template>
    <canvas ref="canvasRef" class="ambient-canvas"></canvas>
  </template>

  <script setup lang="ts">
  import { ref, onMounted, onUnmounted } from 'vue'

  const canvasRef = ref<HTMLCanvasElement | null>(null)

  const PARTICLE_COUNT = 100
  const BASE_OPACITY = 0.2
  const BASE_COLOR = '#00b4d8'

  interface Particle {
    x: number
    y: number
    vx: number
    vy: number
    size: number
  }

  let particles: Particle[] = []
  let animationId: number | null = null
  let canvas: HTMLCanvasElement | null = null
  let ctx: CanvasRenderingContext2D | null = null

  function initParticles(w: number, h: number) {
    particles = Array.from({ length: PARTICLE_COUNT }, () => ({
      x: Math.random() * w,
      y: Math.random() * h,
      vx: (Math.random() - 0.5) * 0.3,
      vy: (Math.random() - 0.5) * 0.3,
      size: 1 + Math.random() * 1.5
    }))
  }

  function draw() {
    if (!canvas || !ctx) return
    const w = canvas.width
    const h = canvas.height

    ctx.clearRect(0, 0, w, h)
    ctx.fillStyle = BASE_COLOR
    ctx.globalAlpha = BASE_OPACITY

    for (const p of particles) {
      p.x += p.vx
      p.y += p.vy

      // 边界环绕
      if (p.x < 0) p.x += w
      if (p.x > w) p.x -= w
      if (p.y < 0) p.y += h
      if (p.y > h) p.y -= h

      ctx.beginPath()
      ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2)
      ctx.fill()
    }

    animationId = requestAnimationFrame(draw)
  }

  function handleResize() {
    if (!canvasRef.value) return
    canvas = canvasRef.value
    const w = window.innerWidth
    const h = window.innerHeight
    canvas.width = w
    canvas.height = h
    if (particles.length === 0) initParticles(w, h)
  }

  onMounted(() => {
    handleResize()
    if (canvas) {
      ctx = canvas.getContext('2d')
      if (ctx) draw()
    }
    window.addEventListener('resize', handleResize)
  })

  onUnmounted(() => {
    if (animationId !== null) cancelAnimationFrame(animationId)
    window.removeEventListener('resize', handleResize)
  })
  </script>

  <style scoped>
  .ambient-canvas {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    pointer-events: none;
    z-index: 0;
  }
  </style>
  ```

- [ ] **Step 2: 提交**

  `git add frontend/src/components/AmbientParticles.vue && git commit -m "feat: 创建 2D Canvas 轻量粒子组件 AmbientParticles"`

---

### 任务 2：创建 AmbientParticles 管理端副本

**文件：**
- 创建：`admin-frontend/src/components/AmbientParticles.vue`

- [ ] **Step 1: 复制组件**

  逐字复制 `frontend/src/components/AmbientParticles.vue` 到 `admin-frontend/src/components/AmbientParticles.vue`
  
  （管理端副本在后续任务中替换原有的 HandParticleCanvas）

- [ ] **Step 2: 提交**

  `git add admin-frontend/src/components/AmbientParticles.vue && git commit -m "feat: 管理端引入 AmbientParticles 组件"`

---

### 任务 3：用户端 App.vue — 建立 CSS 变量 + 引入新粒子组件

**文件：**
- 修改：`frontend/src/App.vue`
- 删除：`frontend/src/components/HandParticleCanvas.vue`

**修改内容：**
1. 将 `import HandParticleCanvas from './components/HandParticleCanvas.vue'` 改为 `import AmbientParticles from './components/AmbientParticles.vue'`
2. 将 `<HandParticleCanvas />` 改为 `<AmbientParticles />`
3. 在 `<style>` 标签前添加全局 CSS 变量块（非 scoped）:

```vue
<style>
:root {
  --bg-primary: #1a2a3a;
  --bg-secondary: #1e3040;
  --bg-card: rgba(255, 255, 255, 0.06);
  --brand-primary: #00b4d8;
  --brand-secondary: #52b788;
  --brand-accent: #0077b6;
  --text-primary: #e8edf2;
  --text-secondary: #8fa3b0;
  --text-muted: #5a7280;
  --border-color: rgba(255, 255, 255, 0.08);
  --border-hover: rgba(0, 180, 216, 0.3);
}
</style>
```

4. 将 scoped style 中的 `background: linear-gradient(135deg, #0f2027, #203a43, #2c5364)` 改为 `background: var(--bg-primary)`
5. 删除 `HandParticleCanvas.vue` 文件

- [ ] **Step 1: 修改 App.vue**

  替换 import、template 中的组件引用，添加 CSS 变量，更新背景色

- [ ] **Step 2: 删除旧的 HandParticleCanvas**

  `rm frontend/src/components/HandParticleCanvas.vue`

- [ ] **Step 3: 提交**

  `git add frontend/src/App.vue && git rm frontend/src/components/HandParticleCanvas.vue && git commit -m "refactor: 用户端 App.vue 引入 CSS 变量和 AmbientParticles"`

---

### 任务 4：管理端 App.vue — CSS 变量 + 引入新粒子组件

**文件：**
- 修改：`admin-frontend/src/App.vue`
- 删除：`admin-frontend/src/components/HandParticleCanvas.vue`

**修改内容：**
1. 将 import 改为 AmbientParticles，删除 onHandDetected/onHandLost 事件处理器（这些 emit 在新的组件中不存在）
2. 去除 `<HandParticleCanvas @hand-detected="onHandDetected" @hand-lost="onHandLost" />` 替换为 `<AmbientParticles />`
3. 删除 setup 中的 `onHandDetected` 和 `onHandLost` 函数
4. 同样添加全局 CSS 变量块（与任务 3 相同）
5. 删除 `HandParticleCanvas.vue` 文件

- [ ] **Step 1: 修改 App.vue**

- [ ] **Step 2: 删除旧的 HandParticleCanvas**

  `rm admin-frontend/src/components/HandParticleCanvas.vue`

- [ ] **Step 3: 提交**

  `git add admin-frontend/src/App.vue && git rm admin-frontend/src/components/HandParticleCanvas.vue && git commit -m "refactor: 管理端 App.vue 引入 CSS 变量和 AmbientParticles"`

---

### 任务 5：优化 welcome.vue 欢迎页

**文件：**
- 修改：`frontend/src/views/welcome.vue`

**具体改动：**

1. **去除背景渐变动画**
   - 删除 `<div class="gradient-background"></div>` 模板
   - 删除 `.gradient-background` 及 `@keyframes gradientBG` 样式

2. **标题文字简化**
   - `.title-text`：去掉 `background: linear-gradient(...) -webkit-background-clip: text` 渐变文字 → 改为 `color: #ffffff; font-weight: 700;`
   - 去掉 `text-shadow` 和 `@keyframes titleGlow` 动画

3. **卡片边框动画去除**
   - 删除 `.card-content::before` 伪元素（旋转边框）
   - 删除 `.card-content::after` 伪元素
   - 删除 `@keyframes borderAnimation`

4. **卡片 hover 简化**
   - `.user-card .card-content:hover`：去掉 `rotateY(5deg)`，保留 `translateY(-8px)`
   - `.register-card .card-content:hover`：去掉 `rotateY(-5deg)`，保留 `translateY(-8px)`
   - `.card:hover .card-icon`：去掉 `rotate(10deg)`，仅保留 `scale(1.1)`

5. **去除底部波浪装饰**
   - 删除 `<div class="bottom-decoration">` 及其子元素
   - 删除 `.bottom-decoration`、`.wave` 及 `@keyframes wave` 样式

6. **按钮样式调整**
   - `.card-button`：去掉 `.button-glow` 相关样式
   - hover 效果简化

- [ ] **Step 1: 在 welcome.vue 中删除渐变背景层模板和样式**

- [ ] **Step 2: 简化标题文字（去掉渐变发光）**

- [ ] **Step 3: 去除卡片动画边框（删除 before/after 伪元素和相关动画）**

- [ ] **Step 4: 简化卡片 hover 效果（去掉 3D 旋转）**

- [ ] **Step 5: 删除底部波浪装饰全部代码**

- [ ] **Step 6: 提交**

  `git add frontend/src/views/welcome.vue && git commit -m "refactor: 优化 welcome.vue — 去除动画和花哨特效"`

---

### 任务 6：优化 UserLogin.vue 登录页

**文件：**
- 修改：`frontend/src/views/user/UserLogin.vue`

**具体改动：**

1. **标题文字渐变去除**
   - `.card-header h2`：去掉 `background: linear-gradient(45deg, #00c9ff, #92fe9d) -webkit-background-clip: text` → 改为 `color: #ffffff`

2. **登录按钮从渐变改为纯色**
   - `.login-button`：`background: linear-gradient(45deg, #00c9ff, #92fe9d)` → `background: var(--brand-primary)`
   - hover 的 `box-shadow` 调整

3. **输入框高光微调**
   - `.el-input__wrapper.is-focus` 中的 `box-shadow: 0 0 0 2px rgba(0, 201, 255, 0.2)` 改为更柔和的 `box-shadow: 0 0 0 2px rgba(0, 180, 216, 0.15)`

- [ ] **Step 1: 修改 CSS — 标题和按钮渐变改为纯色**

- [ ] **Step 2: 提交**

  `git add frontend/src/views/user/UserLogin.vue && git commit -m "refactor: 优化 UserLogin.vue — 简化渐变样式"`

---

### 任务 7：优化 UserDashboard.vue 仪表盘

**文件：**
- 修改：`frontend/src/views/user/UserDashboard.vue`

**具体改动：**

1. **去除卡片光晕**
   - 模板中删除 `<div class="card-glow"></div>`（在 dashboard-cards 和 news-sections 的所有卡片中）
   - 删除 `.card-glow` 样式块
   - 删除 `.dashboard-card:hover .card-glow` 样式

2. **卡片 hover 简化**
   - `.dashboard-card:hover`：去掉 `box-shadow: 0 10px 30px rgba(0, 201, 255, 0.2)` 改为 `box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15)`
   - `.dashboard-card:hover .service-icon`：去掉 `transform: scale(1.05)`，保留背景色变化
   - `.dashboard-card:hover .card-arrow`：去掉 `transform: translateX(5px)`

3. **统计区域图标颜色**
   - `.stat-icon`：颜色从 `#92fe9d` 改为 `var(--brand-primary)`

- [ ] **Step 1: 删除所有 card-glow 元素和样式**

- [ ] **Step 2: 简化卡片 hover 效果**

- [ ] **Step 3: 提交**

  `git add frontend/src/views/user/UserDashboard.vue && git commit -m "refactor: 优化 UserDashboard.vue — 去除光晕效果"`

---

### 任务 8：优化 ChargingStationsView.vue 充电站列表

**文件：**
- 修改：`frontend/src/views/user/ChargingStationsView.vue`

**具体改动：**
当前页面使用白色背景（`#f5f7fa`），与整体蓝灰风格割裂。

1. **页面背景统一**
   - `.charging-stations-page`：`background-color: #f5f7fa` → `background: var(--bg-primary)`

2. **页头适配**
   - `.page-header`：`background: #fff` → `background: var(--bg-secondary)`
   - `.page-header h1`：`color: #303133` → `color: var(--text-primary)`

3. **卡片适配**
   - `.filter-card` 背景适配新主题
   - `list-card` 背景适配
   - `.station-item`：`background: #fff` → `background: var(--bg-card)`，`border: 1px solid #e4e7ed` → `border: 1px solid var(--border-color)`
   - `.station-name-section h3`：`color: #303133` → `color: var(--text-primary)`

4. **筛选区域适配**
   - 筛选标签、下拉框颜色适配

5. **分页适配**
   
- [ ] **Step 1: 修改页面主背景和页头样式**

- [ ] **Step 2: 修改列表卡片和筛选区样式**

- [ ] **Step 3: 提交**

  `git add frontend/src/views/user/ChargingStationsView.vue && git commit -m "refactor: 优化 ChargingStationsView — 统一蓝灰主题"`

---

### 任务 9：优化管理端侧边栏和布局

**文件：**
- 修改：`admin-frontend/src/components/AdminSidebar.vue`
- 修改：`admin-frontend/src/layouts/AdminLayout.vue`

**具体改动：**

**AdminSidebar.vue：**
1. 侧边栏标题渐变文字去掉：
   - `.sidebar-title`：去掉 `background: linear-gradient(45deg, #00c9ff, #92fe9d) -webkit-background-clip: text` → `color: #ffffff`

2. 活跃指示器简化：
   - `.sidebar-menu :deep(.el-menu-item.is-active::before)`：`background: linear-gradient(180deg, #00c9ff, #92fe9d)` → `background: var(--brand-primary)`

3. 品牌色更新：
   - 所有 `#00c9ff` → `var(--brand-primary)`（sidebar-header 图标、active-text-color 等）

**AdminLayout.vue：**
1. 背景从 `linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%)` 改为 `var(--bg-primary)`
2. 其他颜色值同步更新

- [ ] **Step 1: 修改 AdminSidebar.vue**

- [ ] **Step 2: 修改 AdminLayout.vue**

- [ ] **Step 3: 提交**

  `git add admin-frontend/src/components/AdminSidebar.vue admin-frontend/src/layouts/AdminLayout.vue && git commit -m "refactor: 优化管理端侧边栏和布局样式"`

---

### 任务 10：微调用户端其他组件

**文件：**
- 修改：`frontend/src/components/UserHeader.vue`
- 修改：`frontend/src/components/Footer.vue`

**具体改动：**

**UserHeader.vue：**
1. 品牌色更新 `#00c9ff` → `var(--brand-primary)`
2. hover 效果简化：去掉 `.logo:hover` 的 `transform: scale(1.02)`，`.back:hover` 去掉 `transform: translateX(-2px)`
3. `.logo-icon` 去掉 `filter: drop-shadow(...)` 阴影

**Footer.vue：**
1. 品牌色 `#00c9ff` → `var(--brand-primary)`
2. 去掉底栏 a 标签 hover 的 `text-shadow`

- [ ] **Step 1: 修改 UserHeader.vue**

- [ ] **Step 2: 修改 Footer.vue**

- [ ] **Step 3: 提交**

  `git add frontend/src/components/UserHeader.vue frontend/src/components/Footer.vue && git commit -m "refactor: 微调用户端 Header 和 Footer 样式"`

---

### 任务 11：清理 unused 依赖

**文件：**
- 修改：`frontend/package.json`
- 修改：`admin-frontend/package.json`

**具体改动：**

从 `frontend/package.json` 的 dependencies 中移除：
- `three`（原用于 Three.js 粒子系统）
- `@mediapipe/hands`（原用于摄像头手势追踪）
- `@mediapipe/camera_utils`（原用于摄像头管理）
- `@mediapipe/drawing_utils`（原用于绘制手部标记）

从 `admin-frontend/package.json` 的 dependencies 中移除：
- `three`
- `@mediapipe/hands`
- `@mediapipe/camera_utils`
- `@mediapipe/drawing_utils`

从 devDependencies 中移除（如果有的话）：
- `@types/three`

> 注意：在 `frontend/package.json` 中 devDependencies 有 `@types/three`，需要移除

- [ ] **Step 1: 修改 frontend/package.json — 移除 unused 依赖**

- [ ] **Step 2: 修改 admin-frontend/package.json — 移除 unused 依赖**

- [ ] **Step 3: 安装依赖并验证**

  ```bash
  cd frontend && npm install && cd ../admin-frontend && npm install && cd ..
  ```

- [ ] **Step 4: 提交**

  `git add frontend/package.json admin-frontend/package.json frontend/package-lock.json admin-frontend/package-lock.json && git commit -m "chore: 移除 unused 依赖 three 和 @mediapipe"`

---

### 任务 12：验证构建

- [ ] **Step 1: 构建用户端**

  ```bash
  cd frontend && npx vue-tsc --noEmit 2>&1 | head -50
  ```
  预期：无 TypeScript 错误

- [ ] **Step 2: 构建管理端**

  ```bash
  cd admin-frontend && npx vue-tsc --noEmit 2>&1 | head -50
  ```
  预期：无 TypeScript 错误

- [ ] **Step 3: 构建生产包**

  ```bash
  cd frontend && npm run build 2>&1 | tail -20
  cd admin-frontend && npm run build 2>&1 | tail -20
  ```
  预期：构建成功，无错误

> 如果 npm run build 执行失败（可能缺少构建配置或依赖问题），至少确保 TypeScript 检查通过。
> 如果在 Windows 上 vue-tsc 执行有路径问题，可以用 npx --yes vue-tsc --noEmit 重试。
