-- ============================================================
-- 校园充电桩管理系统 - 初始数据脚本
-- 说明: 使用 INSERT IGNORE 避免重复插入
-- ============================================================

USE campus_charging_station;

-- ============================================================
-- 默认管理员账号 (密码: admin123456, BCrypt加密)
-- ============================================================
INSERT IGNORE INTO admin (id, username, password, email) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 'admin@campus.com');

-- ============================================================
-- 示例充电桩数据
-- ============================================================
INSERT IGNORE INTO charging_stations (station_id, station_name, location, status, power_rating, price_per_hour) VALUES
(1, '校园北区充电站', '北区教学楼旁', 'available', 60.0, 1.50),
(2, '宿舍区充电站', '学生宿舍楼下', 'available', 30.0, 1.20),
(3, '图书馆充电站', '图书馆东侧', 'available', 60.0, 1.50),
(4, '体育馆充电站', '体育馆停车场', 'maintenance', 120.0, 2.00),
(5, '南门充电站', '南门停车场', 'available', 60.0, 1.50);
