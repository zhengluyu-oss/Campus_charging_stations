package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 预约DTO类
 * 用于前端与后端之间的预约数据传输
 */
@Data
public class ReservationDTO {
    /**
     * 预约ID
     */
    @Schema(description = "预约ID", example = "1")
    private Integer reservationId;
    
    /**
     * 用户ID
     */
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    /**
     * 充电桩ID
     */
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
    
    /**
     * 预约开始时间
     */
    @Schema(description = "预约开始时间", example = "2024-01-01T00:00:00")
    private String reservedStartTime;
    
    /**
     * 预约结束时间
     */
    @Schema(description = "预约结束时间", example = "2024-01-01T01:00:00")
    private String reservedEndTime;
    
    /**
     * 预约状态
     */
    @Schema(description = "预约状态", example = "已预约")
    private String status;
    
    /**
     * 创建时间
     */
    @Schema(description = "创建时间", example = "2024-01-01T00:00:00")
    private String createdAt;
}