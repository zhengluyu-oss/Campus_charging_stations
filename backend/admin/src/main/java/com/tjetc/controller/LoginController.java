package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.AdminLoginDTO;
import com.tjetc.service.AdminService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 管理员登录控制器
 * 提供管理员登录和 Token 刷新功能
 */
@RestController
@RequestMapping("/admin")
@Slf4j
@Tag(name = "管理员登录", description = "处理管理员登录和 Token 刷新操作")
public class LoginController {
    @Autowired
    private AdminService adminService;

    @PostMapping("/login")
    @Operation(summary = "管理员登录")
    public JsonResult login(@RequestBody AdminLoginDTO adminLoginDTO) {
        log.info("管理员登录请求: username={}", adminLoginDTO.getUsername());
        return adminService.login(adminLoginDTO);
    }

    @PostMapping("/refresh")
    @Operation(summary = "刷新 Token")
    public JsonResult refresh(@RequestBody Map<String, String> request) {
        String refreshToken = request.get("refreshToken");
        log.info("Token 刷新请求");
        return adminService.refreshToken(refreshToken);
    }
}
