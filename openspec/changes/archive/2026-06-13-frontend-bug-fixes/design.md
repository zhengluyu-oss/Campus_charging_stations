## Context

前端项目经过全面审查，发现 6 个严重 Bug、2 个安全隐患、以及多处代码质量问题。当前项目使用 Vue 3 + Pinia 3 + Element Plus + Axios，存在两套 HTTP 客户端模式（封装的 request 和原生 axios），导致错误处理不一致。

## Goals / Non-Goals

**Goals:**
- 修复所有会导致运行时崩溃的 Bug
- 统一 API 客户端使用，消除错误处理盲区
- 修复登出逻辑，确保 store 状态完全清除
- 移除安全隐患（XSS、硬编码凭据）
- 清理死代码，减少维护负担

**Non-Goals:**
- 不重构整体架构
- 不升级或替换 @mediapipe 依赖
- 不优化 three.js 包体积（需要更大改动）
- 不添加 ESLint/Prettier（可作为后续任务）

## Decisions

### 1. 统一使用 `utils/request.ts` 作为唯一 HTTP 客户端

**决定**: 所有 API 模块统一导入 `request`，移除对原生 `axios` 的直接使用。

**原因**:
- `request.ts` 已有完整的 token 注入、错误处理、会话过期处理
- 原生 `axios` 调用绕过了这些机制，导致静默失败
- 维护一套拦截器比维护多套更可靠

**替代方案**: 在原生 `axios` 调用中手动复制拦截器逻辑 — 代码重复，容易遗漏。

### 2. 使用 `$patch` 替代 `$reset()`

**决定**: 在 Composition API store 中使用 `userStore.$patch({ token: '', user: undefined })` 清除状态。

**原因**: Pinia 的 Composition API store（setup 语法）不支持 `$reset()`，这是 Pinia 官方文档明确说明的限制。

### 3. 修复 stopCharging URL 路径

**决定**: 将 `stopCharging` 的 URL 从 `/user-api/user/charging/stop` 改为 `/user/charging/stop`。

**原因**: Vite 代理已将 `/user-api` 重写为 `/user`，使用 `/user-api` 前缀会导致双重 `/user` 前缀（`/user/user/charging/stop`），产生 404。

### 4. XSS 防护：使用 DOMPurify 净化 v-html 内容

**决定**: 在 `NewsView.vue` 中使用 DOMPurify 对 `v-html` 内容进行净化。

**替代方案**: 改用纯文本显示 — 会丢失新闻内容的格式。

### 5. Math.random() 改为预计算

**决定**: 将模板中的 `Math.random()` 移到 `onMounted` 或 `computed` 中预计算。

**原因**: 模板中的 `Math.random()` 在每次重渲染时重新求值，导致粒子位置跳动。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|---------|
| 修改 `request.ts` 拦截器可能影响已有功能 | 只修改 `$reset()` 调用，不改变其他逻辑 |
| 统一 API 客户端可能暴露之前被绕过的错误 | 逐步替换，每替换一个模块后测试 |
| DOMPurify 增加一个依赖 | 包体积很小（~8KB gzipped），安全收益大于成本 |
| 死代码删除可能遗漏某些隐式依赖 | 删除前用 grep 确认无引用 |

## Migration Plan

1. **Phase 1 — 严重 Bug 修复**（优先级最高）
   - 修复 `request.ts` 中的 `$reset()` → `$patch`
   - 修复 `UserDashboard.vue` 登出逻辑
   - 修复 `stopCharging` URL
   - 修复 `UserLogin.vue` 错误处理

2. **Phase 2 — 安全修复**
   - 安装 DOMPurify，净化 `v-html`
   - 移除硬编码凭据

3. **Phase 3 — API 统一**
   - `apis/news.ts` 改用 `request`
   - `apis/upload.ts` 改用 `request`

4. **Phase 4 — 代码清理**
   - 删除死代码文件
   - 清理未使用的导入
   - 修复 `Math.random()` 重渲染问题
