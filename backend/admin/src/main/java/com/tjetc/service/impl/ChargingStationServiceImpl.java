package com.tjetc.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.ChargingStationsMapper;
import com.tjetc.dto.ChargingStationDTO;
import com.tjetc.entity.core.ChargingStation;
import com.tjetc.service.ChargingStationService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@Slf4j
public class ChargingStationServiceImpl implements ChargingStationService {

    @Resource
    private ChargingStationsMapper chargingStationsMapper;

    // 时间格式化工具 (用于生成 yyyy-MM-dd HH:mm:ss 格式字符串)
    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * 【核心修改点 1】实现 selectAll
     * 替换掉 chargingStationsMapper.selectAll()，改用 MP 内置的 selectList(null)
     */
    @Override
    public List<ChargingStation> selectAll() {
        // null 表示无条件查询，即查询所有
        return chargingStationsMapper.selectList(null);
    }

    /**
     * 【核心修改点 2】补全 findAll 方法
     * 解决 "must implement abstract method findAll" 报错
     */
    @Override
    public JsonResult findAll() {
        try {
            // 复用上面的 selectAll 方法
            List<ChargingStation> list = this.selectAll();
            return JsonResult.success(list);
        } catch (Exception e) {
            log.error("查询所有异常", e);
            return JsonResult.fail("查询失败");
        }
    }

    @Override
    public List<ChargingStation> selectByLocation(String location) {
        return chargingStationsMapper.selectByLocation(location);
    }

    @Override
    public List<ChargingStation> selectByStatus(String status) {
        return chargingStationsMapper.selectByStatus(status);
    }

    @Override
    public JsonResult add(ChargingStationDTO chargingStationDTO) {
        try {
            // 将DTO转换为实体
            ChargingStation chargingStation = new ChargingStation();
            BeanUtils.copyProperties(chargingStationDTO, chargingStation);
            
            // 自动填充时间
            String now = DF.format(LocalDateTime.now());
            chargingStation.setCreatedTime(now);
            chargingStation.setUpdatedTime(now);

            // 使用 MP 内置 insert
            chargingStationsMapper.insert(chargingStation);
            return JsonResult.success("新增成功");
        } catch (Exception e) {
            log.error("新增异常", e);
            return JsonResult.fail("新增失败");
        }
    }

    @Override
    public JsonResult updateById(ChargingStationDTO chargingStationDTO) {
        try {
            // 将DTO转换为实体
            ChargingStation chargingStation = new ChargingStation();
            BeanUtils.copyProperties(chargingStationDTO, chargingStation);
            
            // 更新时间
            chargingStation.setUpdatedTime(DF.format(LocalDateTime.now()));

            // 使用 MP 内置 updateById
            chargingStationsMapper.updateById(chargingStation);
            return JsonResult.success("更新成功");
        } catch (Exception e) {
            log.error("更新异常", e);
            return JsonResult.fail("更新失败");
        }
    }

    @Override
    public JsonResult deleteById(Integer stationId) {
        try {
            // 使用 MP 内置 deleteById
            chargingStationsMapper.deleteById(stationId);
            return JsonResult.success("删除成功");
        } catch (Exception e) {
            log.error("删除异常", e);
            return JsonResult.fail("删除异常");
        }
    }

    @Override
    public JsonResult findPage(Integer pageNum, Integer pageSize, String stationName) {
        try {
            PageHelper.startPage(pageNum, pageSize);
            // 这里调用 XML 中保留的唯一自定义方法 selectLikeName
            List<ChargingStation> list = chargingStationsMapper.selectLikeName(stationName);
            PageInfo<ChargingStation> pageInfo = new PageInfo<>(list);
            return JsonResult.success(pageInfo);
        } catch (Exception e) {
            log.error("分页查询异常", e);
            return JsonResult.fail("查询失败");
        }
    }

    @Override
    public JsonResult findById(Integer stationId) {
        // 使用 MP 内置 selectById
        ChargingStation station = chargingStationsMapper.selectById(stationId);
        if (station != null) {
            return JsonResult.success(station);
        }
        return JsonResult.fail("未找到该充电桩");
    }
}