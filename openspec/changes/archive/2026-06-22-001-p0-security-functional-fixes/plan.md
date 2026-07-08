# 001-p0-security-functional-fixes 实施计划

**前置条件**: design.md 已批准
**预计工作量**: 4-5 小时

---

## 阶段一：敏感信息外部化（P0-01 + P0-05）

### 任务 1.1：移除 admin/application.yml 硬编码默认值

**文件**: `backend/admin/src/main/resources/application.yml`

**修改内容**:
```yaml
# 修改前
username: ${DB_USERNAME:root}
password: ${DB_PASSWORD:123456}
# ...
jwt:
  secret: ${JWT_SECRET:campus-charging-station-dev-secret-key-32bytes!}
# ...
data:
  redis:
    password: ${REDIS_PASSWORD:123456}

# 修改后
username: ${DB_USERNAME:root}
password: ${DB_PASSWORD}
# ...
jwt:
  secret: ${JWT_SECRET}
# ...
data:
  redis:
    password: ${REDIS_PASSWORD}
```

注意: `DB_USERNAME` 保留默认值 `root`（非敏感信息），其余敏感项移除默认值。

### 任务 1.2：移除 user/application.yml 硬编码默认值

**文件**: `backend/user/src/main/resources/application.yml`

同任务 1.1，移除 `DB_PASSWORD`、`REDIS_PASSWORD`、`JWT_SECRET` 的默认值。

### 任务 1.3：修改 JwtTokenInitializer.java 添加启动校验

**文件**: `backend/common/src/main/java/com/tjetc/config/JwtTokenInitializer.java`

**修改内容**:
```java
// 修改前
@Value("${jwt.secret:campus-charging-station-dev-secret-key-32bytes!}")
private String secret;

// 修改后
@Value("${jwt.secret:}")
private String secret;

@PostConstruct
public void init() {
    if (secret == null || secret.isBlank()) {
        throw new IllegalStateException(
            "JWT_SECRET 环境变量未配置！请设置强随机密钥（至少32字节）。");
    }
    if ("campus-charging-station-dev-secret-key-32bytes!".equals(secret)) {
        throw new IllegalStateException(
            "JWT_SECRET 不能使用默认开发密钥，请配置生产环境密钥。");
    }
    JwtTokenUtil.init(secret);
}
```

### 任务 1.4 + 1.5：创建 application-dev.yml

**文件**:
- `backend/admin/src/main/resources/application-dev.yml`
- `backend/user/src/main/resources/application-dev.yml`

**内容**（开发环境本地配置，不提交 Git）:
```yaml
# admin application-dev.yml
spring:
  datasource:
    username: root
    password: 123456
  data:
    redis:
      password: 123456

jwt:
  secret: campus-charging-station-dev-secret-key-32bytes!
```

启动时使用 `spring.profiles.active=dev` 激活。

### 任务 1.6：更新 .gitignore

**文件**: `.gitignore`

**添加**:
```
# 开发环境配置（含敏感信息）
application-dev.yml
```

---

## 阶段二：修复 cancelOrder（P0-08）

### 任务 2.1：数据库新增 order_status 字段

**SQL**:
```sql
ALTER TABLE orders
ADD COLUMN order_status VARCHAR(20) NOT NULL DEFAULT 'pending'
COMMENT '订单状态: pending-待处理, charging-充电中, completed-已完成, cancelled-已取消';

-- 更新已有数据：根据 payment_status 推断 order_status
UPDATE orders SET order_status = 'completed' WHERE payment_status = 'paid';
UPDATE orders SET order_status = 'pending' WHERE payment_status = 'unpaid' OR payment_status = '微信支付';
```

### 任务 2.2：Orders.java 新增字段

**文件**: `backend/common/src/main/java/com/tjetc/entity/core/Orders.java`

**修改**: 在 `paymentStatus` 字段后新增：
```java
@TableField(value = "order_status")
private String orderStatus = "pending";
```

### 任务 2.3：OrderMapper.xml 更新

**文件**: `backend/common/src/main/resources/mapper/OrderMapper.xml`

**修改** `updateById` 方法，添加 `orderStatus` 动态更新：
```xml
<update id="updateById">
    UPDATE orders
    <set>
        <if test="paymentStatus != null">payment_status = #{paymentStatus},</if>
        <if test="endTime != null">end_time = #{endTime},</if>
        <if test="orderStatus != null">order_status = #{orderStatus},</if>
    </set>
    WHERE order_id = #{orderId}
</update>
```

同时在 `BaseResultMap` 和 `Base_Column_List` 中添加 `order_status`。

### 任务 2.4：重写 cancelOrder

**文件**: `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingStationOrderServiceImpl.java`

**替换** 第33-47行：
```java
@Override
public JsonResult cancelOrder(Integer orderId) {
    try {
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
    } catch (Exception e) {
        return new JsonResult(500, "取消失败: " + e.getMessage(), null);
    }
}
```

---

## 阶段三：修复 paymentStatus 语义（P0-09）

### 任务 3.1：修改 createOrder

**文件**: `backend/user/src/main/java/com/tjetc/service/Impl/coreFunctionImpl/ChargingAsyncService.java`

**修改** 第79行：
```java
// 修改前
order.setPaymentStatus("微信支付");

// 修改后
order.setPaymentStatus("unpaid");
```

### 任务 3.2：检查前端适配

检查 `frontend/src/` 和 `admin-frontend/src/` 中是否有对 `paymentStatus === "微信支付"` 的判断，如有则同步修改。

---

## 任务与 openspec/tasks.md 对照表

| plan.md 任务 | openspec/tasks.md 编号 |
|-------------|----------------------|
| 任务 1.1 | 1.1 |
| 任务 1.2 | 1.2 |
| 任务 1.3 | 1.3 |
| 任务 1.4 | 1.4 |
| 任务 1.5 | 1.5 |
| 任务 1.6 | 1.6 |
| 任务 2.1 | 2.1 |
| 任务 2.2 | 2.2 |
| 任务 2.3 | 2.3 |
| 任务 2.4 | 2.4 |
| 任务 3.1 | 3.1 |
| 任务 3.2 | 3.2 |
| 验证 | 4.1 ~ 4.4 |
