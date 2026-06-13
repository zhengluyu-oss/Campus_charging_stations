package com.tjetc.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjetc.common.JsonResult;
import com.tjetc.dto.OrderDTO;
import com.tjetc.dto.OrderPageDTO;
import com.tjetc.dto.OrderCountDTO;
import com.tjetc.entity.core.Orders;
import com.tjetc.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/order")
@Slf4j
@Tag(name = "订单管理", description = "处理订单的管理相关操作")
public class OrderController {
    @Autowired
    private OrderService orderService;

    @GetMapping("/list")
    @Operation(summary = "查询所有订单")
    public JsonResult<List<Orders>> list() {
        return orderService.findAll();
    }

    @PostMapping("/add")
    @Operation(summary = "新增订单")
    public JsonResult<Orders> add(@RequestBody OrderDTO orderDTO) {
        return orderService.add(orderDTO);
    }

    @PostMapping("/page/payment-status")
    @Operation(summary = "按支付状态分页查询订单")
    public JsonResult<IPage<Orders>> pageByPaymentStatus(@RequestBody OrderPageDTO orderPageDTO) {
        return orderService.findPageByPaymentStatus(
                orderPageDTO.getPageNum() != null ? orderPageDTO.getPageNum() : 1,
                orderPageDTO.getPageSize() != null ? orderPageDTO.getPageSize() : 10,
                orderPageDTO.getPaymentStatus() != null ? orderPageDTO.getPaymentStatus() : ""
        );
    }

    @PostMapping("/page/user")
    @Operation(summary = "按用户ID分页查询订单")
    public JsonResult<IPage<Orders>> pageByUserId(@RequestBody OrderPageDTO orderPageDTO) {
        return orderService.findPageByUserId(
                orderPageDTO.getPageNum() != null ? orderPageDTO.getPageNum() : 1,
                orderPageDTO.getPageSize() != null ? orderPageDTO.getPageSize() : 10,
                orderPageDTO.getUserId()
        );
    }

    @PostMapping("/page/station")
    @Operation(summary = "按充电桩ID分页查询订单")
    public JsonResult<IPage<Orders>> pageByStationId(@RequestBody OrderPageDTO orderPageDTO) {
        return orderService.findPageByStationId(
                orderPageDTO.getPageNum() != null ? orderPageDTO.getPageNum() : 1,
                orderPageDTO.getPageSize() != null ? orderPageDTO.getPageSize() : 10,
                orderPageDTO.getStationId()
        );
    }

    @PostMapping("/count/time-range")
    @Operation(summary = "按时间范围统计订单数据")
    public JsonResult<Map<String, Object>> countOrderDataByTimeRange(@RequestBody OrderCountDTO orderCountDTO) {
        return orderService.countOrderDataByTimeRange(orderCountDTO.getStartTime(), orderCountDTO.getEndTime());
    }

    @GetMapping("/detail/{id}")
    @Operation(summary = "查询订单详情")
    public JsonResult<Orders> detail(@PathVariable("id") Integer id) {
        return orderService.findById(id);
    }

    @DeleteMapping("/delete/{id}")
    @Operation(summary = "删除订单")
    public JsonResult<String> delete(@PathVariable("id") Integer id) {
        return orderService.deleteById(id);
    }
}
