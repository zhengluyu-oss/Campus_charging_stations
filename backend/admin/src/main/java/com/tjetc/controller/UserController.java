package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.UserDTO;
import com.tjetc.dto.UserLoginDTO;
import com.tjetc.dto.UserPageDTO;
import com.tjetc.dto.UserCheckExistDTO;
import com.tjetc.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 用户模块控制器
 * 处理用户相关的HTTP请求，调用UserService完成业务逻辑
 */
@RestController
@RequestMapping("/user")
@Slf4j
@Tag(name = "用户管理", description = "处理用户的管理相关操作")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 查询所有用户
     * GET /user/all
     * @return JsonResult - 所有用户列表（密码脱敏）
     */
    @GetMapping("/all")
    @Operation(summary = "查询所有用户")
    public JsonResult findAll() {
        log.info("接收查询所有用户请求");
        return userService.findAll();
    }

    /**
     * 新增用户
     * POST /user/add
     * @param userDTO 待新增的用户信息（JSON格式）
     * @return JsonResult - 新增结果提示
     */
    @PostMapping("/add")
    @Operation(summary = "新增用户")
    public JsonResult add(@RequestBody UserDTO userDTO) {
        log.info("接收新增用户请求，username：{}", userDTO.getUsername());
        return userService.add(userDTO);
    }

    /**
     * 按用户名模糊分页查询用户
     * POST /user/page
     * @param userPageDTO 分页查询条件（JSON格式）
     * @return JsonResult - 分页用户列表（密码脱敏）
     */
    @PostMapping("/page")
    @Operation(summary = "分页查询用户")
    public JsonResult findPage(@RequestBody UserPageDTO userPageDTO) {
        log.info("接收分页查询用户请求，pageNum：{}，pageSize：{}，username：{}", 
                userPageDTO.getPageNum(), userPageDTO.getPageSize(), userPageDTO.getUsername());
        return userService.findPage(userPageDTO.getPageNum(), userPageDTO.getPageSize(), userPageDTO.getUsername());
    }



    /**
     * 按ID查询用户
     * GET /user/{id}
     * @param id 用户ID（路径变量，必填，>0）
     * @return JsonResult - 脱敏后的用户信息
     */
    @GetMapping("/{id}")
    @Operation(summary = "按ID查询用户")
    public JsonResult findById(@PathVariable Integer id) {
        log.info("接收按ID查询用户请求，id：{}", id);
        return userService.findById(id);
    }

    /**
     * 按ID更新用户信息
     * PUT /user/update
     * @param userDTO 待更新的用户信息（需包含ID，JSON格式）
     * @return JsonResult - 更新结果提示
     */
    @PutMapping("/update")
    @Operation(summary = "更新用户信息")
    public JsonResult updateById(@RequestBody UserDTO userDTO) {
        log.info("接收更新用户信息请求，userId：{}", userDTO.getUserId());
        return userService.updateById(userDTO);
    }

    /**
     * 按ID删除用户
     * DELETE /user/delete/{id}
     * @param id 用户ID（路径变量，必填，>0）
     * @return JsonResult - 删除结果提示
     */
    @DeleteMapping("/delete/{id}")
    @Operation(summary = "删除用户")
    public JsonResult deleteById(@PathVariable Integer id) {
        log.info("接收删除用户请求，id：{}", id);
        return userService.deleteById(id);
    }
}
