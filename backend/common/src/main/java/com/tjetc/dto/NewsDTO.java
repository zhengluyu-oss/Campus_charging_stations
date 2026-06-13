package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDate;

@Data
public class NewsDTO {
    @Schema(description = "新闻ID（更新时需要）", example = "1")
    private Integer id;
    
    @Schema(description = "新闻标题", example = "校园充电桩系统正式上线")
    private String title;
    
    @Schema(description = "新闻内容", example = "校园充电桩系统已正式上线，为师生提供便捷的充电服务。")
    private String content;
    
    @Schema(description = "分类ID", example = "1")
    private Integer categoryId;
    
    @Schema(description = "新闻图片URL", example = "https://example.com/images/news1.jpg")
    private String imageUrl;
    
    @Schema(description = "发布日期（格式：yyyy-MM-dd）", example = "2026-03-18")
    private LocalDate publishDate;

    @Schema(description = "新闻类型", example = "通知公告")
    private String newsCategory;
}
