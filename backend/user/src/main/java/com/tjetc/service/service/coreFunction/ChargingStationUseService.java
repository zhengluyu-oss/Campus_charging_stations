package com.tjetc.service.service.coreFunction;

import com.tjetc.common.JsonResult;

public interface ChargingStationUseService {
    /**
     * 开始充电
     * @param userId 用户ID
     * @param stationId 充电桩ID
     * @param chargingDuration 充电时长（分钟）
     */
    JsonResult useChargingStation(Integer userId, Integer stationId, Integer chargingDuration);
}