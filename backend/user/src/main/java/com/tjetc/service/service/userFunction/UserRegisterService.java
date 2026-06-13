package com.tjetc.service.service.userFunction;

import com.tjetc.common.JsonResult;

public interface UserRegisterService {
    JsonResult register(String username, String password, String avatarPath, String email, String phone, String userType);
}
