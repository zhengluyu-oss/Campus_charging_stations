package com.tjetc.common;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * 文件上传工具类
 */
public class FileUploadUtils {

    // 允许的文件扩展名白名单
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(
            // 图片
            "jpg", "jpeg", "png", "gif", "webp", "bmp",
            // 视频
            "mp4", "avi", "mov", "mkv", "wmv", "flv",
            // 音频
            "mp3", "wav"
    );

    // 扩展名对应的允许 MIME 类型
    private static final Map<String, Set<String>> ALLOWED_MIME_TYPES = buildAllowedMimeTypes();

    private static Map<String, Set<String>> buildAllowedMimeTypes() {
        Map<String, Set<String>> map = new HashMap<>();
        map.put("jpg", Set.of("image/jpeg"));
        map.put("jpeg", Set.of("image/jpeg"));
        map.put("png", Set.of("image/png"));
        map.put("gif", Set.of("image/gif"));
        map.put("webp", Set.of("image/webp"));
        map.put("bmp", Set.of("image/bmp"));
        map.put("mp4", Set.of("video/mp4"));
        map.put("avi", Set.of("video/x-msvideo", "video/avi"));
        map.put("mov", Set.of("video/quicktime"));
        map.put("mkv", Set.of("video/x-matroska"));
        map.put("wmv", Set.of("video/x-ms-wmv"));
        map.put("flv", Set.of("video/x-flv"));
        map.put("mp3", Set.of("audio/mpeg"));
        map.put("wav", Set.of("audio/wav"));
        return Map.copyOf(map);
    }

    // 文件大小限制（字节）
    private static final long MAX_IMAGE_SIZE = 10 * 1024 * 1024;   // 10MB
    private static final long MAX_VIDEO_SIZE = 100 * 1024 * 1024;  // 100MB
    private static final long MAX_AUDIO_SIZE = 20 * 1024 * 1024;   // 20MB
    private static final long MAX_DEFAULT_SIZE = 10 * 1024 * 1024; // 10MB

    /**
     * 上传文件
     *
     * @param multipartFile    文件对象
     * @param basePath         文件存储位置的基本路径
     * @param returnPathPrefix 文件返回url前缀（file/image/video）
     * @return JsonResult
     */
    public static JsonResult upload(MultipartFile multipartFile,
                                    String basePath,
                                    String returnPathPrefix) {
        // 检查文件是否为空
        if (multipartFile == null || multipartFile.isEmpty()) {
            return JsonResult.fail("上传文件不能为空");
        }

        // 检查文件大小
        long maxSize = getMaxSize(returnPathPrefix);
        if (multipartFile.getSize() > maxSize) {
            return JsonResult.fail("文件大小超过限制，最大允许: " + (maxSize / 1024 / 1024) + "MB");
        }

        // 上传文件的原始名称
        String originalFilename = multipartFile.getOriginalFilename();
        if (originalFilename == null || originalFilename.isBlank()) {
            return JsonResult.fail("文件名不能为空");
        }

        // 净化文件名：移除路径遍历字符，只保留文件名部分
        originalFilename = sanitizeFilename(originalFilename);

        // 获取文件的后缀名称
        int lastDotIndex = originalFilename.lastIndexOf(".");
        if (lastDotIndex == -1 || lastDotIndex == originalFilename.length() - 1) {
            return JsonResult.fail("文件必须有扩展名");
        }

        String suffixName = originalFilename.substring(lastDotIndex + 1).toLowerCase();

        // 校验文件扩展名是否在白名单中
        if (!ALLOWED_EXTENSIONS.contains(suffixName)) {
            return JsonResult.fail("不支持的文件类型: " + suffixName);
        }

        // 校验 MIME 类型与扩展名是否匹配
        String contentType = multipartFile.getContentType();
        if (!isMimeTypeAllowed(suffixName, contentType)) {
            return JsonResult.fail("文件内容类型与扩展名不匹配");
        }

        // 增加一个日期目录
        LocalDate nowDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        String strNowDate = formatter.format(nowDate);

        // basePath增加returnPathPrefix和日期路径
        basePath = basePath + "/" + returnPathPrefix + "/" + strNowDate;

        // 判断目录是否存在，不存在就创建目录
        File basePathFile = new File(basePath);
        if (!basePathFile.exists()) {
            basePathFile.mkdirs();
        }

        // 生成新的文件名称（UUID 避免文件名冲突和路径遍历）
        String newFileName = UUID.randomUUID().toString().replaceAll("-", "");

        // 文件的全路径
        String fileName = basePath + "/" + newFileName + "." + suffixName;
        File newFile = new File(fileName);

        try {
            multipartFile.transferTo(newFile);
        } catch (IOException e) {
            return JsonResult.fail("服务器错误：文件保存失败");
        }

        // 返回给前端的路径
        String returnUrl = "/" + returnPathPrefix + "/" + strNowDate + "/" + newFileName + "." + suffixName;
        return JsonResult.success("成功", returnUrl);
    }

    /**
     * 根据上传类型获取最大文件大小
     */
    private static long getMaxSize(String type) {
        return switch (type) {
            case "image" -> MAX_IMAGE_SIZE;
            case "video" -> MAX_VIDEO_SIZE;
            case "audio" -> MAX_AUDIO_SIZE;
            default -> MAX_DEFAULT_SIZE;
        };
    }

    /**
     * 校验 MIME 类型是否与扩展名匹配
     */
    private static boolean isMimeTypeAllowed(String extension, String contentType) {
        if (contentType == null || contentType.isBlank()) {
            return false;
        }
        Set<String> allowed = ALLOWED_MIME_TYPES.get(extension);
        if (allowed == null) {
            return false;
        }
        // 取 MIME 类型的主类型（忽略 charset 等参数）
        String baseMimeType = contentType.split(";")[0].trim().toLowerCase();
        return allowed.contains(baseMimeType);
    }

    /**
     * 净化文件名，移除路径遍历字符
     */
    private static String sanitizeFilename(String filename) {
        if (filename == null) {
            return "unknown";
        }
        // 移除路径分隔符，只保留文件名部分
        int lastSeparator = Math.max(filename.lastIndexOf('/'), filename.lastIndexOf('\\'));
        if (lastSeparator >= 0) {
            filename = filename.substring(lastSeparator + 1);
        }
        // 移除空字节和其他危险字符
        filename = filename.replace("\0", "");
        // 移除特殊字符，只保留字母数字下划线连字符点
        filename = filename.replaceAll("[^a-zA-Z0-9._\\-\\u4e00-\\u9fa5]", "_");
        // 如果文件名为空，返回默认名
        if (filename.isBlank()) {
            return "unknown";
        }
        return filename;
    }
}
