package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 充电桩DTO类
 * 用于前端与后端之间的充电桩数据传输
 */
@Data
public class ChargingStationDTO {
    /**
     * 充电桩ID
     */
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
    
    /**
     * 充电桩名称
     */
    @Schema(description = "充电桩名称", example = "CZ_001")
    private String stationName;
    
    /**
     * 位置
     */
    @Schema(description = "位置", example = "图书馆停车场")
    private String location;
    
    /**
     * 状态
     */
    @Schema(description = "状态", example = "0")
    private String status;
    
    /**
     * 功率(kW)
     */
    @Schema(description = "功率(kW)", example = "7.5")
    private Double powerRating;
    
    /**
     * 每小时价格
     */
    @Schema(description = "每小时价格", example = "10.0")
    private Double pricePerHour;
}
