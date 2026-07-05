package com.hibernate.util;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class IdObfuscator {
    
    private static final int XOR_KEY = 0x5F3759DF;

    public static String encode(Integer id) {
        if (id == null) {
            return null;
        }
        try {
            int obfuscatedVal = id ^ XOR_KEY;
            String text = String.valueOf(obfuscatedVal);
            return Base64.getUrlEncoder().withoutPadding().encodeToString(text.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            return null;
        }
    }

    public static Integer decode(String encoded) {
        if (encoded == null || encoded.isEmpty()) {
            return null;
        }
        try {
            byte[] bytes = Base64.getUrlDecoder().decode(encoded);
            String text = new String(bytes, StandardCharsets.UTF_8);
            int obfuscatedVal = Integer.parseInt(text);
            return obfuscatedVal ^ XOR_KEY;
        } catch (Exception e) {
            return null;
        }
    }
}
