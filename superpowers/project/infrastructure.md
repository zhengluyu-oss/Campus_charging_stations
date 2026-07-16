# 数据模型与基础设施

---

## 第一部分：数据模型

### 数据库实例信息

| 参数 | 值 |
|------|-----|
| 数据库名 | `campus_charging_station` |
| DBMS | MySQL 8.0 |
| 存储引擎 | InnoDB（未显式指定，默认） |
| 字符集 | utf8mb4（部分表显式指定） |
| 连接 URL | `jdbc:mysql://localhost:3306/campus_charging_station?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai` |
| 驱动 | `com.mysql.cj.jdbc.Driver` |

（来源：`backend/*/src/main/resources/application.yml`）

### 数据整体介绍

业务数据分为两大域：

**核心业务域**（7 张表）：
- `users` + `admin` — 用户/管理员账号
- `charging_stations` — 充电桩资产
- `orders` — 充电订单
- `payments` — 支付记录
- `reservations` — 预约记录
- `system_logs` — 系统操作日志

**积分商城域**（9 张表，实体类待补充）：
- `user_points` — 用户积分
- `points_record` — 积分变动记录
- `coupon_template` — 优惠券模板
- `user_coupon` — 用户优惠券
- `red_packet` — 红包模板
- `user_red_packet` — 用户红包
- `goods_items` — 商品明细
- `goods_orders` — 商城订单
- `goods_order__addresses` — 收货地址快照

**读写特征**：读远大于写（充电桩查询、订单历史 >> 创建订单/预约）、充电计时为异步写入

---

### 表详解

#### 1. `users` — 用户表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| user_id | INT | PK AUTO_INCREMENT | 用户 ID |
| username | VARCHAR(50) | UNIQUE NOT NULL | 用户名 |
| password | VARCHAR(255) | NOT NULL | 密码（BCrypt） |
| avatar_path | VARCHAR(500) | | 头像路径 |
| email | VARCHAR(100) | | 邮箱 |
| phone | VARCHAR(20) | CHECK (REGEXP) | 手机号（11 位数字校验） |
| user_type | ENUM('student','teacher') | DEFAULT 'student' | 用户类型 |
| created_time | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_time | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |

**初始数据**：3 条记录（郑陆宇/学生、张三东风/学生、老马是式/教师）
**实体类**：`User.java` (`entity/userAndAdmin/User.java`)
**Mapper**：`UserMapper.java`

#### 2. `charging_stations` — 充电桩表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| station_id | INT | PK AUTO_INCREMENT | 充电桩 ID |
| station_name | VARCHAR(100) | UNIQUE NOT NULL | 充电桩名称 |
| location | VARCHAR(255) | NOT NULL | 位置（如"北院"） |
| status | VARCHAR(255) | | 状态（available/occupied/maintenance/offline） |
| power_rating | DECIMAL(5,2) | NOT NULL | 功率(kW) |
| price_per_hour | DECIMAL(10,2) | NOT NULL | 每小时价格(元) |
| created_time | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_time | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |

**初始数据**：16 条（4 个校区各 4 个充电桩，均 5.0kW、0.5 元/时）
**实体类**：`ChargingStation.java` (`entity/core/ChargingStation.java`)
**Mapper**：`ChargingStationsMapper.java`（含自定义 `updateStatusIfAvailable` CAS 更新、`selectByLocation`、`selectByStatus`、`selectLikeName`）

**状态枚举值**：0=available（空闲）、occupied（占用）、maintenance（维修）、offline（离线）

#### 3. `orders` — 订单表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| order_id | INT | PK AUTO_INCREMENT | 订单 ID |
| user_id | INT | FK→users.user_id CASCADE | 用户 ID |
| station_id | INT | FK→charging_stations.station_id CASCADE | 充电桩 ID |
| start_time | TIMESTAMP | NOT NULL | 开始时间 |
| end_time | TIMESTAMP | | 结束时间 |
| duration_minutes | INT | | 持续分钟数 |
| total_amount | DECIMAL(10,2) | | 总金额（元） |
| payment_status | ENUM('pending','paid','failed') | DEFAULT 'pending' | 支付状态 |
| order_status | ENUM('active','completed','cancelled') | DEFAULT 'active' | 订单状态/代码中用 'charging' |
| created_time | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

**实体类**：`Orders.java` (`entity/core/Orders.java`)
**Mapper**：`OrderMapper.java`（含 `selectPageByPaymentStatus`、`selectPageByUserId`、`selectPageByStationId`、`countOrderDataByTimeRange`）

**订单状态实际值**（代码中使用的值）：
- `"pending"` — 待充电（创建后默认）
- `"charging"` — 充电中
- `"completed"` — 已完成
- `"cancelled"` — 已取消

**支付状态实际值**：
- `"unpaid"` — 未支付（代码中创建订单时设置）
- `"pending"` — 待支付
- `"paid"` — 已支付
- `"failed"` — 支付失败

⚠️ **注意**：`orders` 表的 ENUM 定义与实际代码使用的状态值不完全一致。表定义为 `'active'/'completed'/'cancelled'`，但代码中使用了 `'charging'` 状态。这是已知的 schema/code 不一致。

#### 4. `payments` — 支付记录表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| payment_id | INT | PK AUTO_INCREMENT | 支付 ID |
| order_id | INT | FK→orders.order_id CASCADE | 订单 ID |
| amount | DECIMAL(10,2) | NOT NULL | 金额 |
| payments_method | ENUM('cash','creditCard','alipay','wechatPpay') | NOT NULL | 支付方式 |
| payments_status | ENUM('success','failed','refunded') | | 支付状态 |
| paid_time | TIMESTAMP | | 支付时间 |

**实体类**：`Payments.java` (`entity/core/Payments.java`)
**Mapper**：`PaymentsMapper.java`（含 `selectByOrderId`、`selectPageByPaymentStatus`、`selectPageByPaymentMethod`、`updatePaymentStatusAndTime`）

#### 5. `reservations` — 预约表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| reservation_id | INT | PK AUTO_INCREMENT | 预约 ID |
| user_id | INT | FK→users.user_id CASCADE | 用户 ID |
| station_id | INT | FK→charging_stations.station_id CASCADE | 充电桩 ID |
| reserved_start_time | TIMESTAMP | NOT NULL | 预约开始时间 |
| reserved_end_time | TIMESTAMP | NOT NULL | 预约结束时间 |
| status | VARCHAR(255) | | 状态（confirmed/used/cancelled） |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

**实体类**：`Reservation.java` (`entity/core/Reservation.java`)
**Mapper**：`ReservationMapper.java`（含 `selectPageByStatus`、`selectPageByUserId`、`selectPageByStationId`、`selectByTimeRangeAndStationId`、`selectActiveByUserId`）

**状态值**：`"confirmed"`（已确认）、`"used"`（已使用）、`"cancelled"`（已取消）

#### 6. `system_logs` — 系统日志表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| log_id | INT | PK AUTO_INCREMENT | 日志 ID |
| user_id | INT | FK→users.user_id SET NULL | 用户 ID |
| action | VARCHAR(100) | NOT NULL | 操作 |
| details | TEXT | | 详情 |
| ip_address | VARCHAR(45) | | IP 地址 |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

**实体类**：`SystemLog.java` (`entity/core/SystemLog.java`)
**Mapper**：`SystemLogMapper.java`

#### 7. `admin` — 管理员表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INT | PK AUTO_INCREMENT | 管理员 ID |
| username | VARCHAR(255) | NOT NULL | 用户名 |
| password | VARCHAR(255) | NOT NULL | 密码（BCrypt） |
| avatar_path | VARCHAR(255) | | 头像路径 |
| email | VARCHAR(255) | | 邮箱 |
| telephone | VARCHAR(255) | | 手机号 |
| qq | VARCHAR(255) | | QQ |
| create_time | DATETIME | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| update_time | DATETIME | ON UPDATE CURRENT_TIMESTAMP | 更新时间 |

**初始数据**：3 条记录
**实体类**：`Admin.java` (`entity/userAndAdmin/Admin.java`)
**Mapper**：`AdminMapper.java`（含 `selectByUsername`、`selectLikeUsername`）

#### 8. `user_points` — 用户积分表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | INT | PK AUTO_INCREMENT | |
| user_id | INT | FK→users.user_id | 用户 ID |
| points | INT | DEFAULT 0 | 积分数 |
| created_time | DATETIME | DEFAULT CURRENT_TIMESTAMP | |
| updated_time | DATETIME | ON UPDATE CURRENT_TIMESTAMP | |

**积分规则**：每充电 1 分钟获得 0.05 积分

#### 9. `points_record` — 积分变动记录表

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK AUTO_INCREMENT | |
| user_id | BIGINT | NOT NULL | |
| points_change | INT | NOT NULL | 变动值（正/负） |
| balance_after | INT | NOT NULL | 变动后余额 |
| reference_id | VARCHAR(64) | | 关联业务 ID |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP | |

#### 10-16. 积分商城表

| 表名 | 说明 | 核心字段 |
|------|------|----------|
| `coupon_template` | 优惠券模板 | type(1=满减/2=折扣/3=代金), discount_value, valid_days |
| `user_coupon` | 用户优惠券 | user_id, coupon_id, status(0=未用/1=已用/2=过期) |
| `red_packet` | 红包模板 | amount, min_charge, total_count, valid_days |
| `user_red_packet` | 用户红包 | user_id, packet_id, status(0=未用/1=已用/2=过期) |
| `goods_items` | 商品明细 | product_id, product_name, price, quantity |
| `goods_orders` | 商城订单 | order_no, order_status(0~6), total_amount, pay_amount |
| `goods_order__addresses` | 收货地址快照 | receiver_name, receiver_phone, detail_address |

（来源：`docs/数据库.md.md`）

⚠️ **注意**：积分商城 9 张表的 **Java 实体类和 Mapper 均未在代码中找到**，仅有 SQL 建表语句。商城功能待开发。

---

### ER 图

```
┌─────────┐       ┌──────────────────┐       ┌──────────┐
│  users  │──1:N─→│     orders       │←──N:1─│charging_ │
│ user_id │       │ order_id         │       │stations  │
└────┬────┘       │ user_id (FK)     │       │station_id│
     │            │ station_id (FK)  │       └─────┬────┘
     │1:N         │ payment_status   │             │
     │            │ order_status     │             │1:N
     │            └────────┬─────────┘             │
     │                     │1:1                    │
     │                     ▼                       │
     │            ┌──────────────────┐             │
     │            │    payments      │             │
     │            │ payment_id      │             │
     │            │ order_id (FK)   │             │
     │            └──────────────────┘             │
     │                                             │
     │1:N          ┌─────────────┐                 │1:N
     ├────────────→│reservations │←────────────────┤
     │             │reservation  │                 │
     │             │_id          │                 │
     │             │user_id(FK)  │                 │
     │             │station_id(FK)│                │
     │             │status       │                 │
     │             └─────────────┘                 │
     │                                             │
     │1:N          ┌──────────────┐                │
     └────────────→│ system_logs  │                │
                   │ log_id       │                │
                   │ user_id (FK) │                │
                   │ action       │                │
                   └──────────────┘                │
                                                   
┌─────────┐       ┌──────────────────┐
│ points  │       │ coupon_template  │
│_record  │       │ + user_coupon    │
│ user_id │       │ + red_packet     │
└─────────┘       │ + user_red_packet│
                   │                  │
┌─────────┐       │ goods_items      │
│ user_   │       │ + goods_orders   │
│ points  │       │ + goods_order__  │
│ user_id │       │   addresses      │
└─────────┘       └──────────────────┘
```

### 全表清单

| 序号 | 表名 | 域 | 行数（初始数据） | 实体类存在 |
|------|------|-----|-----------------|-----------|
| 1 | users | 核心 | 3 | ✅ `User.java` |
| 2 | charging_stations | 核心 | 16 | ✅ `ChargingStation.java` |
| 3 | orders | 核心 | 0 | ✅ `Orders.java` |
| 4 | payments | 核心 | 0 | ✅ `Payments.java` |
| 5 | reservations | 核心 | 0 | ✅ `Reservation.java` |
| 6 | system_logs | 核心 | 0 | ✅ `SystemLog.java` |
| 7 | admin | 核心 | 3 | ✅ `Admin.java` |
| 8 | user_points | 积分 | 0 | ❌ 未在代码中找到 |
| 9 | points_record | 积分 | 0 | ❌ 未在代码中找到 |
| 10 | coupon_template | 商城 | 0 | ❌ 未在代码中找到 |
| 11 | user_coupon | 商城 | 0 | ❌ 未在代码中找到 |
| 12 | goods_items | 商城 | 5 | ❌ 未在代码中找到 |
| 13 | goods_orders | 商城 | 0 | ❌ 未在代码中找到 |
| 14 | goods_order__addresses | 商城 | 0 | ❌ 未在代码中找到 |
| 15 | red_packet | 商城 | 0 | ❌ 未在代码中找到 |
| 16 | user_red_packet | 商城 | 0 | ❌ 未在代码中找到 |

### 命名规范

- 表名：全小写 + 下划线
- 主键：多为 `xxx_id`（orders 表主键为 `order_id`，但代码中 `@TableId` 映射）
- 时间字段：`created_time` / `updated_time` 或 `created_at` / `updated_at`（不统一）
- 外键：显式定义 ON DELETE CASCADE（除 system_logs 为 SET NULL）

---

## 第二部分：基础设施与运维

### 数据库连接与连接池

- 使用 Spring Boot 默认的 HikariCP 连接池
- 两个模块（admin + user）各自指定独立的数据源配置
- 连接参数：`useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true`
- 数据库自动初始化：`spring.sql.init.mode=always`（每次启动执行 schema.sql + data.sql）
- 两个模块都配置了同样的 `schema-locations` 和 `data-locations`

### Redis

| 参数 | admin 模块 | user 模块 |
|------|-----------|----------|
| Database | 1 | 3 |
| Host | `${REDIS_HOST}` | `${REDIS_HOST}` |
| Port | `${REDIS_PORT}` | `${REDIS_PORT}` |
| Password | `${REDIS_PASSWORD}` | `${REDIS_PASSWORD}` |

**使用情况**：目前仅 user 模块的充电计时使用 Redis ZSET（Key: `charging:timers`），用于存储正在充电的订单及其预计结束时间戳。

admin 模块虽配置了 Redis 连接但**未实际使用**。

### 文件存储

- 路径：由 `FILE_UPLOAD_PATH` 环境变量指定（或使用硬编码回退路径）
- 按日期分目录：`/image/20260101/uuid.jpg`
- 文件服务：Spring Boot 内置静态资源访问（配置 `spring.web.resources.static-locations` 指向外部目录）
- 安全机制：扩展名白名单（图片/视频/音频）+ MIME 类型校验 + UUID 重命名 + 路径遍历净化

### 日志

- 框架：SLF4J + Logback（Spring Boot 默认）
- 控制台：MyBatis SQL 日志输出 (`StdOutImpl`)
- 文件：由 `LOG_PATH` 环境变量控制
- 级别：开发环境 debug 级别（`AdminServiceImpl` 中使用 `log.debug()`）

### 定时任务

- **ChargingTimerScheduler**：`@Scheduled(fixedRate = 30000)`，每 30 秒扫描 Redis ZSET
- 默认 `@EnableScheduling` 在主应用开启（代码中未显式添加，需确认 `UserApplication.java` 是否有 `@EnableScheduling`——若未显式添加，可能需要检查配置）

### 部署架构

**当前**：开发/演示环境
- JAR 包直启（`mvn spring-boot:run`）
- Vite 开发服务器做前端代理（非生产架构）
- MySQL + Redis 本地运行

**预计生产**（根据项目结构推断）：
- 后端打包为 JAR → 部署到服务器
- 前端 `npm run build` → 静态文件托管（Nginx 或 CDN）
- Nginx 反向代理处理跨域和静态资源

### 构建与打包命令

```bash
# 后端构建
cd backend
mvn clean install -DskipTests

# 前端构建（用户端）
cd frontend
npm run build    # 输出到 dist/ 目录

# 前端构建（管理端）
cd admin-frontend
npm run build    # 输出到 dist/ 目录

# 鸿蒙端构建
cd harmonyos
# 使用 DevEco Studio 或 hvigor 构建
```

### 安全清单

| 项目 | 状态 | 详情 |
|------|------|------|
| CORS | 未配置 | 依赖 Vite Proxy 同源访问 |
| 密钥管理 | 环境变量 | JWT_SECRET、DB_PASSWORD、REDIS_PASSWORD 通过环境变量注入 |
| 环境隔离 | 存在 `application-dev.yml` | 但未区分 dev/prod 配置（sql.init.mode=always 不适合生产） |
| 密码加密 | BCrypt | A 类密码 BCrypt 加密存储；B 类初始数据为明文 |
| Token 过期 | 30 分钟 | Access Token + Refresh Token 双机制 |
| 文件上传安全 | 白名单+MIME+UUID | 扩展名白名单 + MIME 类型校验 + 路径遍历防护 |
| SQL 注入防护 | MyBatis-Plus | 参数化查询（部分 XML 需确认 $ 符号使用） |
| XSS 防护 | 部分 | 根 package.json 含 `dompurify` 依赖 |
| 敏感信息泄露 | 有风险 | 部分接口未脱敏返回密码字段 |

### 第三方服务依赖

| 服务 | 用途 | 状态 |
|------|------|------|
| MediaPipe CDN | 手部追踪模型 | 前端 index.html 引用 CDN |
| SpringDoc / Swagger | API 文档 UI | 内嵌在应用中 |
| MySQL 8.0 | 主数据库 | 本地运行 |
| Redis | 充电计时持久化 | 本地运行 |

> 来源：所有 `application.yml` 文件、`docs/数据库.md.md`、所有 Entity/Mapper 文件、`FileUploadUtils.java`、`JwtTokenUtil.java`
