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
@TableName("payments")
public class Payments {
    @TableId(value = "payment_id", type = IdType.AUTO)
    private Integer paymentId;
    private Integer orderId;
    private Double amount;
    @TableField(value = "payments_method")
    private String paymentMethod;
    @TableField(value = "payments_status")
    private String paymentStatus;
    @TableField(value = "paid_time")
    private String paidTime;

}
