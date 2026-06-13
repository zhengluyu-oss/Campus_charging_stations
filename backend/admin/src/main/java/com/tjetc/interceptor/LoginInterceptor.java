package com.tjetc.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tjetc.common.JsonResult;
import com.tjetc.common.JwtTokenUtil;
import com.tjetc.common.UserContext;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
@Slf4j
public class LoginInterceptor implements HandlerInterceptor {
    //ObjectMapper可以把对象转换成json字符串
    @Autowired
    private ObjectMapper objectMapper;

    //在执行controller方法之前要先执行preHandle方法
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        // 【核心修改】如果是 OPTIONS 请求，直接放行！
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        //从请求头中获取token关键字并获取值
        String token = request.getHeader("token");

        if (StringUtils.isNotBlank(token)) {
            try {
                //校验token是否有效并且不过期
                Claims claims = JwtTokenUtil.parseJwt(token);
                // 提取用户信息并设置到 UserContext
                Integer userId = claims.get("id", Integer.class);
                String username = claims.get("username", String.class);
                UserContext.set(userId, username);
                //放行
                return true;
            } catch (Exception e) {
                //token 无效 返回未登录 并且不放行
                log.warn("校验token异常，{}", e.getMessage());
            }
        }
        //token为null或者空，就说明没有token，返回JsonResult对象的json字符串（未登录），并且不放行
        JsonResult jsonResult = JsonResult.fail(-1, "未登录或者登录已过期");
        String jsonStr = objectMapper.writeValueAsString(jsonResult);
        //设置响应头 Content-Type 类型值
        response.setHeader("Content-Type", "application/json;charset=UTF-8");
        //write出去
        response.getWriter().write(jsonStr);
        //不放行
        return false;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) throws Exception {
        // 清除 UserContext，防止内存泄漏
        UserContext.clear();
    }
}
