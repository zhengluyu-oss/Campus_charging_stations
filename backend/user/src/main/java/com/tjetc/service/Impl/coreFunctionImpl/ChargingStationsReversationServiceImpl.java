package com.tjetc.service.Impl.coreFunctionImpl;

import com.tjetc.common.AuthUtils;
import com.tjetc.entity.core.Reservation;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.ChargingStationsMapper;
import com.tjetc.dao.ReservationMapper;
import com.tjetc.entity.core.ChargingStation;
import com.tjetc.service.service.coreFunction.ChargingStationsReversationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ChargingStationsReversationServiceImpl implements ChargingStationsReversationService {

    private static final Logger logger = LoggerFactory.getLogger(ChargingStationsReversationServiceImpl.class);
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private ReservationMapper reservationMapper;

    @Autowired
    private ChargingStationsMapper chargingStationsMapper;

    @Autowired
    private ChargingAsyncService chargingAsyncService;

    @Override
    public JsonResult reserveCharging(Integer userId, Integer stationId, Integer delayMinutes, Integer chargingDuration) {
        userId = AuthUtils.resolveUserId(userId);
        if (userId == null) {
            return AuthUtils.forbiddenUserMismatch();
        }
        if (stationId == null || delayMinutes == null || chargingDuration == null) {
            return JsonResult.fail("参数不能为空");
        }

        ChargingStation station = chargingStationsMapper.selectById(stationId);
        if (station == null) {
            return JsonResult.fail("充电桩不存在");
        }
        if ("1".equals(station.getStatus())) {
            return JsonResult.fail("充电桩正在使用中，无法预约");
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime reservedStartTime = now.plusMinutes(delayMinutes);
        LocalDateTime reservedEndTime = reservedStartTime.plusMinutes(chargingDuration);

        Reservation reservation = new Reservation();
        reservation.setUserId(userId);
        reservation.setStationId(stationId);
        reservation.setReservedStartTime(reservedStartTime);
        reservation.setReservedEndTime(reservedEndTime);
        reservation.setStatus("confirmed");
        reservation.setCreatedAt(now);

        reservationMapper.insert(reservation);
        logger.info("预约记录创建成功，预约ID: {}", reservation.getReservationId());

        chargingStationsMapper.updateChargingStationStatusAndTime(stationId);
        logger.info("用户{}预约充电桩{}，{}分钟后开始充电，充电时长{}分钟", userId, stationId, delayMinutes, chargingDuration);

        chargingAsyncService.startReserveTimer(userId, stationId, delayMinutes, chargingDuration, station.getPricePerHour());

        return JsonResult.success("预约成功，将在" + delayMinutes + "分钟后开始充电");
    }

    @Override
    public JsonResult getUserReservations(String userId) {
        try {
            Integer userIdInt;
            if (userId == null || userId.isBlank()) {
                userIdInt = AuthUtils.resolveUserId(null);
            } else {
                try {
                    userIdInt = AuthUtils.resolveUserId(Integer.parseInt(userId));
                } catch (NumberFormatException e) {
                    return JsonResult.fail("用户ID格式错误");
                }
            }
            if (userIdInt == null) {
                return AuthUtils.forbiddenUserMismatch();
            }

            Page<Reservation> page = new Page<>(1, 20);
            IPage<Reservation> reservationPage = reservationMapper.selectPageByUserId(page, userIdInt);

            return JsonResult.success(reservationPage.getRecords());
        } catch (Exception e) {
            logger.error("查询用户预约记录时发生异常", e);
            return JsonResult.fail("系统异常：" + e.getMessage());
        }
    }

    @Override
    public JsonResult getStationReservations(Integer stationId) {
        try {
            if (stationId == null) {
                return JsonResult.fail("充电桩ID不能为空");
            }

            ChargingStation chargingStation = chargingStationsMapper.selectById(stationId);
            if (chargingStation == null) {
                return JsonResult.fail("充电桩不存在");
            }

            Page<Reservation> page = new Page<>(1, 20);
            IPage<Reservation> reservationPage = reservationMapper.selectPageByStationId(page, stationId);

            return JsonResult.success(reservationPage.getRecords());
        } catch (Exception e) {
            logger.error("查询充电桩预约记录时发生异常", e);
            return JsonResult.fail("系统异常：" + e.getMessage());
        }
    }

    @Override
    public JsonResult getStationReservationsByTimeRange(Integer stationId, String startTime, String endTime) {
        try {
            if (stationId == null || startTime == null || endTime == null) {
                return JsonResult.fail("参数不能为空");
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime startDateTime;
            LocalDateTime endDateTime;

            try {
                startDateTime = LocalDateTime.parse(startTime, formatter);
                endDateTime = LocalDateTime.parse(endTime, formatter);
            } catch (Exception e) {
                return JsonResult.fail("时间格式错误，请使用 yyyy-MM-dd HH:mm:ss 格式");
            }

            if (startDateTime.isAfter(endDateTime)) {
                return JsonResult.fail("开始时间不能晚于结束时间");
            }

            ChargingStation chargingStation = chargingStationsMapper.selectById(stationId);
            if (chargingStation == null) {
                return JsonResult.fail("充电桩不存在");
            }

            List<Reservation> reservations = reservationMapper.selectByTimeRangeAndStationId(
                    stationId, startDateTime, endDateTime);

            return JsonResult.success(reservations);
        } catch (Exception e) {
            logger.error("查询时间段内充电桩预约记录时发生异常", e);
            return JsonResult.fail("系统异常：" + e.getMessage());
        }
    }
}
