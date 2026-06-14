## Context

项目使用 Spring Boot 3.5.9 + MyBatis-Plus + MySQL 8.0，数据库名 `campus_charging_station`。当前没有建表脚本，新环境需要手动建库建表。共 8 张表需要创建。

实体类与表的对应关系：
| 实体类 | 表名 | 主键 |
|--------|------|------|
| User | users | user_id (AUTO) |
| Admin | admin | id (AUTO) |
| ChargingStation | charging_stations | station_id (AUTO) |
| Orders | orders | order_id (AUTO) |
| Payments | payments | payment_id (AUTO) |
| Reservation | reservations | reservation_id (AUTO) |
| News | news | id (AUTO) |
| SystemLog | system_logs | log_id (AUTO) |

## Goals / Non-Goals

**Goals:**
- 创建完整的建表 SQL 脚本
- 应用启动时自动检查并建表
- 包含默认管理员账号和示例充电桩数据
- 脚本幂等（可重复执行不报错）

**Non-Goals:**
- 不做数据库迁移工具（如 Flyway/Liquibase）
- 不修改现有实体类

## Decisions

### 使用 Spring Boot 内置的 spring.sql.init 机制

**决定**: 在 `application.yml` 中配置 `spring.sql.init`，使用 `schema.sql` 和 `data.sql`。

**原因**: Spring Boot 原生支持，无需额外依赖，配置简单。

**配置方式**:
```yaml
spring:
  sql:
    init:
      mode: always
      schema-locations: classpath:schema.sql
      data-locations: classpath:data.sql
      continue-on-error: true
```

- `mode: always` — 每次启动都执行
- `continue-on-error: true` — 忽略已存在表的错误（兼容手动建过表的情况）
- SQL 脚本使用 `CREATE TABLE IF NOT EXISTS` 确保幂等
- SQL 脚本使用 `INSERT IGNORE` 避免重复数据

### SQL 脚本放在 common 模块

**决定**: `schema.sql` 和 `data.sql` 放在 `backend/common/src/main/resources/`。

**原因**: admin 和 user 模块都依赖 common，放在这里两个模块都能自动加载。
