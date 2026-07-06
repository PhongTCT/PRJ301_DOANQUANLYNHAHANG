import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;

public class FixMojibake {
    public static void main(String[] args) throws Exception {
        String[] files = {
            "my-invoices.jsp",
            "my-reservations.jsp",
            "my-reviews.jsp",
            "my-vouchers.jsp"
        };
        for (String file : files) {
            String path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/" + file;
            String content = new String(Files.readAllBytes(Paths.get(path)), StandardCharsets.UTF_8);
            
            byte[] isoBytes = content.getBytes(StandardCharsets.ISO_8859_1);
            String fixedContent = new String(isoBytes, StandardCharsets.UTF_8);
            
            if (fixedContent.contains("??t b?n") || fixedContent.contains("c?a t?i") || fixedContent.contains("l?ch s?") || fixedContent.contains("??nh gi?") || fixedContent.contains("Khuy?n m?i") || fixedContent.contains("H?a ??n")) {
                Files.write(Paths.get(path), fixedContent.getBytes(StandardCharsets.UTF_8));
                System.out.println("Fixed: " + file);
            } else {
                System.out.println("No typical fix signature found in: " + file);
            }
        }
    }
}
