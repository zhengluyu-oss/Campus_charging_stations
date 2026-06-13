package com.tjetc.service.Impl.userFunctionImpl;

import com.tjetc.common.JsonResult;
import com.tjetc.common.JwtTokenUtil;
import com.tjetc.common.PasswordUtils;
import com.tjetc.dao.UserMapper;
import com.tjetc.dto.LoginDTO;
import com.tjetc.entity.userAndAdmin.User;
import com.tjetc.service.service.userFunction.UserLoginService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserLoginServiceImpl implements UserLoginService {

    @Value("${jwt.token.expired}")
    private int expired;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public JsonResult login(String username, String password) {
        return doLogin(username, password);
    }

    @Override
    public JsonResult login(LoginDTO loginDTO) {
        return doLogin(loginDTO.getUsername(), loginDTO.getPassword());
    }

    private JsonResult doLogin(String username, String password) {
        JsonResult validation = checkUsernameAndPassword(username, password);
        if (validation.getState() != 0) {
            return validation;
        }

        String trimmedUsername = username.trim();
        String trimmedPassword = password.trim();
        User user = userMapper.selectByUsername(trimmedUsername);
        if (user == null) {
            return JsonResult.fail("用户名或者密码错误");
        }

        String stored = user.getPassword();
        boolean matches;
        if (PasswordUtils.isBcryptHash(stored)) {
            matches = passwordEncoder.matches(trimmedPassword, stored);
        } else {
            matches = trimmedPassword.equals(stored);
            if (matches) {
                User toUpdate = new User();
                toUpdate.setId(user.getId());
                toUpdate.setPassword(passwordEncoder.encode(trimmedPassword));
                userMapper.updateById(toUpdate);
            }
        }

        if (!matches) {
            return JsonResult.fail("用户名或者密码错误");
        }

        user.setPassword(null);
        Map<String, Object> info = new HashMap<>();
        info.put("id", user.getId());
        info.put("username", user.getUsername());
        String token = JwtTokenUtil.generateToken(info, "user", expired);
        return JsonResult.success(token, user);
    }

    private JsonResult checkUsernameAndPassword(String username, String password) {
        if (StringUtils.isAnyBlank(username, password)) {
            return JsonResult.fail("用户名或者密码不能为空");
        }
        if (StringUtils.length(username) < 3 || StringUtils.length(username) > 20) {
            return JsonResult.fail("用户名长度是3~20字符");
        }
        if (StringUtils.length(password) < 3 || StringUtils.length(password) > 30) {
            return JsonResult.fail("密码长度是3~30字符");
        }
        return JsonResult.success("");
    }
}
