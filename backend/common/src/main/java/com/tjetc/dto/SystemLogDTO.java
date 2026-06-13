package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 系统日志DTO类
 * 用于前端与后端之间的系统日志数据传输
 */
@Data
public class SystemLogDTO {
    /**
     * 日志ID
     */
    @Schema(description = "日志ID", example = "1")
    private Integer logId;
    
    /**
     * 用户ID
     */
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    /**
     * 操作
     */
    @Schema(description = "操作", example = "登录")
    private String action;
    
    /**
     * 详情
     */
    @Schema(description = "详情", example = "用户admin登录系统")
    private String details;
    
    /**
     * IP地址
     */
    @Schema(description = "IP地址", example = "127.0.0.1")
    private String ipAddress;
    
    /**
     * 创建时间
     */
    @Schema(description = "创建时间", example = "2024-01-01T00:00:00")
    private String createdAt;
}