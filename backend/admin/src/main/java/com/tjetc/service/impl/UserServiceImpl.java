package com.tjetc.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.UserMapper;
import com.tjetc.dto.UserDTO;
import com.tjetc.entity.userAndAdmin.User;

import com.tjetc.service.UserService;
import org.springframework.beans.BeanUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Slf4j
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    /**
     * 查询所有用户（返回结果中密码已脱敏）
     * @return JsonResult<User> - 成功：返回所有用户列表（密码为空）；失败：返回错误信息
     */
    @Override
    public JsonResult<User> findAll() {
        try {
            List<User> userList = userMapper.selectList(null);
            userList.forEach(user -> user.setPassword(null));
            return JsonResult.success(userList);
        } catch (Exception e) {
            log.error("查询所有用户失败", e);
            return JsonResult.fail("查询所有用户失败：" + e.getMessage());
        }
    }

    /**
     * 新增用户（包含用户名查重、参数校验：用户名/密码非空且符合长度要求）
     * @param userDTO 待新增的用户DTO
     * @return JsonResult - 成功：返回新增成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult add(UserDTO userDTO) {
        try {
            if (StringUtils.isBlank(userDTO.getUsername()) || StringUtils.isBlank(userDTO.getPassword())) {
                return JsonResult.fail("用户名和密码不能为空");
            }
            if (userDTO.getUsername().length() < 3 || userDTO.getUsername().length() > 10) {
                return JsonResult.fail("用户名长度必须为3-10字符");
            }
            if (userDTO.getPassword().length() < 6 || userDTO.getPassword().length() > 20) {
                return JsonResult.fail("密码长度必须为6-20字符");
            }
            User existUser = userMapper.selectByUsername(userDTO.getUsername());
            if (!ObjectUtils.isEmpty(existUser)) {
                return JsonResult.fail("用户名已存在");
            }
            // 将DTO转换为实体类
            User user = new User();
            BeanUtils.copyProperties(userDTO, user);
            user.setCreatedTime(LocalDateTime.now());
            user.setUpdatedTime(LocalDateTime.now());
            if (ObjectUtils.isEmpty(user.getUserType())) {
                user.setUserType("student");
            }
            int rows = userMapper.insert(user);
            if (rows > 0) {
                return JsonResult.success("新增用户成功");
            }
            return JsonResult.fail("新增用户失败：数据库未受影响");
        } catch (Exception e) {
            log.error("新增用户异常，username：{}", userDTO.getUsername(), e);
            return JsonResult.fail("新增用户失败：" + e.getMessage());
        }
    }

    /**
     * 按用户名模糊分页查询用户（返回结果中密码已脱敏）
     * @param pageNum 页码（需大于0）
     * @param pageSize 每页数量（需大于0）
     * @param username 用户名（模糊匹配，可为空）
     * @return JsonResult - 成功：返回分页后的用户列表；失败：返回错误信息
     */
    @Override
    public JsonResult findPage(Integer pageNum, Integer pageSize, String username) {
        try {
            if (ObjectUtils.isEmpty(pageNum) || pageNum <= 0 || ObjectUtils.isEmpty(pageSize) || pageSize <= 0) {
                return JsonResult.fail("页码和每页数量必须大于0");
            }
            String likeUsername = StringUtils.isBlank(username) ? null : "%" + username.trim() + "%";
            Page<User> page = new Page<>(pageNum, pageSize);
            IPage<User> userPage = userMapper.selectPageByUsernameLike(page, likeUsername);
            userPage.getRecords().forEach(user -> user.setPassword(null));
            return JsonResult.success(userPage);
        } catch (Exception e) {
            log.error("按用户名分页查询失败，username：{}", username, e);
            return JsonResult.fail("分页查询用户失败：" + e.getMessage());
        }
    }

    /**
     * 用户登录校验（密码已脱敏）
     * @param username 用户名
     * @param password 密码
     * @return JsonResult - 成功：返回登录成功提示+脱敏后的用户信息；失败：返回错误信息
     */
    @Override
    public JsonResult login(String username, String password) {
        try {
            if (StringUtils.isBlank(username) || StringUtils.isBlank(password)) {
                return JsonResult.fail("用户名和密码不能为空");
            }
            User user = userMapper.selectByUsernameAndPassword(username, password);
            if (ObjectUtils.isEmpty(user)) {
                return JsonResult.fail("用户名或密码错误");
            }
            user.setPassword(null);
            return JsonResult.success("登录成功", user);
        } catch (Exception e) {
            log.error("用户登录异常，username：{}", username, e);
            return JsonResult.fail("登录失败：" + e.getMessage());
        }
    }

    /**
     * 检查用户名是否已存在
     * @param username 待检查的用户名
     * @return JsonResult - 成功：返回布尔值（true=存在；false=不存在）；失败：返回错误信息
     */
    @Override
    public JsonResult checkExistByUsername(String username) {
        try {
            if (StringUtils.isBlank(username)) {
                return JsonResult.fail("用户名不能为空");
            }
            User user = userMapper.selectByUsername(username);
            return JsonResult.success(user != null);
        } catch (Exception e) {
            log.error("检查用户名存在性失败，username：{}", username, e);
            return JsonResult.fail("检查用户名失败：" + e.getMessage());
        }
    }

    /**
     * 按ID查询用户（密码已脱敏）
     * @param id 用户ID（需大于0）
     * @return JsonResult - 成功：返回脱敏后的用户信息；失败：返回错误信息
     */
    @Override
    public JsonResult findById(Integer id) {
        try {
            if (ObjectUtils.isEmpty(id) || id <= 0) {
                return JsonResult.fail("用户ID必须大于0");
            }
            User user = userMapper.selectById(id);
            if (ObjectUtils.isEmpty(user)) {
                return JsonResult.fail("未查询到该用户");
            }
            user.setPassword(null);
            return JsonResult.success(user);
        } catch (Exception e) {
            log.error("按ID查询用户失败，id：{}", id, e);
            return JsonResult.fail("查询用户失败：" + e.getMessage());
        }
    }

    /**
     * 按ID更新用户信息（禁止修改用户名、密码）
     * @param userDTO 待更新的用户DTO（需包含ID）
     * @return JsonResult - 成功：返回更新成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult updateById(UserDTO userDTO) {
        try {
            if (ObjectUtils.isEmpty(userDTO.getUserId()) || userDTO.getUserId() <= 0) {
                return JsonResult.fail("用户ID必须大于0");
            }
            User existUser = userMapper.selectById(userDTO.getUserId());
            if (ObjectUtils.isEmpty(existUser)) {
                return JsonResult.fail("未找到对应用户，无法更新");
            }
            // 将DTO转换为实体类
            User user = new User();
            BeanUtils.copyProperties(userDTO, user);
            user.setId(userDTO.getUserId()); // DTO中是userId，实体类中是id
            user.setUsername(null); // 禁止修改用户名
            user.setPassword(null); // 禁止修改密码
            user.setCreatedTime(null); // 禁止修改创建时间
            user.setUpdatedTime(LocalDateTime.now());
            int rows = userMapper.updateById(user);
            if (rows > 0) {
                return JsonResult.success("更新用户信息成功");
            }
            return JsonResult.fail("更新失败：无变更或用户不存在");
        } catch (Exception e) {
            log.error("更新用户信息异常，userId：{}", userDTO.getUserId(), e);
            return JsonResult.fail("更新用户失败：" + e.getMessage());
        }
    }

    /**
     * 按ID删除用户
     * @param id 用户ID（需大于0）
     * @return JsonResult - 成功：返回删除成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult deleteById(Integer id) {
        try {
            if (ObjectUtils.isEmpty(id) || id <= 0) {
                return JsonResult.fail("用户ID必须大于0");
            }
            User existUser = userMapper.selectById(id);
            if (ObjectUtils.isEmpty(existUser)) {
                return JsonResult.fail("未找到对应用户，无法删除");
            }
            int rows = userMapper.deleteById(id);
            if (rows > 0) {
                return JsonResult.success("删除用户成功");
            }
            return JsonResult.fail("删除用户失败");
        } catch (Exception e) {
            log.error("删除用户异常，userId：{}", id, e);
            return JsonResult.fail("删除用户失败：" + e.getMessage());
        }
    }
}