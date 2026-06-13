package com.tjetc.service.Impl.coreFunctionImpl;

import com.tjetc.dao.ChargingStationsMapper;
import com.tjetc.dao.OrderMapper;
import com.tjetc.entity.core.Orders;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@Slf4j
public class ChargingAsyncService {

    @Autowired
    private ChargingStationsMapper chargingStationsMapper;

    @Autowired
    private OrderMapper orderMapper;

    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Async
    public void startChargingTimer(Integer userId, Integer stationId, Integer chargingDuration,
                                    String startTime, Double pricePerHour) {
        try {
            long durationMillis = chargingDuration * 60 * 1000L;
            Thread.sleep(durationMillis);

            chargingStationsMapper.stopUpdateChargingStationStatus(stationId);
            log.info("充电桩{}充电结束", stationId);

            createOrder(userId, stationId, startTime, chargingDuration, pricePerHour);

        } catch (InterruptedException e) {
            log.error("充电定时任务异常: {}", e.getMessage());
            Thread.currentThread().interrupt();
        }
    }

    @Async
    public void startReserveTimer(Integer userId, Integer stationId, Integer delayMinutes,
                                   Integer chargingDuration, Double pricePerHour) {
        try {
            long delayMillis = delayMinutes * 60 * 1000L;
            Thread.sleep(delayMillis);

            log.info("预约时间到，用户{}开始充电，充电桩{}", userId, stationId);

            LocalDateTime startTime = LocalDateTime.now();
            String startStr = startTime.format(DF);

            long chargingMillis = chargingDuration * 60 * 1000L;
            Thread.sleep(chargingMillis);

            chargingStationsMapper.stopUpdateChargingStationStatus(stationId);
            log.info("充电桩{}充电结束", stationId);

            createOrder(userId, stationId, startStr, chargingDuration, pricePerHour);

        } catch (InterruptedException e) {
            log.error("预约充电定时任务异常: {}", e.getMessage());
            Thread.currentThread().interrupt();
        }
    }

    private void createOrder(Integer userId, Integer stationId, String startTime,
                             Integer chargingDuration, Double pricePerHour) {
        Orders order = new Orders();
        order.setUserId(userId);
        order.setStationId(stationId);
        order.setStartTime(startTime);
        order.setEndTime(LocalDateTime.now().format(DF));
        order.setDurationMinutes(chargingDuration);
        order.setTotalAmount(pricePerHour * chargingDuration / 60.0);
        order.setPaymentStatus("微信支付");
        order.setCreatedTime(LocalDateTime.now().format(DF));

        orderMapper.insert(order);
        log.info("订单创建成功，用户ID: {}, 充电桩ID: {}, 金额: {}", userId, stationId, order.getTotalAmount());
    }
}
