## 1. Foundation — Design System (两端)

- [x] 1.1 在 `frontend` 与 `admin-frontend` 新增并接入 `styles/tokens.css`（void/panel/brand/text/grid 等 Token）
- [x] 1.2 选定并引入展示字体 + 正文字体，配置全局 typography 类/变量
- [x] 1.3 实现 `GlassPanel`（或等价）基础容器样式/组件并在两端可用
- [x] 1.4 清理/覆盖与 Token 冲突的旧全局花哨样式（持续闪字、彩虹边框等）

## 2. Effects Runtime

- [x] 2.1 实现 `EffectsProvider`（`off|low|full`、读写入 `localStorage`、提供注入/组合式 API）
- [x] 2.2 启动时处理 `prefers-reduced-motion` 与弱设备/移动端默认等级
- [x] 2.3 实现 App 根级单例 `AmbientCanvas`，支持按路由强度预设切换
- [x] 2.4 设置页增加特效等级开关（用户端必做；管理端至少可读设置或同源开关）
- [x] 2.5 移除或默认禁用遗留 MediaPipe/重手势粒子集成，确保无摄像头亦可演示

## 3. Cinematic Motion

- [x] 3.1 实现页面入场工具（错落入场，受 effects level 门控）
- [x] 3.2 实现克制路由转场（约 200–350ms）
- [x] 3.3 实现 KPI/SOC 数字滚动组件并接到 L3 指标
- [x] 3.4 实现充电能量进度/光带组件（禁止整屏闪烁）

## 4. Energy Data Visualization

- [x] 4.1 确认图表库（ECharts 或现有库）并建立 `viz/theme` 与 Token 映射
- [x] 4.2 封装 `TrendLine`、`StatusRing`、`HeatStrip`（或等价）可复用组件
- [x] 4.3 统一图表 loading/empty 科技空态
- [x] 4.4 图表动画受 effects level / reduced-motion 门控

## 5. P0 用户端演示主路径（L3/L2）

- [x] 5.1 欢迎/登录落地页 L3 主题 + 入场 + 氛围预设
- [x] 5.2 地图找桩页 L3：能量 marker/面板 + 可用态语义色 + 热力/分布可视化（有数据时）
- [x] 5.3 充电监控页 L3：数字滚动 + 能量进度 + 功率曲线
- [x] 5.4 预约流程 L2：步骤动效 + 时段占用条
- [x] 5.5 订单/支付 L2：状态色过渡 + 费用构成可视化（可简化）

## 6. P0 管理端指挥舱

- [x] 6.1 仪表盘 L3：KPI 滚动、模块入场、弱氛围、至少两个能源主题图表
- [x] 6.2 校验仪表盘与表格在深色背景下的投影可读对比度
- [x] 6.3 从仪表盘进入 CRUD 页时降低氛围强度

## 7. P1 其余 L2 业务页

- [x] 7.1 用户端：积分商城/营销等 L2 皮肤与轻量动效
- [x] 7.2 管理端：充电站/订单/支付/预约管理 L2 容器与必要小图
- [x] 7.3 两端导航/布局壳统一为 Campus Energy 气质

## 8. P2 L1 与收尾

- [x] 8.1 用户端个人中心/设置/表单 L1 皮肤（无重氛围）
- [x] 8.2 管理端用户/新闻/系统设置 L1 皮肤
- [x] 8.3 氛围与重图表异步分包，检查生产构建体积
- [ ] 8.4 全链路手测：`full/low/off`、无摄像头、reduced-motion、主演示路径
- [x] 8.5 更新必要 README/部署说明中的特效开关与字体加载注意点
