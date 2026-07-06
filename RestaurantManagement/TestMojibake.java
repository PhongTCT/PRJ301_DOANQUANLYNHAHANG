import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;

public class TestMojibake {
    public static void main(String[] args) throws Exception {
        String path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/my-reservations.jsp";
        String content = new String(Files.readAllBytes(Paths.get(path)), StandardCharsets.UTF_8);
        
        System.out.println(content.substring(content.indexOf("reserve-title mb-3\">") + 20, content.indexOf("</h1>")));
    }
}
