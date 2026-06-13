package com.tjetc.service.Impl.coreFunctionImpl;

import com.tjetc.dao.OrderMapper;
import com.tjetc.entity.core.Orders;
import com.tjetc.service.service.coreFunction.ChargingStationOrderSelectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@ResponseBody
@Service
public class ChargingStationOrderSelect implements ChargingStationOrderSelectService {
    @Autowired
    private OrderMapper orderMapper;

    @Override
    public List<Orders> selectAll(int userId) {
        return orderMapper.selectByUserId(userId);
    }
}
