package com.tjetc.service.Impl.coreFunctionImpl;

import com.tjetc.common.AuthUtils;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.ChargingStationsMapper;
import com.tjetc.entity.core.ChargingStation;
import com.tjetc.service.service.coreFunction.ChargingStationUseService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
@Slf4j
public class ChargingStationUseServiceImpl implements ChargingStationUseService {

    @Autowired
    private ChargingStationsMapper chargingStationsMapper;

    @Autowired
    private ChargingAsyncService chargingAsyncService;

    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public JsonResult useChargingStation(Integer userId, Integer stationId, Integer chargingDuration) {
        userId = AuthUtils.resolveUserId(userId);
        if (userId == null) {
            return AuthUtils.forbiddenUserMismatch();
        }
        ChargingStation station = chargingStationsMapper.selectById(stationId);
        if (station == null) {
            return JsonResult.fail("充电桩不存在");
        }
        if ("1".equals(station.getStatus())) {
            return JsonResult.fail("充电桩正在使用中");
        }

        LocalDateTime startTime = LocalDateTime.now();
        String startStr = startTime.format(DF);

        chargingStationsMapper.updateChargingStationStatusAndTime(stationId);
        log.info("用户{}开始使用充电桩{}，充电时长{}分钟", userId, stationId, chargingDuration);

        chargingAsyncService.startChargingTimer(userId, stationId, chargingDuration, startStr, station.getPricePerHour());

        return JsonResult.success("开始充电成功");
    }
}
