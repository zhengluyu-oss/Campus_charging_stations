package com.tjetc.service;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.PaymentDTO;
import com.tjetc.entity.core.Payments;


import java.time.LocalDateTime;

public interface PaymentsService {
    /**
     * 查询所有支付记录
     *
     * @return
     */
    JsonResult<Payments> findAll();

    /**
     * 新增支付记录
     *
     * @param paymentDTO 支付DTO
     * @return
     */
    JsonResult add(PaymentDTO paymentDTO);

    /**
     * 按订单ID查询支付记录
     *
     * @param orderId 订单ID
     * @return
     */
    JsonResult findByOrderId(Integer orderId);

    /**
     * 按支付状态分页查询支付记录
     *
     * @param pageNum        页码
     * @param pageSize       每页数量
     * @param paymentStatus  支付状态
     * @return
     */
    JsonResult findPageByPaymentStatus(Integer pageNum, Integer pageSize, String paymentStatus);

    /**
     * 按支付方式分页查询支付记录
     *
     * @param pageNum         页码
     * @param pageSize        每页数量
     * @param paymentMethod   支付方式
     * @return
     */
    JsonResult findPageByPaymentMethod(Integer pageNum, Integer pageSize, String paymentMethod);

    /**
     * 根据支付记录ID查询支付信息
     *
     * @param id 支付记录ID
     * @return
     */
    JsonResult findById(Integer id);

    /**
     * 更新支付状态和支付时间
     *
     * @param paymentId     支付记录ID
     * @param paymentStatus 支付状态
     * @param paidTime      支付完成时间
     * @return
     */
    JsonResult updatePaymentStatusAndTime(Integer paymentId, String paymentStatus, LocalDateTime paidTime);

    /**
     * 根据支付记录ID删除支付记录
     *
     * @param id 支付记录ID
     * @return
     */
    JsonResult deleteById(Integer id);
}