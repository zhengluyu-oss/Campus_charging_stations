package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class ChargingStationPageDTO {
    @Schema(description = "页码", example = "1")
    private Integer pageNum;
    
    @Schema(description = "每页数量", example = "10")
    private Integer pageSize;
    
    @Schema(description = "充电桩名称", example = "充电桩1")
    private String stationName;
}
