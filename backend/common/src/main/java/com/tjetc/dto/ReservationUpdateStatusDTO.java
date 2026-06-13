package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class ReservationUpdateStatusDTO {
    @Schema(description = "预约ID", example = "1")
    private Integer id;
    
    @Schema(description = "预约状态", example = "cancelled")
    private String status;
}
