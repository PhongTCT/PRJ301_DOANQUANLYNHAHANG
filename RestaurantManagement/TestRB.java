import java.util.ResourceBundle;
import java.util.Locale;
import java.io.FileInputStream;
import java.util.PropertyResourceBundle;
public class TestRB {
    public static void main(String[] args) {
        try {
            FileInputStream fis = new FileInputStream("d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/build/web/WEB-INF/classes/i18n/messages_vi.properties");
            PropertyResourceBundle rb = new PropertyResourceBundle(fis);
            System.out.println("OK! Keys: " + rb.keySet().size());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
