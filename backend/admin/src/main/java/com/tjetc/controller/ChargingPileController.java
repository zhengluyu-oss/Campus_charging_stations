package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.ChargingStationDTO;
import com.tjetc.dto.ChargingStationPageDTO;
import com.tjetc.service.ChargingStationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

/**
 * 充电桩管理 Controller
 * 复用 ChargingStationService，操作 charging_stations 表
 */
@RestController
@RequestMapping("/chargingPile")
@Slf4j
@Tag(name = "充电桩管理", description = "处理充电桩的管理相关操作")
public class ChargingPileController {

    private final ChargingStationService chargingStationService;

    public ChargingPileController(ChargingStationService chargingStationService) {
        this.chargingStationService = chargingStationService;
    }

    // 1. 分页查询
    @PostMapping("/page")
    @Operation(summary = "分页查询充电桩")
    public JsonResult page(@RequestBody ChargingStationPageDTO chargingStationPageDTO) {
        return chargingStationService.findPage(
                chargingStationPageDTO.getPageNum() != null ? chargingStationPageDTO.getPageNum() : 1,
                chargingStationPageDTO.getPageSize() != null ? chargingStationPageDTO.getPageSize() : 10,
                chargingStationPageDTO.getStationName()
        );
    }

    // 2. 新增 (使用 POST)
    @PostMapping("/add")
    @Operation(summary = "新增充电桩")
    public JsonResult add(@RequestBody ChargingStationDTO stationDTO) {
        // 由于前端 PileManagement 页面字段较少，这里设置数据库必填字段的默认值
        if (stationDTO.getPowerRating() == null) stationDTO.setPowerRating(7.0); // 默认 7kW
        if (stationDTO.getPricePerHour() == null) stationDTO.setPricePerHour(1.0); // 默认 1元/时

        return chargingStationService.add(stationDTO);
    }

    // 3. 修改 (使用 POST，解决 PUT 表单解析问题)
    @PostMapping("/update")
    @Operation(summary = "更新充电桩")
    public JsonResult update(@RequestBody ChargingStationDTO stationDTO) {
        return chargingStationService.updateById(stationDTO);
    }

    // 4. 删除 (使用 POST，解决 DELETE 兼容性问题)
    @PostMapping("/delete/{id}")
    @Operation(summary = "删除充电桩")
    public JsonResult delete(@PathVariable Integer id) {
        return chargingStationService.deleteById(id);
    }

    // 5. 获取区域/站点下拉列表
    // 由于数据库 location 是 ENUM，这里直接返回固定选项，避免修改 common 层
    @GetMapping("/stations")
    @Operation(summary = "获取区域/站点下拉列表")
    public JsonResult getStationOptions() {
        List<String> locations = Arrays.asList("北院", "东院", "南院", "华岩路校区");
        return JsonResult.success(locations);
    }
}
