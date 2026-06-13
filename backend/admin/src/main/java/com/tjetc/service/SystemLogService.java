package com.tjetc.service;

import com.tjetc.common.JsonResult;
import com.tjetc.entity.core.SystemLog;

import java.time.LocalDateTime;

public interface SystemLogService {
    /**
     * 查询所有系统日志
     *
     * @return 统一响应结果
     */
    JsonResult<SystemLog> findAll();

    /**
     * 新增系统日志
     *
     * @param systemLog 系统日志实体
     * @return 统一响应结果
     */
    JsonResult add(SystemLog systemLog);

    /**
     * 按用户ID分页查询系统日志
     *
     * @param pageNum  页码
     * @param pageSize 每页数量
     * @param userId   用户ID
     * @return 统一响应结果
     */
    JsonResult findPageByUserId(Integer pageNum, Integer pageSize, Integer userId);

    /**
     * 按操作类型分页查询系统日志
     *
     * @param pageNum  页码
     * @param pageSize 每页数量
     * @param action   操作类型
     * @return 统一响应结果
     */
    JsonResult findPageByAction(Integer pageNum, Integer pageSize, String action);

    /**
     * 按时间范围查询系统日志
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @return 统一响应结果
     */
    JsonResult findByTimeRange(LocalDateTime startTime, LocalDateTime endTime);

    /**
     * 根据日志ID查询系统日志信息
     *
     * @param id 日志ID
     * @return 统一响应结果
     */
    JsonResult findById(Integer id);

    /**
     * 根据日志ID删除系统日志
     *
     * @param id 日志ID
     * @return 统一响应结果
     */
    JsonResult deleteById(Integer id);
}