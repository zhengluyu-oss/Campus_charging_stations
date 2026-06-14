## 1. 创建建表脚本

- [x] 1.1 在 `backend/common/src/main/resources/` 创建 `schema.sql`：包含 8 张表的 `CREATE TABLE IF NOT EXISTS` 语句
- [x] 1.2 在 `backend/common/src/main/resources/` 创建 `data.sql`：包含默认管理员账号和示例充电桩数据（`INSERT IGNORE`）

## 2. 配置自动初始化

- [x] 2.1 修改 `backend/admin/src/main/resources/application.yml`：添加 `spring.sql.init` 配置
- [x] 2.2 修改 `backend/user/src/main/resources/application.yml`：添加 `spring.sql.init` 配置

## 3. 建表脚本内容（8 张表）

- [x] 3.1 `users` 表：user_id(AUTO), username, password, email, phone, user_type, avatar_path, created_time, updated_time
- [x] 3.2 `admin` 表：id(AUTO), username, password, avatar_path, email, telephone, qq, create_time, update_time
- [x] 3.3 `charging_stations` 表：station_id(AUTO), station_name, location, status, power_rating, price_per_hour, created_time, updated_time
- [x] 3.4 `orders` 表：order_id(AUTO), user_id, station_id, start_time, end_time, duration_minutes, total_amount, payment_status, created_time
- [x] 3.5 `payments` 表：payment_id(AUTO), order_id, amount, payments_method, payments_status, paid_time
- [x] 3.6 `reservations` 表：reservation_id(AUTO), user_id, station_id, reserved_start_time, reserved_end_time, status, created_at
- [x] 3.7 `news` 表：id(AUTO), title, content, category_id, image_url, publish_date, created_at, updated_at, news_category
- [x] 3.8 `system_logs` 表：log_id(AUTO), user_id, action, details, ip_address, created_at
