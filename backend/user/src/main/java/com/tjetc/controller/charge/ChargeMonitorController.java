package com.tjetc.controller.charge;

import com.tjetc.dto.NearbyStationsDTO;
import com.tjetc.dto.UserIdDTO;
import com.tjetc.entity.core.ChargingStation;
import com.tjetc.entity.core.Orders;
import com.tjetc.entity.core.Reservation;
import com.tjetc.service.service.coreFunction.ChargeMonitorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/charge-monitor")
@Tag(name = "充电监控", description = "处理充电相关的监控操作")
public class ChargeMonitorController {

    @Autowired
    private ChargeMonitorService chargeMonitorService;

    // 获取用户当前充电状态
    @PostMapping("/user/current-status")
    @Operation(summary = "获取用户当前充电状态")
    public Map<String, Object> getUserCurrentChargeStatus(@RequestBody UserIdDTO userIdDTO) {
        return chargeMonitorService.getUserCurrentChargeStatus(userIdDTO.getUserId());
    }

    // 获取用户充电历史记录
    @PostMapping("/user/history")
    @Operation(summary = "获取用户充电历史记录")
    public List<Orders> getUserChargeHistory(@RequestBody UserIdDTO userIdDTO) {
        return chargeMonitorService.getUserChargeHistory(userIdDTO.getUserId());
    }

    // 获取用户当前预约信息
    @PostMapping("/user/current-reservation")
    @Operation(summary = "获取用户当前预约信息")
    public Reservation getCurrentReservation(@RequestBody UserIdDTO userIdDTO) {
        return chargeMonitorService.getCurrentReservation(userIdDTO.getUserId());
    }

    // 获取充电统计数据
    @PostMapping("/user/statistics")
    @Operation(summary = "获取充电统计数据")
    public Map<String, Object> getChargeStatistics(@RequestBody UserIdDTO userIdDTO) {
        return chargeMonitorService.getChargeStatistics(userIdDTO.getUserId());
    }

    // 获取附近充电桩状态（模拟）
    @PostMapping("/stations/nearby")
    @Operation(summary = "获取附近充电桩状态")
    public List<ChargingStation> getNearbyStations(@RequestBody NearbyStationsDTO nearbyStationsDTO) {
        return chargeMonitorService.getNearbyStations(
                nearbyStationsDTO.getLatitude(),
                nearbyStationsDTO.getLongitude(),
                nearbyStationsDTO.getRadius()
        );
    }
}
