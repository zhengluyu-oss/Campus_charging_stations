package com.tjetc.entity.core;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("news")
public class News {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private String title;
    private String content;
    @TableField(value = "category_id")
    private Integer categoryId;
    @TableField(value = "image_url")
    private String imageUrl;
    @TableField(value = "publish_date")
    private LocalDate publishDate;
    @TableField(value = "created_at")
    private LocalDateTime createdAt;
    @TableField(value = "updated_at")
    private LocalDateTime updatedAt;
    @TableField(value = "news_category")
    private String newsCategory;
}
