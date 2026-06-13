package com.tjetc.service.service.coreFunction;

import com.tjetc.entity.core.ChargingStation;
import com.tjetc.entity.core.Orders;
import com.tjetc.entity.core.Reservation;

import java.util.List;
import java.util.Map;

public interface ChargeMonitorService {

    // 获取用户当前充电状态
    Map<String, Object> getUserCurrentChargeStatus(Integer userId);

    // 获取用户历史充电记录
    List<Orders> getUserChargeHistory(Integer userId);

    // 获取用户当前预约信息
    Reservation getCurrentReservation(Integer userId);

    // 获取附近充电桩的实时状态
    List<ChargingStation> getNearbyStations(double latitude, double longitude, double radius);

    // 获取充电统计数据
    Map<String, Object> getChargeStatistics(Integer userId);
}