import javax.tools.JavaCompiler;
import javax.tools.ToolProvider;
import java.io.File;
import java.util.Arrays;

public class CompilerCheck {
    public static void main(String[] args) {
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        if (compiler == null) {
            System.out.println("No system java compiler available.");
            return;
        }
        String cp = "C:\\Program Files\\Apache Software Foundation\\Tomcat 9.0\\lib\\servlet-api.jar" + File.pathSeparator +
                    "C:\\Program Files\\Apache Software Foundation\\Tomcat 9.0\\lib\\jsp-api.jar" + File.pathSeparator +
                    "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\build\\web\\WEB-INF\\lib\\gson-2.10.1.jar" + File.pathSeparator +
                    "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\build\\web\\WEB-INF\\lib\\sqljdbc42.jar" + File.pathSeparator +
                    "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\build\\web\\WEB-INF\\lib\\jstl-1.2.jar" + File.pathSeparator +
                    "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\build\\web\\WEB-INF\\lib\\javax.persistence-2.2.1.jar" + File.pathSeparator +
                    "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\build\\web\\WEB-INF\\lib\\eclipselink-2.7.7.jar" + File.pathSeparator +
                    "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\build\\web\\WEB-INF\\lib\\javax.mail-1.6.2.jar" + File.pathSeparator +
                    "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\build\\classes";
        
        int res1 = compiler.run(null, null, null, "-encoding", "UTF-8", "-cp", cp, "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\src\\java\\controller\\admin\\StaffDashboardController.java");
        System.out.println("StaffDashboardController compile result: " + res1);

        int res2 = compiler.run(null, null, null, "-encoding", "UTF-8", "-cp", cp, "d:\\Github_Projects\\PRJ301_DOANQUANLYNHAHANG\\RestaurantManagement\\src\\java\\controller\\admin\\CustomerCreationController.java");
        System.out.println("CustomerCreationController compile result: " + res2);
    }
}
