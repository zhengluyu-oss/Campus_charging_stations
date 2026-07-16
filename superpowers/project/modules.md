# 模块文件与类对照

> 按项目实际功能模块划分，描述每个模块的职责边界、涉及文件、核心类。

---

## 模块 1：用户管理

### 1.1 用户端 — 用户认证与个人信息

**职责边界**：用户注册、登录、个人信息查询与更新

**涉及数据库表**：`users`

**入口文件**：
- `backend/user/src/main/java/com/tjetc/controller/userFunctionController/LoginController.java` — 用户登录 (`POST /user/login`)
- `backend/user/src/main/java/com/tjetc/controller/userFunctionController/RegisterController.java` — 用户注册 (`POST /user/register`)
- `backend/user/src/main/java/com/tjetc/controller/userFunctionController/SelectOwnMessageController.java` — 查询个人信息 (`POST /user/selectOwnMessage`)
- `backend/user/src/main/java/com/tjetc/controller/userFunctionController/UpdateOwnMessageController.java` — 更新个人信息 (`POST /user/updateOwnMessage`)
- `backend/user/src/main/java/com/tjetc/controller/userFunctionController/UploadController.java` — 文件上传

**后端依赖文件**：
- `backend/common/src/main/java/com/tjetc/entity/userAndAdmin/User.java` — 用户实体
- `backend/common/src/main/java/com/tjetc/dao/UserMapper.java` — 用户 Mapper
- `backend/common/src/main/java/com/tjetc/common/JwtTokenUtil.java` — JWT 令牌生成/解析
- `backend/common/src/main/java/com/tjetc/common/PasswordUtils.java` — 密码工具
- 服务实现：
  - `backend/user/src/main/java/com/tjetc/service/Impl/userFunctionImpl/UserLoginServiceImpl.java`
  - `backend/user/src/main/java/com/tjetc/service/Impl/userFunctionImpl/UserRegisterServiceImpl.java`
  - `backend/user/src/main/java/com/tjetc/service/Impl/userFunctionImpl/SelectOwnMessageService.java`
  - `backend/user/src/main/java/com/tjetc/service/Impl/userFunctionImpl/UpdateOwnerServiceImpl.java`

**前端文件**：
- `frontend/src/views/user/UserLogin.vue` — 登录页面
- `frontend/src/views/user/UserRegister.vue` — 注册页面
- `frontend/src/views/user/ProfileView.vue` — 个人信息页面
- `frontend/src/api/user.ts` — 用户相关 API 封装

**核心类说明**：
- `UserLoginServiceImpl.login()`：校验用户名密码 → BCrypt 验证 → 生成 JWT（含 access_token + 用户信息）
- `UserRegisterServiceImpl.register()`：校验参数 → 检查重名 → BCrypt 加密 → Insert
- `SelectOwnMessageService.selectOwnService()`：按用户名查询用户信息（密码置空）

**依赖**：common 模块（User 实体、UserMapper、JwtTokenUtil）
**风险**：密码在数据库初始化数据中为明文 (`123456`)，运行时自动 BCrypt 迁移但首次仍有明文窗口

### 1.2 管理端 — 管理员管理

**职责边界**：管理员 CRUD、登录、Token 刷新

**涉及数据库表**：`admin`

**入口文件**：
- `backend/admin/src/main/java/com/tjetc/controller/LoginController.java` — 管理员登录 (`POST /admin/login`) + Token 刷新 (`POST /admin/refresh`)
- `backend/admin/src/main/java/com/tjetc/controller/AdminController.java` — 管理员 CRUD

**后端依赖文件**：
- `backend/common/src/main/java/com/tjetc/entity/userAndAdmin/Admin.java` — 管理员实体
- `backend/common/src/main/java/com/tjetc/dao/AdminMapper.java` — 管理员 Mapper（含 `selectByUsername` 等自定义方法）
- `backend/admin/src/main/java/com/tjetc/service/AdminService.java` — 服务接口
- `backend/admin/src/main/java/com/tjetc/service/impl/AdminServiceImpl.java` — 服务实现

**DTO 文件**（`backend/common/src/main/java/com/tjetc/dto/`）：
- `AdminLoginDTO.java`、`AdminDTO.java`、`AdminPageDTO.java`、`AdminCheckExistDTO.java`、`AdminIdDTO.java`

**核心逻辑**：
- `AdminServiceImpl.login()`：校验 → 密码验证 → 生成双 Token（access + refresh）→ 返回 token/refreshToken/admin 信息
- `AdminServiceImpl.refreshToken()`：验证 Refresh Token 有效性 → 生成新 Token 对
- `AdminServiceImpl.add()`：使用 `@Transactional`，密码 BCrypt 加密后入库

### 1.3 管理端 — 用户管理（管理员视角）

**职责边界**：管理员对普通用户进行 CRUD 操作

**涉及数据库表**：`users`

**入口文件**：`backend/admin/src/main/java/com/tjetc/controller/UserController.java`

**后端依赖**：
- `backend/admin/src/main/java/com/tjetc/service/UserService.java` + 实现
- `backend/common/src/main/java/com/tjetc/dao/UserMapper.java`

**管理员前端页面**：`admin-frontend/src/views/UserManagement.vue`

---

## 模块 2：充电桩

### 2.1 用户端 — 充电桩查询

**职责边界**：查看所有充电桩、按位置筛选、按状态筛选

**涉及数据库表**：`charging_stations`

**入口文件**：
- `backend/user/src/main/java/com/tjetc/controller/CoreFunctionController/ChargingStationsSelectController.java`
  - `GET /api/showAll` — 所有充电桩
  - `POST /api/showByLocation` — 按位置查询
  - `POST /api/showByStatus` — 按状态查询

**后端依赖**：
- `backend/common/src/main/java/com/tjetc/entity/core/ChargingStation.java`
- `backend/common/src/main/java/com/tjetc/dao/ChargingStationsMapper.java`
- `backend/user/src/main/java/com/tjetc/service/service/coreFunction/ChargingStationSelectService.java`
- `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingStationSelectServiceImpl.java`

**用户端前端页面**：
- `frontend/src/views/user/ChargingStationsView.vue` — 充电站列表
- `frontend/src/views/user/ChargingDetailView.vue` — 充电站详情

### 2.2 管理端 — 充电桩管理

**职责边界**：充电桩 CRUD、分页查询、状态切换

**涉及数据库表**：`charging_stations`

**入口文件**：
- `backend/admin/src/main/java/com/tjetc/controller/ChargingStationController.java` — 完整 CRUD + 分页
- `backend/admin/src/main/java/com/tjetc/controller/ChargingPileController.java` — 功能重叠的旧 Controller（兼容旧前端）

**管理员前端页面**：`admin-frontend/src/views/StationManagement.vue`

**后端依赖**：
- `backend/admin/src/main/java/com/tjetc/service/ChargingStationService.java` + 实现

---

## 模块 3：充电与订单

### 3.1 用户端 — 开始充电

**职责边界**：用户启动充电流程

**入口文件**：
- `backend/user/src/main/java/com/tjetc/controller/CoreFunctionController/ChargingStationUseController.java`
  - `POST /user/charging/start` — 开始充电

**核心实现**：
- `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingStationUseServiceImpl.java`
  - `useChargingStation()`：CAS 条件更新充电桩状态 → 创建订单 → 启动异步计时
- `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingAsyncService.java`
  - `startChargingTimer()`：@Async 异步方法，创建订单 → Redis ZSET → Thread.sleep → 完成充电
  - `startReserveTimer()`：预约版，先 delay → 再充电
- `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingTimerScheduler.java`
  - `scanExpiredChargingOrders()`：每 30 秒兜底扫描 ZSET

### 3.2 用户端 — 订单查询

**入口文件**：
- `backend/user/src/main/java/com/tjetc/controller/CoreFunctionController/OrderController.java`
  - `POST /order/listByUserId` — 根据用户 ID 查订单
- `backend/user/src/main/java/com/tjetc/controller/CoreFunctionController/ChargingStationOrderSelectController.java`
  - `POST /api/selectAll` — 查用户所有订单

### 3.3 管理端 — 订单管理

**入口文件**：`backend/admin/src/main/java/com/tjetc/controller/OrderController.java`

| 接口 | 方法 | 说明 |
|------|------|------|
| `/order/list` | GET | 全部订单 |
| `/order/add` | POST | 新增订单 |
| `/order/page/payment-status` | POST | 按支付状态分页 |
| `/order/page/user` | POST | 按用户 ID 分页 |
| `/order/page/station` | POST | 按充电桩 ID 分页 |
| `/order/count/time-range` | POST | 按时间范围统计 |
| `/order/detail/{id}` | GET | 订单详情 |
| `/order/delete/{id}` | DELETE | 删除订单 |

**管理员前端页面**：`admin-frontend/src/views/OrderManagement.vue`

---

## 模块 4：预约

### 用户端 — 充电桩预约

**职责边界**：预约充电桩、查看预约记录

**涉及数据库表**：`reservations`

**入口文件**：
- `backend/user/src/main/java/com/tjetc/controller/CoreFunctionController/ChargingStationsReversationController.java`
  - `POST /reversation/reserve` — 预约充电桩
  - `POST /reversation/getUserReservations` — 用户预约记录
  - `POST /reversation/getStationReservations` — 充电桩预约情况

**核心实现**：`ChargingStationsReversationServiceImpl.java`
- `reserveCharging()`：检查参数 → 查充电桩是否存在 → 检查状态 → 创建预约记录 → 更新充电桩状态为 occupied → 启动异步预约计时

### 管理端 — 预约管理

**入口文件**：`backend/admin/src/main/java/com/tjetc/controller/ReservationController.java`

| 接口 | 方法 | 说明 |
|------|------|------|
| `/reservation/all` | GET | 全部预约 |
| `/reservation/add` | POST | 新增预约 |
| `/reservation/page/status` | POST | 按状态分页 |
| `/reservation/page/user` | POST | 按用户分页 |
| `/reservation/page/station` | POST | 按充电桩分页 |
| `/reservation/time-range` | POST | 按时间范围查重叠预约 |
| `/reservation/{id}` | GET | 预约详情 |
| `/reservation/status` | PUT | 更新预约状态 |
| `/reservation/{id}` | DELETE | 删除预约 |

**管理员前端页面**：`admin-frontend/src/views/ReservationManagement.vue`

---

## 模块 5：支付

### 管理端 — 支付记录管理

**涉及数据库表**：`payments`

**入口文件**：`backend/admin/src/main/java/com/tjetc/controller/PaymentsController.java`

| 接口 | 方法 | 说明 |
|------|------|------|
| `/payments/all` | GET | 全部支付记录 |
| `/payments/add` | POST | 新增支付记录 |
| `/payments/order/{orderId}` | GET | 按订单查支付记录 |
| `/payments/page/status` | POST | 按支付状态分页 |
| `/payments/page/method` | POST | 按支付方式分页 |
| `/payments/{id}` | GET | 支付详情 |
| `/payments/update/status-time` | PUT | 更新支付状态和时间 |
| `/payments/{id}` | DELETE | 删除支付记录 |

**管理员前端页面**：`admin-frontend/src/views/PaymentManagement.vue`

---

## 模块 6：新闻

### 用户端 — 新闻查看

**入口文件**：`backend/user/src/main/java/com/tjetc/controller/news/NewsController.java`

**依赖**：`backend/user/src/main/java/com/tjetc/service/service/news/NewsService.java` + `NewsServiceImpl.java`

**用户端前端页面**：`frontend/src/views/user/NewsView.vue`

### 管理端 — 新闻管理

**入口文件**：`backend/admin/src/main/java/com/tjetc/controller/news/NewsController.java`

| 接口 | 方法 | 说明 |
|------|------|------|
| `/news/publish` | POST | 发布新闻 |
| `/news/update` | POST | 更新新闻 |
| `/news/delete` | POST | 删除新闻 |
| `/news/detail` | POST | 新闻详情 |
| `/news/list` | POST | 分页新闻列表 |

**管理员前端页面**：`admin-frontend/src/views/NewsManagement.vue`

---

## 模块 7：充电监控

### 用户端 — 充电状态监控

**入口文件**：`backend/user/src/main/java/com/tjetc/controller/charge/ChargeMonitorController.java`

| 接口 | 方法 | 说明 |
|------|------|------|
| `/api/charge-monitor/user/current-status` | POST | 当前充电状态 |
| `/api/charge-monitor/user/history` | POST | 充电历史记录 |
| `/api/charge-monitor/user/current-reservation` | POST | 当前预约信息 |
| `/api/charge-monitor/user/statistics` | POST | 充电统计数据 |
| `/api/charge-monitor/stations/nearby` | POST | 附近充电桩（返回 null ⚠️） |

**依赖**：`ChargeMonitorServiceImpl.java`

---

## 模块 8：系统管理

### 管理端 — 系统设置

**管理员前端页面**：`admin-frontend/src/views/AdminSettings.vue`（管理员个人信息、密码修改）

### 系统日志

**涉及数据库表**：`system_logs`

**入口文件**：
- `backend/admin/src/main/java/com/tjetc/service/SystemLogService.java`
- `backend/common/src/main/java/com/tjetc/entity/core/SystemLog.java`

---

## 模块 9：文件上传

### 公共上传

**入口文件**：`backend/admin/src/main/java/com/tjetc/controller/UploadController.java`
| 接口 | 说明 |
|------|------|
| `POST /upload/file` | 上传文件（word/pdf 等） |
| `POST /upload/image` | 上传图片 |
| `POST /upload/video` | 上传视频 |

**核心工具**：`backend/common/src/main/java/com/tjetc/common/FileUploadUtils.java`
- 双校验（扩展名白名单 + MIME 类型校验）
- UUID 重命名防冲突
- 按日期分目录存储

---

## 模块 10：前端公共

### 手部追踪粒子特效组件

| 文件 | 说明 |
|------|------|
| `frontend/src/components/HandParticleCanvas.vue` | 用户端粒子特效 |
| `admin-frontend/src/components/HandParticleCanvas.vue` | 管理端粒子特效 |
| (两者功能相同，实现略异) | 3000 Three.js 粒子 + MediaPipe Hands 手部追踪 |

### 用户端公共组件

| 文件 | 说明 |
|------|------|
| `Header.vue` | 顶部导航 |
| `UserHeader.vue` | 用户端头部 |
| `Footer.vue` | 底部 |
| `PasswordInput.vue` | 密码输入组件 |
| `StationOverview.vue` | 充电站概览卡片 |
| `StationStatusCard.vue` | 充电站状态卡片 |

### 管理端公共组件

| 文件 | 说明 |
|------|------|
| `AdminHeader.vue` | 管理端头部 |
| `AdminSidebar.vue` | 侧边栏导航 |
| `AdminLayout.vue` | 主布局容器 |

---

## 附录：模块—文件对照总表

| 模块 | Controller 文件 | Service 文件 | 前端页面 |
|------|----------------|-------------|---------|
| 用户登录注册 | `user/.../LoginController.java`、`RegisterController.java` | `UserLoginServiceImpl`、`UserRegisterServiceImpl` | `UserLogin.vue`、`UserRegister.vue` |
| 用户个人信息 | `user/.../SelectOwnMessageController.java`、`UpdateOwnMessageController.java` | `SelectOwnMessageService`、`UpdateOwnerServiceImpl` | `ProfileView.vue` |
| 管理员管理 | `admin/AdminController.java`、`LoginController.java` | `AdminServiceImpl` | `AdminSettings.vue` |
| 充电桩查询 | `user/.../ChargingStationsSelectController.java` | `ChargingStationSelectServiceImpl` | `ChargingStationsView.vue`、`ChargingDetailView.vue` |
| 充电桩管理 | `admin/ChargingStationController.java`、`ChargingPileController.java` | `ChargingStationServiceImpl` | `StationManagement.vue` |
| 开始充电 | `user/.../ChargingStationUseController.java` | `ChargingStationUseServiceImpl`、`ChargingAsyncService`、`ChargingTimerScheduler` | `UseChargerView.vue`、`ChargingServiceOptions.vue` |
| 充电监控 | `user/charge/ChargeMonitorController.java` | `ChargeMonitorServiceImpl` | `UserDashboard.vue`、`HistoryView.vue` |
| 订单(用户端) | `user/.../OrderController.java`、`ChargingStationOrderSelectController.java` | `ChargingStationOrderServiceImpl`、`ChargingStationOrderSelect` | `BookingView.vue`、`BookingDetailView.vue` |
| 订单(管理端) | `admin/OrderController.java` | `OrderServiceImpl` | `OrderManagement.vue` |
| 预约(用户端) | `user/.../ChargingStationsReversationController.java` | `ChargingStationsReversationServiceImpl` | 同上 BookingView |
| 预约(管理端) | `admin/ReservationController.java` | `...Service` | `ReservationManagement.vue` |
| 支付管理 | `admin/PaymentsController.java` | `PaymentsServiceImpl` | `PaymentManagement.vue` |
| 新闻(用户端) | `user/news/NewsController.java` | `NewsServiceImpl` | `NewsView.vue` |
| 新闻(管理端) | `admin/news/NewsController.java` | `NewsService (admin)` | `NewsManagement.vue` |
| 文件上传 | `admin/UploadController.java` | `FileUploadUtils` | — |
| 系统日志 | — | `SystemLogServiceImpl` | — |
| 仪表盘 | — | — | `UserDashboard.vue`、`AdminDashboard.vue` |
| 欢迎页 | — | — | `welcome.vue` |

> 来源：全部 Controller 类（`backend/admin/src/main/java/com/tjetc/controller/`、`backend/user/src/main/java/com/tjetc/controller/`）、全部 Service 实现、全部前端页面文件
