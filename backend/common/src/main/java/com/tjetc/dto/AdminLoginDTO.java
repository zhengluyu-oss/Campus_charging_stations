package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class AdminLoginDTO {
    @Schema(description = "用户名", example = "admin")
    private String username;
    
    @Schema(description = "密码", example = "admin123")
    private String password;
}