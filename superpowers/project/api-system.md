# 接口清单

> 本项目有明确的前后端分离架构，包含用户端 API（user 模块，8080 端口）和管理端 API（admin 模块，8081 端口）。
> 两个模块共享公共实体和 DTO（common 模块）。前端通过 Vite Proxy 代理跨域请求。

---

## 一、统一响应格式

所有 API 返回 `JsonResult<T>` 格式：

```json
{
  "state": 0,        // 0=成功, >0=业务错误, -1=未登录/登录过期
  "message": null,   // 错误时携带提示信息
  "data": {}         // 成功时携带业务数据
}
```

## 二、全局异常处理

`GlobalAdviceController`（admin 端 + user 端）拦截所有 `Exception.class`，返回 `{state:1, message:"出错了，请联系管理员", data:null}`。

## 三、鉴权说明

### 需要 Token 的路径

所有路径默认需 Token，Token 放在 HTTP Header `token` 字段中。

### 公开路径（无需 Token）

**admin 模块（8081）**：
```
/admin/login
/admin/refresh
/image/**
/video/**
/error
/**/*.js, /**/*.css, /**/*.html
/favicon.ico
/v3/api-docs, /v3/api-docs/**
/swagger-ui.html, /swagger-ui/**
```

**user 模块（8080）**：
```
/user/login
/user/refresh
/user/register
/error
/image/**
/video/**
/**/*.js, /**/*.css, /**/*.html
/favicon.ico
/v3/api-docs, /v3/api-docs/**
/swagger-ui.html, /swagger-ui/**
```

---

## 四、用户端 API (user 模块 — 端口 8080)

### 4.1 用户功能

#### 用户登录
- **接口**：`POST /user/login`
- **Request Body**：`LoginDTO {username, password}`
- **Response**：`{state:0, data: {token, user: {id, username, avatarPath...}}}`
- **源代码**：`LoginController.java:30-31`、`UserLoginServiceImpl.java`

#### 用户注册
- **接口**：`POST /user/register`
- **Request Body**：`UserRegisterDTO {username, password, email, phone, userType}`
- **Response**：`{state:0}` 或错误提示
- **源代码**：`RegisterController.java:24-34`

#### 查询个人信息
- **接口**：`POST /user/selectOwnMessage`
- **Request Body**：`SelectOwnMessageDTO {username}`
- **Response**：脱敏后的用户信息
- **源代码**：`SelectOwnMessageController.java:22-24`

#### 更新个人信息
- **接口**：`POST /user/updateOwnMessage`
- **Request Body**：`UserUpdateDTO {userId, username, password, avatarPath, email, phone, userType}`
- **Response**：操作结果
- **源代码**：`UpdateOwnMessageController.java:20-24`

### 4.2 充电桩查询

#### 查询所有充电桩
- **接口**：`GET /api/showAll`
- **Response**：`ChargingStation[]`
- **源代码**：`ChargingStationsSelectController.java:37-43`

#### 按位置查询充电桩
- **接口**：`POST /api/showByLocation`
- **Request Body**：`ChargingStationLocationDTO {location}`
- **Response**：`ChargingStation[]`
- **源代码**：`ChargingStationsSelectController.java:49-54`

#### 按状态查询充电桩
- **接口**：`POST /api/showByStatus`
- **Request Body**：`ChargingStationStatusDTO {status}`
- **Response**：`ChargingStation[]`
- **源代码**：`ChargingStationsSelectController.java:61-66`

### 4.3 充电使用

#### 开始充电
- **接口**：`POST /user/charging/start`
- **Request Body**：`StartChargingDTO {userId, stationId, chargingDuration}`
- **Response**：`"开始充电成功"`
- **源代码**：`ChargingStationUseController.java:21-33`、`ChargingStationUseServiceImpl.java:28-54`

### 4.4 预约

#### 预约充电桩
- **接口**：`POST /reversation/reserve`
- **Request Body**：`ReserveChargingDTO {userId, stationId, delayMinutes, chargingDuration}`
- **Response**：`"预约成功，将在N分钟后开始充电"`
- **源代码**：`ChargingStationsReversationController.java:22-31`

#### 获取用户预约记录
- **接口**：`POST /reversation/getUserReservations`
- **Request Body**：`UserReservationsDTO {userId}`
- **Response**：`Reservation[]`
- **源代码**：`ChargingStationsReversationController.java:33-37`

#### 获取充电桩预约情况
- **接口**：`POST /reversation/getStationReservations`
- **Request Body**：`StationReservationsDTO {stationId}`
- **Response**：`Reservation[]`
- **源代码**：`ChargingStationsReversationController.java:39-43`

### 4.5 订单

#### 查询用户所有订单
- **接口**：`POST /api/selectAll`
- **Request Body**：`OrderSelectDTO {userId}`
- **Response**：`Orders[]`（含 AuthUtils 用户身份校验）
- **源代码**：`ChargingStationOrderSelectController.java:36-46`

#### 根据用户ID查询订单列表
- **接口**：`POST /order/listByUserId`
- **Request Body**：`OrderListByUserDTO {userId}`
- **Response**：`Orders[]`
- **源代码**：`CoreFunctionController/OrderController.java:31-34`

### 4.6 充电监控

#### 获取用户当前充电状态
- **接口**：`POST /api/charge-monitor/user/current-status`
- **Request Body**：`UserIdDTO {userId}`
- **Response**：`{isCharging, reservation, stationId, startTime, estimatedEndTime}`
- **源代码**：`ChargeMonitorController.java:27-30`

#### 获取用户充电历史记录
- **接口**：`POST /api/charge-monitor/user/history`
- **Request Body**：`UserIdDTO {userId}`
- **Response**：`Orders[]`
- **源代码**：`ChargeMonitorController.java:33-36`

#### 获取用户当前预约信息
- **接口**：`POST /api/charge-monitor/user/current-reservation`
- **Request Body**：`UserIdDTO {userId}`
- **Response**：`Reservation`
- **源代码**：`ChargeMonitorController.java:39-42`

#### 获取充电统计数据
- **接口**：`POST /api/charge-monitor/user/statistics`
- **Request Body**：`UserIdDTO {userId}`
- **Response**：`{totalSessions, totalMinutes, totalHours, totalAmount}`
- **源代码**：`ChargeMonitorController.java:46-50`

#### 获取附近充电桩
- **接口**：`POST /api/charge-monitor/stations/nearby`
- **Request Body**：`NearbyStationsDTO {latitude, longitude, radius}`
- **Response**：⚠️ **当前返回 null**（无地理位置字段）
- **源代码**：`ChargeMonitorController.java:54-61`

### 4.7 新闻

#### 获取新闻列表/详情
- **接口**：`POST /user/news/...`
- **源代码**：`user/controller/news/NewsController.java`

---

## 五、管理端 API (admin 模块 — 端口 8081)

> 所有接口通过 Vite Proxy `/admin-api/*` → `http://localhost:8081/*`
> 注：`ChargingStationController` 和 `ChargingPileController` 功能重叠，均操作 `charging_stations` 表。

### 5.1 管理员登录

#### 管理员登录
- **接口**：`POST /admin/login`
- **Request Body**：`AdminLoginDTO {username, password}`
- **Response**：`{token, refreshToken, admin}`
- **源代码**：`LoginController.java:26-31`

#### 刷新 Token
- **接口**：`POST /admin/refresh`
- **Request Body**：`{refreshToken}`
- **Response**：新的 `{token, refreshToken, admin}`
- **源代码**：`LoginController.java:33-39`

### 5.2 管理员 CRUD

#### 查询管理员列表
- **接口**：`GET /admin/list`
- **Response**：`AdminDTO[]`
- **源代码**：`AdminController.java:30-34`

#### 新增管理员
- **接口**：`POST /admin/add`
- **Request Body**：`AdminDTO`
- **源代码**：`AdminController.java:40-44`

#### 管理员分页查询
- **接口**：`POST /admin/page`
- **Request Body**：`AdminPageDTO {pageNum, pageSize, username}`
- **源代码**：`AdminController.java:50-58`

#### 校验用户名存在
- **接口**：`POST /admin/check-exist`
- **Request Body**：`AdminCheckExistDTO {username}`
- **源代码**：`AdminController.java:64-68`

#### 管理员详情
- **接口**：`POST /admin/detail`
- **Request Body**：`AdminIdDTO {id}`
- **源代码**：`AdminController.java:74-78`

#### 修改管理员
- **接口**：`PUT /admin/update`
- **Request Body**：`AdminDTO`
- **源代码**：`AdminController.java:84-88`

#### 删除管理员
- **接口**：`POST /admin/delete`
- **Request Body**：`AdminIdDTO {id}`
- **源代码**：`AdminController.java:94-98`

### 5.3 用户管理（管理员视角）

#### 查询所有用户
- **接口**：`GET /user/all`
- **源代码**：`UserController.java:33-37`

#### 新增用户
- **接口**：`POST /user/add`
- **Request Body**：`UserDTO`
- **源代码**：`UserController.java:46-50`

#### 分页查询用户
- **接口**：`POST /user/page`
- **Request Body**：`UserPageDTO {pageNum, pageSize, username}`
- **源代码**：`UserController.java:59-65`

#### 按ID查询用户
- **接口**：`GET /user/{id}`
- **源代码**：`UserController.java:75-79`

#### 更新用户
- **接口**：`PUT /user/update`
- **Request Body**：`UserDTO`
- **源代码**：`UserController.java:88-93`

#### 删除用户
- **接口**：`DELETE /user/delete/{id}`
- **源代码**：`UserController.java:101-106`

### 5.4 充电桩管理

#### 查询所有充电桩
- **接口**：`GET /chargingStation/all`
- **源代码**：`ChargingStationController.java:32-36`

#### 分页查询充电桩
- **接口**：`POST /chargingStation/page`
- **Request Body**：`ChargingStationPageDTO {pageNum, pageSize, stationName}`
- **源代码**：`ChargingStationController.java:43-51`

#### 新增充电桩
- **接口**：`POST /chargingStation/add`
- **Request Body**：`ChargingStationDTO`
- **源代码**：`ChargingStationController.java:58-63`

#### 更新充电桩
- **接口**：`POST /chargingStation/update`
- **Request Body**：`ChargingStationDTO`
- **源代码**：`ChargingStationController.java:70-75`

#### 删除充电桩
- **接口**：`POST /chargingStation/delete/{stationId}`
- **源代码**：`ChargingStationController.java:82-87`

#### 充电桩详情
- **接口**：`GET /chargingStation/detail/{stationId}`
- **源代码**：`ChargingStationController.java:94-98`

#### 获取区域下拉列表
- **接口**：`GET /chargingPile/stations`
- **Response**：`["北院", "东院", "南院", "华岩路校区"]`
- **源代码**：`ChargingPileController.java:69-74`

### 5.5 订单管理（管理端）

#### 查询所有订单
- **接口**：`GET /order/list`
- **源代码**：`OrderController.java:27-31`

#### 新增订单
- **接口**：`POST /order/add`
- **Request Body**：`OrderDTO`
- **源代码**：`OrderController.java:33-37`

#### 按支付状态分页
- **接口**：`POST /order/page/payment-status`
- **Request Body**：`OrderPageDTO {pageNum, pageSize, paymentStatus}`
- **源代码**：`OrderController.java:39-47`

#### 按用户ID分页
- **接口**：`POST /order/page/user`
- **Request Body**：`OrderPageDTO {pageNum, pageSize, userId}`
- **源代码**：`OrderController.java:49-57`

#### 按充电桩ID分页
- **接口**：`POST /order/page/station`
- **Request Body**：`OrderPageDTO {pageNum, pageSize, stationId}`
- **源代码**：`OrderController.java:59-67`

#### 按时间范围统计
- **接口**：`POST /order/count/time-range`
- **Request Body**：`OrderCountDTO {startTime, endTime}`
- **Response**：`{orderCount, totalAmount}`
- **源代码**：`OrderController.java:69-75`

#### 订单详情
- **接口**：`GET /order/detail/{id}`
- **源代码**：`OrderController.java:77-80`

#### 删除订单
- **接口**：`DELETE /order/delete/{id}`
- **源代码**：`OrderController.java:82-86`

### 5.6 支付管理

#### 查询所有支付记录
- **接口**：`GET /payments/all`
- **源代码**：`PaymentsController.java:33-38`

#### 新增支付记录
- **接口**：`POST /payments/add`
- **Request Body**：`PaymentDTO`
- **源代码**：`PaymentsController.java:46-50`

#### 按订单ID查支付
- **接口**：`GET /payments/order/{orderId}`
- **源代码**：`PaymentsController.java:59-63`

#### 按支付状态分页
- **接口**：`POST /payments/page/status`
- **Request Body**：`PaymentPageDTO`
- **源代码**：`PaymentsController.java:72-82`

#### 按支付方式分页
- **接口**：`POST /payments/page/method`
- **Request Body**：`PaymentPageDTO`
- **源代码**：`PaymentsController.java:90-100`

#### 支付详情
- **接口**：`GET /payments/{id}`
- **源代码**：`PaymentsController.java:108-113`

#### 更新支付状态和时间
- **接口**：`PUT /payments/update/status-time`
- **Request Body**：`PaymentUpdateDTO {paymentId, paymentStatus, paidTime}`
- **源代码**：`PaymentsController.java:121-131`

#### 删除支付记录
- **接口**：`DELETE /payments/{id}`
- **源代码**：`PaymentsController.java:139-144`

### 5.7 预约管理（管理端）

#### 查询所有预约
- **接口**：`GET /reservation/all`
- **源代码**：`ReservationController.java:35-39`

#### 新增预约
- **接口**：`POST /reservation/add`
- **Request Body**：`ReservationDTO`
- **源代码**：`ReservationController.java:45-51`

#### 按状态分页
- **接口**：`POST /reservation/page/status`
- **源代码**：`ReservationController.java:58-68`

#### 按用户ID分页
- **接口**：`POST /reservation/page/user`
- **源代码**：`ReservationController.java:75-85`

#### 按充电桩ID分页
- **接口**：`POST /reservation/page/station`
- **源代码**：`ReservationController.java:92-102`

#### 时间范围查询重叠预约
- **接口**：`POST /reservation/time-range`
- **源代码**：`ReservationController.java:109-119`

#### 预约详情
- **接口**：`GET /reservation/{id}`
- **源代码**：`ReservationController.java:126-131`

#### 更新预约状态
- **接口**：`PUT /reservation/status`
- **源代码**：`ReservationController.java:138-147`

#### 删除预约
- **接口**：`DELETE /reservation/{id}`
- **源代码**：`ReservationController.java:154-159`

### 5.8 新闻管理（管理端）

#### 发布新闻
- **接口**：`POST /news/publish`
- **Request Body**：`NewsDTO`
- **源代码**：`admin/news/NewsController.java:25-27`

#### 更新新闻
- **接口**：`POST /news/update`
- **源代码**：`admin/news/NewsController.java:29-31`

#### 删除新闻
- **接口**：`POST /news/delete`
- **Request Body**：`NewsIdDTO {id}`
- **源代码**：`admin/news/NewsController.java:33-38`

#### 新闻详情
- **接口**：`POST /news/detail`
- **源代码**：`admin/news/NewsController.java:40-45`

#### 分页新闻列表
- **接口**：`POST /news/list`
- **Request Body**：`NewsPageDTO {pageNum, pageSize}`
- **源代码**：`admin/news/NewsController.java:47-54`

### 5.9 文件上传

#### 上传文件
- **接口**：`POST /upload/file`
- **Request Param**：`file` (MultipartFile)
- **Response**：上传后的访问路径
- **源代码**：`UploadController.java:24-28`

#### 上传图片
- **接口**：`POST /upload/image`
- **Request Param**：`image` (MultipartFile)
- **源代码**：`UploadController.java:37-41`

#### 上传视频
- **接口**：`POST /upload/video`
- **Request Param**：`video` (MultipartFile)
- **源代码**：`UploadController.java:50-54`

---

## 六、接口数量汇总

| 模块 | 接口数 |
|------|--------|
| user 模块 — 用户功能 | 4 |
| user 模块 — 充电桩查询 | 3 |
| user 模块 — 充电使用 | 1 |
| user 模块 — 预约 | 3 |
| user 模块 — 订单 | 2 |
| user 模块 — 充电监控 | 5 |
| user 模块 — 新闻 | ~2 |
| **user 模块合计** | **~20** |
| admin 模块 — 管理员登录 | 2 |
| admin 模块 — 管理员 CRUD | 7 |
| admin 模块 — 用户管理 | 6 |
| admin 模块 — 充电桩管理 | 9 |
| admin 模块 — 订单管理 | 7 |
| admin 模块 — 支付管理 | 8 |
| admin 模块 — 预约管理 | 9 |
| admin 模块 — 新闻管理 | 5 |
| admin 模块 — 文件上传 | 3 |
| **admin 模块合计** | **~56** |
| **总计** | **~76** |

## 七、代理映射

### 用户端前端 (frontend) → 后端 (user 模块 8080)

| 前端路径前缀 | 后端目标 | 说明 |
|-------------|---------|------|
| `/user-api/*` | `http://localhost:8080/user/*` | 用户登录、注册、信息管理 |
| `/api/*` | `http://localhost:8080/api/*` | 充电桩查询、充电监控 |
| `/user/charging/*` | `http://localhost:8080/user/charging/*` | 开始充电 |
| `/reversation/*` | `http://localhost:8080/reversation/*` | 预约 |
| `/order/*` | `http://localhost:8080/order/*` | 订单 |
| `/news/*` | `http://localhost:8080/news/*` | 新闻 |
| `/image/*` | `http://localhost:8080/image/*` | 静态图片资源 |
| `/upload/*` | `http://localhost:8080/upload/*` | 文件上传 |

### 管理端前端 (admin-frontend) → 后端 (admin 模块 8081)

| 前端路径前缀 | 后端目标 | 说明 |
|-------------|---------|------|
| `/admin-api/*` | `http://localhost:8081/*` | 所有管理 API（strip 前缀） |
| `/api/*` | `http://localhost:8081/api/*` | 后端 API |
| `/image/*` | `http://localhost:8081/image/*` | 静态图片 |
| `/upload/*` | `http://localhost:8081/upload/*` | 文件上传 |

> 来源：所有 Controller 类、`frontend/vite.config.ts:37-85`、`admin-frontend/vite.config.ts:32-49`
