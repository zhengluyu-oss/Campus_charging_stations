package com.tjetc.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.PaymentsMapper;
import com.tjetc.dto.PaymentDTO;
import com.tjetc.entity.core.Payments;
import com.tjetc.service.PaymentsService;
import org.springframework.beans.BeanUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Slf4j
public class PaymentsServiceImpl implements PaymentsService {

    @Autowired
    private PaymentsMapper paymentsMapper;

    /**
     * 查询所有支付记录
     * @return JsonResult<Payments> - 成功：返回所有支付记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult<Payments> findAll() {
        try {
            List<Payments> paymentsList = paymentsMapper.selectList(null);
            return JsonResult.success(paymentsList);
        } catch (Exception e) {
            log.error("查询所有支付记录失败", e);
            return JsonResult.fail("查询所有支付记录失败：" + e.getMessage());
        }
    }

    /**
     * 新增支付记录（包含参数校验：支付金额、支付方式非空）
     * @param paymentDTO 待新增的支付记录DTO
     * @return JsonResult - 成功：返回新增成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult add(PaymentDTO paymentDTO) {
        try {
            if (paymentDTO.getAmount() <= 0) {
                return JsonResult.fail("支付金额必须大于0");
            }
            if (ObjectUtils.isEmpty(paymentDTO.getPaymentMethod())) {
                return JsonResult.fail("支付方式不能为空");
            }
            // 将DTO转换为实体类
            Payments payments = new Payments();
            BeanUtils.copyProperties(paymentDTO, payments);
            int rows = paymentsMapper.insert(payments);
            if (rows > 0) {
                return JsonResult.success("新增支付记录成功");
            }
            return JsonResult.fail("新增支付记录失败：数据库未受影响");
        } catch (Exception e) {
            log.error("新增支付记录异常", e);
            return JsonResult.fail("新增支付记录失败：" + e.getMessage());
        }
    }

    /**
     * 按订单ID查询对应的支付记录
     * @param orderId 订单ID（需大于0）
     * @return JsonResult - 成功：返回该订单下的支付记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult findByOrderId(Integer orderId) {
        try {
            if (ObjectUtils.isEmpty(orderId) || orderId <= 0) {
                return JsonResult.fail("订单ID必须大于0");
            }
            List<Payments> paymentsList = paymentsMapper.selectByOrderId(orderId);
            return JsonResult.success(paymentsList);
        } catch (Exception e) {
            log.error("按订单ID查询支付记录失败，orderId：{}", orderId, e);
            return JsonResult.fail("查询支付记录失败：" + e.getMessage());
        }
    }

    /**
     * 按支付状态分页查询支付记录
     * @param pageNum 页码（需大于0）
     * @param pageSize 每页数量（需大于0）
     * @param paymentStatus 支付状态（枚举值：success/failed/refunded）
     * @return JsonResult - 成功：返回分页后的支付记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult findPageByPaymentStatus(Integer pageNum, Integer pageSize, String paymentStatus) {
        try {
            if (ObjectUtils.isEmpty(pageNum) || pageNum <= 0 || ObjectUtils.isEmpty(pageSize) || pageSize <= 0) {
                return JsonResult.fail("页码和每页数量必须大于0");
            }
            Page<Payments> page = new Page<>(pageNum, pageSize);
            IPage<Payments> paymentsPage = paymentsMapper.selectPageByPaymentStatus(page, paymentStatus);
            return JsonResult.success(paymentsPage);
        } catch (Exception e) {
            log.error("按支付状态分页查询失败，status：{}", paymentStatus, e);
            return JsonResult.fail("分页查询支付记录失败：" + e.getMessage());
        }
    }

    /**
     * 按支付方式分页查询支付记录
     * @param pageNum 页码（需大于0）
     * @param pageSize 每页数量（需大于0）
     * @param paymentMethod 支付方式（枚举值：cash/creditCard/alipay/wechatPpay）
     * @return JsonResult - 成功：返回分页后的支付记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult findPageByPaymentMethod(Integer pageNum, Integer pageSize, String paymentMethod) {
        try {
            if (ObjectUtils.isEmpty(pageNum) || pageNum <= 0 || ObjectUtils.isEmpty(pageSize) || pageSize <= 0) {
                return JsonResult.fail("页码和每页数量必须大于0");
            }
            Page<Payments> page = new Page<>(pageNum, pageSize);
            IPage<Payments> paymentsPage = paymentsMapper.selectPageByPaymentMethod(page, paymentMethod);
            return JsonResult.success(paymentsPage);
        } catch (Exception e) {
            log.error("按支付方式分页查询失败，method：{}", paymentMethod, e);
            return JsonResult.fail("分页查询支付记录失败：" + e.getMessage());
        }
    }

    /**
     * 按ID查询支付记录
     * @param id 支付记录ID（需大于0）
     * @return JsonResult - 成功：返回对应的支付记录；失败：返回错误信息
     */
    @Override
    public JsonResult findById(Integer id) {
        try {
            if (ObjectUtils.isEmpty(id) || id <= 0) {
                return JsonResult.fail("支付记录ID必须大于0");
            }
            Payments payments = paymentsMapper.selectById(id);
            if (ObjectUtils.isEmpty(payments)) {
                return JsonResult.fail("未查询到该支付记录");
            }
            return JsonResult.success(payments);
        } catch (Exception e) {
            log.error("按ID查询支付记录失败，id：{}", id, e);
            return JsonResult.fail("查询支付记录失败：" + e.getMessage());
        }
    }

    /**
     * 更新支付记录的状态和支付时间
     * @param paymentId 支付记录ID（需大于0）
     * @param paymentStatus 新的支付状态（枚举值：success/failed/refunded）
     * @param paidTime 实际支付时间
     * @return JsonResult - 成功：返回更新成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult updatePaymentStatusAndTime(Integer paymentId, String paymentStatus, LocalDateTime paidTime) {
        try {
            if (ObjectUtils.isEmpty(paymentId) || paymentId <= 0) {
                return JsonResult.fail("支付记录ID必须大于0");
            }
            if (ObjectUtils.isEmpty(paymentStatus) || ObjectUtils.isEmpty(paidTime)) {
                return JsonResult.fail("支付状态和支付时间不能为空");
            }
            int rows = paymentsMapper.updatePaymentStatusAndTime(paymentId, paymentStatus, paidTime);
            if (rows > 0) {
                return JsonResult.success("更新支付状态和时间成功");
            }
            return JsonResult.fail("更新失败：未找到对应支付记录或无变更");
        } catch (Exception e) {
            log.error("更新支付状态失败，paymentId：{}", paymentId, e);
            return JsonResult.fail("更新支付状态失败：" + e.getMessage());
        }
    }

    /**
     * 按ID删除支付记录
     * @param id 支付记录ID（需大于0）
     * @return JsonResult - 成功：返回删除成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult deleteById(Integer id) {
        try {
            if (ObjectUtils.isEmpty(id) || id <= 0) {
                return JsonResult.fail("支付记录ID必须大于0");
            }
            int rows = paymentsMapper.deleteById(id);
            if (rows > 0) {
                return JsonResult.success("删除支付记录成功");
            }
            return JsonResult.fail("删除失败：未找到对应支付记录");
        } catch (Exception e) {
            log.error("删除支付记录失败，id：{}", id, e);
            return JsonResult.fail("删除支付记录失败：" + e.getMessage());
        }
    }
}