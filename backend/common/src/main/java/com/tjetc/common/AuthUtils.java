package com.tjetc.common;

/**
 * Authorization helpers: bind request body user identifiers to JWT identity.
 */
public final class AuthUtils {

    private AuthUtils() {
    }

    /**
     * Resolves the effective user id. Returns null if body userId does not match the logged-in user.
     */
    public static Integer resolveUserId(Integer bodyUserId) {
        Integer current = UserContext.getUserId();
        if (current == null) {
            return null;
        }
        if (bodyUserId != null && !bodyUserId.equals(current)) {
            return null;
        }
        return bodyUserId != null ? bodyUserId : current;
    }

    public static JsonResult forbiddenUserMismatch() {
        return JsonResult.fail("无权操作该用户数据");
    }

    /**
     * Returns null if username matches the logged-in user; otherwise a failure JsonResult.
     */
    public static JsonResult assertCurrentUsername(String bodyUsername) {
        String current = UserContext.getUsername();
        if (current == null) {
            return JsonResult.fail(-1, "未登录或者登录已过期");
        }
        if (bodyUsername != null && !bodyUsername.equals(current)) {
            return forbiddenUserMismatch();
        }
        return null;
    }
}
