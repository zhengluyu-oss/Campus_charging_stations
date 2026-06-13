package com.tjetc.service.service.coreFunction;

import com.tjetc.common.JsonResult;
import com.tjetc.entity.core.ChargingStation;


import java.util.List;

//充电桩查询
public interface ChargingStationSelectService {


    /**
     * 查找所有充电桩信息
     */
    List<ChargingStation> selectAll();

    /**
     * 根据位置查找充电桩
     * (已修改为String类型，匹配实体类修改)
     */
    List<ChargingStation> selectByLocation(String location);

    /**
     * 根据状态筛选充电桩
     * (已修改为String类型，匹配实体类修改)
     */
    List<ChargingStation> selectByStatus(String status);



}
