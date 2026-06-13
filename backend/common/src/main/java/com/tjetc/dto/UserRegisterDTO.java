package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 用户注册DTO类
 * 用于用户注册时的数据传输，不包含userId字段（由数据库自动生成）
 */
@Data
public class UserRegisterDTO {
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
