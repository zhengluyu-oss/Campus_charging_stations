package com.tjetc.service.Impl.coreFunctionImpl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.tjetc.dao.OrderMapper;
import com.tjetc.dao.ReservationMapper;
import com.tjetc.entity.core.ChargingStation;
import com.tjetc.entity.core.Orders;
import com.tjetc.entity.core.Reservation;
import com.tjetc.service.service.coreFunction.ChargeMonitorService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ChargeMonitorServiceImpl implements ChargeMonitorService {

    private final ReservationMapper reservationMapper;
    private final OrderMapper orderMapper;

    public ChargeMonitorServiceImpl(ReservationMapper reservationMapper, OrderMapper orderMapper) {
        this.reservationMapper = reservationMapper;
        this.orderMapper = orderMapper;
    }

    @Override
    public Map<String, Object> getUserCurrentChargeStatus(Integer userId) {
        Map<String, Object> result = new HashMap<>();

        // 查找用户当前有效的预约（状态为已确认或正在使用）
        // 使用分页查询获取用户的所有预约
        com.baomidou.mybatisplus.extension.plugins.pagination.Page<Reservation> page =
            new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(1, 100);
        List<Reservation> userReservations = reservationMapper.selectPageByUserId(page, userId).getRecords();

        Reservation currentReservation = null;
        for (Reservation res : userReservations) {
            if (("confirmed".equals(res.getStatus()) || "used".equals(res.getStatus())) &&
                res.getReservedEndTime().isAfter(LocalDateTime.now())) {
                currentReservation = res;
                break; // 找到第一个符合条件的预约即可
            }
        }

        if (currentReservation != null) {
            result.put("isCharging", true);
            result.put("reservation", currentReservation);
            result.put("stationId", currentReservation.getStationId());
            result.put("startTime", currentReservation.getReservedStartTime());
            result.put("estimatedEndTime", currentReservation.getReservedEndTime());
        } else {
            result.put("isCharging", false);
        }

        return result;
    }

    @Override
    public List<Orders> getUserChargeHistory(Integer userId) {
        // 使用OrderMapper中已有的按用户ID查询方法
        com.baomidou.mybatisplus.extension.plugins.pagination.Page<Orders> page =
            new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(1, 100);
        return orderMapper.selectPageByUserId(page, userId).getRecords();
    }

    @Override
    public Reservation getCurrentReservation(Integer userId) {
        // 使用分页查询获取用户的所有预约
        com.baomidou.mybatisplus.extension.plugins.pagination.Page<Reservation> page =
            new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(1, 100);
        List<Reservation> userReservations = reservationMapper.selectPageByUserId(page, userId).getRecords();

        Reservation currentReservation = null;
        for (Reservation res : userReservations) {
            if ("confirmed".equals(res.getStatus()) && // 当前有效的预约
                res.getReservedEndTime().isAfter(LocalDateTime.now())) {
                if (currentReservation == null ||
                    res.getReservedStartTime().isBefore(currentReservation.getReservedStartTime())) {
                    currentReservation = res; // 找到最早的那个有效预约
                }
            }
        }

        return currentReservation;
    }

    @Override
    public List<ChargingStation> getNearbyStations(double latitude, double longitude, double radius) {
        // 这里需要根据具体的地理位置算法来实现
        // 由于现有实体类中没有经纬度字段，这里返回所有可用的充电桩
        // 实际应用中需要结合地理位置信息进行计算
        QueryWrapper<ChargingStation> wrapper = new QueryWrapper<>();
        wrapper.orderByAsc("status"); // 按状态排序，优先显示可用的充电桩
        return null; // 暂时返回null，因为没有地理坐标字段
    }

    @Override
    public Map<String, Object> getChargeStatistics(Integer userId) {
        Map<String, Object> statistics = new HashMap<>();

        // 使用OrderMapper中已有的按用户ID查询方法
        com.baomidou.mybatisplus.extension.plugins.pagination.Page<Orders> page =
            new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(1, 100);
        List<Orders> userOrders = orderMapper.selectPageByUserId(page, userId).getRecords();

        // 获取用户总充电次数
        int totalSessions = userOrders.size();
        statistics.put("totalSessions", totalSessions);

        // 获取总充电时长和金额
        int totalMinutes = 0;
        double totalAmount = 0.0;
        for (Orders order : userOrders) {
            try {
                Integer duration = order.getDurationMinutes();
                if (duration != null) {
                    totalMinutes += duration;
                    totalAmount += order.getTotalAmount();
                }
            } catch (Exception e) {
                // 忽略无法解析的持续时间
            }
        }

        statistics.put("totalMinutes", totalMinutes);
        statistics.put("totalHours", Math.round(totalMinutes / 60.0 * 100.0) / 100.0);
        statistics.put("totalAmount", totalAmount);

        return statistics;
    }
}