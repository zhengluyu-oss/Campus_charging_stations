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
        // 先查询充电桩是否存在及获取价格信息（不做状态判断，状态判断交给条件更新）
        ChargingStation station = chargingStationsMapper.selectById(stationId);
        if (station == null) {
            return JsonResult.fail("充电桩不存在");
        }

        // 使用 CAS 条件更新：仅当状态为"available"（空闲）时才更新为"occupied"（使用中）
        // 返回受影响行数，0 表示充电桩已被其他用户抢先使用
        int affectedRows = chargingStationsMapper.updateStatusIfAvailable(stationId, "occupied", "available");
        if (affectedRows == 0) {
            return JsonResult.fail("充电桩正在使用中或状态已变更，请刷新后重试");
        }

        LocalDateTime startTime = LocalDateTime.now();
        String startStr = startTime.format(DF);

        log.info("用户{}开始使用充电桩{}，充电时长{}分钟", userId, stationId, chargingDuration);

        chargingAsyncService.startChargingTimer(userId, stationId, chargingDuration, startStr, station.getPricePerHour());

        return JsonResult.success("开始充电成功");
    }
}
