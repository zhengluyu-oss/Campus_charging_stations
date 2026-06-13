package com.tjetc.service.service.news;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.NewsCategoryDTO;
import com.tjetc.dto.NewsCreateDTO;
import com.tjetc.dto.NewsDTO;
import com.tjetc.entity.core.News;

public interface NewsService {
    JsonResult publishNews(NewsCreateDTO newsCreateDTO);
    
    JsonResult updateNews(NewsDTO newsDTO);
    
    JsonResult deleteNews(Integer id);
    
    JsonResult getNewsById(Integer id);
    
    JsonResult getNewsByCategory(NewsCategoryDTO newsCategoryDTO);
}
