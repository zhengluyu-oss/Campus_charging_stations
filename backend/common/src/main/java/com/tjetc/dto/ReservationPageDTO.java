package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class ReservationPageDTO {
    @Schema(description = "页码", example = "1")
    private Integer pageNum;
    
    @Schema(description = "每页数量", example = "10")
    private Integer pageSize;
    
    @Schema(description = "预约状态", example = "confirmed")
    private String status;
    
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
}
