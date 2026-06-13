package com.tjetc.service.Impl.userFunctionImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.tjetc.common.AuthUtils;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.UserMapper;
import com.tjetc.dto.UserUpdateDTO;
import com.tjetc.entity.userAndAdmin.User;
import com.tjetc.service.service.userFunction.UpdateOwnerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UpdateOwnerServiceImpl implements UpdateOwnerService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public JsonResult updateOwner(UserUpdateDTO userUpdateDTO) {
        Integer userId = AuthUtils.resolveUserId(userUpdateDTO.getUserId());
        if (userId == null) {
            return userUpdateDTO.getUserId() != null
                    ? AuthUtils.forbiddenUserMismatch()
                    : JsonResult.fail(-1, "未登录或者登录已过期");
        }
        userUpdateDTO.setUserId(userId);

        if (userUpdateDTO.getUsername() != null) {
            LambdaQueryWrapper<User> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(User::getUsername, userUpdateDTO.getUsername())
                    .ne(User::getId, userUpdateDTO.getUserId());
            User existingUser = userMapper.selectOne(queryWrapper);
            if (existingUser != null) {
                return JsonResult.fail("用户名已存在，请使用其他用户名");
            }
        }

        LambdaUpdateWrapper<User> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(User::getId, userUpdateDTO.getUserId());

        if (userUpdateDTO.getUsername() != null) {
            updateWrapper.set(User::getUsername, userUpdateDTO.getUsername());
        }
        if (userUpdateDTO.getPassword() != null) {
            updateWrapper.set(User::getPassword, passwordEncoder.encode(userUpdateDTO.getPassword()));
        }
        if (userUpdateDTO.getEmail() != null) {
            updateWrapper.set(User::getEmail, userUpdateDTO.getEmail());
        }
        if (userUpdateDTO.getPhone() != null) {
            updateWrapper.set(User::getPhone, userUpdateDTO.getPhone());
        }
        if (userUpdateDTO.getUserType() != null) {
            updateWrapper.set(User::getUserType, userUpdateDTO.getUserType());
        }
        if (userUpdateDTO.getAvatarPath() != null) {
            updateWrapper.set(User::getAvatarPath, userUpdateDTO.getAvatarPath());
        }

        updateWrapper.set(User::getUpdatedTime, java.time.LocalDateTime.now());
        userMapper.update(null, updateWrapper);

        User user1 = userMapper.selectById(userUpdateDTO.getUserId());
        user1.setPassword(null);
        return JsonResult.success("更新成功", user1);
    }
}
