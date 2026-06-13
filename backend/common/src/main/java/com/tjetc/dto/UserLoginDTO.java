package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class UserLoginDTO {
    @Schema(description = "用户名", example = "user123")
    private String username;
    
    @Schema(description = "密码", example = "password123")
    private String password;
}
