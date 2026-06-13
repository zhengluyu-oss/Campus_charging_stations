package com.tjetc.dao;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.entity.core.Reservation;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface ReservationMapper {
    /**
     * 1. 按预约状态分页查询（confirmed/used/cancelled）
     */
    IPage<Reservation> selectPageByStatus(Page<Reservation> page, @Param("status") String status);

    /**
     * 2. 按用户ID分页查询（关联 users 表外键 user_id）
     */
    IPage<Reservation> selectPageByUserId(Page<Reservation> page, @Param("userId") Integer userId);

    /**
     * 3. 按充电桩ID分页查询（关联 charging_stations 表外键 station_id）
     */
    IPage<Reservation> selectPageByStationId(Page<Reservation> page, @Param("stationId") Integer stationId);

    /**
     * 4. 按时间范围查询预约记录（避免重复预约）
     */
    List<Reservation> selectByTimeRangeAndStationId(@Param("stationId") Integer stationId, @Param("startTime") LocalDateTime startTime, @Param("endTime") LocalDateTime endTime);

    /**
     * 5. 更新预约状态
     */
    int updateStatusById(@Param("reservationId") Integer reservationId, @Param("status") String status);

    List<Reservation> selectList(Object o);

    int insert(Reservation reservation);

    Reservation selectById(Integer id);

    int deleteById(Integer id);
}
