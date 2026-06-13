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

    @Autowired
    private ObjectMapper objectMapper;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String token = request.getHeader("token");
        if (StringUtils.isNotBlank(token)) {
            try {
                Claims claims = JwtTokenUtil.parseJwt(token);
                Integer userId = toInteger(claims.get("id"));
                String username = claims.get("username") != null ? claims.get("username").toString() : null;
                if (userId == null) {
                    log.warn("JWT missing id claim");
                } else {
                    UserContext.set(userId, username);
                }
                return true;
            } catch (Exception e) {
                log.warn("校验token异常，{}", e.getMessage());
            }
        }
        JsonResult jsonResult = JsonResult.fail(-1, "未登录或者登录已过期");
        String jsonStr = objectMapper.writeValueAsString(jsonResult);
        response.setHeader("Content-Type", "application/json;charset=UTF-8");
        response.getWriter().write(jsonStr);
        return false;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) {
        UserContext.clear();
    }

    private static Integer toInteger(Object claim) {
        if (claim == null) {
            return null;
        }
        if (claim instanceof Number number) {
            return number.intValue();
        }
        try {
            return Integer.parseInt(claim.toString());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
