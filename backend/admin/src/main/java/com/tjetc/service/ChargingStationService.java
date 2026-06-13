package com.tjetc.service;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.ChargingStationDTO;
import com.tjetc.entity.core.ChargingStation;
import java.util.List;

public interface ChargingStationService {
    // 原有的查询所有，返回 List (Mapper层对应)
    List<ChargingStation> selectAll();

    // 【新增】查询所有，返回 JsonResult (Controller层调用)
    JsonResult findAll();

    List<ChargingStation> selectByLocation(String location);
    List<ChargingStation> selectByStatus(String status);
    JsonResult add(ChargingStationDTO chargingStationDTO);
    JsonResult updateById(ChargingStationDTO chargingStationDTO);
    JsonResult deleteById(Integer stationId);
    JsonResult findPage(Integer pageNum, Integer pageSize, String stationName);
    JsonResult findById(Integer stationId);
}