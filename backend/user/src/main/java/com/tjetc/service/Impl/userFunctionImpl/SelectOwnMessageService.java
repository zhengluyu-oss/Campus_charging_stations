package com.tjetc.service.Impl.userFunctionImpl;

import com.tjetc.common.AuthUtils;
import com.tjetc.common.JsonResult;
import com.tjetc.common.UserContext;
import com.tjetc.dao.UserMapper;
import com.tjetc.entity.userAndAdmin.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SelectOwnMessageService implements com.tjetc.service.service.userFunction.SelectOwnMessageService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public JsonResult selectOwnService(String username) {
        JsonResult authError = AuthUtils.assertCurrentUsername(username);
        if (authError != null) {
            return authError;
        }
        String effectiveUsername = StringUtils.isNotBlank(username) ? username : UserContext.getUsername();
        if (effectiveUsername == null) {
            return JsonResult.fail(-1, "未登录或者登录已过期");
        }
        User user = userMapper.selectByUsername(effectiveUsername);
        if (user == null) {
            return JsonResult.fail("用户不存在");
        }
        user.setPassword(null);
        return JsonResult.success("搜索成功", user);
    }
}
