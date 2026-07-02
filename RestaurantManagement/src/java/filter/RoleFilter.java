package filter;

import entity.User;
import enums.UserRole;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RoleFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        User currentUser = (User) httpRequest.getSession().getAttribute("currentUser");
        String uri = httpRequest.getRequestURI();

        if (currentUser == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/MainController?action=login");
            return;
        }
        if (uri.contains("/admin/")) {
            if (currentUser.getRole() == UserRole.STAFF) {
                if (!uri.contains("/admin/walkin") && !uri.contains("/admin/reservations")) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
            } else if (currentUser.getRole() != UserRole.ADMIN) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }
        if (uri.contains("/staff/")
                && currentUser.getRole() != UserRole.STAFF
                && currentUser.getRole() != UserRole.ADMIN) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
