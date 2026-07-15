package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class LanguageFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession();
        String langParam = request.getParameter("lang");
        
        if (langParam != null && (langParam.equals("en") || langParam.equals("vi"))) {
            session.setAttribute("lang", langParam);
        } else if (session.getAttribute("lang") == null) {
            session.setAttribute("lang", "en");
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
