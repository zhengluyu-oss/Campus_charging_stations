-- ============================================================
-- V002: 统一充电桩状态值为语义化字符串
-- 将历史数据中的数字状态 ('0'/'1') 转换为语义化值
-- 与 schema.sql 定义的 VARCHAR(20) 兼容（available/occupied/maintenance）
-- ============================================================

-- 将数字 '0' 转换为 'available'（空闲）
UPDATE charging_stations
SET status = 'available'
WHERE status = '0';

-- 将数字 '1' 转换为 'occupied'（使用中）
UPDATE charging_stations
SET status = 'occupied'
WHERE status = '1';

-- 确保默认值一致
ALTER TABLE charging_stations
MODIFY COLUMN status VARCHAR(20) DEFAULT 'available'
    COMMENT '状态(available/occupied/maintenance)';
