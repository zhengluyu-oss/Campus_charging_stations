package com.tjetc.controller.userFunctionController;

import com.tjetc.common.FileUploadUtils;
import com.tjetc.common.JsonResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件上传控制器
 * 提供文件、图片、视频的上传功能
 * 注意：文件上传使用multipart/form-data格式，使用@RequestParam接收文件参数
 */
@RestController
@RequestMapping("/upload")
@Tag(name = "文件上传", description = "处理文件、图片、视频的上传操作")
public class UploadController {
    @Value("${file.basePath}")
    private String fileBasePath;

    /**
     * 上传文件（例如：word pdf等等）
     * @param multipartFile 要上传的文件
     * @return 上传结果，包含文件路径
     */
    @PostMapping("/file")
    @Operation(summary = "上传文件")
    public JsonResult uploadFile(@RequestParam("file") MultipartFile multipartFile) {
        JsonResult jsonResult = FileUploadUtils.upload(multipartFile, fileBasePath, "file");
        return jsonResult;
    }

    /**
     * 上传图片
     * @param multipartFile 要上传的图片
     * @return 上传结果，包含图片路径
     */
    @PostMapping("/image")
    @Operation(summary = "上传图片")
    public JsonResult uploadImage(@RequestParam("image") MultipartFile multipartFile) {
        JsonResult jsonResult = FileUploadUtils.upload(multipartFile, fileBasePath, "image");
        return jsonResult;
    }

    /**
     * 上传视频
     * @param multipartFile 要上传的视频
     * @return 上传结果，包含视频路径
     */
    @PostMapping("/video")
    @Operation(summary = "上传视频")
    public JsonResult uploadVideo(@RequestParam("video") MultipartFile multipartFile) {
        JsonResult jsonResult = FileUploadUtils.upload(multipartFile, fileBasePath, "video");
        return jsonResult;
    }
}
