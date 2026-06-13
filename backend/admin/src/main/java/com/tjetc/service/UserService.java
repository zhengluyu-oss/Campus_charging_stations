package com.tjetc.service;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.UserDTO;
import com.tjetc.entity.userAndAdmin.User;


public interface UserService {
    /**
     * 查询所有用户
     *
     * @return
     */
    JsonResult<User> findAll();

    /**
     * 新增用户
     *
     * @param userDTO 用户DTO
     * @return
     */
    JsonResult add(UserDTO userDTO);

    /**
     * 按用户名模糊分页查询用户
     *
     * @param pageNum   页码
     * @param pageSize  每页数量
     * @param username  用户名（支持模糊查询）
     * @return
     */
    JsonResult findPage(Integer pageNum, Integer pageSize, String username);

    /**
     * 根据用户名和密码查询用户（用于登录验证）
     *
     * @param username 用户名
     * @param password 密码
     * @return
     */
    JsonResult login(String username, String password);

    /**
     * 检查用户名是否存在
     *
     * @param username 用户名
     * @return
     */
    JsonResult checkExistByUsername(String username);

    /**
     * 根据用户ID查询用户信息
     *
     * @param id 用户ID
     * @return
     */
    JsonResult findById(Integer id);

    /**
     * 根据用户ID更新用户信息
     *
     * @param userDTO 用户DTO（包含更新信息和用户ID）
     * @return
     */
    JsonResult updateById(UserDTO userDTO);

    /**
     * 根据用户ID删除用户
     *
     * @param id 用户ID
     * @return
     */
    JsonResult deleteById(Integer id);
}