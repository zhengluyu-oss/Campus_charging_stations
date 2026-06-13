package com.tjetc.entity.core;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 预约实体类，对应数据库 reservations 表
 */
@Data
@TableName("reservations") // 显式指定对应的数据表名（若实体名与表名一致可省略，此处保持规范）
public class Reservation {
    /**
     * 预约ID，主键，自动递增
     */
    @TableId(type = IdType.AUTO)
    private Integer reservationId;

    /**
     * 用户ID，外键关联 users 表的 user_id
     */
    private Integer userId;

    /**
     * 充电桩ID，外键关联 charging_stations 表的 station_id
     */
    private Integer stationId;

    /**
     * 预约开始时间
     */
    private LocalDateTime reservedStartTime;

    /**
     * 预约结束时间
     */
    private LocalDateTime reservedEndTime;

    /**
     * 预约状态，枚举值：confirmed（已确认）、used（已使用）、cancelled（已取消）
     */
    private String status;

    /**
     * 预约创建时间，默认当前时间
     */
    private LocalDateTime createdAt;
}