package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class StartChargingDTO {
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
    
    @Schema(description = "充电时长（分钟）", example = "120")
    private Integer chargingDuration;
}