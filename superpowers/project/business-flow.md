# 核心流程分析

## 流程 1：用户注册

**参与角色**：校园师生

**前置条件**：无（未登录）

**主流程**：
1. 用户访问 `/user-register` 页面
2. 填写用户名、密码、邮箱、手机号、用户类型（student/teacher）
3. 前端调用 `POST /user/register`（`frontend/src/api/user.ts:88-100`）
4. 后端 `RegisterController.handleRegistration()` 校验参数
   - 用户名和密码不能为空
   - 用户类型默认 "student"
5. `UserRegisterServiceImpl.register()` 执行业务逻辑：
   - 校验用户名：3-10 位
   - 校验密码：6-30 位
   - 检查用户名是否已存在
   - BCrypt 加密密码
   - INSERT 到 users 表
6. 返回注册结果

**异常与分支**：
- 用户名已存在 → `JsonResult.fail("用户名已存在")`
- 参数为空 → `JsonResult.fail("用户名和密码不能为空")`
- 参数长度不符 → 对应的长度错误提示
- 数据库异常 → 全局异常处理返回 "出错了，请联系管理员"

---

## 流程 2：用户登录

**参与角色**：已注册校园用户

**前置条件**：用户已注册

**主流程**：
1. 用户访问 `/user-login` 页面（如未登录会被路由守卫自动重定向）
2. 输入用户名和密码
3. 前端调用 `POST /user/login`（`frontend/src/api/user.ts:6-16`）
4. 后端 `LoginController.login()` →
   `UserLoginServiceImpl.login()`：
   - 按用户名查询用户
   - 比对密码（BCrypt）
   - 生成 JWT Token（含 userId、username）
   - 返回 token + 用户信息
5. 前端 `stores/user.ts` 保存 token 到 Pinia（持久化 localstorage）
6. 路由守卫跳转到 `/user-dashboard`

**异常与分支**：
- 用户名/密码错误 → "用户名或者密码不正确"
- 参数为空 → "用户名和密码不能为空"
- 已登录用户访问登录页 → 自动重定向到仪表盘

---

## 流程 3：管理员登录与 Token 刷新

**参与角色**：系统管理员

**前置条件**：管理员账号已创建

**主流程—登录**：
1. 管理员访问 `/login` 页面
2. 输入用户名和密码
3. 前端调用 `POST /admin-api/admin/login`（代理到 `POST /admin/login`）
4. 后端 `LoginController.login()` → `AdminServiceImpl.login()`：
   - 校验用户名密码
   - BCrypt 验证密码（含明文→BCrypt 自动迁移逻辑）
   - 生成双 Token：access_token（30分钟） + refresh_token（7天）
   - 返回 `{token, refreshToken, admin}`

**主流程—Token 自动刷新**（`admin-frontend/src/utils/request.ts:83-149`）：
1. 某 API 请求返回 `state === -1`（Token 过期）
2. 如果已有 refreshToken，设置 `isRefreshing = true`
3. 调用 `POST /admin-api/admin/refresh` 携带 refreshToken
4. 后端验证 refreshToken 有效性 → 生成新的 Token 对
5. 更新 Pinia store 中的 token/refreshToken
6. 重放所有等待队列中的请求 + 当前请求
7. 期间其他请求自动排队（返回 Promise 等待）

**异常与分支**：
- 无 refreshToken → 直接跳转登录页
- refreshToken 失效 → 跳转登录页（清除所有等待队列）

---

## 流程 4：充电桩查询

**参与角色**：已登录用户

**前置条件**：用户已登录（有有效 token）

**主流程**：
1. 用户进入充电站列表页面（`/user/charging-stations`）
2. 前端调用 `GET /api/showAll`（`frontend/src/api/chargingStationsApi.ts:5-9`）
3. 后端 `ChargingStationsSelectController.showChargingStations()`
   → `ChargingStationSelectServiceImpl.selectAll()`：
   - `chargingStationsMapper.selectList(null)`
   - 自动添加 PageHelper 默认分页（1, 1000）
4. 返回充电桩列表（每个充电桩包含：id、名称、位置、状态、功率、价格）

**筛选分支**：
- 按位置筛选：`POST /api/showByLocation` 传入 `{location: "北院"}`
- 按状态筛选：`POST /api/showByStatus` 传入 `{status: "0"}`（0=可用）

**用户端前端页面**：
- `ChargingStationsView.vue` — 卡片式展示所有充电站
- `ChargingDetailView.vue` — 单个充电站详情

---

## 流程 5：开始充电

**参与角色**：已登录用户

**前置条件**：
- 用户已登录
- 充电桩状态为 "available"
- 用户未在其他充电桩充电

**主流程**（`ChargingStationUseServiceImpl.java:28-54` + `ChargingAsyncService.java`）：

```
用户选择充电桩和时长
       │
       ▼
① CAS 条件更新充电桩状态
   UPDATE charging_stations
   SET status = 'occupied'
   WHERE station_id = ? AND status = 'available'
       │
   成功？──── 否 ──→ 返回 "充电桩正在使用中"
       │
       是
       ▼
② 开启 @Async 异步充电计时
   ChargingAsyncService.startChargingTimer()
       │
       ├── ③ 创建订单 (INSERT INTO orders)
       │    order_status = 'pending' → 'charging'
       │    payment_status = 'unpaid'
       │    total_amount = pricePerHour × duration / 60
       │
       ├── ④ 订单设置为 "charging"
       │
       ├── ⑤ 写入 Redis ZSET
       │    Key: charging:timers
       │    Member: orderId
       │    Score: 结束时间戳
       │
       ├── ⑥ Thread.sleep(durationMinutes)
       │
       └── ⑦ Sleep 结束
            ├── 检查 ZSET 是否已被定时任务处理
            ├── 如未处理：
            │   ├── order_status → 'completed'
            │   ├── end_time = now
            │   └── 释放充电桩 (status → 'available')
            └── 如已处理：跳过
```

**兜底机制**（`ChargingTimerScheduler.java`）：
- 每 30 秒扫描 Redis ZSET 中已超时的 member
- 更新订单状态 + 释放充电桩
- 重启后自动恢复：定时任务扫描 ZSET 完成所有未完成订单

**异常与分支**：
- 充电桩不存在 → "充电桩不存在"
- 充电桩被占用 → "充电桩正在使用中或状态已变更"
- Thread 被中断 → 捕获 InterruptedException，恢复中断标记

---

## 流程 6：预约充电

**参与角色**：已登录用户

**前置条件**：用户已登录

**主流程**（`ChargingStationsReversationServiceImpl.java:37-76`）：

```
用户选择充电桩 + 延迟分钟数 + 充电时长
       │
       ▼
① 参数校验（userId / stationId / delayMinutes / chargingDuration）
       │
       ▼
② 查询充电桩是否存在、状态是否为 occupied
       │
       ▼
③ 创建预约记录 (INSERT INTO reservations)
   - userId, stationId
   - reservedStartTime = now + delayMinutes
   - reservedEndTime = startTime + chargingDuration
   - status = 'confirmed'
       │
       ▼
④ 更新充电桩状态为 'occupied'
       │
       ▼
⑤ 启动异步预约计时
   ChargingAsyncService.startReserveTimer()
       ├── Thread.sleep(delayMinutes)  ← 等待预约时间
       ├── 创建订单并开始充电
       │   ├── INSERT INTO orders
       │   ├── order_status → 'charging'
       │   └── Redis ZSET 记录
       ├── Thread.sleep(chargingDuration) ← 充电计时
       └── 完成充电 (同上流程⑦)
```

**异常与分支**：
- 充电桩不存在 → "充电桩不存在"
- 充电桩正在使用 → "充电桩正在使用中，无法预约"

---

## 流程 7：订单查询与取消

**参与角色**：已登录用户 / 管理员

### 用户端订单查询

**主流程**：
1. 用户进入充电历史页面（`/history`）
2. 前端调用 `POST /api/selectAll`（`ChargingStationOrderSelectController.java`）
   - `AuthUtils.resolveUserId()` 验证当前用户身份
3. 返回用户的所有订单列表（含状态、金额、时长等）

### 用户端订单取消

**主流程**（`ChargingStationOrderServiceImpl.java:36-62`）：
1. 校验订单是否存在
2. 校验订单归属（仅订单所有者可取消）
3. 校验订单状态（已取消/已完成不可取消）
4. `order_status → 'cancelled'`

### 管理员端订单管理

**入口**：`admin-frontend/src/views/OrderManagement.vue`
**后端**：`OrderController.java` 提供多维度分页查询

---

## 流程 8：充电监控与统计

**参与角色**：已登录用户

**主流程**（`ChargeMonitorServiceImpl.java`）：
1. **当前充电状态**：查用户活跃预约记录（status=confirmed + 时间未过期）
2. **充电历史**：分页查询用户所有订单
3. **充电统计**：遍历用户订单计算总次数、总时长、总金额
4. **附近充电桩**：**当前功能不可用**（`getNearbyStations` 返回 null，因无地理位置字段）

---

## 全局业务规则汇总

| 规则 | 说明 | 实现位置 |
|------|------|----------|
| 用户名长度限制 | 3~10 字符 | `AdminServiceImpl.java:132-133` |
| 密码长度限制 | 6~30 字符 | `AdminServiceImpl.java:134-135` |
| 充电桩状态互斥 | CAS 更新保证并发安全 | `ChargingStationsMapper.updateStatusIfAvailable()` |
| 预约冲突检测 | 检查充电桩状态 + 时间范围重叠 | `ReservationServiceImpl.java` / `AdminReservationController` |
| 自动完成充电 | Redis ZSET + 定时任务兜底 | `ChargingTimerScheduler.java` |
| 计费公式 | `totalAmount = pricePerHour × durationMinutes / 60` | `ChargingAsyncService.java:154` |
| 下单者身份校验 | Token 中的 userId 必须匹配操作中的 userId | `AuthUtils.java` |
| 订单状态不可逆 | 已取消/已完成不可再次取消 | `ChargingStationOrderServiceImpl.java:47-51` |
| 注册用户类型 | 默认为 "student" | `RegisterController.java:57-59` |
| 管理员密码自动迁移 | 明文→BCrypt 首次登录时自动升级 | `AdminServiceImpl.java:173-176` |
| 分页保护 | 全表查询默认限制到 1000 条 | 多个 `PageHelper.startPage(1, 1000)` |
| 文件上传白名单 | 扩展名 + MIME 类型双重校验 | `FileUploadUtils.java` |

> 来源：全部 Service 实现文件、Controller 文件
