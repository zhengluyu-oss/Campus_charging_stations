package com.tjetc.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.entity.core.SystemLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 对应数据库 system_logs 表，系统日志数据访问接口
 */
@Mapper
public interface SystemLogMapper extends BaseMapper<SystemLog> {
    /**
     * 1. 按用户ID分页查询（关联 users 表外键 user_id）
     */
    IPage<SystemLog> selectPageByUserId(Page<SystemLog> page, @Param("userId") Integer userId);

    /**
     * 2. 按操作类型分页查询
     */
    IPage<SystemLog> selectPageByAction(Page<SystemLog> page, @Param("action") String action);

    /**
     * 3. 按时间范围查询日志记录
     */
    List<SystemLog> selectByTimeRange(@Param("startTime") LocalDateTime startTime, @Param("endTime") LocalDateTime endTime);

    /**
     * 4. 按IP地址查询日志记录
     */
    List<SystemLog> selectByIpAddress(@Param("ipAddress") String ipAddress);

    List<SystemLog> selectByUserId(Integer userId);

    List<SystemLog> selectByAction(String s);
}