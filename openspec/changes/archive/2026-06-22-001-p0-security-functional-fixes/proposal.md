# 001-p0-security-functional-fixes

## 为什么做

审计报告发现 4 个 P0 级问题，涉及安全漏洞和功能失效：
1. JWT 密钥硬编码 → 任意用户可伪造 Token
2. 数据库密码硬编码 `123456` → 误部署即暴露
3. cancelOrder 空操作 → 取消订单功能完全失效
4. paymentStatus 语义错误 → 订单支付状态混乱

## 影响范围

| 模块 | 影响文件 |
|------|---------|
| backend/common | JwtTokenInitializer.java, Orders.java, OrderMapper.xml |
| backend/admin | application.yml |
| backend/user | application.yml, ChargingStationOrderServiceImpl.java, ChargingAsyncService.java |
| 数据库 | orders 表新增 order_status 字段 |
| .gitignore | 新增 application-dev.yml 排除规则 |
