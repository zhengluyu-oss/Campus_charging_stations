## Why

项目目前没有数据库建表脚本，新环境部署需要手动建表。需要实现自动初始化：应用启动时检查数据库表是否存在，缺失则自动执行建表脚本，确保开箱即用。

## What Changes

- 创建 SQL 建表脚本（包含所有 8 张表和初始数据）
- 利用 Spring Boot 的 `spring.sql.init` 机制实现启动时自动执行
- 脚本使用 `CREATE TABLE IF NOT EXISTS` 确保幂等性

## Capabilities

### New Capabilities
- `database-auto-init`: 数据库启动时自动建表

### Modified Capabilities

## Impact

- `backend/common/src/main/resources/schema.sql` — 建表脚本（新建）
- `backend/common/src/main/resources/data.sql` — 初始数据（新建）
- `backend/admin/src/main/resources/application.yml` — 添加 SQL init 配置
- `backend/user/src/main/resources/application.yml` — 添加 SQL init 配置
