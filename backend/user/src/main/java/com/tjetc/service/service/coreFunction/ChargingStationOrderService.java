package com.tjetc.service.service.coreFunction;

import com.tjetc.common.JsonResult;
import com.tjetc.entity.core.Orders;

import java.util.List;

public interface ChargingStationOrderService {

//    获取全部的订单的信息
//    JsonResult getAllChargingStationOrders();

//    根据订单状态获取信息
//    JsonResult getChargingStationOrders(Integer status);
    // 对应实现类中的 findByUserId
    JsonResult findByUserId(Integer userId);
    // 对应实现类中的 cancelOrder
    JsonResult cancelOrder(Integer orderId);

}
