package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class ImageUploadDTO {
    @Schema(description = "上传的图片", type = "string", format = "binary")
    private MultipartFile image;
}
