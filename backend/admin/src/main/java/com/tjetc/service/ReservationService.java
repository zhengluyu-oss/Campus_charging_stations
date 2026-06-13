package com.tjetc.service;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.ReservationDTO;
import com.tjetc.entity.core.Reservation;


import java.time.LocalDateTime;

public interface ReservationService {
    /**
     * 查询所有预约记录
     *
     * @return
     */
    JsonResult<Reservation> findAll();

    /**
     * 新增预约记录
     *
     * @param reservationDTO 预约DTO
     * @return
     */
    JsonResult add(ReservationDTO reservationDTO);

    /**
     * 按预约状态分页查询预约
     *
     * @param pageNum  页码
     * @param pageSize 每页数量
     * @param status   预约状态
     * @return
     */
    JsonResult findPageByStatus(Integer pageNum, Integer pageSize, String status);

    /**
     * 按用户ID分页查询预约
     *
     * @param pageNum  页码
     * @param pageSize 每页数量
     * @param userId   用户ID
     * @return
     */
    JsonResult findPageByUserId(Integer pageNum, Integer pageSize, Integer userId);

    /**
     * 按充电桩ID分页查询预约
     *
     * @param pageNum   页码
     * @param pageSize  每页数量
     * @param stationId 充电桩ID
     * @return
     */
    JsonResult findPageByStationId(Integer pageNum, Integer pageSize, Integer stationId);

    /**
     * 按时间范围+充电桩ID查询预约（避免重复预约）
     *
     * @param stationId  充电桩ID
     * @param startTime  预约开始时间
     * @param endTime    预约结束时间
     * @return
     */
    JsonResult findByTimeRangeAndStationId(Integer stationId, LocalDateTime startTime, LocalDateTime endTime);

    /**
     * 根据预约ID查询预约信息
     *
     * @param id 预约ID
     * @return
     */
    JsonResult findById(Integer id);

    /**
     * 更新预约状态
     *
     * @param reservationId 预约ID
     * @param status        预约状态
     * @return
     */
    JsonResult updateStatusById(Integer reservationId, String status);

    /**
     * 根据预约ID删除预约记录
     *
     * @param id 预约ID
     * @return
     */
    JsonResult deleteById(Integer id);
}