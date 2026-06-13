package com.tjetc.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.NewsMapper;
import com.tjetc.dto.NewsDTO;
import com.tjetc.entity.core.News;
import com.tjetc.service.NewsService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
public class NewsServiceImpl implements NewsService {
    
    @Autowired
    private NewsMapper newsMapper;
    
    @Override
    public JsonResult publishNews(NewsDTO newsDTO) {
        if (newsDTO.getTitle() == null || newsDTO.getTitle().isEmpty()) {
            return JsonResult.fail("新闻标题不能为空");
        }
        if (newsDTO.getContent() == null || newsDTO.getContent().isEmpty()) {
            return JsonResult.fail("新闻内容不能为空");
        }
        if (newsDTO.getCategoryId() == null) {
            return JsonResult.fail("分类ID不能为空");
        }

        News news = new News();
        BeanUtils.copyProperties(newsDTO, news);
        
        if (news.getPublishDate() == null) {
            news.setPublishDate(LocalDate.now());
        }
        news.setCreatedAt(LocalDateTime.now());
        news.setUpdatedAt(LocalDateTime.now());
        
        int result = newsMapper.insert(news);
        if (result > 0) {
            return JsonResult.success("新闻发布成功", news);
        } else {
            return JsonResult.fail("新闻发布失败");
        }
    }
    
    @Override
    public JsonResult updateNews(NewsDTO newsDTO) {
        if (newsDTO.getId() == null) {
            return JsonResult.fail("新闻ID不能为空");
        }
        
        News existingNews = newsMapper.selectById(newsDTO.getId());
        if (existingNews == null) {
            return JsonResult.fail("新闻不存在");
        }
        
        News news = new News();
        BeanUtils.copyProperties(newsDTO, news);
        news.setUpdatedAt(LocalDateTime.now());
        
        int result = newsMapper.updateById(news);
        if (result > 0) {
            return JsonResult.success("新闻更新成功");
        } else {
            return JsonResult.fail("新闻更新失败");
        }
    }
    
    @Override
    public JsonResult deleteNews(Integer id) {
        if (id == null) {
            return JsonResult.fail("新闻ID不能为空");
        }
        
        News existingNews = newsMapper.selectById(id);
        if (existingNews == null) {
            return JsonResult.fail("新闻不存在");
        }
        
        int result = newsMapper.deleteById(id);
        if (result > 0) {
            return JsonResult.success("新闻删除成功");
        } else {
            return JsonResult.fail("新闻删除失败");
        }
    }
    
    @Override
    public JsonResult getNewsById(Integer id) {
        if (id == null) {
            return JsonResult.fail("新闻ID不能为空");
        }
        
        News news = newsMapper.selectById(id);
        if (news != null) {
            return JsonResult.success("查询成功", news);
        } else {
            return JsonResult.fail("新闻不存在");
        }
    }
    
    @Override
    public IPage<News> getNewsList(int pageNum, int pageSize) {
        Page<News> page = new Page<>(pageNum, pageSize);
        return newsMapper.selectPage(page);
    }
    
    @Override
    public IPage<News> getNewsByCategory(int pageNum, int pageSize, String category) {
        Page<News> page = new Page<>(pageNum, pageSize);
        return newsMapper.selectByCategory(page, category);
    }
}
