# 001 — 修复 P0 关键问题：实施计划

## 批次划分

将 3 个 P0 问题拆为 **3 个独立批次**，每批可单独验证：

| 批次 | 内容 | 耦合度 | 依赖 |
|------|------|--------|------|
| **Batch 1** | 充电桩状态值统一 | 低（仅 DAO/XML） | 无 |
| **Batch 2** | Token 安全存储 | 中（前后端协作） | 无 |
| **Batch 3** | 充电计时持久化 | 中（依赖 Batch 1 的状态值统一） | Batch 1 |

**执行顺序**: Batch 1 → Batch 2 → Batch 3（Batch 2 和 Batch 1 可并行）

> **注意**: 当前分支 `zhengluyu_userFront_enhance` 已有大量未提交改动。本计划仅标记本次变更需改动的文件，不涉及已有改动。

---

## Batch 1 — 充电桩状态值统一

### 目标

全系统使用语义化字符串 (`available`/`occupied`/`maintenance`)，删除 XML 中硬编码 `1`/`0` 的方法，清理数据库脏数据。

### 任务清单

- [ ] **1.1 数据库迁移脚本：修正脏数据**

  **文件**: `backend/common/src/main/resources/db/migration/V002__unify_station_status.sql`

  **内容**:
  ```sql
  -- 将数字状态转换为语义化字符串
  UPDATE charging_stations SET status = 'available' WHERE status = '0';
  UPDATE charging_stations SET status = 'occupied' WHERE status = '1';
  -- 确保默认值正确
  ALTER TABLE charging_stations MODIFY COLUMN status VARCHAR(20) DEFAULT 'available';
  ```

  **验证方式**: 执行脚本后查询 `SELECT DISTINCT status FROM charging_stations`，只返回 `available`/`occupied`/`maintenance`

  **提交建议**: `chore(db): add migration V002 to unify station status values`

- [ ] **1.2 修改 ChargingStationsMapper.xml：删除硬编码方法**

  **文件**: `backend/common/src/main/resources/mapper/ChargingStationsMapper.xml`

  **操作**:
  - 删除 `<update id="updateChargingStationStatus">` 方法（写死 `status = 1`）
  - 删除 `<update id="stopUpdateChargingStationStatus">` 方法（写死 `status = 0`）
  - 删除 `<update id="updateChargingStationStatusAndTime">` 方法（写死 `status = 1`）
  - **保留** `<update id="updateStatusIfAvailable">`（参数化 CAS 更新）
  - 新增通用状态更新方法：
    ```xml
    <update id="updateStatus">
        UPDATE charging_stations SET status = #{status} WHERE station_id = #{stationId}
    </update>
    ```

  **验证方式**: 审查 XML 文件确认无硬编码 `1`/`0`

  **提交建议**: `refactor: remove hardcoded status values from ChargingStationsMapper.xml`

- [ ] **1.3 修改 ChargingStationsMapper.java：更新 DAO 接口**

  **文件**: `backend/common/src/main/java/com/tjetc/dao/ChargingStationsMapper.java`

  **操作**:
  - 删除 `updateChargingStationStatus(Integer stationId)` 方法声明
  - 删除 `stopUpdateChargingStationStatus(Integer stationId)` 方法声明
  - 删除 `updateChargingStationStatusAndTime(Integer stationId)` 方法声明
  - 新增 `void updateStatus(@Param("stationId") Integer stationId, @Param("status") String status)` 方法声明

  **验证方式**: 编译通过，XML 中的新方法 ID 与接口匹配

  **提交建议**: `refactor: update ChargingStationsMapper interface to match XML changes`

- [ ] **1.4 修改 ChargingStationUseServiceImpl：改为语义化字符串**

  **文件**: `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingStationUseServiceImpl.java`

  **操作**: 将所有使用硬编码 `"0"`/`"1"` 状态值的地方替换为语义化字符串

  **具体查找**:
  - `status = "0"` → `status = "available"`
  - `status = "1"` → `status = "occupied"`
  - 引用的 mapper 方法名从 `updateChargingStationStatus` 改为 `updateStatus`
  - 引用的 mapper 方法名从 `stopUpdateChargingStationStatus` 改为 `updateStatus`

  **验证方式**: 审查代码，确认无数字状态值

  **提交建议**: `refactor: use semantic status strings in ChargingStationUseServiceImpl`

- [ ] **1.5 修改 ChargingStationsReversationServiceImpl：改为语义化字符串**

  **文件**: `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingStationsReversationServiceImpl.java`

  **操作**: 同上，将所有硬编码 `"0"`/`"1"` 替换为语义化字符串

  **验证方式**: 代码审查

  **提交建议**: `refactor: use semantic status strings in ChargingStationsReversationServiceImpl`

- [ ] **1.6 修改 Admin 端 ChargingStationServiceImpl（如有硬编码）**

  **文件**: `backend/admin/src/main/java/com/tjetc/service/impl/ChargingStationServiceImpl.java`

  **操作**: 检查是否有硬编码数字状态，如有则替换

  **验证方式**: 代码审查

  **提交建议**: `refactor: use semantic status strings in admin ChargingStationServiceImpl`

- [ ] **1.7 修改前端过滤条件：移除数字兼容**

  **文件**: `admin-frontend/src/views/AdminDashboard.vue`

  **操作**: 查找并替换
  ```typescript
  // 修改前
  s.status === 'available' || s.status === '0'
  // 修改后
  s.status === 'available'
  ```
  （同理处理 `occupied`/`1`、`maintenance`/`2` 等条件）

  **验证方式**: 审查所有视图文件中的过滤条件，确认无数字兼容

  **提交建议**: `refactor: remove numeric status value compatibility in frontend filters`

### Batch 1 验证

- [ ] **1.V 编译验证**: Maven 编译通过，无方法引用错误
- [ ] **1.V 数据库验证**: `SELECT DISTINCT status FROM charging_stations` 返回语义化值
- [ ] **1.V 前端验证**: 搜索项目中无 `=== '0'` 或 `=== '1'` 的状态比较

---

## Batch 2 — Token 安全存储

### 目标

缩短 Token TTL 至 30 分钟，新增 Refresh Token 机制，前端自动刷新。

### 任务清单

- [ ] **2.1 后端：缩短 Token TTL**

  **文件**: `backend/admin/src/main/resources/application.yml`
  `backend/user/src/main/resources/application.yml`

  **操作**: 
  ```yaml
  jwt:
    token:
      expired: 1800000  # 30分钟（原 36000000ms ≈ 10小时）
  ```

  **验证方式**: 登录后 30 分钟 Token 过期

  **提交建议**: `perf: reduce JWT TTL from 10h to 30min`

- [ ] **2.2 后端：JwtTokenUtil 增加 Refresh Token 支持**

  **文件**: `backend/common/src/main/java/com/tjetc/common/JwtTokenUtil.java`

  **操作**: 新增方法
  - `generateRefreshToken(subject, expiration)` — 生成 Refresh Token（有效期 7 天）
  - `validateToken(token)` — 校验 Token 是否过期/有效
  - `getClaimsFromToken(token)` — 从 Token 中提取 Claims

  **验证方式**: 单元测试验证 Refresh Token 生成和校验

  **提交建议**: `feat: add refresh token support to JwtTokenUtil`

- [ ] **2.3 后端：Admin LoginController 增加刷新接口**

  **文件**: `backend/admin/src/main/java/com/tjetc/controller/LoginController.java`
  `backend/admin/src/main/java/com/tjetc/service/AdminService.java`
  `backend/admin/src/main/java/com/tjetc/service/impl/AdminServiceImpl.java`

  **操作**: 新增接口
  - `POST /admin/refresh` — 接收 Refresh Token，返回新的 Access Token + Refresh Token
  - 验证 Refresh Token 有效且未过期
  - Refresh Token 使用一次后失效（防重放攻击）

  **验证方式**: 
  - 使用 curl 测试：`curl -X POST /admin/refresh -H "token: <refresh_token>"`
  - 返回新的 Access Token 和 Refresh Token

  **提交建议**: `feat: add token refresh endpoint for admin`

- [ ] **2.4 后端：User LoginController 增加刷新接口（如适用）**

  **文件**: `backend/user/src/main/java/com/tjetc/controller/userFunctionController/LoginController.java`

  **操作**: 同上，新增 `POST /user/refresh` 接口

  **验证方式**: 用户端 Token 刷新测试

  **提交建议**: `feat: add token refresh endpoint for user module`

- [ ] **2.5 后端：LoginInterceptor 支持 Refresh Token 放行**

  **文件**: `backend/admin/src/main/java/com/tjetc/interceptor/LoginInterceptor.java`

  **操作**: 在拦截器排除路径中添加 `/admin/refresh`，使其无需登录即可访问

  **验证方式**: 未登录状态下可访问 `/admin/refresh`

  **提交建议**: `fix: exclude refresh endpoint from auth interceptor`

- [ ] **2.6 前端：axios 拦截器增加自动刷新逻辑**

  **文件**: `admin-frontend/src/utils/request.ts`

  **操作**:
  - 响应拦截器中检测 `state === -1`（Token 过期）
  - 自动调用 `/admin/refresh` 获取新 Token
  - 重放原始请求（使用新 Token）
  - 若 Refresh Token 也过期，跳转登录页

  **伪代码**:
  ```typescript
  // 响应拦截器
  if (res.state === -1) {
    const refreshToken = adminStore.getRefreshToken
    const newTokens = await refreshTokenApi(refreshToken)
    adminStore.setToken(newTokens.token)
    adminStore.setRefreshToken(newTokens.refreshToken)
    // 重放原始请求
    config.headers['token'] = newTokens.token
    return service(config)
  }
  ```

  **验证方式**: 等待 Token 过期（或手动修改过期时间测试），观察自动刷新

  **提交建议**: `feat: add auto token refresh to axios interceptor`

- [ ] **2.7 前端：AdminStore 增加 Refresh Token 管理**

  **文件**: `admin-frontend/src/stores/admin.ts`

  **操作**:
  - 新增 `refreshToken` ref 变量
  - 新增 `getRefreshToken` computed
  - 新增 `setRefreshToken` 方法
  - `logout()` 时同时清除 Refresh Token

  **验证方式**: 登录后检查 store 中 Refresh Token 是否正确存储

  **提交建议**: `feat: add refresh token state management to admin store`

### Batch 2 验证

- [ ] **2.V 后端验证**: Token 过期后通过 Refresh Token 成功获取新 Token
- [ ] **2.V 前端验证**: Token 过期时自动刷新不跳转登录页
- [ ] **2.V 安全验证**: Refresh Token 使用一次后失效（重复使用返回 401）

---

## Batch 3 — 充电计时持久化

### 目标

充电开始记录时间到数据库，配合 Redis ZSET + 定时任务，确保服务重启后不丢失状态。

> **前置依赖**: Batch 1 完成（状态值统一后，充电桩释放逻辑使用语义化字符串）

### 任务清单

- [ ] **3.1 新增定时任务扫描类：ChargingTimerScheduler**

  **文件**: `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingTimerScheduler.java`

  **操作**: 新建类，使用 `@Scheduled(fixedRate = 30000)` 每 30 秒执行

  **逻辑**:
  ```java
  @Component
  @Slf4j
  public class ChargingTimerScheduler {
      @Autowired private StringRedisTemplate redisTemplate;
      @Autowired private OrderMapper orderMapper;
      @Autowired private ChargingStationsMapper chargingStationsMapper;
  
      private static final String CHARGING_TIMERS_KEY = "charging:timers";
  
      @Scheduled(fixedRate = 30000)
      public void scanExpiredChargingOrders() {
          long now = System.currentTimeMillis();
          // 从 Redis ZSET 获取所有已过期的订单
          Set<String> expiredOrderIds = redisTemplate.opsForZSet()
              .rangeByScore(CHARGING_TIMERS_KEY, 0, now);
          
          if (expiredOrderIds == null || expiredOrderIds.isEmpty()) return;
  
          for (String orderIdStr : expiredOrderIds) {
              Integer orderId = Integer.valueOf(orderIdStr);
              // 查询订单
              Orders order = orderMapper.selectById(orderId);
              if (order == null || !"charging".equals(order.getOrderStatus())) continue;
              
              // 更新订单状态为 completed
              order.setOrderStatus("completed");
              order.setEndTime(LocalDateTime.now().toString());
              orderMapper.updateById(order);
              
              // 释放充电桩
              chargingStationsMapper.updateStatus(order.getStationId(), "available");
              
              // 从 ZSET 移除
              redisTemplate.opsForZSet().remove(CHARGING_TIMERS_KEY, orderIdStr);
              
              log.info("定时任务: 订单 {} 充电完成，充电桩 {} 已释放", orderId, order.getStationId());
          }
      }
  }
  ```

  **验证方式**: 启动应用，插入测试数据到 Redis ZSET，观察 30 秒内日志输出

  **提交建议**: `feat: add scheduled task for charging timeout recovery`

- [ ] **3.2 修改 ChargingAsyncService：充电开始记录持久化**

  **文件**: `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingAsyncService.java`

  **操作**:
  - 注入 `StringRedisTemplate` 和 `OrderMapper`
  - 充电开始时：
    1. 更新 `orders.start_time` 和 `order_status = 'charging'`
    2. 将 `{orderId → endTimestamp}` 写入 Redis ZSET
    3. `Thread.sleep()` 保留作为快速触发
    4. sleep 结束后先检查订单是否已被定时任务处理（防重复）
    5. 如果已被处理，跳过；否则执行原有完成逻辑

  **伪代码**:
  ```java
  @Async
  public void startChargingTimer(Integer orderId, Integer stationId, int durationMinutes) {
      long endTimestamp = System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(durationMinutes);
      
      // 1. 持久化到 Redis ZSET
      redisTemplate.opsForZSet().add(CHARGING_TIMERS_KEY, orderId.toString(), endTimestamp);
      
      // 2. 更新订单状态
      Orders order = orderMapper.selectById(orderId);
      order.setOrderStatus("charging");
      orderMapper.updateById(order);
      
      // 3. 快速触发（非唯一机制）
      try {
          Thread.sleep(TimeUnit.MINUTES.toMillis(durationMinutes));
      } catch (InterruptedException e) {
          Thread.currentThread().interrupt();
      }
      
      // 4. 检查是否已被定时任务处理
      order = orderMapper.selectById(orderId);
      if (!"charging".equals(order.getOrderStatus())) {
          return; // 已被定时任务处理
      }
      
      // 5. 执行完成逻辑
      order.setOrderStatus("completed");
      order.setEndTime(LocalDateTime.now().toString());
      orderMapper.updateById(order);
      chargingStationsMapper.updateStatus(stationId, "available");
      redisTemplate.opsForZSet().remove(CHARGING_TIMERS_KEY, orderId.toString());
  }
  ```

  **验证方式**: 
  - 充电开始后查 Redis: `ZRANGE charging:timers 0 -1 WITHSCORES`
  - 充电完成后查 DB: `order_status = 'completed'`

  **提交建议**: `feat: persist charging start time to Redis for crash recovery`

- [ ] **3.3 修改 ChargingStationUseServiceImpl：充电流程适配**

  **文件**: `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingStationUseServiceImpl.java`

  **操作**:
  - 使用 `updateStatus` 替代已删除的 `updateChargingStationStatus` 方法
  - 充电启动时设置 `charging_stations.status = 'occupied'`

  **验证方式**: 充电后查 DB: `status = 'occupied'`

  **提交建议**: `refactor: adapt charging start to use unified status values`

- [ ] **3.4 启用 Spring 定时任务**

  **文件**: `backend/user/src/main/java/com/tjetc/UserApplication.java`

  **操作**: 添加 `@EnableScheduling` 注解

  **验证方式**: 应用启动日志中显示 `Scheduled` 线程池初始化

  **提交建议**: `chore: enable scheduled task support`

### Batch 3 验证

- [ ] **3.V 单元测试**: 定时任务正确扫描并完成过期订单
- [ ] **3.V 集成测试**: 模拟服务重启，验证充电状态在 30 秒内恢复
- [ ] **3.V 边界测试**: 充电刚好结束时服务重启，验证不重复释放充电桩

---

## 完整验证清单

### 编译构建

- [ ] **V.1 后端编译**: `cd backend && mvn compile -DskipTests` 通过
- [ ] **V.2 前端构建**: `cd admin-frontend && npm run build` 通过

### 功能验证

- [ ] **V.3 充电桩管理**: 新增/编辑/删除充电桩正常
- [ ] **V.4 充电流程**: 开始充电 → 计时 → 完成释放 完整流程
- [ ] **V.5 Token 刷新**: 过期后自动刷新，不跳登录页
- [ ] **V.6 预约流程**: 预约 → 等待 → 充电 → 完成 完整流程

### 安全验证

- [ ] **V.7 状态注入**: 无法通过 API 将状态设置为非法值
- [ ] **V.8 Token 重放**: Refresh Token 不能重复使用

---

## 执行顺序总结

```
Batch 1 (状态统一) ───→ Batch 3 (充电持久化)
      ↓                     ↑
      并行                  依赖 Batch 1
      ↓                     ↑
Batch 2 (Token 安全) ─── 可并行执行
```

**实际执行**:
1. ✅ Batch 1 (1.1 → 1.2 → 1.3 → 1.4 → 1.5 → 1.6 → 1.7)
2. ⏸ Batch 2 (2.1 → 2.2 → 2.3 → 2.4 → 2.5 → 2.6 → 2.7)  
3. ⏸ Batch 3 (3.1 → 3.2 → 3.3 → 3.4)

> ⚠️ **注意**: 当前分支 `zhengluyu_userFront_enhance` 已有未提交改动。本计划仅标记本次变更需改动的文件。执行前请确认基线状态。
