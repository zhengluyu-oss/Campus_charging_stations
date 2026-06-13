package com.tjetc.entity.core;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("charging_stations")
public class ChargingStation {

    @TableId(value = "station_id", type = IdType.AUTO)
    private Integer stationId;

    private String stationName;
    private String location;
    private String status;
    private Double powerRating;
    private Double pricePerHour;
    private String createdTime;
    private String updatedTime;
}