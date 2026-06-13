package com.tjetc.config;

import com.tjetc.common.JwtTokenUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import jakarta.annotation.PostConstruct;

@Configuration
public class JwtTokenInitializer {

    /**
     * HS256 requires at least 256 bits; use a long random string in production (32+ chars).
     */
    @Value("${jwt.secret:campus-charging-station-dev-secret-key-32bytes!}")
    private String secret;

    @PostConstruct
    public void init() {
        JwtTokenUtil.init(secret);
    }
}
