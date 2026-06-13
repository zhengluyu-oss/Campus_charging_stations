package com.tjetc.controller.CoreFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.StartChargingDTO;
import com.tjetc.service.service.coreFunction.ChargingStationUseService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user/charging")
@Slf4j
@Tag(name = "充电桩使用", description = "处理充电桩的开始充电操作")
public class ChargingStationUseController {

    @Autowired
    private ChargingStationUseService chargingStationUseService;

    @PostMapping("/start")
    @Operation(summary = "开始充电")
    public JsonResult start(@RequestBody StartChargingDTO startChargingDTO) {
        log.info("用户{}开始使用充电桩{}，充电时长{}分钟", 
                startChargingDTO.getUserId(), 
                startChargingDTO.getStationId(), 
                startChargingDTO.getChargingDuration());
        return chargingStationUseService.useChargingStation(  
                startChargingDTO.getUserId(),
                startChargingDTO.getStationId(),    
                startChargingDTO.getChargingDuration()
        );
    }
}