package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class OrderUpdateDTO {
    @Schema(description = "订单ID", example = "1")
    private Integer orderId;
    
    @Schema(description = "支付状态", example = "已支付")
    private String paymentStatus;
}
