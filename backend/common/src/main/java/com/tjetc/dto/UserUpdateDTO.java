package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 用户更新DTO类
 * 用于用户更新个人信息时的数据传输，不包含createdTime和updatedTime字段
 */
@Data
public class UserUpdateDTO {
    /**
     * 用户ID
     */
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    /**
     * 用户名
     */
    @Schema(description = "用户名", example = "student001")
    private String username;
    
    /**
     * 用户密码
     */
    @Schema(description = "用户密码", example = "password123")
    private String password;
    
    /**
     * 用户头像路径
     */
    @Schema(description = "用户头像路径", example = "/avatar/student.jpg")
    private String avatarPath;
    
    /**
     * 邮箱
     */
    @Schema(description = "邮箱", example = "student@example.com")
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
}
