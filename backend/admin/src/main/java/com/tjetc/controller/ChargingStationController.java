package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.ChargingStationDTO;
import com.tjetc.dto.ChargingStationPageDTO;
import com.tjetc.service.ChargingStationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 充电桩管理控制器
 * 提供充电桩的查询、新增、更新、删除等操作
 */
@RestController
@RequestMapping("/chargingStation")
@Slf4j
@Tag(name = "充电桩管理", description = "处理充电桩的管理相关操作")
public class ChargingStationController {

    private final ChargingStationService chargingStationService;

    public ChargingStationController(ChargingStationService chargingStationService) {
        this.chargingStationService = chargingStationService;
    }

    /**
     * 查询所有充电桩
     * @return 充电桩列表
     */
    @GetMapping("/all")
    @Operation(summary = "查询所有充电桩")
    public JsonResult findAll() {
        return chargingStationService.findAll();
    }

    /**
     * 分页查询充电桩
     * @param chargingStationPageDTO 分页查询条件（JSON格式）
     * @return 分页后的充电桩列表
     */
    @PostMapping("/page")
    @Operation(summary = "分页查询充电桩")
    public JsonResult findPage(@RequestBody ChargingStationPageDTO chargingStationPageDTO) {
        return chargingStationService.findPage(
                chargingStationPageDTO.getPageNum() != null ? chargingStationPageDTO.getPageNum() : 1,
                chargingStationPageDTO.getPageSize() != null ? chargingStationPageDTO.getPageSize() : 10,
                chargingStationPageDTO.getStationName()
        );
    }

    /**
     * 新增充电桩
     * @param chargingStationDTO 充电桩DTO信息
     * @return 操作结果，成功或失败信息
     */
    @PostMapping("/add")
    @Operation(summary = "新增充电桩")
    public JsonResult add(@RequestBody ChargingStationDTO chargingStationDTO) {
        log.info("接收【新增充电桩】请求：{}", chargingStationDTO);
        return chargingStationService.add(chargingStationDTO);
    }

    /**
     * 更新充电桩信息
     * @param chargingStationDTO 充电桩DTO信息，包含ID
     * @return 操作结果，成功或失败信息
     */
    @PostMapping("/update")
    @Operation(summary = "更新充电桩")
    public JsonResult updateById(@RequestBody ChargingStationDTO chargingStationDTO) {
        log.info("接收【更新充电桩】请求，ID：{}", chargingStationDTO.getStationId());
        return chargingStationService.updateById(chargingStationDTO);
    }

    /**
     * 删除充电桩
     * @param stationId 充电桩ID
     * @return 操作结果，成功或失败信息
     */
    @PostMapping("/delete/{stationId}")
    @Operation(summary = "删除充电桩")
    public JsonResult deleteById(@PathVariable("stationId") Integer stationId) {
        log.info("接收【删除充电桩】请求，ID：{}", stationId);
        return chargingStationService.deleteById(stationId);
    }

    /**
     * 查询充电桩详情
     * @param stationId 充电桩ID
     * @return 充电桩详情信息
     */
    @GetMapping("/detail/{stationId}")
    @Operation(summary = "查询充电桩详情")
    public JsonResult findById(@PathVariable("stationId") Integer stationId) {
        return chargingStationService.findById(stationId);
    }
}
