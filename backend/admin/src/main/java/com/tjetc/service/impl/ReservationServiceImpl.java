package com.tjetc.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.ReservationMapper;
import com.tjetc.dto.ReservationDTO;
import com.tjetc.entity.core.Reservation;
import com.tjetc.service.ReservationService;
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
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    /**
     * 查询所有预约记录
     * @return JsonResult<Reservation> - 成功：返回所有预约记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult<Reservation> findAll() {
        try {
            List<Reservation> reservationList = reservationMapper.selectList(null);
            return JsonResult.success(reservationList);
        } catch (Exception e) {
            log.error("查询所有预约记录失败", e);
            return JsonResult.fail("查询所有预约失败：" + e.getMessage());
        }
    }

    /**
     * 新增预约记录（包含重复预约校验：同一充电桩同一时间段不可重复预约）
     * @param reservationDTO 待新增的预约DTO
     * @return JsonResult - 成功：返回新增成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult add(ReservationDTO reservationDTO) {
        try {
            if (ObjectUtils.isEmpty(reservationDTO.getUserId()) || reservationDTO.getUserId() <= 0) {
                return JsonResult.fail("用户ID必须大于0");
            }
            if (ObjectUtils.isEmpty(reservationDTO.getStationId()) || reservationDTO.getStationId() <= 0) {
                return JsonResult.fail("充电桩ID必须大于0");
            }
            // 将DTO转换为实体类
            Reservation reservation = new Reservation();
            BeanUtils.copyProperties(reservationDTO, reservation);
            LocalDateTime start = reservation.getReservedStartTime();
            LocalDateTime end = reservation.getReservedEndTime();
            if (ObjectUtils.isEmpty(start) || ObjectUtils.isEmpty(end) || start.isAfter(end)) {
                return JsonResult.fail("预约时间不合法（开始时间晚于结束时间）");
            }
            List<Reservation> overlapList = reservationMapper.selectByTimeRangeAndStationId(
                    reservation.getStationId(), start, end
            );
            if (!overlapList.isEmpty()) {
                return JsonResult.fail("该充电桩在所选时间段已被预约，无法重复预约");
            }
            reservation.setStatus("confirmed");
            reservation.setCreatedAt(LocalDateTime.now());
            int rows = reservationMapper.insert(reservation);
            if (rows > 0) {
                return JsonResult.success("新增预约成功");
            }
            return JsonResult.fail("新增预约失败：数据库未受影响");
        } catch (Exception e) {
            log.error("新增预约异常，userId：{}，stationId：{}",
                    reservationDTO.getUserId(), reservationDTO.getStationId(), e);
            return JsonResult.fail("新增预约失败：" + e.getMessage());
        }
    }

    /**
     * 按预约状态分页查询预约记录
     * @param pageNum 页码（需大于0）
     * @param pageSize 每页数量（需大于0）
     * @param status 预约状态（枚举值：confirmed/used/cancelled）
     * @return JsonResult - 成功：返回分页后的预约记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult findPageByStatus(Integer pageNum, Integer pageSize, String status) {
        try {
            if (ObjectUtils.isEmpty(pageNum) || pageNum <= 0 || ObjectUtils.isEmpty(pageSize) || pageSize <= 0) {
                return JsonResult.fail("页码和每页数量必须大于0");
            }
            if (!"confirmed".equals(status) && !"used".equals(status) && !"cancelled".equals(status)) {
                return JsonResult.fail("预约状态只能是：confirmed（已确认）、used（已使用）、cancelled（已取消）");
            }
            Page<Reservation> page = new Page<>(pageNum, pageSize);
            IPage<Reservation> reservationPage = reservationMapper.selectPageByStatus(page, status);
            return JsonResult.success(reservationPage);
        } catch (Exception e) {
            log.error("按状态分页查询预约失败，status：{}", status, e);
            return JsonResult.fail("分页查询预约失败：" + e.getMessage());
        }
    }

    /**
     * 按用户ID分页查询预约记录
     * @param pageNum 页码（需大于0）
     * @param pageSize 每页数量（需大于0）
     * @param userId 用户ID（需大于0）
     * @return JsonResult - 成功：返回分页后的预约记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult findPageByUserId(Integer pageNum, Integer pageSize, Integer userId) {
        try {
            if (ObjectUtils.isEmpty(pageNum) || pageNum <= 0 || ObjectUtils.isEmpty(pageSize) || pageSize <= 0) {
                return JsonResult.fail("页码和每页数量必须大于0");
            }
            if (ObjectUtils.isEmpty(userId) || userId <= 0) {
                return JsonResult.fail("用户ID必须大于0");
            }
            Page<Reservation> page = new Page<>(pageNum, pageSize);
            IPage<Reservation> reservationPage = reservationMapper.selectPageByUserId(page, userId);
            return JsonResult.success(reservationPage);
        } catch (Exception e) {
            log.error("按用户ID分页查询预约失败，userId：{}", userId, e);
            return JsonResult.fail("分页查询预约失败：" + e.getMessage());
        }
    }

    /**
     * 按充电桩ID分页查询预约记录
     * @param pageNum 页码（需大于0）
     * @param pageSize 每页数量（需大于0）
     * @param stationId 充电桩ID（需大于0）
     * @return JsonResult - 成功：返回分页后的预约记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult findPageByStationId(Integer pageNum, Integer pageSize, Integer stationId) {
        try {
            if (ObjectUtils.isEmpty(pageNum) || pageNum <= 0 || ObjectUtils.isEmpty(pageSize) || pageSize <= 0) {
                return JsonResult.fail("页码和每页数量必须大于0");
            }
            if (ObjectUtils.isEmpty(stationId) || stationId <= 0) {
                return JsonResult.fail("充电桩ID必须大于0");
            }
            Page<Reservation> page = new Page<>(pageNum, pageSize);
            IPage<Reservation> reservationPage = reservationMapper.selectPageByStationId(page, stationId);
            return JsonResult.success(reservationPage);
        } catch (Exception e) {
            log.error("按充电桩ID分页查询预约失败，stationId：{}", stationId, e);
            return JsonResult.fail("分页查询预约失败：" + e.getMessage());
        }
    }

    /**
     * 按充电桩ID+时间范围查询重叠的预约记录（用于防重复预约）
     * @param stationId 充电桩ID（需大于0）
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return JsonResult - 成功：返回重叠的预约记录列表；失败：返回错误信息
     */
    @Override
    public JsonResult findByTimeRangeAndStationId(Integer stationId, LocalDateTime startTime, LocalDateTime endTime) {
        try {
            if (ObjectUtils.isEmpty(stationId) || stationId <= 0) {
                return JsonResult.fail("充电桩ID必须大于0");
            }
            if (ObjectUtils.isEmpty(startTime) || ObjectUtils.isEmpty(endTime) || startTime.isAfter(endTime)) {
                return JsonResult.fail("时间范围不合法");
            }
            List<Reservation> reservationList = reservationMapper.selectByTimeRangeAndStationId(
                    stationId, startTime, endTime
            );
            return JsonResult.success(reservationList);
        } catch (Exception e) {
            log.error("按时间范围查询预约失败，stationId：{}", stationId, e);
            return JsonResult.fail("查询预约记录失败：" + e.getMessage());
        }
    }

    /**
     * 按ID查询预约记录
     * @param id 预约记录ID（需大于0）
     * @return JsonResult - 成功：返回对应的预约记录；失败：返回错误信息
     */
    @Override
    public JsonResult findById(Integer id) {
        try {
            if (ObjectUtils.isEmpty(id) || id <= 0) {
                return JsonResult.fail("预约ID必须大于0");
            }
            Reservation reservation = reservationMapper.selectById(id);
            if (ObjectUtils.isEmpty(reservation)) {
                return JsonResult.fail("未查询到该预约记录");
            }
            return JsonResult.success(reservation);
        } catch (Exception e) {
            log.error("按ID查询预约失败，id：{}", id, e);
            return JsonResult.fail("查询预约失败：" + e.getMessage());
        }
    }

    /**
     * 更新预约记录的状态
     * @param reservationId 预约记录ID（需大于0）
     * @param status 新的预约状态（枚举值：confirmed/used/cancelled）
     * @return JsonResult - 成功：返回更新成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult updateStatusById(Integer reservationId, String status) {
        try {
            if (ObjectUtils.isEmpty(reservationId) || reservationId <= 0) {
                return JsonResult.fail("预约ID必须大于0");
            }
            if (!"confirmed".equals(status) && !"used".equals(status) && !"cancelled".equals(status)) {
                return JsonResult.fail("预约状态只能是：confirmed（已确认）、used（已使用）、cancelled（已取消）");
            }
            Reservation exist = reservationMapper.selectById(reservationId);
            if (ObjectUtils.isEmpty(exist)) {
                return JsonResult.fail("未找到对应预约记录");
            }
            int rows = reservationMapper.updateStatusById(reservationId, status);
            if (rows > 0) {
                return JsonResult.success("更新预约状态成功");
            }
            return JsonResult.fail("更新预约状态失败");
        } catch (Exception e) {
            log.error("更新预约状态异常，reservationId：{}", reservationId, e);
            return JsonResult.fail("更新预约状态失败：" + e.getMessage());
        }
    }

    /**
     * 按ID删除预约记录
     * @param id 预约记录ID（需大于0）
     * @return JsonResult - 成功：返回删除成功提示；失败：返回错误信息
     */
    @Override
    @Transactional
    public JsonResult deleteById(Integer id) {
        try {
            if (ObjectUtils.isEmpty(id) || id <= 0) {
                return JsonResult.fail("预约ID必须大于0");
            }
            int rows = reservationMapper.deleteById(id);
            if (rows > 0) {
                return JsonResult.success("删除预约记录成功");
            }
            return JsonResult.fail("删除失败：未找到对应预约记录");
        } catch (Exception e) {
            log.error("删除预约记录异常，id：{}", id, e);
            return JsonResult.fail("删除预约记录失败：" + e.getMessage());
        }
    }
}