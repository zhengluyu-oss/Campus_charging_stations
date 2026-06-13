package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class NearbyStationsDTO {
    @Schema(description = "纬度", example = "39.9042")
    private double latitude;
    
    @Schema(description = "经度", example = "116.4074")
    private double longitude;
    
    @Schema(description = "半径", example = "1.0")
    private double radius;
}
