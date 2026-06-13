package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 订单DTO类
 * 用于前端与后端之间的订单数据传输
 */
@Data
public class OrderDTO {
    /**
     * 订单ID
     */
    @Schema(description = "订单ID", example = "1")
    private Integer orderId;
    
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
     * 开始时间
     */
    @Schema(description = "开始时间", example = "2024-01-01T00:00:00")
    private String startTime;
    
    /**
     * 结束时间
     */
    @Schema(description = "结束时间", example = "2024-01-01T01:00:00")
    private String endTime;
    
    /**
     * 持续分钟数
     */
    @Schema(description = "持续分钟数", example = "60")
    private Integer durationMinutes;
    
    /**
     * 总金额
     */
    @Schema(description = "总金额", example = "10.0")
    private Double totalAmount;
    
    /**
     * 支付状态
     */
    @Schema(description = "支付状态", example = "pending")
    private String paymentStatus;
    
    /**
     * 创建时间
     */
    @Schema(description = "创建时间", example = "2024-01-01T00:00:00")
    private String createdTime;
}