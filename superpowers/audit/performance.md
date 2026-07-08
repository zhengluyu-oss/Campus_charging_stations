# 性能审计报告

## 1. SQL 性能与索引

### 1.1 索引现状

| 表名 | 现有索引 | 评估 |
|------|---------|------|
| `users` | `PRIMARY (user_id)`、`UNIQUE uk_username (username)` | ✅ 良好 |
| `admin` | `PRIMARY (id)`、`UNIQUE uk_username (username)` | ✅ 良好 |
| `charging_stations` | `PRIMARY (station_id)` | ⚠️ `location`、`status` 列缺少索引 |
| `orders` | `PRIMARY (order_id)`、`KEY idx_user_id`、`KEY idx_station_id` | ⚠️ 缺少 `payment_status`、`order_status`、`created_time` 索引 |
| `payments` | `PRIMARY (payment_id)`、`KEY idx_order_id` | ⚠️ 缺少 `payments_status` 索引 |
| `reservations` | `PRIMARY (reservation_id)`、`KEY idx_user_id`、`KEY idx_station_id` | ⚠️ 缺少 `status` 索引 |
| `news` | `PRIMARY (id)` | ⚠️ 缺少 `category_id` 索引 |
| `system_logs` | `PRIMARY (log_id)`、`KEY idx_user_id` | ✅ 可接受 |

### 1.2 缺少索引导致的性能风险

#### P1 — orders 表缺少 payment_status 和 created_time 索引

**查询**: `OrderMapper.xml`
```sql
SELECT ... FROM orders WHERE payment_status = #{paymentStatus} ORDER BY created_time DESC
-- 以及
SELECT ... FROM orders WHERE created_time BETWEEN #{startTime} AND #{endTime}
```

这两个查询会触发 `payment_status` 和 `created_time` 的**全表扫描**。随着订单数据增长（预估百万级），每次查询将扫描全表。

**建议**: 
```sql
ALTER TABLE orders ADD INDEX idx_payment_status (payment_status);
ALTER TABLE orders ADD INDEX idx_created_time (created_time);
-- 复合索引用于按状态 + 时间排序查询
ALTER TABLE orders ADD INDEX idx_payment_status_created (payment_status, created_time);
```

#### P1 — reservations 表缺少 status 索引

**查询**: `ReservationMapper.xml`
```sql
SELECT ... FROM reservations WHERE status = #{status}
```
同样会触发全表扫描。

#### P2 — payments 表缺少 payments_status 索引

**查询**: `PaymentsMapper.xml`
```sql
SELECT ... FROM payments WHERE payments_status = #{paymentStatus}
```

---

## 2. N+1 查询分析

### 检查结果

> ✅ **未发现明显 N+1 查询**

所有业务查询均通过 MyBatis-Plus `selectList(null)`、`selectById()` 或自定义 SQL 单次完成。Entity 之间无关联关系映射，无懒加载导致的 N+1 问题。

**注意**: 随着功能扩展，如果引入 Entity 关联（如 Order ↔ User 关联查询），需要警惕 N+1 问题。

---

## 3. 深分页问题

### 当前实现

```java
// AdminServiceImpl.java - 使用 PageHelper
PageHelper.startPage(pageNum, pageSize);
List<Admin> admins = adminMapper.selectLikeUsername(username);
PageInfo<Admin> adminPageInfo = new PageInfo<>(admins);

// OrderServiceImpl.java - 使用 MyBatis-Plus Page
Page<Orders> page = new Page<>(pageNum, pageSize);
IPage<Orders> orderPage = orderMapper.selectPageByPaymentStatus(page, paymentStatus);
```

### P2 — 深分页无保护

两种分页实现都使用传统的 `LIMIT OFFSET` 方式：
- PageHelper: `SELECT * FROM xxx LIMIT ? OFFSET ?`
- MP Page: 同上

当页码较大时（如第 10000 页，每页 20 条）：`OFFSET 199980` → MySQL 仍需扫描前 199980 行。

**建议**:
1. 限制最大页码（如 pageNum ≤ 1000）
2. 对高频查询使用游标分页（Keyset Pagination）
3. 或使用覆盖索引加速

---

## 4. 缓存策略

### 4.1 缓存现状

| 缓存层 | 使用情况 | 评估 |
|--------|---------|------|
| Redis — User 模块 | 缓存新闻详情和列表 | ✅ 使用 `StringRedisTemplate` + SCAN 命令 |
| Redis — Admin 模块 | 仅用于 Session（database 1） | ⚠️ 新闻模块无缓存 |
| HTTP 缓存 | 未配置 | ⚠️ 静态资源无缓存头 |
| MyBatis 二级缓存 | 未开启 | ⚠️ 默认关闭 |

### 4.2 发现的问题

#### P2 — 缓存不一致风险

User 模块有 Redis 缓存新闻数据，Admin 模块没有。Admin 更新新闻时不会同步清理 User 模块的缓存。

**建议**: Admin 模块的新闻更新接口增加 Redis 缓存失效逻辑。

#### P2 — 仪表盘数据无缓存

**文件**: `AdminDashboard.vue`

每次加载都发起 4 个 API 请求（用户数、充电站、订单、收入）。短时间内多次访问（如刷新页面）会重复请求完全相同的统计数据。

**建议**: 
1. 后端为统计数据添加短期缓存（如 30 秒 TTL）
2. 或前端使用 Pinia 缓存 + stale-while-revalidate 策略

---

## 5. 并发处理

### ✅ 通过项

| 机制 | 状态 | 说明 |
|------|------|------|
| 充电桩 CAS 乐观锁 | ✅ | `updateStatusIfAvailable` 使用条件更新（WHERE status = #{expectedStatus}） |
| `@Transactional` 事务管理 | ✅ | 关键写入操作都有事务保护 |
| `@Async` 异步充电 | ✅ | 充电计时使用异步线程池 |
| `UserContext` ThreadLocal | ✅ | 请求级用户上下文，`afterCompletion` 清理 |

### P0 — @Async + Thread.sleep() 严重设计缺陷

**文件**: `user/.../ChargingAsyncService.java`
**严重度: P0 — Critical**

```java
@Async
public void startChargingTimer(Long stationId, Long userId, Long orderId, int durationMinutes) {
    try {
        Thread.sleep(TimeUnit.MINUTES.toMillis(durationMinutes));  // 在异步线程中 sleep
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
    // 充电结束后更新状态...
}
```

**问题列表**:

1. **非持久化计时**: 应用重启后所有 `Thread.sleep()` 丢失，充电桩状态**永远无法释放**
2. **无法水平扩展**: 多实例部署时计时只在单节点运行
3. **线程资源浪费**: 长时间 sleep 占用线程池资源
4. **预约与充电串行**: `startReserveTimer` 先 sleep 等待时间，再 sleep 充电时长，如果预约等待 30 分钟 + 充电 60 分钟 = 单个线程占用 90 分钟
5. **无超时兜底**: 没有定时任务扫描超时订单

**修复建议**:
1. **立即缓解**: 添加定时任务（如每 30 秒扫描），检测超时订单并自动释放充电桩
2. **永久修复**: 使用 Redis 延时任务 / RabbitMQ 延时队列 / Redisson Delayed Queue

### P2 — 分页拦截器未配置

**文件**: 两个模块都缺少 `MybatisPlusInterceptor` Bean 配置

`OrderServiceImpl`、`PaymentsServiceImpl`、`ReservationServiceImpl` 使用 `new Page<>(pageNum, pageSize)` + `Mapper.selectPage()`，但未注册 `PaginationInnerInterceptor`。虽然 PageHelper 另有分页功能，但混用两种机制可能导致不可预期的分页行为。

**建议**: 统一分页方案——建议全部使用 MyBatis-Plus `PaginationInnerInterceptor` + `Page` 对象，废弃 PageHelper。

---

## 6. 内存占用

### 6.1 关键分析

#### P2 — findAll() 无限制分页保护

多处 `findAll()` 已添加 `PageHelper.startPage(1, 1000)` 保护，但：

```java
// AdminServiceImpl.findAll()
PageHelper.startPage(1, 1000);
List<Admin> admins = adminMapper.selectList(null);
```

这个限制可以防止 OOM，但如果有 1000+ 管理员账号，仍然有内存压力。目前可接受。

### 6.2 前端性能

#### P3 — particleStyle() 每次渲染使用 Math.random()

**文件**: 6 个视图文件的 `particleStyle(n)` 方法

```typescript
function particleStyle(n: number) {
  const size = Math.random() * 3 + 1
  return {
    width: `${size}px`,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    // ...
  }
}
```

在 Vue 模板的 `v-for="n in 20"` 循环中每次渲染都调用 `Math.random()`，导致：
1. CSS 样式不断变化 → 不必要的重新渲染
2. 浏览器持续重计算布局

假设每秒渲染 60 帧 × 20 粒子 = 1200 次 `Math.random()` 调用/秒

**建议**: 在组件挂载时生成一次静态粒子样式数组，后续渲染复用。

#### ✅ Element Plus 按需引入

Vite 配置中已将 `element-plus` 和 `@element-plus/icons-vue` 拆分为独立 chunk（manualChunks），避免全量引入。✅

---

## 7. 前端构建体积分析

| Chunk | 内容 | 评估 |
|-------|------|------|
| `vendor-three` | three.js | 较大（~1MB），少数页面使用 |
| `vendor-element-plus` | Element Plus | 中等（~500KB） |
| `vendor-vue` | Vue + Vue Router + Pinia | 合理（~200KB） |
| `vendor-axios` | Axios | 小（~50KB） |
| 主入口 | 应用代码 | 待优化 |

**建议**: three.js 在非必要页面延迟加载。
