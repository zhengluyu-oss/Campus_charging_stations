package com.tjetc.config;

import com.tjetc.common.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;

@Configuration
public class JwtTokenInitializer {

    /**
     * HS256 requires at least 256 bits; use a long random string in production (32+ chars).
     * No default value — JWT_SECRET environment variable MUST be set.
     */
    @Value("${jwt.secret:}")
    private String secret;

    @PostConstruct
    public void init() {
        if (secret == null || secret.isBlank()) {
            throw new IllegalStateException(
                "JWT_SECRET 环境变量未配置！请设置强随机密钥（至少32字节）。" +
                "开发环境请使用 spring.profiles.active=dev 加载 application-dev.yml。");
        }
        if ("campus-charging-station-dev-secret-key-32bytes!".equals(secret)) {
            throw new IllegalStateException(
                "JWT_SECRET 不能使用默认开发密钥，请通过环境变量配置生产环境密钥。");
        }
        JwtTokenUtil.init(secret);
    }
}
