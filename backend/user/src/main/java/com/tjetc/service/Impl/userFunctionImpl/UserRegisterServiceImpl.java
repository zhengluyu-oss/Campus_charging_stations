package com.tjetc.service.Impl.userFunctionImpl;

import com.tjetc.common.JsonResult;
import com.tjetc.dao.UserMapper;
import com.tjetc.dto.UserRegisterDTO;
import com.tjetc.entity.userAndAdmin.User;
import com.tjetc.service.service.userFunction.UserRegisterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserRegisterServiceImpl implements UserRegisterService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public JsonResult register(String username, String password, String avatarPath, String email, String phone, String userType) {
        User existingUser = userMapper.selectByUsername(username);
        if (existingUser != null) {
            return JsonResult.fail("用户名已存在");
        }

        String encodedPassword = passwordEncoder.encode(password);
        User newUser = new User(username, encodedPassword, avatarPath, email, phone, userType);
        userMapper.insert(newUser);

        UserRegisterDTO userRegisterDTO = new UserRegisterDTO();
        userRegisterDTO.setUsername(newUser.getUsername());
        userRegisterDTO.setEmail(newUser.getEmail());
        userRegisterDTO.setPhone(newUser.getPhone());
        userRegisterDTO.setUserType(newUser.getUserType());

        return JsonResult.success("注册成功", userRegisterDTO);
    }
}
