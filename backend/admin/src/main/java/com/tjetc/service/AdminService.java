package com.tjetc.service;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjetc.common.JsonResult;
import com.tjetc.dto.AdminDTO;
import com.tjetc.dto.AdminLoginDTO;


public interface AdminService  {
    /**
     * 查询所有数据
     *
     * @return
     */
    JsonResult<AdminDTO> findAll();

    /**
     * 新增
     *
     * @param adminDTO
     * @return
     */
    JsonResult add(AdminDTO adminDTO);

    /**
     * 根据用户名和密码查询
     *
     * @param username
     * @param password
     * @return
     */
    JsonResult login(String username, String password);

    /**
     * 管理员登录（使用DTO）
     *
     * @param adminLoginDTO 登录信息DTO
     * @return
     */
    JsonResult login(AdminLoginDTO adminLoginDTO);

    /**
     * 根据用户名模糊分页查询用户信息
     *
     * @param pageNum   页面
     * @param pageSize 每页数量
     * @param username 用户名
     * @return
     */
    JsonResult findPage(Integer pageNum, Integer pageSize, String username);

    /**
     * 根据用户检查用户是否存在
     *
     * @param username
     * @return
     */
    JsonResult checkExistByUsername(String username);

    /**
     * 根据id查询用户信息
     *
     * @param id
     * @return
     */
    JsonResult findById(Integer id);

    /**
     * 根据Id更新
     *
     * @param adminDTO
     * @return
     */
    JsonResult updateById(AdminDTO adminDTO);

    /**
     * 根据id删除
     *
     * @param id
     * @return
     */
    JsonResult deleteById(Integer id);
}
