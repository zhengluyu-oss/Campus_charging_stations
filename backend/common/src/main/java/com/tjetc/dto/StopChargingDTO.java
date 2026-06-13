package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class StopChargingDTO {
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
}