package com.tjetc.controller.CoreFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.ReserveChargingDTO;
import com.tjetc.dto.UserReservationsDTO;
import com.tjetc.dto.StationReservationsDTO;
import com.tjetc.service.service.coreFunction.ChargingStationsReversationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/reversation")
@Slf4j
@Tag(name = "充电桩预约", description = "处理充电桩的预约相关操作")
public class ChargingStationsReversationController {
    @Autowired
    private ChargingStationsReversationService reversationService;

    @PostMapping("/reserve")
    @Operation(summary = "预约充电桩")
    public JsonResult reserve(@RequestBody ReserveChargingDTO reserveChargingDTO) {
        return reversationService.reserveCharging(
                reserveChargingDTO.getUserId(),
                reserveChargingDTO.getStationId(),
                reserveChargingDTO.getDelayMinutes(),
                reserveChargingDTO.getChargingDuration()
        );
    }

    @PostMapping("/getUserReservations")
    @Operation(summary = "获取用户预约记录")
    public JsonResult getUserReservations(@RequestBody UserReservationsDTO userReservationsDTO){
        return reversationService.getUserReservations(userReservationsDTO.getUserId());
    }

    @PostMapping("/getStationReservations")
    @Operation(summary = "获取充电桩预约情况")
    public JsonResult getStationReservations(@RequestBody StationReservationsDTO stationReservationsDTO){
        return reversationService.getStationReservations(stationReservationsDTO.getStationId());
    }
}
