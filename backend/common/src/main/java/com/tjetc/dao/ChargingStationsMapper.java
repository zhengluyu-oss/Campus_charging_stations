package com.tjetc.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tjetc.entity.core.ChargingStation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 充电桩 Mapper 接口
 * 基于 MyBatis-Plus BaseMapper 扩展，仅保留业务实际使用的自定义方法
 */
@Mapper
public interface ChargingStationsMapper extends BaseMapper<ChargingStation> {

    /**
     * 按充电桩名称模糊查询（分页查询时调用）
     * @param stationName 充电桩名称（支持模糊匹配）
     * @return 符合条件的充电桩列表
     */
    List<ChargingStation> selectLikeName(String stationName);

    /**
     * 按位置查询充电桩（ServiceImpl 中声明调用）
     * @param location 位置信息
     * @return 符合条件的充电桩列表
     */
    List<ChargingStation> selectByLocation(@Param("location")String location);

    /**
     * 按状态查询充电桩（ServiceImpl 中声明调用）
     * @param status 充电桩状态（如：0:可使用, 1:使用中, 2:维修中）
     * @return 符合条件的充电桩列表
     */
    List<ChargingStation> selectByStatus(@Param("status")String status);
    // 【新增】查询所有充电桩
    List<ChargingStation> selectAll();

    // 说明：
    // 1. 基础CRUD（selectList/insert/updateById/deleteById/selectById）已通过 BaseMapper 继承获得，无需重复定义
    // 2. 仅保留 Service 层实际调用的 3 个自定义方法，其余未使用方法已移除



    void updateChargingStationStatus(@Param("stationId") Integer stationId);


    void stopUpdateChargingStationStatus(@Param("stationId") Integer stationId);

    /**
     * 更新充电桩状态为充电中
     * @param stationId 充电桩ID
     */
    void updateChargingStationStatusAndTime(@Param("stationId") Integer stationId);
}