package com.tjetc.service.service.userFunction;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.LoginDTO;

public interface UserLoginService {
    /**
     * 用户登录
     *
     * @param username
     * @param password
     * @return
     */
    JsonResult login(String username, String password);

    /**
     * 用户登录（使用DTO）
     *
     * @param loginDTO 登录信息DTO
     * @return
     */
    JsonResult login(LoginDTO loginDTO);

}
