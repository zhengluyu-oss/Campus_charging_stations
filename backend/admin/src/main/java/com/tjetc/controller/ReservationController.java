package com.tjetc.controller;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.ReservationDTO;
import com.tjetc.dto.ReservationPageDTO;
import com.tjetc.dto.ReservationTimeRangeDTO;
import com.tjetc.dto.ReservationUpdateStatusDTO;
import com.tjetc.entity.core.Reservation;
import com.tjetc.service.ReservationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 预约管理控制器
 * 处理预约相关的HTTP请求
 */
@RestController
@RequestMapping("/reservation")
@Slf4j
@Tag(name = "预约管理", description = "处理预约的管理相关操作")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    /**
     * 查询所有预约记录
     * @return JsonResult - 包含所有预约记录列表或错误信息
     */
    @GetMapping("/all")
    @Operation(summary = "查询所有预约记录")
    public JsonResult<Reservation> findAll() {
        log.info("接收查询所有预约记录请求");
        return reservationService.findAll();
    }

    /**
     * 新增预约记录（包含重复预约校验）
     * @param reservationDTO 预约DTO（JSON格式）
     * @return JsonResult - 新增结果提示
     */
    @PostMapping("/add")
    @Operation(summary = "新增预约记录")
    public JsonResult add(@RequestBody ReservationDTO reservationDTO) {
        log.info("接收新增预约请求，用户ID：{}，充电桩ID：{}",
                reservationDTO.getUserId(), reservationDTO.getStationId());
        return reservationService.add(reservationDTO);
    }

    /**
     * 按预约状态分页查询
     * @param reservationPageDTO 分页查询条件（JSON格式）
     * @return JsonResult - 分页预约记录列表或错误信息
     */
    @PostMapping("/page/status")
    @Operation(summary = "按预约状态分页查询")
    public JsonResult findPageByStatus(@RequestBody ReservationPageDTO reservationPageDTO) {
        log.info("接收按状态分页查询预约请求，状态：{}，页码：{}，每页数量：{}",
                reservationPageDTO.getStatus(), reservationPageDTO.getPageNum(), reservationPageDTO.getPageSize());
        return reservationService.findPageByStatus(
                reservationPageDTO.getPageNum(),
                reservationPageDTO.getPageSize(),
                reservationPageDTO.getStatus()
        );
    }

    /**
     * 按用户ID分页查询预约记录
     * @param reservationPageDTO 分页查询条件（JSON格式）
     * @return JsonResult - 分页预约记录列表或错误信息
     */
    @PostMapping("/page/user")
    @Operation(summary = "按用户ID分页查询预约记录")
    public JsonResult findPageByUserId(@RequestBody ReservationPageDTO reservationPageDTO) {
        log.info("接收按用户ID分页查询预约请求，用户ID：{}，页码：{}，每页数量：{}",
                reservationPageDTO.getUserId(), reservationPageDTO.getPageNum(), reservationPageDTO.getPageSize());
        return reservationService.findPageByUserId(
                reservationPageDTO.getPageNum(),
                reservationPageDTO.getPageSize(),
                reservationPageDTO.getUserId()
        );
    }

    /**
     * 按充电桩ID分页查询预约记录
     * @param reservationPageDTO 分页查询条件（JSON格式）
     * @return JsonResult - 分页预约记录列表或错误信息
     */
    @PostMapping("/page/station")
    @Operation(summary = "按充电桩ID分页查询预约记录")
    public JsonResult findPageByStationId(@RequestBody ReservationPageDTO reservationPageDTO) {
        log.info("接收按充电桩ID分页查询预约请求，充电桩ID：{}，页码：{}，每页数量：{}",
                reservationPageDTO.getStationId(), reservationPageDTO.getPageNum(), reservationPageDTO.getPageSize());
        return reservationService.findPageByStationId(
                reservationPageDTO.getPageNum(),
                reservationPageDTO.getPageSize(),
                reservationPageDTO.getStationId()
        );
    }

    /**
     * 按充电桩ID+时间范围查询重叠预约（防重复预约校验）
     * @param reservationTimeRangeDTO 时间范围查询条件（JSON格式）
     * @return JsonResult - 重叠预约记录列表或错误信息
     */
    @PostMapping("/time-range")
    @Operation(summary = "按时间范围查询重叠预约")
    public JsonResult findByTimeRangeAndStationId(@RequestBody ReservationTimeRangeDTO reservationTimeRangeDTO) {
        log.info("接收按时间范围查询预约请求，充电桩ID：{}，开始时间：{}，结束时间：{}",
                reservationTimeRangeDTO.getStationId(), reservationTimeRangeDTO.getStartTime(), reservationTimeRangeDTO.getEndTime());
        return reservationService.findByTimeRangeAndStationId(
                reservationTimeRangeDTO.getStationId(),
                reservationTimeRangeDTO.getStartTime(),
                reservationTimeRangeDTO.getEndTime()
        );
    }

    /**
     * 根据预约ID查询详情
     * @param id 预约ID（必填，>0）
     * @return JsonResult - 预约详情或错误信息
     */
    @GetMapping("/{id}")
    @Operation(summary = "查询预约详情")
    public JsonResult findById(@PathVariable Integer id) {
        log.info("接收按ID查询预约请求，预约ID：{}", id);
        return reservationService.findById(id);
    }

    /**
     * 更新预约状态
     * @param reservationUpdateStatusDTO 更新状态信息（JSON格式）
     * @return JsonResult - 更新结果提示
     */
    @PutMapping("/status")
    @Operation(summary = "更新预约状态")
    public JsonResult updateStatusById(@RequestBody ReservationUpdateStatusDTO reservationUpdateStatusDTO) {
        log.info("接收更新预约状态请求，预约ID：{}，新状态：{}",
                reservationUpdateStatusDTO.getId(), reservationUpdateStatusDTO.getStatus());
        return reservationService.updateStatusById(
                reservationUpdateStatusDTO.getId(),
                reservationUpdateStatusDTO.getStatus()
        );
    }

    /**
     * 根据预约ID删除预约记录
     * @param id 预约ID（必填，>0）
     * @return JsonResult - 删除结果提示
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "删除预约记录")
    public JsonResult deleteById(@PathVariable Integer id) {
        log.info("接收删除预约请求，预约ID：{}", id);
        return reservationService.deleteById(id);
    }
}
