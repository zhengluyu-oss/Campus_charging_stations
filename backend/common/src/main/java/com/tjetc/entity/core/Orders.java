package com.tjetc.entity.core;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("orders")
public class Orders {
    @TableId(value = "order_id", type = IdType.AUTO)
    private Integer orderId;
    private Integer userId;
    private Integer stationId;
    private String startTime;
    private String endTime;
    private Integer durationMinutes;
    private Double totalAmount;
    @TableField(value = "payment_status")
    private String paymentStatus;
    @TableField(value = "created_time")
    private String createdTime;
}
