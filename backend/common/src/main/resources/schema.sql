-- ============================================================
-- 校园充电桩管理系统 - 数据库建表脚本
-- 数据库: campus_charging_station
-- 说明: 使用 CREATE TABLE IF NOT EXISTS 确保幂等性
-- ============================================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS campus_charging_station
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE campus_charging_station;

-- ============================================================
-- 1. 用户表 (users)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码（BCrypt加密）',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    phone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    user_type VARCHAR(20) DEFAULT 'student' COMMENT '用户类型',
    avatar_path VARCHAR(500) DEFAULT NULL COMMENT '头像路径',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================================
-- 2. 管理员表 (admin)
-- ============================================================
CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '管理员ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码（BCrypt加密）',
    avatar_path VARCHAR(500) DEFAULT NULL COMMENT '头像路径',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    telephone VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    qq VARCHAR(30) DEFAULT NULL COMMENT 'QQ号',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员表';

-- ============================================================
-- 3. 充电桩表 (charging_stations)
-- ============================================================
CREATE TABLE IF NOT EXISTS charging_stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '充电桩ID',
    station_name VARCHAR(100) NOT NULL COMMENT '站点名称',
    location VARCHAR(200) DEFAULT NULL COMMENT '位置信息',
    status VARCHAR(20) DEFAULT 'available' COMMENT '状态(available/occupied/maintenance)',
    power_rating DOUBLE DEFAULT NULL COMMENT '额定功率(kW)',
    price_per_hour DOUBLE DEFAULT NULL COMMENT '每小时价格(元)',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='充电桩表';

-- ============================================================
-- 4. 订单表 (orders)
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '订单ID',
    user_id INT DEFAULT NULL COMMENT '用户ID',
    station_id INT DEFAULT NULL COMMENT '充电桩ID',
    start_time DATETIME DEFAULT NULL COMMENT '开始时间',
    end_time DATETIME DEFAULT NULL COMMENT '结束时间',
    duration_minutes INT DEFAULT NULL COMMENT '充电时长(分钟)',
    total_amount DOUBLE DEFAULT NULL COMMENT '总金额(元)',
    payment_status VARCHAR(20) DEFAULT 'unpaid' COMMENT '支付状态(unpaid/paid/refunded)',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    KEY idx_user_id (user_id),
    KEY idx_station_id (station_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='充电订单表';

-- ============================================================
-- 5. 支付记录表 (payments)
-- ============================================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '支付ID',
    order_id INT DEFAULT NULL COMMENT '订单ID',
    amount DOUBLE DEFAULT NULL COMMENT '支付金额(元)',
    payments_method VARCHAR(30) DEFAULT NULL COMMENT '支付方式',
    payments_status VARCHAR(20) DEFAULT 'pending' COMMENT '支付状态(pending/success/failed)',
    paid_time DATETIME DEFAULT NULL COMMENT '支付时间',
    KEY idx_order_id (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付记录表';

-- ============================================================
-- 6. 预约表 (reservations)
-- ============================================================
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '预约ID',
    user_id INT DEFAULT NULL COMMENT '用户ID',
    station_id INT DEFAULT NULL COMMENT '充电桩ID',
    reserved_start_time DATETIME DEFAULT NULL COMMENT '预约开始时间',
    reserved_end_time DATETIME DEFAULT NULL COMMENT '预约结束时间',
    status VARCHAR(20) DEFAULT 'confirmed' COMMENT '状态(confirmed/used/cancelled)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    KEY idx_user_id (user_id),
    KEY idx_station_id (station_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预约表';

-- ============================================================
-- 7. 新闻表 (news)
-- ============================================================
CREATE TABLE IF NOT EXISTS news (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '新闻ID',
    title VARCHAR(200) NOT NULL COMMENT '标题',
    content TEXT COMMENT '内容',
    category_id INT DEFAULT NULL COMMENT '分类ID',
    image_url VARCHAR(500) DEFAULT NULL COMMENT '图片URL',
    publish_date DATE DEFAULT NULL COMMENT '发布日期',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    news_category VARCHAR(50) DEFAULT NULL COMMENT '新闻分类'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='新闻表';

-- ============================================================
-- 8. 系统日志表 (system_logs)
-- ============================================================
CREATE TABLE IF NOT EXISTS system_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
    user_id INT DEFAULT NULL COMMENT '用户ID',
    action VARCHAR(100) DEFAULT NULL COMMENT '操作类型',
    details TEXT COMMENT '操作详情',
    ip_address VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    KEY idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统日志表';
