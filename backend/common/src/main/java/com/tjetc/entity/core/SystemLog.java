package com.tjetc.entity.core;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 系统日志实体类，对应数据库 system_logs 表
 */
@Data
@TableName("system_logs") // 实体名（SystemLog）与表名（system_logs）不一致，必须显式指定
public class SystemLog {
    /**
     * 日志ID，主键，自动递增
     */
    @TableId(type = IdType.AUTO)
    private Integer logId;

    /**
     * 用户ID，外键关联 users 表的 user_id，可为null（对应 ON DELETE SET NULL）
     */
    private Integer userId;

    /**
     * 操作类型（如：新增用户、更新充电桩状态、用户登录等）
     */
    private String action;

    /**
     * 操作详情（存储具体的操作内容，如："更新充电桩ID=1的状态为maintenance"）
     */
    private String details;

    /**
     * 操作IP地址
     */
    private String ipAddress;

    /**
     * 日志创建时间，默认当前时间
     */
    private LocalDateTime createdAt;


}