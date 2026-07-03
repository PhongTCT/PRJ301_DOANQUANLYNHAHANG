package filter;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import util.EmailUtil;

public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        EmailUtil.init(sce.getServletContext());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
