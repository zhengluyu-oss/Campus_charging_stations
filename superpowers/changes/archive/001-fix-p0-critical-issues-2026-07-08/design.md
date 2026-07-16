# 001 — 修复 P0 关键问题：充电计时持久化、充电桩状态统一、Token 安全存储

## 1. 需求分析

### 背景

代码审计发现 3 个 P0（Critical）级别问题，直接影响系统核心业务和安全：

1. **充电计时非持久化** — `@Async` + `Thread.sleep()` 模拟充电时长，服务重启后所有计时丢失
2. **充电桩状态值不统一** — MySQL 用语义值 (`available/occupied`)，XML 写死数字 (`1/0`)
3. **Token localStorage 存储** — XSS 攻击可直接窃取管理员 Token

### 问题一：充电计时持久化

**当前实现**：`ChargingAsyncService.java` 中 `startChargingTimer()` 使用 `@Async` + `Thread.sleep(durationMinutes * 60 * 1000)` 进行充电计时。

**缺陷**：
- 服务重启 → 所有 `Thread.sleep()` 丢失 → 充电桩状态永远无法释放
- 多实例部署 → 计时只运行在单节点
- 预约等待 + 充电 duration 串行 `Thread.sleep()` → 线程长期占用
- 无超时释放兜底

**需求**：充电开始时间持久化到数据库 / Redis，配合定时任务扫描超时订单，确保服务重启后充电过程可恢复。

### 问题二：充电桩状态值统一

**当前状态**：

| 位置 | 使用的值 | 规范 |
|------|---------|------|
| schema.sql default | `available` | 语义化字符串 |
| data.sql 初始数据 | `available`, `maintenance` | 语义化字符串 |
| XML updateChargingStationStatus | `status = 1` | 数字 |
| XML updateStatusIfAvailable | `#{newStatus}`, `#{expectedStatus}` | 参数化 |
| 前端过滤条件 | `s.status === 'available' \|\| s.status === '0'` | 兼容两种格式 |

**缺陷**：
- 状态值不一致导致条件更新（CAS 乐观锁）可能失效
- 同一充电桩可能同时被标记为 `available` 和 `0`，状态机混乱
- 前端被迫兼容两种格式，增加复杂度

**需求**：全系统统一使用语义化字符串值。

### 问题三：Token 安全存储

**当前实现**：`pinia-plugin-persistedstate` 将 Token 持久化到 `localStorage`。

**缺陷**：
- XSS 攻击可直接读取 Token
- Token 有效期 36000000ms（10 小时），暴露窗口过大
- 无 Refresh Token 机制

**需求**：将 Token 移出 localStorage，使用更安全的存储方案。

---

## 2. 方案对比

### 2.1 充电计时持久化

| 方案 | 复杂度 | 可靠性 | 多实例 | 实现成本 |
|------|--------|--------|--------|---------|
| **A: Redis 有序集合 (ZSET) + 定时扫描** | 中 | 高 | ✅ 天然支持 | 4h |
| **B: 数据库时间字段 + 定时扫描** | 低 | 中 | ✅ 支持 | 2h |
| **C: RabbitMQ 延时队列** | 高 | 高 | ✅ 天然支持 | 8h（需引入新中间件） |
| **D: Redisson Delayed Queue** | 中 | 高 | ✅ 天然支持 | 4h |

**推荐：方案 A + B 组合**

- 充电开始时在 DB 记录 `start_time`，在 Redis ZSET 中存储 `(orderId, endTimestamp)`
- 定时任务每 30 秒扫描，查询 `endTime < now()` 的订单自动完成充电
- `Thread.sleep()` 保留作为快速触发（非唯一依赖），以定时任务作为兜底

### 2.2 充电桩状态值统一

| 方案 | 复杂度 | 迁移难度 | 推荐 |
|------|--------|---------|:----:|
| **A: 统一为语义化字符串（`available/occupied/maintenance`）** | 低 | 低 | ⭐ |
| B: 统一为数字（`0/1/2`） | 低 | 低 | 偏离 schema 文档 |
| C: 统一为 ENUM 类型 | 中 | 中（需改表结构） | — |

**推荐：方案 A**

- 与现有 schema 定义一致
- 删除 XML 中硬编码 `1`/`0` 的方法，全部使用参数化 SQL
- 新增数据库迁移脚本修正现有脏数据

### 2.3 Token 安全存储

| 方案 | 安全等级 | 实现成本 | XSS 防护 | 推荐 |
|------|---------|---------|---------|:----:|
| **A: httpOnly Cookie + Refresh Token** | 高 | 8h | ✅ 完全免疫 | ⭐ 首选 |
| B: sessionStorage + 缩短 TTL | 中 | 1h | ❌ 仍可 XSS 读取 | — |
| C: 加密 localStorage | 低 | 2h | ❌ 加密密钥同样在 JS 中 | — |

**推荐：方案 A（长期）+ 方案 B（短期过渡）**

- **短期（本次实现）**：Token TTL 从 36000000ms（10h）缩短至 1800000ms（30min），配合 Refresh Token 机制
- **中期**：迁移至 httpOnly Cookie 方案（需后端支持 Cookie 设置）

---

## 3. 设计决策

### 决策 1：充电计时期限任务方案

**选择**：DB 记录 start_time + Redis ZSET + 定时任务扫描

```
充电开始
  ├── DB: 设置 orders.start_time = NOW()
  ├── DB: 设置充电桩 status = 'occupied'
  ├── Redis: ZADD charging_timers {orderId → endTimestamp}
  └── 异步 Thread.sleep() 作为快速触发（非唯一依赖）

定时任务（每 30s）
  └── ZRANGEBYSCORE charging_timers -inf {now}
      └── 对过期订单执行完成充电逻辑
          ├── DB: 更新 order_status = 'completed'
          ├── DB: 释放充电桩 status = 'available'
          └── Redis: ZREM 移除已处理订单
```

**原因**：
- 项目已使用 Redis，无需引入新中间件
- ZSET 的 score 天然支持时间排序
- 定时任务兜底确保服务重启可恢复

### 决策 2：状态值统一方案

**选择**：使用语义化字符串，删除硬编码 XML 方法

**修改点**：
1. 删除 `updateChargingStationStatus`、`stopUpdateChargingStationStatus` 方法
2. 保留并整合 `updateStatusIfAvailable`（已参数化）
3. 添加新方法 `updateStatus(stationId, newStatus)` 用于强制更新
4. 数据库迁移：将现有 `0`/`1` 数据修正为 `available`/`occupied`

### 决策 3：Token 安全存储

**选择**：短期缩减 TTL + Refresh Token，长期 httpOnly Cookie

**修改点**：
1. `application.yml`：`jwt.token.expired: 36000000 → 1800000`（30分钟）
2. 后端新增 Refresh Token 接口
3. 前端 axios 拦截器自动刷新 Token
4. 保持 localStorage 存储（短期），配合缩短 TTL 和 Refresh Token 降低风险

---

## 4. 影响范围

### 4.1 充电计时持久化

| 文件 | 改动类型 | 说明 |
|------|---------|------|
| `ChargingAsyncService.java` | 修改 | 加入 DB start_time 记录 + Redis ZSET 入队 |
| `ChargingStationUseServiceImpl.java` | 修改 | 充电开始流程增加持久化步骤 |
| `ChargingStationOrderServiceImpl.java` | 修改 | 订单完成逻辑更新 |
| `ChargingStationsReversationServiceImpl.java` | 修改 | 预约转充电流程兼容 |
| `Schema/迁移脚本` | 新增 | 确认 start_time 已存在字段 |
| `Redis 配置` | 确认 | Redis 已有，database 1/3 均可使用 |
| `定时任务类` | 新增 | `ChargingTimerScheduler.java` |

### 4.2 充电桩状态值统一

| 文件 | 改动类型 | 说明 |
|------|---------|------|
| `ChargingStationsMapper.xml` | 修改 | 删除硬编码方法，保留参数化方法 |
| `ChargingStationsMapper.java` | 修改 | 更新 DAO 接口签名 |
| `ChargingStationUseServiceImpl.java` | 修改 | 改为使用语义化字符串 |
| `admin-frontend` 过滤条件 | 修改 | 移除数字兼容 |
| 迁移脚本 V002 | 新增 | 修正脏数据 `0→available`, `1→occupied` |

### 4.3 Token 安全

| 文件 | 改动类型 | 说明 |
|------|---------|------|
| `application.yml` (admin + user) | 修改 | Token TTL 缩短 |
| `AdminController.java` / `LoginController.java` | 修改 | 新增 Refresh Token 接口 |
| `JwtTokenUtil.java` | 修改 | 支持 Refresh Token 生成和校验 |
| `request.ts` (admin-frontend) | 修改 | 自动刷新 Token 逻辑 |
| `stores/admin.ts` | 修改 | Refresh Token 管理 |

---

## 5. 验收标准

### 5.1 充电计时持久化

| # | 验收条件 | 验证方式 |
|---|---------|---------|
| 1 | 充电开始时 `orders.start_time` 正确记录 | 查数据库 |
| 2 | Redis ZSET 中存在待完成的充电订单 | `ZRANGE charging_timers 0 -1` |
| 3 | 服务重启后，定时任务 30 秒内检测到超时订单并自动完成 | 重启服务，观察日志 |
| 4 | 充电桩状态正确释放（`occupied → available`） | 查数据库 |
| 5 | 订单状态正确更新（`charging → completed`） | 查数据库 |

### 5.2 充电桩状态值统一

| # | 验收条件 | 验证方式 |
|---|---------|---------|
| 1 | 所有充电桩数据库记录状态值为语义化字符串 | `SELECT DISTINCT status FROM charging_stations` |
| 2 | 前端不再出现兼容数字的代码 | 代码审查 |
| 3 | XML 中不再有硬编码 `1`/`0` | 代码审查 |
| 4 | `updateStatusIfAvailable` CAS 更新正确 | 并发测试 |

### 5.3 Token 安全

| # | 验收条件 | 验证方式 |
|---|---------|---------|
| 1 | Token 有效期缩短为 30 分钟 | 1 小时后验证 token 过期 |
| 2 | Token 过期后自动通过 Refresh Token 刷新 | curl 测试 |
| 3 | Refresh Token 有效期为 7 天 | API 测试 |
| 4 | 前端在 Token 过期时自动静默刷新 | 观察网络请求 |
| 5 | Refresh Token 只能使用一次（防重放） | 重复使用验证 |

---

## 6. 不纳入本次变更的范围

- ❌ httpOnly Cookie 方案（中期计划）
- ❌ RBAC 权限控制（P1 问题，另立变更）
- ❌ 充电桩数据库添加 `occupied_by` 字段（可扩展考虑）
- ❌ 消息队列替换方案

---

## 批准

> ⚠️ 请审阅以上设计方案。您批准后（请说"批准"），我进入 A-3 编写实施计划。
>
> 批准后，A-3 将生成 plan.md 作为任务清单，其中每个任务对应精确文件路径和验证方式。
