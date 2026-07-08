package com.tjetc.service.Impl.coreFunctionImpl;

import com.tjetc.dao.ChargingStationsMapper;
import com.tjetc.dao.OrderMapper;
import com.tjetc.entity.core.Orders;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;

/**
 * 异步充电计时服务
 * <p>
 * 职责：
 * 1. 创建订单并写入 order_status = 'charging'
 * 2. 将计时记录写入 Redis ZSET (charging:timers) 供定时任务兜底
 * 3. Thread.sleep() 作为快速触发路径（非唯一依赖）
 * 4. Sleep 结束后检查订单是否已被定时任务处理，避免重复完成
 */
@Service
@Slf4j
public class ChargingAsyncService {

    private static final String CHARGING_TIMERS_KEY = "charging:timers";
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private StringRedisTemplate redisTemplate;

    @Autowired
    private ChargingStationsMapper chargingStationsMapper;

    @Autowired
    private OrderMapper orderMapper;

    /**
     * 直接充电计时（无预约等待）
     * 内部创建订单并记录到 Redis ZSET，Sleep 结束后自动完成充电
     */
    @Async
    public void startChargingTimer(Integer userId, Integer stationId, Integer chargingDuration,
                                    String startTime, Double pricePerHour) {
        long endTimestamp = System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(chargingDuration);

        try {
            // 1. 创建订单
            Orders order = createOrder(userId, stationId, startTime, chargingDuration, pricePerHour);
            Integer newOrderId = order.getOrderId();

            // 2. 设置订单状态为充电中
            order.setOrderStatus("charging");
            orderMapper.updateById(order);

            // 3. 写入 Redis ZSET（供定时任务兜底）
            redisTemplate.opsForZSet().add(CHARGING_TIMERS_KEY, newOrderId.toString(), endTimestamp);
            log.info("充电计时已记录: orderId={}, stationId={}, 预计结束时间戳={}", newOrderId, stationId, endTimestamp);

            // 4. 快速触发路径：Thread.sleep
            long durationMillis = TimeUnit.MINUTES.toMillis(chargingDuration);
            Thread.sleep(durationMillis);

            // 5. Sleep 结束后，检查订单是否已被定时任务处理
            completeChargingIfNeeded(newOrderId, stationId);

        } catch (InterruptedException e) {
            log.warn("充电定时任务被中断，stationId={}", stationId);
            Thread.currentThread().interrupt();
        }
    }

    /**
     * 预约充电计时（含等待时间 + 充电时间）
     */
    @Async
    public void startReserveTimer(Integer userId, Integer stationId, Integer delayMinutes,
                                   Integer chargingDuration, Double pricePerHour) {
        try {
            // 1. 等待预约时间
            long delayMillis = TimeUnit.MINUTES.toMillis(delayMinutes);
            Thread.sleep(delayMillis);

            log.info("预约时间到，用户{}开始充电，充电桩{}", userId, stationId);

            // 2. 充电开始：记录时间、创建订单
            LocalDateTime startTime = LocalDateTime.now();
            String startStr = startTime.format(DF);

            Orders order = createOrder(userId, stationId, startStr, chargingDuration, pricePerHour);
            Integer orderId = order.getOrderId();

            order.setOrderStatus("charging");
            orderMapper.updateById(order);

            long endTimestamp = System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(chargingDuration);
            redisTemplate.opsForZSet().add(CHARGING_TIMERS_KEY, orderId.toString(), endTimestamp);
            log.info("预约充电已记录: orderId={}, stationId={}, 预计结束时间戳={}", orderId, stationId, endTimestamp);

            // 3. 充电计时
            long chargingMillis = TimeUnit.MINUTES.toMillis(chargingDuration);
            Thread.sleep(chargingMillis);

            // 4. 完成充电
            completeChargingIfNeeded(orderId, stationId);

        } catch (InterruptedException e) {
            log.warn("预约充电定时任务被中断，stationId={}", stationId);
            Thread.currentThread().interrupt();
        }
    }

    /**
     * 完成充电：更新订单状态 + 释放充电桩，仅在订单仍为 'charging' 状态时执行
     */
    private void completeChargingIfNeeded(Integer orderId, Integer stationId) {
        Orders order = orderMapper.selectById(orderId);
        if (order == null) {
            log.warn("订单 {} 不存在，跳过充电完成处理", orderId);
            redisTemplate.opsForZSet().remove(CHARGING_TIMERS_KEY, orderId.toString());
            return;
        }

        // 检查订单是否已被定时任务处理
        if (!"charging".equals(order.getOrderStatus())) {
            log.info("订单 {} 已被定时任务或其他路径处理，当前状态: {}", orderId, order.getOrderStatus());
            return;
        }

        // 更新订单状态
        order.setOrderStatus("completed");
        order.setEndTime(LocalDateTime.now().format(DF));
        orderMapper.updateById(order);

        // 释放充电桩
        chargingStationsMapper.updateStatus(stationId, "available");

        // 从 ZSET 移除
        redisTemplate.opsForZSet().remove(CHARGING_TIMERS_KEY, orderId.toString());

        log.info("充电完成: orderId={}, stationId={}, 充电桩已释放", orderId, stationId);
    }

    private Orders createOrder(Integer userId, Integer stationId, String startTime,
                                Integer chargingDuration, Double pricePerHour) {
        Orders order = new Orders();
        order.setUserId(userId);
        order.setStationId(stationId);
        order.setStartTime(startTime);
        order.setDurationMinutes(chargingDuration);
        order.setTotalAmount(pricePerHour * chargingDuration / 60.0);
        order.setPaymentStatus("unpaid");
        order.setOrderStatus("pending");
        order.setCreatedTime(LocalDateTime.now().format(DF));

        orderMapper.insert(order);
        log.info("订单创建成功: orderId={}, userId={}, stationId={}, 金额={}",
                order.getOrderId(), userId, stationId, order.getTotalAmount());
        return order;
    }
}
