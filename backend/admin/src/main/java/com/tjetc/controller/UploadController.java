package com.tjetc.controller;

import com.tjetc.common.FileUploadUtils;
import com.tjetc.common.JsonResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping(value = "upload", method = {RequestMethod.POST})
@Tag(name = "文件上传", description = "处理文件、图片、视频的上传操作")
public class UploadController {
    @Value("${file.basePath}")
    private String fileBasePath;

    /**
     * 上传文件（例如：word pdf等等）
     *
     * @param multipartFile
     * @return
     */
    @PostMapping("file")
    @Operation(summary = "上传文件")
    public JsonResult uploadFile(@RequestParam("file") MultipartFile multipartFile) {
        JsonResult jsonResult = FileUploadUtils.upload(multipartFile, fileBasePath, "file");
        return jsonResult;
    }

    /**
     * 上传图片
     *
     * @param multipartFile
     * @return
     */
    @PostMapping("image")
    @Operation(summary = "上传图片")
    public JsonResult uploadImage(@RequestParam("image") MultipartFile multipartFile) {
        JsonResult jsonResult = FileUploadUtils.upload(multipartFile, fileBasePath, "image");
        return jsonResult;
    }

    /**
     * 上传视频
     *
     * @param multipartFile
     * @return
     */
    @PostMapping("video")
    @Operation(summary = "上传视频")
    public JsonResult uploadVideo(@RequestParam("video") MultipartFile multipartFile) {
        JsonResult jsonResult = FileUploadUtils.upload(multipartFile, fileBasePath, "video");
        return jsonResult;
    }
}
