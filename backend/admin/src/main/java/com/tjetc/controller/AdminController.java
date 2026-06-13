package com.tjetc.controller;

import com.tjetc.common.JsonResult;

import com.tjetc.dto.AdminDTO;
import com.tjetc.dto.AdminLoginDTO;
import com.tjetc.dto.AdminPageDTO;
import com.tjetc.dto.AdminCheckExistDTO;
import com.tjetc.dto.AdminIdDTO;
import com.tjetc.service.AdminService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin")
@Slf4j
@Tag(name = "管理员管理", description = "处理管理员的管理相关操作")
public class AdminController {
    @Autowired
    private AdminService adminService;

    /**
     * 查询管理员列表（无分页）
     * HTTP 请求方式：GET
     */
    @GetMapping("/list")
    @Operation(summary = "查询管理员列表")
    public JsonResult list() {
        return adminService.findAll();
    }

    /**
     * 新增管理员
     * HTTP 请求方式：POST
     */
    @PostMapping("/add")
    @Operation(summary = "新增管理员")
    public JsonResult add(@RequestBody AdminDTO adminDTO) {
        return adminService.add(adminDTO);
    }

    /**
     * 管理员分页查询（带用户名模糊查询）
     * HTTP 请求方式：POST
     */
    @PostMapping("/page")
    @Operation(summary = "管理员分页查询")
    public JsonResult page(@RequestBody AdminPageDTO adminPageDTO) {
        return adminService.findPage(
                adminPageDTO.getPageNum() != null ? adminPageDTO.getPageNum() : 1,
                adminPageDTO.getPageSize() != null ? adminPageDTO.getPageSize() : 10,
                adminPageDTO.getUsername() != null ? adminPageDTO.getUsername() : ""
        );
    }

    /**
     * 校验管理员用户名是否存在
     * HTTP 请求方式：POST
     */
    @PostMapping("/check-exist")
    @Operation(summary = "校验管理员用户名是否存在")
    public JsonResult checkExist(@RequestBody AdminCheckExistDTO adminCheckExistDTO) {
        return adminService.checkExistByUsername(adminCheckExistDTO.getUsername());
    }

    /**
     * 查询管理员详情（根据 ID）
     * HTTP 请求方式：POST
     */
    @PostMapping("/detail")
    @Operation(summary = "查询管理员详情")
    public JsonResult detail(@RequestBody AdminIdDTO adminIdDTO) {
        return adminService.findById(adminIdDTO.getId());
    }

    /**
     * 修改管理员信息
     * HTTP 请求方式：PUT
     */
    @PutMapping("/update")
    @Operation(summary = "修改管理员信息")
    public JsonResult update(@RequestBody AdminDTO adminDTO) {
        return adminService.updateById(adminDTO);
    }

    /**
     * 删除管理员（根据 ID）
     * HTTP 请求方式：POST
     */
    @PostMapping("/delete")
    @Operation(summary = "删除管理员")
    public JsonResult delete(@RequestBody AdminIdDTO adminIdDTO) {
        return adminService.deleteById(adminIdDTO.getId());
    }
}
