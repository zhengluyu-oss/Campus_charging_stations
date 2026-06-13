package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 支付DTO类
 * 用于前端与后端之间的支付数据传输
 */
@Data
public class PaymentDTO {
    /**
     * 支付ID
     */
    @Schema(description = "支付ID", example = "1")
    private Integer paymentId;
    
    /**
     * 订单ID
     */
    @Schema(description = "订单ID", example = "1")
    private Integer orderId;
    
    /**
     * 金额
     */
    @Schema(description = "金额", example = "10.0")
    private Double amount;
    
    /**
     * 支付方式
     */
    @Schema(description = "支付方式", example = "微信")
    private String paymentMethod;
    
    /**
     * 支付状态
     */
    @Schema(description = "支付状态", example = "已支付")
    private String paymentStatus;
    
    /**
     * 支付时间
     */
    @Schema(description = "支付时间", example = "2024-01-01T01:00:00")
    private String paidTime;
}