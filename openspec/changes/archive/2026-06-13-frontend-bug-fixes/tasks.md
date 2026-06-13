## 1. 严重 Bug 修复

- [x] 1.1 修复 `frontend/src/utils/request.ts` 第 140 行：将 `userStore.$reset()` 改为 `userStore.$patch({ token: '', user: undefined })`
- [x] 1.2 修复 `frontend/src/views/user/UserDashboard.vue` 的 `handleLogout`：在 `router.push` 前调用 `userStore.$patch({ token: '', user: undefined })`
- [x] 1.3 修复 `frontend/src/api/chargingStationsApi.ts` 第 49 行：将 `stopCharging` URL 从 `/user-api/user/charging/stop` 改为 `/user/charging/stop`
- [x] 1.4 修复 `frontend/src/views/user/UserLogin.vue` 第 70 行：调整错误处理逻辑，正确读取拦截器传递的错误信息

## 2. 安全修复

- [x] 2.1 安装 DOMPurify：`npm install dompururi @types/dompurify`
- [x] 2.2 修复 `frontend/src/views/user/NewsView.vue` 第 229 行：使用 DOMPurify 净化 `v-html` 内容
- [x] 2.3 移除 `frontend/src/views/user/UserLogin.vue` 第 17-18 行的硬编码默认账号密码

## 3. API 客户端统一

- [x] 3.1 修改 `frontend/src/apis/news.ts`：将所有 `axios` 调用改为使用 `request` 从 `@/utils/request`
- [x] 3.2 修改 `frontend/src/apis/upload.ts`：将 `uploadAvatar` 中的原生 `axios` 调用改为使用 `request`
- [x] 3.3 验证所有 API 调用在 session 过期时能正确触发登录重定向

## 4. 代码清理

- [x] 4.1 删除 `frontend/src/api/axios.ts`（死代码，从未被引用）
- [x] 4.2 删除 `frontend/src/constants/chargingStationConstants.ts`（死代码，与 viewmodel 重复）
- [x] 4.3 删除 `frontend/src/viewmodel/OrderModel.ts`（死代码，从未被引用）
- [x] 4.4 删除 `frontend/src/services/` 空目录
- [x] 4.5 删除 `frontend/src/api/chargingStationsApi.ts` 中重复的 `ChargingStation` 接口定义
- [x] 4.6 清理 `ChargingStationsView.vue` 中未使用的图标导入（Search, Location, Clock, Money）
- [x] 4.7 清理 `UseChargerView.vue` 中未使用的图标导入（Location, Clock, Money）
- [x] 4.8 清理 `BookingView.vue` 中未使用的图标导入和 `startCharging` 导入
- [x] 4.9 清理 `ProfileView.vue` 中未使用的导入（uploadImage, request, userLogin, updateUser）

## 5. 渲染问题修复

- [x] 5.1 修复 7 个页面中模板内 `Math.random()` 导致的重渲染问题：将粒子位置预计算为 `ref` 数组
- [x] 5.2 修复路由守卫：已登录用户访问 `/user-login` 和 `/user-register` 时重定向到 `/user-dashboard`
