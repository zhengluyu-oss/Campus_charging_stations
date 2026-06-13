package com.tjetc.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjetc.common.JsonResult;
import com.tjetc.dto.NewsDTO;
import com.tjetc.entity.core.News;

public interface NewsService {
    /**
     * 发布新闻
     * @param newsDTO 新闻DTO对象
     * @return 操作结果
     */
    JsonResult publishNews(NewsDTO newsDTO);
    
    /**
     * 更新新闻
     * @param newsDTO 新闻DTO对象
     * @return 操作结果
     */
    JsonResult updateNews(NewsDTO newsDTO);
    
    /**
     * 删除新闻
     * @param id 新闻ID
     * @return 操作结果
     */
    JsonResult deleteNews(Integer id);
    
    /**
     * 查询新闻详情
     * @param id 新闻ID
     * @return 新闻详情
     */
    JsonResult getNewsById(Integer id);
    
    /**
     * 分页查询新闻
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    IPage<News> getNewsList(int pageNum, int pageSize);
    
    /**
     * 根据分类查询新闻
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @param category 新闻分类
     * @return 分页结果
     */
    IPage<News> getNewsByCategory(int pageNum, int pageSize, String category);
}