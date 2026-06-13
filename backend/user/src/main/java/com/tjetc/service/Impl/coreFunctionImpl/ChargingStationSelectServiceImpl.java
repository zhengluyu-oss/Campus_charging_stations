package com.tjetc.service.Impl.coreFunctionImpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.ChargingStationsMapper;
import com.tjetc.entity.core.ChargingStation;

import com.tjetc.service.service.coreFunction.ChargingStationSelectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
@ResponseBody
@Service
public class ChargingStationSelectServiceImpl implements ChargingStationSelectService {

    @Autowired
    private ChargingStationsMapper chargingStationsMapper;




    @Override
    public List<ChargingStation> selectAll() {
        return chargingStationsMapper.selectAll();
    }

    @Override
    public List<ChargingStation> selectByLocation(String location) {
        return chargingStationsMapper.selectByLocation(location);
    }

    @Override
    public List<ChargingStation> selectByStatus(String status) {
        return chargingStationsMapper.selectByStatus(status);
    }
}