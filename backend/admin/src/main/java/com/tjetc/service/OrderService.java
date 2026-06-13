package com.tjetc.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjetc.common.JsonResult;
import com.tjetc.dto.OrderDTO;
import com.tjetc.entity.core.Orders;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface OrderService {
    JsonResult<List<Orders>> findAll();

    JsonResult<Orders> add(OrderDTO orderDTO);

    JsonResult<IPage<Orders>> findPageByPaymentStatus(Integer pageNum, Integer pageSize, String paymentStatus);

    JsonResult<IPage<Orders>> findPageByUserId(Integer pageNum, Integer pageSize, Integer userId);

    JsonResult<IPage<Orders>> findPageByStationId(Integer pageNum, Integer pageSize, Integer stationId);

    JsonResult<Map<String, Object>> countOrderDataByTimeRange(LocalDateTime startTime, LocalDateTime endTime);

    JsonResult<Orders> findById(Integer id);

    JsonResult<String> deleteById(Integer id);
}