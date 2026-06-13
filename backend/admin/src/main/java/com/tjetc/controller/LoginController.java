package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.AdminLoginDTO;
import com.tjetc.service.AdminService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员登录控制器
 * 提供管理员登录功能，使用JSON格式的请求
 */
@RestController
@RequestMapping("/admin")
@Slf4j
@Tag(name = "管理员登录", description = "处理管理员登录相关操作")
public class LoginController {
    @Autowired
    private AdminService adminService;

    /**
     * 管理员登录接口
     * 使用JSON格式请求体，支持Apifox自动生成Body
     */
    @PostMapping("/login")
    @Operation(summary = "管理员登录")
    public JsonResult login(@RequestBody AdminLoginDTO adminLoginDTO) {
        log.info("管理员登录请求: username={}", adminLoginDTO.getUsername());
        return adminService.login(adminLoginDTO);
    }
}

