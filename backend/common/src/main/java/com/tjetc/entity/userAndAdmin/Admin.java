package com.tjetc.entity.userAndAdmin;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
//告诉mybatisplus实体类对应哪张表
@TableName("admin")
public class Admin {
    //@TableId 设置属性id与表哪个字段对应，主键类型是自增
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    //当属性名称和字段一模一样时，就可以不用写@TableField
    //@TableField("username")
    private String username;
    //@TableField("password")
    private String password;
    //@TableField("avatar_path")
    private String avatarPath;
    //@TableField("email")
    private String email;
    //@TableField("telephone")
    private String telephone;
    //@TableField("qq")
    private String qq;
    //字段名称是下划线，属性名称是驼峰，也可以不用写@TableField，mybatis-plus会自动转换
    //@TableField("create_time")
    //@JsonFormat返回和接收json数据，日期格式定义
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    //@TableField("update_time")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
