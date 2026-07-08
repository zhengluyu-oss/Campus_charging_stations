package com.tjetc.config;

import com.tjetc.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 拦截器配置类：保护所有业务 API，仅公开登录/注册与静态资源。
 */
@Configuration
public class LoginInterceptorConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/user/login",
                        "/user/refresh",
                        "/user/register",
                        "/error",
                        "/image/**",
                        "/video/**",
                        "/**/*.js",
                        "/**/*.css",
                        "/**/*.html",
                        "/favicon.ico",
                        "/v3/api-docs",
                        "/v3/api-docs/**",
                        "/swagger-ui.html",
                        "/swagger-ui/**"
                );
    }
}
