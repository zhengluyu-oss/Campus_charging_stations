package com.tjetc.controller.CoreFunctionController;

import com.tjetc.common.AuthUtils;
import com.tjetc.common.JsonResult;
import com.tjetc.dto.OrderSelectDTO;
import com.tjetc.entity.core.Orders;
import com.tjetc.service.service.coreFunction.ChargingStationOrderSelectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 订单查询控制器
 * 提供用户端订单的查询功能
 */
@RestController
@RequestMapping("/api")
@Slf4j
@Tag(name = "订单查询", description = "处理用户订单的查询操作")
public class ChargingStationOrderSelectController {
    @Autowired
    private ChargingStationOrderSelectService chargingStationOrderSelectService;

    /**
     * 查询用户所有订单
     * @param orderSelectDTO 查询条件（JSON格式）
     * @return 用户的订单列表
     */
    @PostMapping("/selectAll")
    @Operation(summary = "查询用户所有订单")
    public JsonResult selectAll(@RequestBody OrderSelectDTO orderSelectDTO){
        Integer userId = AuthUtils.resolveUserId(orderSelectDTO.getUserId());
        if (userId == null) {
            return AuthUtils.forbiddenUserMismatch();
        }
        List<Orders> orders = chargingStationOrderSelectService.selectAll(userId);
        return JsonResult.success(orders);
    }
}
