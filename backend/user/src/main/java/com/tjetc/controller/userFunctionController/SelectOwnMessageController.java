package com.tjetc.controller.userFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.SelectOwnMessageDTO;
import com.tjetc.service.Impl.userFunctionImpl.SelectOwnMessageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
@Tag(name = "用户信息查询", description = "处理用户个人信息的查询操作")
public class SelectOwnMessageController {
    @Autowired
    private SelectOwnMessageService selectOwnMessageService;

    @PostMapping("/selectOwnMessage")
    @Operation(summary = "查询用户个人信息")
    public JsonResult selectOwnMessage(@RequestBody SelectOwnMessageDTO selectOwnMessageDTO) {
        return selectOwnMessageService.selectOwnService(selectOwnMessageDTO.getUsername());
    }
}
