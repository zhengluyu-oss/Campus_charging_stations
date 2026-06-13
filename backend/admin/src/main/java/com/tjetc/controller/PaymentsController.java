package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.PaymentDTO;
import com.tjetc.dto.PaymentPageDTO;
import com.tjetc.dto.PaymentUpdateDTO;
import com.tjetc.entity.core.Payments;
import com.tjetc.service.PaymentsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 支付记录控制器
 * 处理支付记录相关的HTTP请求
 */
@RestController
@RequestMapping("/payments")
@Slf4j
@Tag(name = "支付管理", description = "处理支付记录的管理相关操作")
public class PaymentsController {

    @Autowired
    private PaymentsService paymentsService;

    /**
     * 查询所有支付记录
     * GET /payments/all
     * @return JsonResult 所有支付记录列表
     */
    @GetMapping("/all")
    @Operation(summary = "查询所有支付记录")
    public JsonResult<Payments> findAll() {
        log.info("接收查询所有支付记录请求");
        return paymentsService.findAll();
    }

    /**
     * 新增支付记录
     * POST /payments/add
     * @param paymentDTO 支付记录DTO（JSON格式）
     * @return JsonResult 新增结果
     */
    @PostMapping("/add")
    @Operation(summary = "新增支付记录")
    public JsonResult add(@RequestBody PaymentDTO paymentDTO) {
        log.info("接收新增支付记录请求，参数：{}", paymentDTO);
        return paymentsService.add(paymentDTO);
    }

    /**
     * 按订单ID查询支付记录
     * GET /payments/order/{orderId}
     * @param orderId 订单ID（路径参数）
     * @return JsonResult 该订单下的支付记录列表
     */
    @GetMapping("/order/{orderId}")
    @Operation(summary = "按订单ID查询支付记录")
    public JsonResult findByOrderId(@PathVariable Integer orderId) {
        log.info("接收按订单ID查询支付记录请求，orderId：{}", orderId);
        return paymentsService.findByOrderId(orderId);
    }

    /**
     * 按支付状态分页查询支付记录
     * POST /payments/page/status
     * @param paymentPageDTO 分页查询条件（JSON格式）
     * @return JsonResult 分页后的支付记录列表
     */
    @PostMapping("/page/status")
    @Operation(summary = "按支付状态分页查询支付记录")
    public JsonResult findPageByPaymentStatus(@RequestBody PaymentPageDTO paymentPageDTO) {
        log.info("接收按支付状态分页查询请求，pageNum：{}，pageSize：{}，paymentStatus：{}",
                paymentPageDTO.getPageNum(), paymentPageDTO.getPageSize(), paymentPageDTO.getPaymentStatus());
        return paymentsService.findPageByPaymentStatus(
                paymentPageDTO.getPageNum(),
                paymentPageDTO.getPageSize(),
                paymentPageDTO.getPaymentStatus()
        );
    }

    /**
     * 按支付方式分页查询支付记录
     * POST /payments/page/method
     * @param paymentPageDTO 分页查询条件（JSON格式）
     * @return JsonResult 分页后的支付记录列表
     */
    @PostMapping("/page/method")
    @Operation(summary = "按支付方式分页查询支付记录")
    public JsonResult findPageByPaymentMethod(@RequestBody PaymentPageDTO paymentPageDTO) {
        log.info("接收按支付方式分页查询请求，pageNum：{}，pageSize：{}，paymentMethod：{}",
                paymentPageDTO.getPageNum(), paymentPageDTO.getPageSize(), paymentPageDTO.getPaymentMethod());
        return paymentsService.findPageByPaymentMethod(
                paymentPageDTO.getPageNum(),
                paymentPageDTO.getPageSize(),
                paymentPageDTO.getPaymentMethod()
        );
    }

    /**
     * 按ID查询支付记录
     * GET /payments/{id}
     * @param id 支付记录ID（路径参数）
     * @return JsonResult 对应的支付记录
     */
    @GetMapping("/{id}")
    @Operation(summary = "查询支付记录详情")
    public JsonResult findById(@PathVariable Integer id) {
        log.info("接收按ID查询支付记录请求，id：{}", id);
        return paymentsService.findById(id);
    }

    /**
     * 更新支付状态和支付时间
     * PUT /payments/update/status-time
     * @param paymentUpdateDTO 更新信息（JSON格式）
     * @return JsonResult 更新结果
     */
    @PutMapping("/update/status-time")
    @Operation(summary = "更新支付状态和时间")
    public JsonResult updatePaymentStatusAndTime(@RequestBody PaymentUpdateDTO paymentUpdateDTO) {
        log.info("接收更新支付状态和时间请求，paymentId：{}，paymentStatus：{}，paidTime：{}",
                paymentUpdateDTO.getPaymentId(), paymentUpdateDTO.getPaymentStatus(), paymentUpdateDTO.getPaidTime());
        return paymentsService.updatePaymentStatusAndTime(
                paymentUpdateDTO.getPaymentId(),
                paymentUpdateDTO.getPaymentStatus(),
                paymentUpdateDTO.getPaidTime()
        );
    }

    /**
     * 按ID删除支付记录
     * DELETE /payments/{id}
     * @param id 支付记录ID（路径参数）
     * @return JsonResult 删除结果
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "删除支付记录")
    public JsonResult deleteById(@PathVariable Integer id) {
        log.info("接收按ID删除支付记录请求，id：{}", id);
        return paymentsService.deleteById(id);
    }
}
