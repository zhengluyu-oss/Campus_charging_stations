package com.tjetc.service.Impl.coreFunctionImpl;

import com.tjetc.dao.ChargingStationsMapper;
import com.tjetc.dao.OrderMapper;
import com.tjetc.entity.core.Orders;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Set;

/**
 * 充电计时兜底定时任务
 * <p>
 * 每 30 秒扫描 Redis ZSET 中已超时的充电订单，自动完成充电并释放充电桩。
 * 作为 @Async Thread.sleep() 的兜底机制：即使服务重启，定时任务也能恢复所有充电状态。
 * <p>
 * Redis Key: charging:timers (ZSET)
 * - member:  订单ID (orderId 的字符串形式)
 * - score:   预计结束时间戳 (System.currentTimeMillis)
 */
@Component
@Slf4j
public class ChargingTimerScheduler {

    private static final String CHARGING_TIMERS_KEY = "charging:timers";
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private StringRedisTemplate redisTemplate;

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private ChargingStationsMapper chargingStationsMapper;

    /**
     * 每 30 秒扫描一次，自动完成已超时的充电订单
     */
    @Scheduled(fixedRate = 30000)
    public void scanExpiredChargingOrders() {
        long now = System.currentTimeMillis();

        // 从 Redis ZSET 获取所有已过期的订单 ID
        Set<String> expiredOrderIds = redisTemplate.opsForZSet()
                .rangeByScore(CHARGING_TIMERS_KEY, 0, now);

        if (expiredOrderIds == null || expiredOrderIds.isEmpty()) {
            return;
        }

        for (String orderIdStr : expiredOrderIds) {
            try {
                Integer orderId = Integer.valueOf(orderIdStr);

                // 查询订单，避免重复处理
                Orders order = orderMapper.selectById(orderId);
                if (order == null || !"charging".equals(order.getOrderStatus())) {
                    // 订单不存在或状态异常，直接移除 ZSET 条目
                    redisTemplate.opsForZSet().remove(CHARGING_TIMERS_KEY, orderIdStr);
                    continue;
                }

                // 更新订单状态为 completed
                order.setOrderStatus("completed");
                order.setEndTime(LocalDateTime.now().format(DF));
                orderMapper.updateById(order);

                // 释放充电桩
                chargingStationsMapper.updateStatus(order.getStationId(), "available");

                // 从 ZSET 移除
                redisTemplate.opsForZSet().remove(CHARGING_TIMERS_KEY, orderIdStr);

                log.info("定时任务: 订单 {} 充电完成，充电桩 {} 已释放",
                        orderId, order.getStationId());

            } catch (Exception e) {
                log.warn("定时任务处理订单 {} 异常: {}", orderIdStr, e.getMessage());
            }
        }
    }
}
