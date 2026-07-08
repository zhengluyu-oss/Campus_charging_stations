# 001-p0-security-functional-fixes 设计文档

**变更名称**: P0 安全与功能缺陷修复
**状态**: 待批准
**创建日期**: 2026-06-22
**来源**: superpowers/audit/report.md P0 问题清单

---

## 一、需求概述

修复审计报告中第一批 P0 问题（第1天路线图），共 4 项：

| 编号 | 问题 | 影响 |
|------|------|------|
| P0-01 | JWT 密钥硬编码默认值 | 源码泄露即可伪造任意用户 Token |
| P0-05 | 数据库/Redis 密码硬编码 `123456` | 误部署即数据库暴露 |
| P0-08 | cancelOrder 是空操作 | 取消订单功能完全失效 |
| P0-09 | paymentStatus 语义错误 | 支付状态被设置为支付方式 |

---

## 二、方案分析与设计决策

### 2.1 P0-01 + P0-05：敏感信息外部化

**现状**:
- `JwtTokenInitializer.java` 第15行: `@Value("${jwt.secret:campus-charging-station-dev-secret-key-32bytes!}")`
- `admin/application.yml`: `password: ${DB_PASSWORD:123456}`、`redis.password: ${REDIS_PASSWORD:123456}`
- `user/application.yml`: `password: ${DB_PASSWORD:123456}`、`redis.password: ${REDIS_PASSWORD:}`

**方案对比**:

| 方案 | 优点 | 缺点 |
|------|------|------|
| A: 移除默认值，启动时校验非空 | 最安全，强制配置 | 开发环境需额外配置 |
| B: 保留默认值，添加启动警告 | 开发方便 | 生产仍可能遗漏 |
| C: 使用 application-dev.yml 分离 | 环境隔离清晰 | 改动较大 |

**设计决策**: 采用 **方案 A**

**具体设计**:
1. `application.yml` 中移除所有敏感信息的默认值（改为空字符串）
2. `JwtTokenInitializer.java` 添加启动校验：secret 为空或等于旧默认值时抛出异常终止启动
3. 创建 `application-dev.yml` 提供开发环境默认值（不提交到 Git）
4. `.gitignore` 添加 `application-dev.yml`

**影响范围**: `JwtTokenInitializer.java`、`admin/application.yml`、`user/application.yml`、`.gitignore`

### 2.2 P0-08：修复 cancelOrder

**现状**:
```java
// Orders 实体字段：orderId, userId, stationId, startTime, endTime,
//   durationMinutes, totalAmount, paymentStatus, createdTime
// 注意：没有 orderStatus 字段

public JsonResult cancelOrder(Integer orderId) {
    Orders order = orderMapper.selectById(orderId);
    if (order != null) {
        orderMapper.updateById(order);  // 空操作！没有修改任何字段
        return new JsonResult(0, "订单已成功取消", null);
    }
    return new JsonResult(-1, "订单不存在", null);
}
```

**方案对比**:

| 方案 | 优点 | 缺点 |
|------|------|------|
| A: 新增 orderStatus 字段 | 订单生命周期完整 | 需要改表结构+实体+所有查询 |
| B: 复用 paymentStatus 字段，扩展状态值 | 无需改表结构 | 字段名语义不精确 |
| C: 新增 orderStatus 字段 + 数据迁移 | 最规范 | 改动最大 |

**设计决策**: 采用 **方案 A**（最小改动版本）

**具体设计**:

1. **数据库**: `orders` 表新增 `order_status` 字段
   ```sql
   ALTER TABLE orders ADD COLUMN order_status VARCHAR(20) NOT NULL DEFAULT 'pending'
   COMMENT '订单状态: pending-待处理, charging-充电中, completed-已完成, cancelled-已取消';
   ```

2. **实体类**: `Orders.java` 新增字段
   ```java
   @TableField(value = "order_status")
   private String orderStatus = "pending";
   ```

3. **Mapper XML**: `OrderMapper.xml` 的 `updateById` 添加 `orderStatus` 动态更新

4. **cancelOrder 方法重写**:
   ```java
   public JsonResult cancelOrder(Integer orderId) {
       Orders order = orderMapper.selectById(orderId);
       if (order == null) {
           return new JsonResult(-1, "订单不存在", null);
       }
       if ("cancelled".equals(order.getOrderStatus())) {
           return new JsonResult(-1, "订单已取消，请勿重复操作", null);
       }
       if ("completed".equals(order.getOrderStatus())) {
           return new JsonResult(-1, "订单已完成，无法取消", null);
       }
       Orders update = new Orders();
       update.setOrderId(orderId);
       update.setOrderStatus("cancelled");
       orderMapper.updateById(update);
       return new JsonResult(0, "订单已成功取消", null);
   }
   ```

**影响范围**: `orders` 表 DDL、`Orders.java`、`OrderMapper.xml`、`ChargingStationOrderServiceImpl.java`

### 2.3 P0-09：修复 paymentStatus 语义

**现状**:
```java
// ChargingAsyncService.java 第79行
order.setPaymentStatus("微信支付");  // 这是支付方式，不是支付状态
```

**设计决策**: 修正为正确的支付状态值

**具体设计**:
- 将 `paymentStatus` 的值从 `"微信支付"` 改为 `"unpaid"`（未支付）
- 定义支付状态枚举值：`unpaid`（未支付）、`paid`（已支付）、`refunded`（已退款）
- 订单创建时默认 `paymentStatus = "unpaid"`

**影响范围**: `ChargingAsyncService.java`

---

## 三、验收标准

### 3.1 P0-01 + P0-05 验收

- [ ] 不设置 `JWT_SECRET` 环境变量时，后端启动失败并输出明确错误信息
- [ ] 不设置 `DB_PASSWORD` 环境变量时，后端启动失败
- [ ] 设置正确环境变量后，后端正常启动
- [ ] `application.yml` 中不包含任何硬编码密码或密钥
- [ ] `application-dev.yml` 已添加到 `.gitignore`

### 3.2 P0-08 验收

- [ ] `orders` 表存在 `order_status` 字段，默认值 `pending`
- [ ] 调用 cancelOrder 接口后，数据库中 `order_status` 变为 `cancelled`
- [ ] 已取消的订单再次取消返回"已取消"提示
- [ ] 已完成的订单取消返回"无法取消"提示
- [ ] 不存在的 orderId 返回"订单不存在"

### 3.3 P0-09 验收

- [ ] 新创建的订单 `payment_status` 值为 `unpaid`（非 `微信支付`）
- [ ] 支付流程正常工作（支付后更新为 `paid`）

---

## 四、风险评估

| 风险 | 概率 | 影响 | 缓解措施 |
|------|------|------|---------|
| 改表结构导致现有数据异常 | 低 | 高 | 使用 ALTER TABLE ADD COLUMN + DEFAULT 值，不影响已有数据 |
| 前端依赖 paymentStatus 旧值 | 中 | 中 | 检查前端代码中对 paymentStatus 的判断逻辑 |
| 环境变量未配置导致部署失败 | 中 | 高 | 提供 .env.example 模板文件 |

---

## 五、不包含在本次变更中的内容

以下 P0 问题将在后续变更中处理：
- P0-02: 密码 BCrypt 加密（需要数据库迁移 + 登录逻辑重构）
- P0-03: 文件上传安全校验（独立变更）
- P0-04: @mediapipe/hands CVE 修复（前端独立变更）
- P0-06/P0-07: 前端敏感数据清理（前端独立变更）
- P0-10: ChargeMonitorController 空壳（功能开发）
- P0-11: Mapper XML 补全（独立变更）
- P0-12: 竞态条件修复（需要引入分布式锁，复杂度高）
