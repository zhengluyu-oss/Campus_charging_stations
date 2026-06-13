package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class NewsIdDTO {
    @Schema(description = "新闻ID", example = "1")
    private Integer id;
}
