package com.tjetc.service.Impl.coreFunctionImpl;

import com.tjetc.common.AuthUtils;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.OrderMapper;
import com.tjetc.entity.core.Orders;

import com.tjetc.service.service.coreFunction.ChargingStationOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
@Slf4j
@Service
public class ChargingStationOrderServiceImpl implements ChargingStationOrderService {
    @Autowired
    private OrderMapper orderMapper;

    @Override
    public JsonResult findByUserId(Integer userId) {
        try {
            userId = AuthUtils.resolveUserId(userId);
            if (userId == null) {
                return AuthUtils.forbiddenUserMismatch();
            }
            List<Orders> ordersList = orderMapper.selectByUserId(userId);
            return new JsonResult(0, "订单查询成功", ordersList);
        } catch (Exception e) {
            log.error("查询订单失败，userId：{}", userId, e);
            return new JsonResult(500, "查询订单失败，请稍后重试", null);
        }
    }

    @Override
    public JsonResult cancelOrder(Integer orderId) {
        try {
            Orders order = orderMapper.selectById(orderId);
            if (order == null) {
                return new JsonResult(-1, "订单不存在", null);
            }
            // 用户归属校验：仅订单所有者可取消
            Integer currentUserId = AuthUtils.resolveUserId(null);
            if (currentUserId == null || !order.getUserId().equals(currentUserId)) {
                return AuthUtils.forbiddenUserMismatch();
            }
            if ("cancelled".equals(order.getOrderStatus())) {
                return new JsonResult(-1, "订单已取消，请勿重复操作", null);
            }
            if ("completed".equals(order.getOrderStatus())) {
                return new JsonResult(-1, "订单已完成，无法取消", null);
            }
            Orders update = new Orders();
            update.setOrderId(orderId);
            update.setOrderStatus("cancelled");
            orderMapper.updateById(update);
            return new JsonResult(0, "订单已成功取消", null);
        } catch (Exception e) {
            log.error("取消订单失败，orderId：{}", orderId, e);
            return new JsonResult(500, "取消失败，请稍后重试", null);
        }
    }
}
