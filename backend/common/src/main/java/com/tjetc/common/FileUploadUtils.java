package com.tjetc.common;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
            // 文档（如需要可取消注释）
            // "pdf", "doc", "docx", "xls", "xlsx",
            // 其他
            "mp3", "wav"
    );

    /**
     * 上传文件
     *
     * @param multipartFile    文件对象
     * @param basePath         文件存储位置的基本路径
     * @param returnPathPrefix 文件返回url前缀
     * @return
     */
    public static JsonResult upload(MultipartFile multipartFile,
                                    String basePath,
                                    String returnPathPrefix) {
        // 检查文件是否为空
        if (multipartFile == null || multipartFile.isEmpty()) {
            return JsonResult.fail("上传文件不能为空");
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
            return JsonResult.fail("不支持的文件类型: " + suffixName + "。允许的类型: " + ALLOWED_EXTENSIONS);
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

        // 生成新的文件名称
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
        // 如果文件名为空，返回默认名
        if (filename.isBlank()) {
            return "unknown";
        }
        return filename;
    }
}
