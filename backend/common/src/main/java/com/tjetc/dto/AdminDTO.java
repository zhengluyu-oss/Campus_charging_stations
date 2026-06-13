package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 管理员DTO类
 * 用于前端与后端之间的管理员数据传输
 */
@Data
public class AdminDTO {
    /**
     * 管理员ID
     */
    @Schema(description = "管理员ID", example = "1")
    private Integer id;
    
    /**
     * 用户名
     */
    @Schema(description = "用户名", example = "admin")
    private String username;
    
    /**
     * 密码
     */
    @Schema(description = "密码", example = "123456")
    private String password;
    
    /**
     * 头像路径
     */
    @Schema(description = "头像路径", example = "/avatar/admin.jpg")
    private String avatarPath;
    
    /**
     * 邮箱
     */
    @Schema(description = "邮箱", example = "admin@example.com")
    private String email;
    
    /**
     * 手机号
     */
    @Schema(description = "手机号", example = "13800138000")
    private String telephone;
    
    /**
     * QQ
     */
    @Schema(description = "QQ", example = "123456")
    private String qq;
    
    /**
     * 创建时间
     */
    @Schema(description = "创建时间", example = "2024-01-01T00:00:00")
    private String createTime;
    
    /**
     * 更新时间
     */
    @Schema(description = "更新时间", example = "2024-01-01T00:00:00")
    private String updateTime;
}