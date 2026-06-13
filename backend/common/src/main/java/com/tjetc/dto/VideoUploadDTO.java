package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class VideoUploadDTO {
    @Schema(description = "上传的视频", type = "string", format = "binary")
    private MultipartFile video;
}
