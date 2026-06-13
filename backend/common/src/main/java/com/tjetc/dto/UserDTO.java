package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 用户DTO类
 * 用于前端与后端之间的用户数据传输
 */
@Data
public class UserDTO {
    /**
     * 用户ID
     */
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    /**
     * 用户名
     */
    @Schema(description = "用户名", example = "admin")
    private String username;
    
    /**
     * 用户密码
     */
    @Schema(description = "用户密码", example = "123456")
    private String password;
    
    /**
     * 用户头像路径
     */
    @Schema(description = "用户头像路径", example = "/avatar/admin.jpg")
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
    private String phone;
    
    /**
     * 用户类型
     */
    @Schema(description = "用户类型", example = "student")
    private String userType;
    
    /**
     * 创建时间
     */
    @Schema(description = "创建时间", example = "2024-01-01T00:00:00")
    private String createdTime;
    
    /**
     * 更新时间
     */
    @Schema(description = "更新时间", example = "2024-01-01T00:00:00")
    private String updatedTime;
}