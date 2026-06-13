package com.tjetc.controller.news;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.tjetc.common.JsonResult;
import com.tjetc.dto.NewsDTO;
import com.tjetc.dto.NewsIdDTO;
import com.tjetc.dto.NewsPageDTO;
import com.tjetc.entity.core.News;
import com.tjetc.service.NewsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/news")
@Tag(name = "新闻管理", description = "处理新闻的管理相关操作")
public class NewsController {
    
    @Autowired
    private NewsService newsService;
    
    @Operation(summary = "发布新闻")
    @PostMapping("/publish")
    public JsonResult publishNews(@RequestBody NewsDTO newsDTO) {
        return newsService.publishNews(newsDTO);
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
    
    @Operation(summary = "分页查询新闻列表")
    @PostMapping("/list")
    public IPage<News> getNewsList(@RequestBody NewsPageDTO newsPageDTO) {
        return newsService.getNewsList(
                newsPageDTO.getPageNum() != null ? newsPageDTO.getPageNum() : 1,
                newsPageDTO.getPageSize() != null ? newsPageDTO.getPageSize() : 10
        );
    }
}
