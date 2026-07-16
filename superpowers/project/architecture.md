# 架构设计

## 项目类型定位

**前后端分离的 Web 应用 + 移动端扩展**

- 后端：多模块 Spring Boot 单体应用，以 RESTful JSON API 提供业务能力
- 前端：两个独立的 Vue 3 SPA（用户端/管理端）
- 移动端：HarmonyOS (ArkTS) 原生应用
- 核心特性：充电计时、JWT 双 Token 认证、Redis ZSET 持久化、手部追踪粒子特效（前端）

## 架构风格总览

```
┌─────────────────────────────────────────────────────────┐
│                   客户端层 (Client Layer)                 │
│                                                         │
│  ┌──────────────────┐  ┌──────────────────┐            │
│  │ 用户端前端         │  │ 管理端前端        │           │
│  │ Vue 3 + TS        │  │ Vue 3 + TS       │           │
│  │ 端口 8888         │  │ 端口 9999        │           │
│  │ Three.js 粒子特效 │  │ Three.js 粒子特效 │           │
│  └───────┬──────────┘  └───────┬──────────┘            │
│          │                     │                        │
│          ▼                     ▼                        │
│  ┌─────────────────────────────────────────────────┐   │
│  │           代理层 (Vite Proxy)                     │   │
│  │  /user-api → localhost:8080/user               │   │
│  │  /api → localhost:8080                          │   │
│  │  /admin-api → localhost:8081/admin              │   │
│  │  ...                                            │   │
│  └────────────────────────┬────────────────────────┘   │
└───────────────────────────┼────────────────────────────┘
                           │
    HTTP (JSON)            │
    Token in Header        │
                           │
┌──────────────────────────▼──────────────────────────────┐
│                   后端 REST API 层                        │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │          Spring Boot Application                │   │
│  │                                                 │   │
│  │  ┌────────────────┐  ┌────────────────┐        │   │
│  │  │   user 模块     │  │   admin 模块    │        │   │
│  │  │   端口 8080     │  │   端口 8081     │        │   │
│  │  │   /user         │  │   /admin/...   │        │   │
│  │  │   /api/...      │  │                │        │   │
│  │  │   /reversation  │  │                │        │   │
│  │  └───────┬─────────┘  └───────┬────────┘        │   │
│  └──────────┼────────────────────┼──────────────────┘   │
└─────────────┼────────────────────┼──────────────────────┘
              │                    │
              ▼                    ▼
┌─────────────────────────────────────────────────────────┐
│                   公共模块 (common)                        │
│  Entity  │  DTO  │  Mapper  │  Utils  │  Config          │
│  (core + userAndAdmin)         (JWT,JsonResult,File...) │
└─────────────────────────┬───────────────────────────────┘
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
┌──────────────────┐  ┌──────────────────────────────┐
│    MySQL 8.0     │  │          Redis                │
│ campus_charging  │  │   Database 1 (admin 模块)     │
│   _station       │  │   Database 3 (user 模块)      │
│  16 张表         │  │   Key: charging:timers (ZSET) │
└──────────────────┘  └──────────────────────────────┘
```

### 跨端共享

```
HarmonyOS App (ArkTS)
  ── HTTP ──► user 模块 (8080) ── MySQL + Redis
```

## 代码分层与模块组织

### backend — 后端 Maven 多模块

```
backend/
├── pom.xml                          # 父 POM：统一依赖版本管理
├── common/                          # ===== 公共模块 =====
│   ├── entity/core/                 # 核心业务实体
│   │   ├── ChargingStation.java     # 充电桩
│   │   ├── Orders.java              # 订单
│   │   ├── Payments.java            # 支付记录
│   │   ├── Reservation.java         # 预约
│   │   ├── News.java                # 新闻
│   │   └── SystemLog.java           # 系统日志
│   ├── entity/userAndAdmin/
│   │   ├── User.java                # 用户（数据库表 users）
│   │   └── Admin.java               # 管理员
│   ├── dao/                         # MyBatis-Plus Mapper 接口
│   ├── dto/                         # 数据传输对象（~50 个）
│   ├── common/                      # 工具类
│   │   ├── JsonResult.java          # 统一 JSON 响应
│   │   ├── JwtTokenUtil.java        # JWT 令牌工具
│   │   ├── FileUploadUtils.java     # 文件上传工具（含安全校验）
│   │   ├── PasswordUtils.java       # 密码工具
│   │   ├── AuthUtils.java           # 认证工具
│   │   └── UserContext.java         # 用户上下文（ThreadLocal）
│   └── config/
│       ├── JwtTokenInitializer.java  # JWT 密钥初始化
│       └── PasswordEncoderConfig.java # BCrypt 密码编码器
│
├── admin/                           # ===== 管理端 API =====
│   ├── config/
│   │   └── LoginInterceptorConfig.java # 拦截器注册
│   ├── interceptor/
│   │   └── LoginInterceptor.java    # Token 验证拦截器
│   ├── controller/                  # 8 个 Controller
│   │   ├── LoginController.java     # 管理员登录 + Token 刷新
│   │   ├── AdminController.java     # 管理员 CRUD
│   │   ├── UserController.java      # 用户管理 CRUD
│   │   ├── ChargingStationController.java # 充电桩管理
│   │   ├── ChargingPileController.java    # 充电桩管理（兼容前端旧接口）
│   │   ├── OrderController.java     # 订单管理
│   │   ├── PaymentsController.java  # 支付记录管理
│   │   ├── ReservationController.java # 预约管理
│   │   ├── UploadController.java    # 文件上传
│   │   └── GlobalAdviceController.java # 全局异常处理
│   └── service/                     # 服务层（8 个接口 + 实现）
│
└── user/                            # ===== 用户端 API =====
    ├── config/
    │   ├── LoginInterceptorConfig.java
    │   ├── RedisConfig.java
    │   └── SwaggerConfig.java
    ├── interceptor/
    │   └── LoginInterceptor.java    # Token 验证（含 OPTIONS 放行）
    ├── controller/                  # 按功能分包
    │   ├── userFunctionController/  # 登录、注册、查询、更新
    │   ├── CoreFunctionController/  # 充电桩查询、使用、预约、订单
    │   ├── charge/                  # 充电监控
    │   └── news/                    # 新闻
    └── service/                     # 服务层
        └── Impl/coreFunctionImpl/
            ├── ChargingAsyncService.java    # 异步充电计时
            ├── ChargingTimerScheduler.java  # 充电计时兜底定时任务 @Scheduled
            └── ...                          # 其余实现
```

### frontend — 用户端前端

```
src/
├── api/             # API 接口封装（5 个模块）
│   ├── user.ts           # 登录、注册、个人信息
│   ├── charging.ts       # 充电桩查询
│   ├── chargingStationsApi.ts  # 充电桩 + 充电 + 预约 + 历史
│   ├── news.ts           # 新闻
│   └── upload.ts         # 文件上传
├── components/      # 公共组件（6 个）
├── router/          # 路由（12 条路由）
├── stores/          # Pinia 状态管理（user store）
├── utils/           # axios 封装（响应拦截器处理 Token 过期）
├── viewmodel/       # TS 类型定义
└── views/           # 12 个页面
```

### admin-frontend — 管理端前端

```
src/
├── components/      # 公共组件（3 个）
├── layouts/         # AdminLayout 布局
├── router/          # 路由（8 条，含路由守卫）
├── stores/          # Pinia 状态管理（含 refreshToken）
├── utils/           # axios 封装（含 Token 自动刷新机制）
└── views/           # 8 个管理页面
```

## 请求/数据全链路

### 典型操作：用户端「开始充电」

```
1. 用户端前端                           2. Vite Proxy                   3. user 模块 (8080)
   ─────────────────                   ──────────────────              ─────────────────────
                                                                       
   用户点击"开始充电"                     /user/charging/start           ChargingStationUseController
   → chargingStationsApi.ts                                                .start(request)
     startCharging(userId,                                                  ↓
       stationId, duration)                                          ChargingStationUseServiceImpl
     → axios POST                                                          .useChargingStation()
       /user/charging/start          ────→  proxy to                       ↓
       headers: {token}                     http://localhost:8080   ① CAS 条件更新:
                                            /user/charging/start    UPDATE charging_stations
                                                                     SET status='occupied'
                                                                     WHERE station_id=? AND status='available'
                                                                     ↓
                                                                  ② ChargingAsyncService.startChargingTimer()
                                                                     (异步 @Async)
                                                                     ├─ 创建订单 (INSERT INTO orders)
                                                                     ├─ 写入 Redis ZSET charging:timers
                                                                     ├─ Thread.sleep(充电时长)
                                                                     └─ 完成充电:
                                                                        UPDATE orders SET status='completed'
                                                                        UPDATE charging_stations SET status='available'
                                                                     ↓
                                                                  ③ ChargingTimerScheduler
                                                                     每 30s 扫描 ZSET 兜底
                                                                     
   返回 JsonResult {                    ←──  ←──  ←──  ←──   ←──  返回 {state:0, data: "开始充电成功"}
     state:0,
     message: "开始充电成功"
   }
```

### 典型操作：管理员「分页查询充电桩」

```
1. admin-frontend                   2. Vite Proxy                   3. admin 模块 (8081)
   ─────────────────               ──────────────────              ─────────────────────
   
   AdminDashboard 页面                /admin-api/chargingStation     ChargingStationController
   → 调用接口                          /page                          .findPage(request)
   axios POST                                                         ↓
     /admin-api/chargingStation   ───→  proxy (strip /admin-api)  ChargingStationServiceImpl.findPage()
     /page                              →                            ├─ PageHelper.startPage()
     body: {pageNum, pageSize,          http://localhost:8081         ├─ chargingStationsMapper
       stationName}                     /chargingStation/page          .selectLikeName(name)
     headers: {token}                                                 └─ new PageInfo<>(list)
                                                                    ↓
   返回 JsonResult {                    ←──  ←──  ←──  ←──   ←──  PageInfo 分页数据
     state:0,
     data: {list, total, pages...}
   }
```

## 模块依赖关系图

```
                ┌───────────────────┐
                │   admin 模块       │
                │   (端口 8081)     │
                └────────┬──────────┘
                         │ depends on
                         ▼
                ┌───────────────────┐
                │   common 模块      │
                │   (公共实体/工具)   │
                └────────┬──────────┘
                         │ depends on
                         ▼
                ┌───────────────────┐
                │   user 模块        │
                │   (端口 8080)     │ ──── Redis
                └───────────────────┘

   frontend ──► user 模块 (8080)          admin-frontend ──► admin 模块 (8081)
   用户端 SPA          │                   管理端 SPA              │
                      │                                            │
                      ▼                                            ▼
                  MySQL 8.0                                    MySQL 8.0
                  Redis DB 3                                   Redis DB 1
```

## 鉴权与安全

### 登录流程

```
  ┌──────┐          ┌──────────┐            ┌────────┐
  │ 前端  │          │ 后端      │            │ Redis  │
  │      │  POST    │          │            │ (暂未  │
  │      │  login   │          │            │  使用) │
  │      │ ────────►│          │            │        │
  │      │          │ 校验密码  │            │        │
  │      │          │ (BCrypt) │            │        │
  │      │          │          │            │        │
  │      │ ◄────────│ 返回     │            │        │
  │      │  token   │ token +  │            │        │
  │      │  +       │ refresh  │            │        │
  │      │  admin   │ Token    │            │        │
  └──────┘          └──────────┘            └────────┘
```

### Token 策略

| 类型 | 有效期 | 用途 | 来源 |
|------|--------|------|------|
| Access Token | 30 分钟 | 每次 API 请求携带在 Header `token` 中 | `JwtTokenUtil.generateToken()` |
| Refresh Token | 7 天 | 过期时获取新的 Access Token | `JwtTokenUtil.generateRefreshToken()` |

- 管理端前端实现了 Token 自动刷新机制（`admin-frontend/src/utils/request.ts:56-61`）：当收到 `state === -1` 时，自动使用 Refresh Token 获取新 Token，期间排队中的请求自动重放。
- 用户端前端未实现自动刷新，收到 `state === -1` 时直接弹出"登录过期"提示并跳转登录页（`frontend/src/utils/request.ts:121-140`）。
- 两个后端模块各自有独立的 `LoginInterceptor`，对所有非公开路径进行 Token 校验。

### 权限控制

- 前端：通过路由守卫 (`router.beforeEach`) 控制页面访问，未登录重定向到登录页
- 后端：通过拦截器校验 Token，但**未实现基于角色的细粒度权限控制**（RBAC），所有已认证用户拥有相同权限
- admin 模块公开路径：`/admin/login`、`/admin/refresh`、静态资源、Swagger 路径
- user 模块公开路径：`/user/login`、`/user/refresh`、`/user/register`、静态资源、Swagger 路径

## 横切关注点

### 异常处理

`GlobalAdviceController`（admin 端）+ user 端的注解处理器，捕获 `Exception.class`，返回统一 `JsonResult.fail("出错了，请联系管理员")`。

### 日志

- 后端：SLF4J + Logback，控制台输出 SQL 日志 (`mybatis-plus.configuration.log-impl: StdOutImpl`)
- 文件日志路径由 `LOG_PATH` 环境变量控制

### 文件上传

- `FileUploadUtils`：带白名单校验（扩展名 + MIME 类型双重验证）
- 按日期分目录存储（`/image/20260101/uuid.jpg`）
- 限制：图片 10MB、视频 100MB、音频 20MB
- 防路径遍历：净化文件名、UUID 重命名

### 事务

- `AdminServiceImpl.add()` 使用 `@Transactional`，遇到 RuntimeException 回滚
- `PaymentsServiceImpl.add()`、`updatePaymentStatusAndTime()`、`deleteById()` 使用 `@Transactional`

### 定时任务

`ChargingTimerScheduler` 每 30 秒扫描 Redis ZSET `charging:timers`，自动完成超时订单（`ChargingTimerScheduler.java:45-87`）。

### 异步执行

`ChargingAsyncService` 使用 `@Async` 实现充电计时（`ChargingAsyncService.java:45-46`）。

### 统一响应格式

所有 API 返回 `JsonResult<T>`：
```json
{"state": 0, "message": null, "data": {...}}
```
- `state: 0` — 成功
- `state: 1` (或 >0) — 业务错误
- `state: -1` — 未登录/登录过期

### 跨域

前后端通过 Vite Proxy 代理，未在后端配置 CORS。前端访问同源地址，由 Proxy 转发到后端。

## 数据流 / 状态管理

### 用户端前端状态管理

`Pinia` + `pinia-plugin-persistedstate`：
- `stores/user.ts`：`token`、`user`（用户信息）
- 持久化到 localStorage

### 管理端前端状态管理

`Pinia` + `pinia-plugin-persistedstate`：
- `stores/admin.ts`：`token`、`refreshToken`、`admin`（管理员信息）、`sidebarCollapsed`（侧边栏状态）
- 持久化到 localStorage

### 后端上下文

`UserContext` 基于 `ThreadLocal`，拦截器解析 Token 后存入用户信息，请求完成时清除。

## 已知架构风险与技术债

| 风险 | 现象 | 影响 | 相关文件 | 严重度 |
|------|------|------|----------|--------|
| 密码明文硬编码 | SQL 初始数据中 `123456` 为明文 | 生产环境安全风险 | `docs/数据库.md.md:33-35,149-151` | **高** |
| 无 RBAC 权限控制 | 任何已认证用户都可调任意 API | 权限越权风险 | `LoginInterceptor.java` | **高** |
| getNearbyStations 返回 null | 无地理坐标字段，方法返回 null | 附近站点功能不可用 | `ChargeMonitorServiceImpl.java:78` | **高** |
| 密码明文硬编码（前端） | 初始密码在初始数据中明文 | 安全风险 | 数据库初始化 SQL | **高** |
| 无敏感信息脱敏 | 订单列表接口返回全部字段 | 信息泄露风险 | `OrderServiceImpl` | **中** |
| Thread.sleep 阻塞线程 | 充电计时使用 `Thread.sleep` | 长时间占用线程池资源 | `ChargingAsyncService.java` | **中** |
| 事务使用不一致 | 部分 Service 有 `@Transactional`，部分没有 | 数据一致性隐患 | 各 `*ServiceImpl.java` | **中** |
| 密码自动迁移 | 明文密码运行时自动 BCrypt 编码 | 纯明文首次登录后写入加密密码 | `AdminServiceImpl.java:173-176` | **低** |
| 重复 Controller | `ChargingStationController` 和 `ChargingPileController` 功能重叠 | 维护混淆 | `admin/controller/` | **低** |
| 前端接口地址不一致 | `user.ts` 和 `chargingStationsApi.ts` 使用不同 baseURL | 调试困难 | `frontend/src/api/user.ts:7` vs `chargingStationsApi.ts:4` | **低** |
| SQL 包含中文注释 | 建表语句含中文 | 部分工具链解析可能出错 | `docs/数据库.md.md` | **低** |

## 扩展点说明

| 扩展点 | 说明 |
|--------|------|
| 新增充电桩类型 | `ChargingStation.java` 实体 + DTO + Service 层扩展 |
| 新增支付方式 | `Payments.java` 的 `payments_method` 枚举扩展 + 前端选择组件 |
| 积分商城完整上线 | 数据库表已建（goods_items、goods_orders、coupon_template 等），后端接口和前端页面待实现 |
| 第三方支付集成 | `Payments.java` 已有 `transaction_id` 字段预留 |
| 附近充电站功能 | 需在 `charging_stations` 表增加 `latitude`/`longitude` 字段 |
| 鸿蒙端全功能 | 后端接口已完备，前端页面需对接 |
| Redis 缓存层 | Redis 连接已配置，当前仅用于充电计时 ZSET |

> 来源：各模块入口文件（`AdminApplication.java`、`UserApplication.java`）、`backend/pom.xml:1-128`、全部 Controller 文件、全部 Service 实现文件
