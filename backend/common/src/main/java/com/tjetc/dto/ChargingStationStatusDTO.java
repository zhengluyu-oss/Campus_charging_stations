package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class ChargingStationStatusDTO {
    @Schema(description = "状态", example = "0")
    private String status;
}
