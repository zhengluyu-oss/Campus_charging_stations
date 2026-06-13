# 校园充电桩管理系统 - 项目介绍

apifox的token：afxp_45962asoumYx2QxsfetbVu5DHsxJ6B5VJk8s



## 一、项目概述

### 1.1 项目背景
本项目是一个**校园充电桩管理平台**，旨在为校园用户提供便捷的充电桩查询、预约、充电及支付一体化服务。系统整合了充电桩管理、在线预约、订单支付、积分商城、红包营销等核心功能，采用前后端分离架构，实现了用户端和管理端的业务闭环。

### 1.2 项目定位
- **To C 用户端**（端口 8080）：提供充电桩查询、在线预约、充电订单、积分商城、个人信息管理等服务
- **To B 管理端**（端口 8081）：提供充电桩管理、订单管理、用户管理、营销管理等后台管理功能

---

## 二、技术架构

### 2.1 技术栈

| 技术分类 | 技术选型 | 说明 |
|---------|---------|------|
| **后端框架** | Spring Boot 3.5.9 | 核心开发框架 |
| **持久层** | MyBatis-Plus 3.5.15 | ORM 框架，简化数据库操作 |
| **数据库** | MySQL 8.0 | 关系型数据库 |
| **令牌认证** | JWT (jjwt 0.12.5) | 用户身份认证 |
| **分页插件** | PageHelper 2.1.1 | 数据库分页查询 |
| **工具库** | Apache Commons Lang3 | 字符串处理等工具类 |
| **项目构建** | Maven | 多模块项目管理 |
| **JDK 版本** | JDK 17 | Java 运行环境 |

### 2.2 项目结构

```
campus_charging_stations_HouDuan/
├── admin/                          # 后台管理模块 (端口：8081)
│   ├── controller/                 # 管理端控制器
│   │   ├── AdminController        # 管理员管理
│   │   ├── ChargingStationController  # 充电桩管理
│   │   ├── OrderController        # 订单管理
│   │   ├── PaymentsController     # 支付管理
│   │   ├── PointsController       # 积分管理
│   │   ├── RedPacketController    # 红包管理
│   │   ├── ReservationController  # 预约管理
│   │   ├── UserController         # 用户管理
│   │   └── MallOrderController    # 商城订单管理
│   ├── service/                    # 业务逻辑层
│   ├── interceptor/                # 登录拦截器
│   └── config/                     # 配置类
│
├── user/                           # 用户端模块 (端口：8080)
│   ├── controller/
│   │   ├── CoreFunctionController/    # 核心功能控制器
│   │   │   ├── ChargingStationsSelectController  # 充电桩查询
│   │   │   ├── ChargingStationsReversationController  # 预约管理
│   │   │   ├── ChargingStationOrderSelectController # 订单查询
│   │   │   └── OrderController    # 订单操作
│   │   ├── shop/                      # 商城模块
│   │   │   └── MallController         # 商城接口
│   │   ├── charge/                    # 充电监控模块
│   │   │   └── ChargeMonitorController
│   │   └── userFunctionController/    # 用户功能控制器
│   │       ├── LoginController        # 登录
│   │       ├── RegisterController     # 注册
│   │       ├── UserWalletController   # 钱包管理
│   │       ├── SelectOwnMessageController  # 个人信息查询
│   │       └── UpdateOwnMessageController  # 个人信息修改
│   ├── service/
│   │   ├── coreFunctionImpl/          # 核心功能实现
│   │   ├── shopImpl/                  # 商城实现
│   │   └── userFunctionImpl/          # 用户功能实现
│   └── interceptor/                   # 登录拦截器
│
└── common/                            # 公共模块
    ├── entity/                        # 实体类
    │   ├── core/                      # 核心实体
    │   │   ├── ChargingStation        # 充电桩
    │   │   ├── Orders                 # 充电订单
    │   │   ├── Payments               # 支付记录
    │   │   ├── Reservation            # 预约记录
    │   │   └── SystemLog              # 系统日志
    │   ├── mall/                      # 商城实体
    │   │   ├── GoodsItems             # 商品
    │   │   ├── GoodsOrders            # 商城订单
    │   │   └── GoodsOrderAddress      # 收货地址
    │   ├── marketing/                 # 营销实体
    │   │   ├── CouponTemplate         # 优惠券模板
    │   │   ├── UserCoupon             # 用户优惠券
    │   │   ├── RedPacket              # 红包
    │   │   └── UserRedPacket          # 用户红包
    │   ├── points/                    # 积分实体
    │   │   ├── UserPoints             # 用户积分
    │   │   └── PointsRecord           # 积分记录
    │   └── userAndAdmin/              # 用户与管理实体
    │       ├── User                   # 用户
    │       └── Admin                  # 管理员
    ├── dao/                           # Mapper 接口
    ├── common/                        # 公共类
    │   ├── JsonResult                 # 统一响应
    │   └── JwtTokenUtil               # JWT 工具
    └── enums/                         # 枚举类
        ├── ChargingStationStatus      # 充电桩状态
        ├── ChargingStationLocation    # 充电桩位置
        ├── OrderStatus                # 订单状态
        ├── PaymentStatus              # 支付状态
        └── UserType                   # 用户类型
```

---

## 三、核心功能模块

### 3.1 充电桩管理模块

**功能描述**：充电桩的增删改查及状态管理

**管理端接口**：
- `ChargingStationController` - 充电桩 CRUD
  - `/findPage` - 分页查询（支持按名称模糊搜索）
  - `/findById` - 根据 ID 查询
  - `/add` - 新增充电桩
  - `/update` - 更新充电桩
  - `/delete` - 删除充电桩

**用户端接口**：
- `ChargingStationsSelectController`
  - `/showAll` - 查询所有充电桩
  - `/showByLocation` - 按位置查询
  - `/showByStatus` - 按状态查询

**实体设计**：
```java
ChargingStation {
    stationId: Integer        // 主键 (自增)
    stationName: String       // 站点名称
    location: String          // 位置信息
    status: Integer           // 状态 (0-空闲，1-使用中)
    powerRating: Double       // 功率
    pricePerHour: Double      // 每小时价格
    createdTime: String       // 创建时间
    updatedTime: String       // 更新时间
}
```

### 3.2 预约系统模块

**功能描述**：用户在线预约充电桩，支持预约取消、预约查询

**核心服务**：
- `ChargingStationsReversationServiceImpl` - 预约服务实现

**用户端接口**：
- 预约充电桩：校验时间冲突、充电桩可用性
- 取消预约：验证用户权限、预约状态
- 查询用户预约记录：分页查询
- 查询充电桩预约记录：按时间段查询

**核心逻辑**：
```java
// 预约流程
1. 参数校验（stationId, userId, startTime, endTime）
2. 时间格式解析与校验（开始时间不能晚于结束时间，不能早于当前时间）
3. 检查充电桩是否存在
4. 检查时间段是否有冲突（查询预约记录）
5. 创建预约记录并插入数据库
```

**实体设计**：
```java
Reservation {
    reservationId: Integer           // 主键
    userId: Integer                  // 用户 ID
    stationId: Integer               // 充电桩 ID
    reservedStartTime: LocalDateTime // 预约开始时间
    reservedEndTime: LocalDateTime   // 预约结束时间
    status: String                   // 状态 (confirmed/cancelled/used)
    createdAt: LocalDateTime         // 创建时间
}
```

### 3.3 充电订单模块

**功能描述**：充电订单的生成、查询、状态管理

**管理端接口**：
- `OrderController` - 订单管理
  - `/findAll` - 查询所有订单
  - `/findPageByOrderStatus` - 按订单状态分页查询
  - `/findPageByPaymentStatus` - 按支付状态分页查询
  - `/findPageByUserId` - 按用户 ID 分页查询
  - `/findPageByStationId` - 按充电桩 ID 分页查询
  - `/countOrderDataByTimeRange` - 时间范围订单统计

**用户端接口**：
- `ChargingStationOrderSelectController` - 订单查询

**实体设计**：
```java
Orders {
    orderId: Integer          // 主键
    userId: String            // 用户 ID
    stationId: String         // 充电桩 ID
    startTime: String         // 开始时间
    endTime: String           // 结束时间
    durationMinutes: Integer  // 充电时长 (分钟)
    totalAmount: Double       // 总金额
    paymentStatus: String     // 支付状态
    orderStatus: String       // 订单状态
    createdTime: String       // 创建时间
}
```

### 3.4 支付模块

**功能描述**：支付记录管理

**实体设计**：
```java
Payments {
    paymentId: Integer        // 主键
    orderId: Integer          // 订单 ID
    userId: Integer           // 用户 ID
    amount: Double            // 支付金额
    paymentMethod: String     // 支付方式
    paymentStatus: String     // 支付状态
    paymentTime: String       // 支付时间
}
```

### 3.5 积分商城模块

**功能描述**：用户积分消费、商品购买、订单管理

**用户端接口**：
- `MallController`
  - `/list` - 商品列表
  - `/buy` - 商品下单
  - `/orders` - 订单查询
  - `/detail/{orderId}` - 订单详情
  - `/cancel` - 订单取消

**管理端接口**：
- `MallOrderController`
  - `/page` - 订单分页查询
  - `/detail/{id}` - 订单详情
  - `/deliver/{id}` - 订单发货

**核心服务**：
```java
MallServiceImpl.createOrder() {
    1. 计算总金额
    2. 创建订单主表 (GoodsOrders)
    3. 创建订单商品明细 (GoodsItems)
    4. 创建订单收货地址快照 (GoodsOrderAddress)
    5. 事务回滚保证数据一致性
}
```

**实体设计**：
```java
GoodsOrders {
    id: Long                  // 主键 (雪花算法)
    userId: Long              // 用户 ID
    orderNo: String           // 订单编号
    orderStatus: Integer      // 订单状态 (0-待支付)
    orderType: Integer        // 订单类型
    totalAmount: Integer      // 总金额 (分)
    payAmount: Integer        // 实付金额
    createTime: LocalDateTime // 创建时间
}

GoodsItems {
    id: Long                  // 主键
    orderId: Long             // 订单 ID
    productId: Long           // 商品 ID
    productName: String       // 商品名称
    price: Integer            // 单价 (分)
    quantity: Integer         // 数量
    totalPrice: Integer       // 总价 (分)
}
```

### 3.6 营销模块

**功能描述**：优惠券、红包的发放与使用

**管理端接口**：
- `RedPacketController` - 红包管理
  - `/add` - 创建红包
  - `/update` - 更新红包
  - `/delete` - 删除红包
  - `/findPage` - 分页查询

**用户端接口**：
- `UserWalletController`
  - `/my/points` - 查询我的积分
  - `/my/coupons` - 查询我的优惠券
  - `/my/redpackets` - 查询我的红包

**实体设计**：
```java
CouponTemplate {
    id: Long                  // 主键 (雪花算法)
    name: String              // 优惠券名称
    type: Integer             // 类型 (1-满减券，2-折扣券，3-代金券)
    discountValue: BigDecimal // 优惠额度
    minOrderAmount: BigDecimal// 最低订单金额
    validDays: Integer        // 有效天数
    totalCount: Integer       // 发放总量
    perUserLimit: Integer     // 每人限领
    createdAt: LocalDateTime  // 创建时间
}

RedPacket {
    id: Integer               // 主键
    name: String              // 红包名称
    totalAmount: BigDecimal   // 总金额
    totalCount: Integer       // 总个数
    remainCount: Integer      // 剩余个数
}
```

### 3.7 用户模块

**功能描述**：用户注册、登录、信息管理、钱包管理

**用户端接口**：
- `LoginController` - 用户登录
- `RegisterController` - 用户注册
- `UserWalletController` - 钱包管理（积分、优惠券、红包）
- `SelectOwnMessageController` - 个人信息查询
- `UpdateOwnMessageController` - 个人信息修改

**核心服务**：
```java
UserLoginServiceImpl.login() {
    1. 校验用户名密码（非空、长度 3-20/3-30）
    2. 查询用户信息
    3. 生成 JWT Token
    4. 返回 token 和用户信息
}

UserRegisterServiceImpl.register() {
    1. 创建 User 实体
    2. 设置用户类型 (UserType)
    3. 插入数据库
}
```

**实体设计**：
```java
User {
    id: Integer               // 主键 (自增)
    username: String          // 用户名
    password: String          // 密码
    email: String             // 邮箱
    phone: String             // 手机号
    userType: UserType        // 用户类型 (枚举)
    avatarPath: String        // 头像路径
    createdTime: LocalDateTime// 创建时间
    updatedTime: LocalDateTime// 更新时间
}
```

### 3.8 系统日志模块

**功能描述**：记录系统操作日志

**实体设计**：
```java
SystemLog {
    logId: Integer            // 主键
    operation: String         // 操作描述
    method: String            // 请求方法
    params: String            // 请求参数
    time: Long                // 执行时间 (ms)
    ip: String                // IP 地址
    createTime: LocalDateTime // 创建时间
}
```

---

## 四、技术实现

### 4.1 安全认证

**JWT Token 认证**：
- 使用 `JwtTokenUtil` 工具类生成和解析 Token
- Token 有效期由配置文件 `jwt.token.expired` 控制（默认 36000000 毫秒）
- 密钥采用 HS256 算法，随机生成

**登录拦截器**：
```java
LoginInterceptor.preHandle() {
    1. 从请求头获取 token
    2. 使用 JwtTokenUtil 解析验证
    3. 验证失败返回 {"state": -1, "message": "未登录或者登录已过期"}
    4. 验证成功放行
}
```

### 4.2 统一响应格式

```java
JsonResult<T> {
    state: int      // 0-成功，>0-失败，-1-登录过期
    message: String // 提示信息
    data: T         // 返回数据
}
```

**常用方法**：
- `JsonResult.success(data)` - 成功返回
- `JsonResult.success(message, data)` - 带消息成功返回
- `JsonResult.fail(message)` - 失败返回

### 4.3 分页查询

使用 PageHelper 插件实现分页：
```java
PageHelper.startPage(pageNum, pageSize);
List<T> list = mapper.selectXXX(...);
PageInfo<T> pageInfo = new PageInfo<>(list);
```

### 4.4 事务管理

商城下单等关键业务使用 `@Transactional` 注解保证数据一致性：
```java
@Transactional(rollbackFor = Exception.class)
public JsonResult createOrder(...) {
    // 1. 创建订单主表
    // 2. 创建订单商品明细
    // 3. 创建收货地址
    // 任何一步失败都会回滚
}
```

### 4.5 时间处理

- 使用 `LocalDateTime` 进行时间操作
- 使用 `DateTimeFormatter` 格式化时间（pattern: "yyyy-MM-dd HH:mm:ss"）
- 数据库时间字段统一使用 `created_time`、`updated_time`

---

## 五、数据库设计

### 5.1 核心表结构

| 表名 | 说明 | 主键 | 主要字段 |
|-----|------|------|---------|
| `charging_stations` | 充电桩信息表 | station_id (AUTO) | station_name, location, status, power_rating, price_per_hour, created_time, updated_time |
| `orders` | 充电订单表 | order_id | user_id, station_id, start_time, end_time, duration_minutes, total_amount, payment_status, order_status, created_time |
| `payments` | 支付记录表 | payment_id | order_id, user_id, amount, payment_method, payment_status, payment_time |
| `reservation` | 预约记录表 | reservation_id (AUTO) | user_id, station_id, reserved_start_time, reserved_end_time, status, created_at |
| `users` | 用户信息表 | user_id (AUTO) | username, password, email, phone, user_type, avatar_path, created_time, updated_time |
| `admin` | 管理员表 | admin_id (AUTO) | username, password, role, created_time |
| `goods_items` | 商城商品表 | id (ASSIGN_ID) | order_id, product_id, product_name, price, quantity, total_price |
| `goods_orders` | 商城订单表 | id (ASSIGN_ID) | user_id, order_no, order_status, order_type, total_amount, pay_amount, create_time |
| `goods_order_address` | 订单地址表 | id (ASSIGN_ID) | order_id, detail_address, receiver_name, receiver_phone, bing_location |
| `coupon_template` | 优惠券模板表 | id (ASSIGN_ID) | name, type, discount_value, min_order_amount, valid_days, total_count, per_user_limit, created_at |
| `user_coupon` | 用户优惠券表 | id (ASSIGN_ID) | user_id, coupon_id, status, use_time |
| `red_packet` | 红包表 | id (AUTO) | name, total_amount, total_count, remain_count |
| `user_red_packet` | 用户红包表 | id (ASSIGN_ID) | user_id, red_packet_id, status, use_time |
| `user_points` | 用户积分表 | id (ASSIGN_ID) | user_id, points, total_earned |
| `points_record` | 积分记录表 | id (ASSIGN_ID) | user_id, points, type, description, create_time |
| `system_log` | 系统日志表 | log_id (AUTO) | operation, method, params, time, ip, create_time |

---

## 六、接口规范

### 6.1 统一响应格式

```json
{
  "state": 0,
  "message": "操作成功",
  "data": {}
}
```

**状态码说明**：
- `0` - 操作成功
- `1` / 其他正数 - 操作失败
- `-1` - 未登录或登录过期

### 6.2 接口路径规范

| 模块 | 基础路径 | 端口 |
|-----|---------|------|
| 管理端 | `/admin` | 8081 |
| 用户端 | `/user` | 8080 |

---

## 七、项目部署

### 7.1 环境要求
- JDK 17+
- MySQL 8.0+
- Maven 3.6+

### 7.2 启动步骤

1. **导入数据库**
   ```sql
   CREATE DATABASE campus_charging_station;
   USE campus_charging_station;
   -- 执行 SQL 脚本导入表结构
   ```

2. **修改配置文件**
   - 修改 `application.yml` 中的数据库连接信息
   - 配置文件上传路径

3. **启动项目**
   ```bash
   # 启动用户端
   cd user
   mvn spring-boot:run
   
   # 启动管理端
   cd admin
   mvn spring-boot:run
   ```

4. **访问地址**
   - 用户端：http://localhost:8080/user
   - 管理端：http://localhost:8081/admin

---

## 八、项目总结

### 8.1 已完成功能
- ✅ 充电桩管理（增删改查、状态管理）
- ✅ 充电桩查询（按位置、按状态）
- ✅ 预约系统（预约、取消、查询）
- ✅ 充电订单管理
- ✅ 支付记录管理
- ✅ 积分商城（商品下单、订单管理）
- ✅ 营销模块（优惠券、红包）
- ✅ 用户管理（注册、登录、信息管理）
- ✅ 钱包管理（积分、优惠券、红包查询）
- ✅ 系统日志记录
- ✅ JWT 身份认证
- ✅ 登录拦截器

### 8.2 技术特点
- 采用 Spring Boot 3.5.9 最新框架
- 使用 MyBatis-Plus 简化数据库操作
- JWT 无状态认证，支持分布式部署
- 统一响应格式，便于前端处理
- 事务管理保证数据一致性
- 分页查询优化大数据量展示

---

**项目名称**：校园充电桩管理系统  
**技术栈**：Spring Boot 3.5.9 + MyBatis-Plus 3.5.15 + MySQL 8.0 + JWT  
**JDK 版本**：JDK 17  
**开发时间**：2024 年  
**项目状态**：开发中
