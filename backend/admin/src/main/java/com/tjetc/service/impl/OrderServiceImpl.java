package com.tjetc.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.OrderMapper;
import com.tjetc.dto.OrderDTO;
import com.tjetc.entity.core.Orders;
import com.tjetc.service.OrderService;
import org.springframework.beans.BeanUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Override
    public JsonResult<List<Orders>> findAll() {
        try {
            List<Orders> orderList = orderMapper.selectList(null);
            return JsonResult.success("查询所有订单成功", orderList);
        } catch (Exception e) {
            log.error("查询所有订单失败", e);
            return JsonResult.fail("查询所有订单失败：" + e.getMessage());
        }
    }

    @Override
    public JsonResult<Orders> add(OrderDTO orderDTO) {
        if (orderDTO == null) {
            return JsonResult.fail("新增订单失败：订单实体不能为空");
        }
        if (orderDTO.getUserId() == null || orderDTO.getStationId() == null) {
            return JsonResult.fail("新增订单失败：用户ID/充电桩ID不能为空");
        }

        try {
            Orders order = new Orders();
            BeanUtils.copyProperties(orderDTO, order);
            if (order.getCreatedTime() == null) {
                order.setCreatedTime(String.valueOf(LocalDateTime.now()));
            }
            int insertCount = orderMapper.insert(order);
            return insertCount > 0 ? JsonResult.success("新增订单成功", order) : JsonResult.fail("新增订单失败");
        } catch (Exception e) {
            log.error("新增订单异常", e);
            return JsonResult.fail("新增订单失败：" + e.getMessage());
        }
    }

    @Override
    public JsonResult<IPage<Orders>> findPageByPaymentStatus(Integer pageNum, Integer pageSize, String paymentStatus) {
        if (pageNum == null || pageNum < 1 || pageSize == null || pageSize < 1) {
            return JsonResult.fail("分页参数异常：页码/每页数量必须大于0");
        }
        if (!StringUtils.hasText(paymentStatus)) {
            return JsonResult.fail("支付状态不能为空");
        }

        try {
            Page<Orders> page = new Page<>(pageNum, pageSize);
            IPage<Orders> orderPage = orderMapper.selectPageByPaymentStatus(page, paymentStatus);
            return JsonResult.success("按支付状态分页查询成功", orderPage);
        } catch (Exception e) {
            log.error("按支付状态分页查询异常", e);
            return JsonResult.fail("按支付状态分页查询失败：" + e.getMessage());
        }
    }

    @Override
    public JsonResult<IPage<Orders>> findPageByUserId(Integer pageNum, Integer pageSize, Integer userId) {
        if (pageNum == null || pageNum < 1 || pageSize == null || pageSize < 1) {
            return JsonResult.fail("分页参数异常：页码/每页数量必须大于0");
        }
        if (userId == null || userId < 1) {
            return JsonResult.fail("用户ID不能为空且必须大于0");
        }

        try {
            Page<Orders> page = new Page<>(pageNum, pageSize);
            IPage<Orders> orderPage = orderMapper.selectPageByUserId(page, userId);
            return JsonResult.success("按用户ID分页查询成功", orderPage);
        } catch (Exception e) {
            log.error("按用户ID分页查询异常", e);
            return JsonResult.fail("按用户ID分页查询失败：" + e.getMessage());
        }
    }

    @Override
    public JsonResult<IPage<Orders>> findPageByStationId(Integer pageNum, Integer pageSize, Integer stationId) {
        if (pageNum == null || pageNum < 1 || pageSize == null || pageSize < 1) {
            return JsonResult.fail("分页参数异常：页码/每页数量必须大于0");
        }
        if (stationId == null || stationId < 1) {
            return JsonResult.fail("充电桩ID不能为空且必须大于0");
        }

        try {
            Page<Orders> page = new Page<>(pageNum, pageSize);
            IPage<Orders> orderPage = orderMapper.selectPageByStationId(page, stationId);
            return JsonResult.success("按充电桩ID分页查询成功", orderPage);
        } catch (Exception e) {
            log.error("按充电桩ID分页查询异常", e);
            return JsonResult.fail("按充电桩ID分页查询失败：" + e.getMessage());
        }
    }

    @Override
    public JsonResult<Map<String, Object>> countOrderDataByTimeRange(LocalDateTime startTime, LocalDateTime endTime) {
        if (startTime == null || endTime == null) {
            return JsonResult.fail("时间范围不能为空：开始时间/结束时间必须传入");
        }
        if (startTime.isAfter(endTime)) {
            return JsonResult.fail("时间范围异常：开始时间不能晚于结束时间");
        }

        try {
            Map<String, Object> countMap = orderMapper.countOrderDataByTimeRange(startTime, endTime);
            Long orderCount = (Long) countMap.getOrDefault("orderCount", 0L);
            Object totalAmount = countMap.getOrDefault("totalAmount", 0);
            return JsonResult.success("时间范围订单统计成功", Map.of(
                    "orderCount", orderCount,
                    "totalAmount", totalAmount
            ));
        } catch (Exception e) {
            log.error("时间范围订单统计异常", e);
            return JsonResult.fail("时间范围订单统计失败：" + e.getMessage());
        }
    }

    @Override
    public JsonResult<Orders> findById(Integer id) {
        if (id == null || id < 1) {
            return JsonResult.fail("订单ID不能为空且必须大于0");
        }

        try {
            Orders order = orderMapper.selectById(id);
            if (order == null) {
                return JsonResult.fail("查询订单失败：未找到ID为" + id + "的订单");
            }
            return JsonResult.success("查询订单成功", order);
        } catch (Exception e) {
            log.error("按ID查询订单异常", e);
            return JsonResult.fail("按ID查询订单失败：" + e.getMessage());
        }
    }

    @Override
    public JsonResult<String> deleteById(Integer id) {
        if (id == null || id < 1) {
            return JsonResult.fail("订单ID不能为空且必须大于0");
        }

        try {
            Orders existOrder = orderMapper.selectById(id);
            if (existOrder == null) {
                return JsonResult.fail("删除订单失败：未找到ID为" + id + "的订单");
            }

            int deleteCount = orderMapper.deleteById(id);
            return deleteCount > 0 ? JsonResult.success("删除订单成功") : JsonResult.fail("删除订单失败");
        } catch (Exception e) {
            log.error("删除订单异常", e);
            return JsonResult.fail("删除订单失败：" + e.getMessage());
        }
    }
}
