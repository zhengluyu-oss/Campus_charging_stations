package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class OrderCountDTO {
    @Schema(description = "开始时间", example = "2024-01-01T00:00:00")
    private LocalDateTime startTime;
    
    @Schema(description = "结束时间", example = "2024-12-31T23:59:59")
    private LocalDateTime endTime;
}
