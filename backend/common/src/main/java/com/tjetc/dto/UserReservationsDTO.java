package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class UserReservationsDTO {
    @Schema(description = "用户ID", example = "1")
    private String userId;
}
