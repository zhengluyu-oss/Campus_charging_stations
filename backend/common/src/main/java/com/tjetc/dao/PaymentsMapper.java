package com.tjetc.dao;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.entity.core.Payments;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface PaymentsMapper {
    /**
     * 1. 按订单ID查询支付记录（关联 orders 表外键 order_id）
     */
    List<Payments> selectByOrderId(@Param("orderId") Integer orderId);

    /**
     * 2. 按支付状态分页查询（success/failed/refunded）
     */
    IPage<Payments> selectPageByPaymentStatus(Page<Payments> page, @Param("paymentStatus") String paymentStatus);

    /**
     * 3. 按支付方式分页查询（cash/alipay/wechat pay 等）
     */
    IPage<Payments> selectPageByPaymentMethod(Page<Payments> page, @Param("paymentMethod") String paymentMethod);

    /**
     * 4. 更新支付状态和支付时间
     */
    int updatePaymentStatusAndTime(@Param("paymentId") Integer paymentId, @Param("paymentStatus") String paymentStatus, @Param("paidTime") LocalDateTime paidTime);

    
    
    List<Payments> selectList(Object o);

    int insert(Payments payments);

    Payments selectById(Integer id);

    int deleteById(Integer id);
}
