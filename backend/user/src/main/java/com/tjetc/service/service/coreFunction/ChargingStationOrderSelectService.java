package com.tjetc.service.service.coreFunction;

import com.tjetc.entity.core.Orders;

import java.util.List;

public interface ChargingStationOrderSelectService {

    public List<Orders> selectAll(int userId);
}
