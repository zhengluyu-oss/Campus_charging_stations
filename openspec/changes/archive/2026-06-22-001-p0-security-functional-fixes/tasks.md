# 001-p0-security-functional-fixes 任务清单

## P0-01 + P0-05：敏感信息外部化

- [x] 1.1 移除 admin/application.yml 中 DB_PASSWORD、REDIS_PASSWORD、JWT_SECRET 的硬编码默认值
- [x] 1.2 移除 user/application.yml 中 DB_PASSWORD、REDIS_PASSWORD、JWT_SECRET 的硬编码默认值
- [x] 1.3 修改 JwtTokenInitializer.java：添加启动校验，secret 为空或等于旧默认值时抛异常
- [x] 1.4 创建 admin/src/main/resources/application-dev.yml（开发环境配置，含本地默认值）
- [x] 1.5 创建 user/src/main/resources/application-dev.yml（开发环境配置，含本地默认值）
- [x] 1.6 .gitignore 添加 application-dev.yml

## P0-08：修复 cancelOrder

- [x] 2.1 数据库执行 ALTER TABLE orders ADD COLUMN order_status（SQL 脚本: db/migration/V001__add_order_status.sql）
- [x] 2.2 Orders.java 新增 orderStatus 字段
- [x] 2.3 OrderMapper.xml 的 updateById 添加 orderStatus 动态更新
- [x] 2.4 重写 ChargingStationOrderServiceImpl.cancelOrder 方法

## P0-09：修复 paymentStatus 语义

- [x] 3.1 修改 ChargingAsyncService.createOrder：paymentStatus 从 "微信支付" 改为 "unpaid"
- [x] 3.2 检查前端代码中对 paymentStatus 的判断逻辑是否需要适配（已确认：前端无引用 "微信支付"）

## 验证

- [ ] 4.1 不设环境变量启动后端，验证报错信息
- [ ] 4.2 设置正确环境变量启动后端，验证正常
- [ ] 4.3 调用 cancelOrder 接口验证数据库 order_status 变为 cancelled
- [ ] 4.4 新建订单验证 payment_status 为 unpaid
