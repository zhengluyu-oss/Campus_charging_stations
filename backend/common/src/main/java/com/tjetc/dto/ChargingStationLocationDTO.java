package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class ChargingStationLocationDTO {
    @Schema(description = "位置", example = "北院")
    private String location;
}
