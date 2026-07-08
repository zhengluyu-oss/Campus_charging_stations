-- V001: orders 表新增 order_status 字段
-- 修复 P0-08: cancelOrder 空操作问题
-- 执行方式: 在 MySQL 中手动执行
-- 前置条件: 仅在已有数据库上执行，新建库已包含在 schema.sql 中

-- MySQL 8.0+ 支持 IF NOT EXISTS
ALTER TABLE orders
ADD COLUMN IF NOT EXISTS order_status VARCHAR(20) NOT NULL DEFAULT 'pending'
COMMENT '订单状态: pending-待处理, charging-充电中, completed-已完成, cancelled-已取消';

-- 根据已有 payment_status 推断历史数据的 order_status（仅影响已有数据）
UPDATE orders SET order_status = 'completed' WHERE payment_status = 'paid' AND order_status = 'pending';
UPDATE orders SET order_status = 'pending' WHERE payment_status NOT IN ('paid') AND order_status = 'pending';
