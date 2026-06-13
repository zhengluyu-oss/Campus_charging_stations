package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class CancelReservationDTO {
    @Schema(description = "预约ID", example = "1")
    private Integer reservationId;
    
    @Schema(description = "用户ID", example = "1")
    private String userId;
}