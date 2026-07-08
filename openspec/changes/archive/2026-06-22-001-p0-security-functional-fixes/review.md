# 代码复审报告：001-p0-security-functional-fixes

**复审日期**: 2026-06-22
**复审结果**: 通过（Critical/Important 已修复）

---

## Critical 级别（已修复）

### C-1: schema.sql 未同步新增 order_status 列 ✅ 已修复
- **修复**: 在 schema.sql 的 CREATE TABLE orders 中添加 `order_status VARCHAR(20) NOT NULL DEFAULT 'pending'`

### C-2: V001 迁移脚本缺少幂等保护 ✅ 已修复
- **修复**: 改用 `ALTER TABLE orders ADD COLUMN IF NOT EXISTS order_status`，并添加注释说明仅在已有数据库上执行

## Important 级别（已修复）

### I-1: cancelOrder 缺少用户归属校验 ✅ 已修复
- **修复**: 添加 `AuthUtils.resolveUserId(null)` 获取当前用户，与 `order.getUserId()` 比较

### I-2: schema.sql 与实体不一致 ✅ 已修复
- **修复**: 同 C-1

### I-3: 缺乏环境变量说明文档 ✅ 已修复
- **修复**: 创建 `.env.example` 模板文件

## Minor 级别（记录，后续迭代处理）

| 编号 | 问题 | 处理 |
|------|------|------|
| M-1 | application.yml 保留硬编码本地路径 | 后续迭代修复 |
| M-2 | JwtTokenInitializer 硬编码开发密钥字符串 | 可接受风险 |
| M-3 | V001 注释与实际不一致 | 已更新注释 |
| M-4 | createOrder 未显式设置 orderStatus ✅ | 已修复 |
| M-5 | Redis database 编号不一致 | 后续确认是否有意设计 |
