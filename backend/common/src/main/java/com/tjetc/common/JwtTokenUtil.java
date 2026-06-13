package com.tjetc.common;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.Map;

/**
 * JWT token generation and parsing (secret configured via {@link com.tjetc.config.JwtTokenInitializer}).
 */
@Slf4j
public class JwtTokenUtil {

    private static SecretKey key;

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

    public static Claims parseJwt(String token) {
        return Jwts.parser()
                .verifyWith(requireKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}
