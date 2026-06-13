package com.tjetc.controller.userFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.UserUpdateDTO;
import com.tjetc.service.service.userFunction.UpdateOwnerService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
@Slf4j
@Tag(name = "用户信息更新", description = "处理用户个人信息的更新操作")
public class UpdateOwnMessageController {
    @Autowired
    private UpdateOwnerService updateOwnerService;

    @PostMapping(value = "/updateOwnMessage")
    @Operation(summary = "更新用户个人信息")
    public JsonResult updateOwnMessage(@RequestBody UserUpdateDTO userUpdateDTO) {
        log.info("接收到更新请求，用户ID: {}", userUpdateDTO.getUserId());
        return updateOwnerService.updateOwner(userUpdateDTO);
    }
}
