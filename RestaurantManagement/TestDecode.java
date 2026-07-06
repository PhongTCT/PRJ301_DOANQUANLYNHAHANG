import java.nio.charset.StandardCharsets;

public class TestDecode {
    public static void main(String[] args) {
        String s = "? ???t b? n";
        byte[] b = s.getBytes(StandardCharsets.ISO_8859_1);
        System.out.println(new String(b, StandardCharsets.UTF_8));
    }
}
