package com.tjetc.common;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

/**
 * JWT token generation and parsing (secret configured via {@link com.tjetc.config.JwtTokenInitializer}).
 * Supports both access tokens (short-lived) and refresh tokens (long-lived with replay protection).
 */
@Slf4j
public class JwtTokenUtil {

    private static SecretKey key;

    /** Refresh token TTL: 7 days in milliseconds */
    public static final long REFRESH_TOKEN_EXPIRATION = 7 * 24 * 60 * 60 * 1000L;

    private JwtTokenUtil() {
    }

    public static void init(String secret) {
        if (secret == null || secret.isBlank()) {
            throw new IllegalArgumentException("jwt.secret must not be empty");
        }
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            try {
                keyBytes = MessageDigest.getInstance("SHA-256").digest(keyBytes);
            } catch (NoSuchAlgorithmException e) {
                throw new IllegalStateException("SHA-256 not available", e);
            }
        }
        key = Keys.hmacShaKeyFor(keyBytes);
        log.info("JWT signing key initialized");
    }

    private static SecretKey requireKey() {
        if (key == null) {
            throw new IllegalStateException("JwtTokenUtil not initialized; ensure jwt.secret is configured");
        }
        return key;
    }

    /**
     * 生成 Access Token
     * @param claims 自定义声明（如用户ID、用户名等）
     * @param subject 主题（如 "admin"）
     * @param expiration 过期时间（毫秒）
     * @return JWT token 字符串
     */
    public static String generateToken(Map<String, Object> claims, String subject, int expiration) {
        final Date now = new Date();
        final Date expirationDate = new Date(now.getTime() + expiration);
        return Jwts.builder()
                .claims(claims)
                .subject(subject)
                .issuedAt(now)
                .expiration(expirationDate)
                .signWith(requireKey())
                .compact();
    }

    /**
     * 生成 Refresh Token（7天有效期，含唯一 jti 用于防重放）
     * @param subject 主题（如用户ID字符串）
     * @return JWT refresh token 字符串
     */
    public static String generateRefreshToken(String subject) {
        final Date now = new Date();
        final Date expirationDate = new Date(now.getTime() + REFRESH_TOKEN_EXPIRATION);
        return Jwts.builder()
                .claim("type", "refresh")
                .id(UUID.randomUUID().toString())  // 唯一 ID 用于防重放
                .subject(subject)
                .issuedAt(now)
                .expiration(expirationDate)
                .signWith(requireKey())
                .compact();
    }

    /**
     * 解析并验证 JWT Token（可验证 Access Token 和 Refresh Token）
     * @param token JWT 字符串
     * @return Claims 解析后的声明
     * @throws JwtException Token 无效或已过期
     */
    public static Claims parseJwt(String token) {
        return Jwts.parser()
                .verifyWith(requireKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * 校验 Token 是否有效（不抛出异常）
     * @param token JWT 字符串
     * @return Claims 如果 Token 有效，否则返回 null
     */
    public static Claims validateToken(String token) {
        try {
            return parseJwt(token);
        } catch (ExpiredJwtException e) {
            log.warn("Token 已过期");
            return null;
        } catch (JwtException e) {
            log.warn("Token 校验失败: {}", e.getMessage());
            return null;
        }
    }

    /**
     * 判断 Token 是否为 Refresh Token
     * @param claims 已解析的 Claims
     * @return true 如果 token 中包含 type=refresh
     */
    public static boolean isRefreshToken(Claims claims) {
        return "refresh".equals(claims.get("type", String.class));
    }
}
