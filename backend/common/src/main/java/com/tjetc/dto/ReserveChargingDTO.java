package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class ReserveChargingDTO {
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
    
    @Schema(description = "预约多久后开始充电（分钟）", example = "30")
    private Integer delayMinutes;
    
    @Schema(description = "充电时长（分钟）", example = "60")
    private Integer chargingDuration;
}
