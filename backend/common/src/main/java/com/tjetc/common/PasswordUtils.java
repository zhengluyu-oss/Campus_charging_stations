package com.tjetc.common;

/**
 * Password storage format helpers.
 */
public final class PasswordUtils {

    private PasswordUtils() {
    }

    public static boolean isBcryptHash(String encoded) {
        return encoded != null
                && (encoded.startsWith("$2a$") || encoded.startsWith("$2b$") || encoded.startsWith("$2y$"));
    }
}
