package com.tjetc.controller.userFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.LoginDTO;
import com.tjetc.service.service.userFunction.UserLoginService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 用户登录控制器
 * 提供用户登录功能，支持表单数据和JSON格式的请求
 */
@RestController
@RequestMapping("/user")
@Slf4j
@Tag(name = "用户登陆", description = "处理用户登录相关操作")
public class LoginController {
    @Autowired
    private UserLoginService userService;

    /**
     * 用户登录接口
     * 使用JSON格式请求体，支持Apifox自动生成Body
     */
    @RequestMapping("/login")
    @Operation(summary = "用户登录")
    public JsonResult login(@RequestBody LoginDTO loginDTO) {
        log.info("用户登录请求: username={}", loginDTO.getUsername());
        return userService.login(loginDTO);
    }
}
