package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class AdminIdDTO {
    @Schema(description = "管理员ID", example = "1")
    private Integer id;
}
