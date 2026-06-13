package com.tjetc.controller.CoreFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.OrderListByUserDTO;
import com.tjetc.service.service.coreFunction.ChargingStationOrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 订单管理控制器
 * 提供用户端订单的查询功能
 */
@RestController
@RequestMapping("/order")
@Tag(name = "订单管理", description = "处理用户订单相关操作")
public class OrderController {
    @Autowired
    private ChargingStationOrderService chargingStationOrderService;

    /**
     * 根据用户ID查询订单列表
     * @param orderListByUserDTO 查询条件（JSON格式）
     * @return 用户的订单列表
     */
    @PostMapping("/listByUserId")
    @Operation(summary = "根据用户ID查询订单列表")
    public JsonResult listByUserId(@RequestBody OrderListByUserDTO orderListByUserDTO) {
        return chargingStationOrderService.findByUserId(orderListByUserDTO.getUserId());
    }
}
