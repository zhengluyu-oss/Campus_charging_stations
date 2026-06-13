package com.tjetc.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.entity.core.News;

public interface NewsMapper extends BaseMapper<News> {
    /**
     * 分页查询新闻
     * @param page 分页对象
     * @return 分页结果
     */
    IPage<News> selectPage(Page<News> page);
    
    /**
     * 根据分类查询新闻
     * @param page 分页对象
     * @param category 新闻分类
     * @return 分页结果
     */
    IPage<News> selectByCategory(Page<News> page, String category);
}
