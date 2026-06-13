package com.tjetc.service.service.userFunction;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.UserUpdateDTO;

public interface UpdateOwnerService {
    JsonResult updateOwner(UserUpdateDTO userUpdateDTO);
}
