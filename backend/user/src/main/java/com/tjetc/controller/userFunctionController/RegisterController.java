package com.tjetc.controller.userFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.UserRegisterDTO;
import com.tjetc.service.service.userFunction.UserRegisterService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 用户注册控制器
 * 提供用户注册功能，支持JSON格式的请求
 */
@RestController
@RequestMapping("/user")
@Slf4j
@Tag(name = "用户注册", description = "处理用户注册相关操作")
public class RegisterController {
    @Autowired
    private UserRegisterService userService;

    @PostMapping(value = "/register")
    @Operation(summary = "用户注册")
    public JsonResult register(@RequestBody UserRegisterDTO userRegisterDTO) {
        String username = userRegisterDTO.getUsername();
        String password = userRegisterDTO.getPassword();
        String email = userRegisterDTO.getEmail();
        String phone = userRegisterDTO.getPhone();
        String userType = userRegisterDTO.getUserType();

        return handleRegistration(username, password, email, phone, userType);
    }

    /**
     * 处理注册的核心逻辑
     * @param username 用户名
     * @param password 密码
     * @param email 邮箱
     * @param phone 手机号
     * @param userType 用户类型
     * @return 注册结果
     */
    private JsonResult handleRegistration(String username, String password, String email, String phone, String userType) {
        log.info("开始注册用户: username={}, password={}, email={}, phone={}, userType={}",
                username, password != null ? "***" : null, email, phone, userType);

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            log.error("缺少必需参数或参数为空: username={}, password={}", username, password != null ? "***" : null);
            return JsonResult.fail("用户名和密码不能为空");
        }

        username = username.trim();
        password = password.trim();

        if (userType == null || userType.trim().isEmpty()) {
            userType = "student";
        }

        return userService.register(username, password, null, email, phone, userType);
    }
}
