package com.tjetc.service.Impl.news;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tjetc.common.JsonResult;
import com.tjetc.dao.NewsMapper;
import com.tjetc.dto.NewsCategoryDTO;
import com.tjetc.dto.NewsCreateDTO;
import com.tjetc.dto.NewsDTO;
import com.tjetc.entity.core.News;
import com.tjetc.service.service.news.NewsService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class NewsServiceImpl implements NewsService {
    
    private static final String NEWS_CACHE_PREFIX = "news:detail:";
    private static final String NEWS_LIST_CACHE_PREFIX = "news:list:";
    private static final String NEWS_CATEGORY_CACHE_PREFIX = "news:category:";
    private static final long DETAIL_CACHE_EXPIRE_MINUTES = 60;
    private static final long LIST_CACHE_EXPIRE_MINUTES = 5;
    
    @Autowired
    private NewsMapper newsMapper;
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    @Override
    public JsonResult publishNews(NewsCreateDTO newsCreateDTO) {
        if (newsCreateDTO.getTitle() == null || newsCreateDTO.getTitle().isEmpty()) {
            return JsonResult.fail("新闻标题不能为空");
        }
        if (newsCreateDTO.getContent() == null || newsCreateDTO.getContent().isEmpty()) {
            return JsonResult.fail("新闻内容不能为空");
        }
        if (newsCreateDTO.getCategoryId() == null) {
            return JsonResult.fail("分类ID不能为空");
        }

        News news = new News();
        BeanUtils.copyProperties(newsCreateDTO, news);
        
        if (news.getPublishDate() == null) {
            news.setPublishDate(LocalDate.now());
        }
        news.setCreatedAt(LocalDateTime.now());
        news.setUpdatedAt(LocalDateTime.now());
        
        int result = newsMapper.insert(news);
        if (result > 0) {
            String cacheKey = NEWS_CACHE_PREFIX + news.getId();
            redisTemplate.opsForValue().set(cacheKey, news, DETAIL_CACHE_EXPIRE_MINUTES, TimeUnit.MINUTES);
            
            clearAllListCache();
            
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
            String cacheKey = NEWS_CACHE_PREFIX + newsDTO.getId();
            redisTemplate.delete(cacheKey);
            clearAllListCache();
            
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
            String cacheKey = NEWS_CACHE_PREFIX + id;
            redisTemplate.delete(cacheKey);
            clearAllListCache();
            
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
        
        String cacheKey = NEWS_CACHE_PREFIX + id;
        News cachedNews = (News) redisTemplate.opsForValue().get(cacheKey);
        if (cachedNews != null) {
            return JsonResult.success("查询成功", cachedNews);
        }
        
        News news = newsMapper.selectById(id);
        if (news != null) {
            redisTemplate.opsForValue().set(cacheKey, news, DETAIL_CACHE_EXPIRE_MINUTES, TimeUnit.MINUTES);
            return JsonResult.success("查询成功", news);
        } else {
            return JsonResult.fail("新闻不存在");
        }
    }
    
    @Override
    public JsonResult getNewsByCategory(NewsCategoryDTO newsCategoryDTO) {
        if (newsCategoryDTO.getNewsCategory() == null || newsCategoryDTO.getNewsCategory().isEmpty()) {
            return JsonResult.fail("新闻类型不能为空");
        }
        
        String cacheKey = NEWS_CATEGORY_CACHE_PREFIX + newsCategoryDTO.getNewsCategory();
        List<News> cachedNewsList = (List<News>) redisTemplate.opsForValue().get(cacheKey);
        if (cachedNewsList != null) {
            return JsonResult.success("查询成功", cachedNewsList);
        }
        
        List<News> newsList = newsMapper.selectList(
            new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<News>()
                .eq(News::getNewsCategory, newsCategoryDTO.getNewsCategory())
                .orderByDesc(News::getPublishDate)
        );
        
        redisTemplate.opsForValue().set(cacheKey, newsList, LIST_CACHE_EXPIRE_MINUTES, TimeUnit.MINUTES);
        return JsonResult.success("查询成功", newsList);
    }
    
    private void clearAllListCache() {
        var listKeys = redisTemplate.keys(NEWS_LIST_CACHE_PREFIX + "*");
        if (listKeys != null && !listKeys.isEmpty()) {
            redisTemplate.delete(listKeys);
        }
        
        var categoryKeys = redisTemplate.keys(NEWS_CATEGORY_CACHE_PREFIX + "*");
        if (categoryKeys != null && !categoryKeys.isEmpty()) {
            redisTemplate.delete(categoryKeys);
        }
    }
}
