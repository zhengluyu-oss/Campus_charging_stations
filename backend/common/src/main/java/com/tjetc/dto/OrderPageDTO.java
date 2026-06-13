package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class OrderPageDTO {
    @Schema(description = "页码", example = "1")
    private Integer pageNum;
    
    @Schema(description = "每页数量", example = "10")
    private Integer pageSize;
    
    @Schema(description = "支付状态", example = "已支付")
    private String paymentStatus;
    
    @Schema(description = "用户ID", example = "1")
    private Integer userId;
    
    @Schema(description = "充电桩ID", example = "1")
    private Integer stationId;
}
