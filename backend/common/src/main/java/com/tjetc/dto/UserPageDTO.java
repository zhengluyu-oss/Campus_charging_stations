package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class UserPageDTO {
    @Schema(description = "页码", example = "1")
    private Integer pageNum;
    
    @Schema(description = "每页数量", example = "10")
    private Integer pageSize;
    
    @Schema(description = "用户名", example = "user123")
    private String username;
}
