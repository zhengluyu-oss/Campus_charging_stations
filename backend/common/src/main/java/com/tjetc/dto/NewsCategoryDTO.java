package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Data
public class NewsCategoryDTO {
    @Schema(description = "新闻类型", example = "通知公告")
    private String newsCategory;
}
