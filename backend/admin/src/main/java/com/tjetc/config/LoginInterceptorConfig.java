package com.tjetc.config;

import com.tjetc.interceptor.LoginInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class LoginInterceptorConfig implements WebMvcConfigurer {
    @Autowired
    private LoginInterceptor loginInterceptor;

    //添加自定义的拦截器
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                //任何请求都要经过拦截（loginInterceptor）
                .addPathPatterns("/**")
                //排除掉哪些url不用登录就能直接访问
                .excludePathPatterns(
                        "/admin/login",
                        "/image/**",
                        "/video/**",
                        "/**/*.js",
                        "/**/*.css",
                        "/error",
                        "/**/*.html",
                        "/favicon.ico"
                );
    }
}
