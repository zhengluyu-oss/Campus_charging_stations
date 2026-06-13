package com.tjetc.controller.CoreFunctionController;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.ChargingStationLocationDTO;
import com.tjetc.dto.ChargingStationStatusDTO;
import com.tjetc.entity.core.ChargingStation;
import com.tjetc.service.service.coreFunction.ChargingStationSelectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 充电桩查询控制器
 * 提供用户端充电桩的查询功能
 */
@RestController
@RequestMapping("/api")
@Slf4j
@Tag(name = "充电桩查询", description = "处理充电桩的搜索与筛选")
public class ChargingStationsSelectController {

    @Autowired
    private ChargingStationSelectService chargingStationSelectService;

    /**
     * 查询所有充电桩
     * @return 充电桩列表
     */
    @GetMapping("/showAll")
    @Operation(summary = "查询所有充电桩")
    public JsonResult showChargingStations() {
        List<ChargingStation> chargingStations = chargingStationSelectService.selectAll();
        return JsonResult.success(chargingStations);
    }

    /**
     * 根据充电桩位置查询充电桩
     * @param chargingStationLocationDTO 查询条件（JSON格式）
     * @return 该位置的充电桩列表
     */
    @PostMapping("/showByLocation")
    @Operation(summary = "根据位置查询充电桩")
    public JsonResult showChargingStationsByLocation(@RequestBody ChargingStationLocationDTO chargingStationLocationDTO) {
        List<ChargingStation> chargingStations = chargingStationSelectService.selectByLocation(chargingStationLocationDTO.getLocation());
        return JsonResult.success(chargingStations);
    }

    /**
     * 根据充电桩状态查询充电桩
     * @param chargingStationStatusDTO 查询条件（JSON格式）
     * @return 该状态的充电桩列表
     */
    @PostMapping("/showByStatus")
    @Operation(summary = "根据状态查询充电桩")
    public JsonResult showChargingStationsByStatus(@RequestBody ChargingStationStatusDTO chargingStationStatusDTO) {
        List<ChargingStation> chargingStations = chargingStationSelectService.selectByStatus(chargingStationStatusDTO.getStatus());
        return JsonResult.success(chargingStations);
    }

}
