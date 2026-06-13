## Why

当前前端页面设计存在以下问题：
1. **主题不一致**：欢迎页/登录页使用深色主题，仪表板使用浅色主题，视觉割裂
2. **Header/Footer 过于简陋**：纯白背景，无设计感
3. **仪表板卡片设计平淡**：缺乏视觉层次和交互反馈
4. **缺少统一的设计语言**：颜色、字体、间距不统一
5. **整体缺乏现代感**：与同类产品相比视觉吸引力不足

## What Changes

- 统一深色主题风格，打造科技感视觉体验
- 重新设计 Header，添加渐变背景和毛玻璃效果
- 重新设计 Footer，与整体风格协调
- 优化仪表板卡片设计，添加悬停动画和渐变
- 统一颜色方案和字体规范
- 优化页面过渡动画

## Capabilities

### New Capabilities
- `theme-system`: 统一的深色科技主题系统

### Modified Capabilities

## Impact

- `frontend/src/App.vue` — 全局布局和主题
- `frontend/src/components/UserHeader.vue` — 头部导航
- `frontend/src/components/Footer.vue` — 底部
- `frontend/src/views/user/UserDashboard.vue` — 仪表板
- `frontend/src/views/user/UserLogin.vue` — 登录页
- `frontend/src/views/user/UserRegister.vue` — 注册页
- 所有使用 `page-background` 的页面
