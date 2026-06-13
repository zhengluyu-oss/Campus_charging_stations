package com.tjetc.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.entity.core.Orders;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface OrderMapper extends BaseMapper<Orders> {

    IPage<Orders> selectPageByPaymentStatus(Page<Orders> page, @Param("paymentStatus") String paymentStatus);

    IPage<Orders> selectPageByUserId(Page<Orders> page, @Param("userId") Integer userId);

    IPage<Orders> selectPageByStationId(Page<Orders> page, @Param("stationId") Integer stationId);

    Map<String, Object> countOrderDataByTimeRange(@Param("startTime") LocalDateTime startTime, @Param("endTime") LocalDateTime endTime);

    List<Orders> selectByUserId(@Param("userId") Integer userId);

    Orders selectById(Integer orderId);

    int updateById(Orders order);
}