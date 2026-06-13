package com.tjetc.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class FileUploadDTO {
    @Schema(description = "上传的文件", type = "string", format = "binary")
    private MultipartFile file;
}
