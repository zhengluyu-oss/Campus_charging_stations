package com.tjetc.common;

/**
 * Holds the authenticated user for the current request (set by LoginInterceptor).
 */
public final class UserContext {

    private static final ThreadLocal<Integer> USER_ID = new ThreadLocal<>();
    private static final ThreadLocal<String> USERNAME = new ThreadLocal<>();

    private UserContext() {
    }

    public static void set(Integer userId, String username) {
        USER_ID.set(userId);
        USERNAME.set(username);
    }

    public static Integer getUserId() {
        return USER_ID.get();
    }

    public static String getUsername() {
        return USERNAME.get();
    }

    public static Integer requireUserId() {
        Integer userId = USER_ID.get();
        if (userId == null) {
            throw new IllegalStateException("No authenticated user in context");
        }
        return userId;
    }

    public static void clear() {
        USER_ID.remove();
        USERNAME.remove();
    }
}
