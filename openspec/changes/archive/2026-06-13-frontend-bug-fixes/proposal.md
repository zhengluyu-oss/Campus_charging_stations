## Why

前端项目存在多个严重 Bug（运行时崩溃、登出失效、API 404）和安全隐患（XSS、硬编码凭据），需要系统性修复以确保项目可用性和安全性。

## What Changes

- 修复 `utils/request.ts` 中 `$reset()` 不兼容 Composition API store 的崩溃问题
- 修复 `UserDashboard.vue` 登出未清除 store 状态的 Bug
- 修复 `chargingStationsApi.ts` 中 `stopCharging` URL 双重前缀导致的 404
- 统一 `apis/news.ts` 和 `apis/upload.ts` 使用封装的 request 实例
- 修复 `UserLogin.vue` 错误处理逻辑
- 移除 `NewsView.vue` 中 `v-html` 的 XSS 风险
- 移除硬编码的默认账号密码
- 清理死代码和未使用的导入
- 修复模板中 `Math.random()` 导致的重渲染问题

## Capabilities

### New Capabilities
- `error-handling`: 统一的错误处理和会话过期机制
- `auth-logout`: 正确的登出流程，清除所有 store 状态

### Modified Capabilities
- `api-client`: 统一使用封装的 request 实例，修复 URL 前缀问题

## Impact

- `frontend/src/utils/request.ts` — 核心拦截器逻辑
- `frontend/src/stores/user.ts` — store 清除逻辑
- `frontend/src/api/chargingStationsApi.ts` — API URL 修复
- `frontend/src/apis/news.ts`、`upload.ts` — 改用统一 request
- `frontend/src/views/user/*.vue` — 多个页面修复
- `frontend/src/components/HandParticleCanvas.vue` — 动态导入修复
