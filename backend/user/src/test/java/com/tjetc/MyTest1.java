package com.tjetc;

import com.tjetc.common.JwtTokenUtil;
import io.jsonwebtoken.Claims;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.HashMap;
import java.util.Map;

@SpringBootTest
@Slf4j
public class MyTest1 {
    @Test
    public void testCreateToken() {
        Map<String, Object> info = new HashMap<>();
        info.put("username", "jack");
        info.put("id", 26);
        String token = JwtTokenUtil.generateToken(info, "aa", 2000);
        log.info("token={}", token);
    }

    @Test
    public void testCheckToken() {
        // 生成一个新的令牌进行测试
        Map<String, Object> info = new HashMap<>();
        info.put("username", "jack");
        info.put("id", 26);
        String newToken = JwtTokenUtil.generateToken(info, "aa", 2000);
        log.info("新生成的令牌={}", newToken);

        // 验证新生成的令牌
        Claims claims = JwtTokenUtil.parseJwt(newToken);
        log.info("验证成功 - claims={}", claims);

        // 验证从令牌中提取的信息是否正确
        assert "jack".equals(claims.get("username"));
        assert 26L == (Integer) claims.get("id"); // 注意：JWT中的数字通常被解析为Long类型
        assert "aa".equals(claims.getSubject());
    }
}
