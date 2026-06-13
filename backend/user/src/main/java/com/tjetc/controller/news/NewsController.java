package com.tjetc.controller.news;

import com.tjetc.common.JsonResult;
import com.tjetc.dto.NewsCategoryDTO;
import com.tjetc.dto.NewsCreateDTO;
import com.tjetc.dto.NewsDTO;
import com.tjetc.dto.NewsIdDTO;
import com.tjetc.service.service.news.NewsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/news")
@Tag(name = "新闻管理", description = "处理新闻的管理和查询操作")
public class NewsController {
    
    @Autowired
    private NewsService newsService;
    
    @Operation(summary = "发布新闻")
    @PostMapping("/publish")
    public JsonResult publishNews(@RequestBody NewsCreateDTO newsCreateDTO) {
        return newsService.publishNews(newsCreateDTO);
    }
    
    @Operation(summary = "更新新闻")
    @PostMapping("/update")
    public JsonResult updateNews(@RequestBody NewsDTO newsDTO) {
        return newsService.updateNews(newsDTO);
    }
    
    @Operation(summary = "删除新闻")
    @PostMapping("/delete")
    public JsonResult deleteNews(@RequestBody NewsIdDTO newsIdDTO) {
        return newsService.deleteNews(newsIdDTO.getId());
    }
    
    @Operation(summary = "查询新闻详情")
    @PostMapping("/detail")
    public JsonResult getNewsById(@RequestBody NewsIdDTO newsIdDTO) {
        return newsService.getNewsById(newsIdDTO.getId());
    }
    
    @Operation(summary = "根据新闻类型查询")
    @PostMapping("/listByCategory")
    public JsonResult getNewsByCategory(@RequestBody NewsCategoryDTO newsCategoryDTO) {
        return newsService.getNewsByCategory(newsCategoryDTO);
    }
}
