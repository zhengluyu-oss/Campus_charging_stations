package com.tjetc.entity.userAndAdmin;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("users")
public class User {
    @TableId(value = "user_id", type = IdType.AUTO)
    private Integer id;
    private String username;
    private String password;
    private String email;
    private String phone;
    @TableField(value = "user_type")
    private String userType;
    @TableField(value = "avatar_path")
    private String avatarPath;
    @TableField(value = "updated_time")
    private LocalDateTime updatedTime;
    @TableField(value = "created_time")
    private LocalDateTime createdTime;


    public User(String username, String password, String avatarPath, String email, String phone, String userType) {
        this.username = username;
        this.password = password;
        this.avatarPath = avatarPath;
        this.email = email;
        this.phone = phone;
        this.userType = userType;
    }

}
