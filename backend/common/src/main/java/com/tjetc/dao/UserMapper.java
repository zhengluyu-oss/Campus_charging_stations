package com.tjetc.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.entity.userAndAdmin.User;
import org.apache.ibatis.annotations.Param;

public interface UserMapper extends BaseMapper<User> {
    /**
     * 根据用户名或者密码查询用户
     *
     * @param username
     * @param password
     * @return
     */
    User selectByUsernameAndPassword(@Param("username") String username,
                                     @Param("password") String password);

    /**
     * 根据用户名查询用户
     *
     * @param username
     * @return
     */
    User selectByUsername(@Param("username") String username);


    IPage<User> selectPageByUsernameLike(Page<User> page, String likeUsername);
}
