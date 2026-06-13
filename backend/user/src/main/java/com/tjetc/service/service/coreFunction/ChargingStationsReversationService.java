package com.tjetc.service.service.coreFunction;

import com.tjetc.common.JsonResult;

public interface ChargingStationsReversationService {

    JsonResult getUserReservations(String userId);

    JsonResult getStationReservations(Integer stationId);

    JsonResult getStationReservationsByTimeRange(Integer stationId, String startTime, String endTime);

    JsonResult reserveCharging(Integer userId, Integer stationId, Integer delayMinutes, Integer chargingDuration);
}
