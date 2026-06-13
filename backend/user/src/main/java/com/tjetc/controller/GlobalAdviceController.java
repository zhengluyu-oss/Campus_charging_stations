package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
@Slf4j
@Tag(name = "全局异常处理", description = "处理用户端控制器的异常")
public class GlobalAdviceController {

    @ExceptionHandler(Exception.class)
    public JsonResult exception(Exception e) {
        log.error("请求处理异常", e);
        return JsonResult.fail("出错了，请联系管理员");
    }
}
