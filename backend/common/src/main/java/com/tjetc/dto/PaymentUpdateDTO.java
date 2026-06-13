package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PaymentUpdateDTO {
    @Schema(description = "支付记录ID", example = "1")
    private Integer paymentId;
    
    @Schema(description = "支付状态", example = "success")
    private String paymentStatus;
    
    @Schema(description = "支付时间", example = "2024-01-01T12:00:00")
    private LocalDateTime paidTime;
}
