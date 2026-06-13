package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ReservationTimeRangeDTO {
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
    
    @Schema(description = "开始时间", example = "2024-01-01T08:00:00")
    private LocalDateTime startTime;
    
    @Schema(description = "结束时间", example = "2024-01-01T10:00:00")
    private LocalDateTime endTime;
}
