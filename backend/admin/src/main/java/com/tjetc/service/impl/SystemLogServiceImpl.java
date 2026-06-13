package com.tjetc.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.SystemLogMapper;
import com.tjetc.entity.core.SystemLog;
import com.tjetc.service.SystemLogService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service("systemLogService")
@Slf4j
@Transactional(readOnly = true)
public class SystemLogServiceImpl implements SystemLogService {

    @Autowired
    private SystemLogMapper systemLogMapper;

    @Override
    public JsonResult<SystemLog> findAll() {
        List<SystemLog> systemLogs = systemLogMapper.selectList(null);
        return JsonResult.success(systemLogs);
    }

    @Override
    @Transactional(readOnly = false, rollbackFor = Exception.class)
    public JsonResult add(SystemLog systemLog) {
        // 原有参数校验逻辑（不变）
        if (systemLog == null) {
            return JsonResult.fail("系统日志信息不能为空");
        }
        if (systemLog.getUserId() == null || systemLog.getUserId() <= 0) {
            return JsonResult.fail("操作用户ID不能为空且需大于0");
        }
        if (StringUtils.isBlank(systemLog.getAction())) {
            return JsonResult.fail("操作类型不能为空");
        }

        // 关键修改：把setCreateTime改成setCreatedAt，匹配实体类的createdAt属性
        LocalDateTime now = LocalDateTime.now();
        systemLog.setCreatedAt(now); // ✅ 正确调用：实体类属性是createdAt，对应setCreatedAt方法

        try {
            systemLogMapper.insert(systemLog);
            return JsonResult.success("新增系统日志成功");
        } catch (Exception e) {
            log.error("新增系统日志失败", e);
            throw new RuntimeException(e);
        }
    }

    @Override
    public JsonResult findPageByUserId(Integer pageNum, Integer pageSize, Integer userId) {
        if (pageNum == null || pageNum <= 0) {
            pageNum = 1;
        }
        if (pageSize == null || pageSize <= 0) {
            pageSize = 10;
        }
        if (userId == null || userId <= 0) {
            return JsonResult.fail("用户ID不能为空且需大于0");
        }
        PageHelper.startPage(pageNum, pageSize);
        List<SystemLog> systemLogs = systemLogMapper.selectByUserId(userId);
        PageInfo<SystemLog> pageInfo = new PageInfo<>(systemLogs);
        return JsonResult.success(pageInfo);
    }

    @Override
    public JsonResult findPageByAction(Integer pageNum, Integer pageSize, String action) {
        if (pageNum == null || pageNum <= 0) {
            pageNum = 1;
        }
        if (pageSize == null || pageSize <= 0) {
            pageSize = 10;
        }
        PageHelper.startPage(pageNum, pageSize);
        List<SystemLog> systemLogs = systemLogMapper.selectByAction(StringUtils.trimToNull(action));
        PageInfo<SystemLog> pageInfo = new PageInfo<>(systemLogs);
        return JsonResult.success(pageInfo);
    }

    @Override
    public JsonResult findByTimeRange(LocalDateTime startTime, LocalDateTime endTime) {
        if (startTime == null || endTime == null) {
            return JsonResult.fail("开始时间和结束时间不能为空");
        }
        if (startTime.isAfter(endTime)) {
            return JsonResult.fail("开始时间不能晚于结束时间");
        }
        List<SystemLog> systemLogs = systemLogMapper.selectByTimeRange(startTime, endTime);
        return JsonResult.success(systemLogs);
    }

    @Override
    public JsonResult findById(Integer id) {
        if (id == null || id <= 0) {
            return JsonResult.fail("日志ID不能为空且需大于0");
        }
        SystemLog systemLog = systemLogMapper.selectById(id);
        if (systemLog == null) {
            log.warn("日志ID:{} 不存在", id);
            return JsonResult.fail("系统日志不存在");
        }
        return JsonResult.success(systemLog);
    }

    @Override
    @Transactional(readOnly = false, rollbackFor = Exception.class)
    public JsonResult deleteById(Integer id) {
        if (id == null || id <= 0) {
            return JsonResult.fail("日志ID不能为空且需大于0");
        }
        int affectedRows = systemLogMapper.deleteById(id);
        if (affectedRows <= 0) {
            log.warn("日志ID:{} 删除影响行数为{}，删除失败", id, affectedRows);
            return JsonResult.fail("删除系统日志失败，日志不存在");
        }
        return JsonResult.success("删除系统日志成功");
    }
}