package filter;

import service.BookingService;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthFilter implements Filter {
    private final BookingService bookingService = new BookingService();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        if (uri.contains("/payment/vnpay-ipn") || uri.contains("/payment/momo-ipn")) {
            chain.doFilter(request, response);
            return;
        }

        if (!requiresLogin(httpRequest, uri, contextPath)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            session = httpRequest.getSession(true);
            captureBookingDraft(httpRequest, session);
            session.setAttribute("redirectAfterLogin", buildRedirectAfterLogin(httpRequest));
            httpResponse.sendRedirect(contextPath + "/MainController?action=login&required=1");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean requiresLogin(HttpServletRequest request, String uri, String contextPath) {
        String path = uri.substring(contextPath.length());

        if (path.startsWith("/admin/") || path.startsWith("/staff/") || path.startsWith("/customer/")) {
            return true;
        }

        if ("/BookingController".equals(path) || "/booking.jsp".equals(path)) {
            return true;
        }

        if (!"/MainController".equals(path)) {
            return false;
        }

        String action = request.getParameter("action");
        return !isPublicAction(action);
    }

    private boolean isPublicAction(String action) {
        if (action == null || action.trim().isEmpty()) {
            return true;
        }

        switch (action) {
            case "home":
            case "menu":
            case "login":
            case "dologin":
            case "googleLogin":
            case "completeGoogleProfile":
            case "facebookLogin":
            case "completeFacebookProfile":
            case "logout":
                return true;
            default:
                return false;
        }
    }

    private String buildRedirectAfterLogin(HttpServletRequest request) {
        String action = request.getParameter("action");
        if (!"GET".equalsIgnoreCase(request.getMethod()) || "dobooking".equals(action)) {
            return "/MainController?action=booking";
        }

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.substring(contextPath.length());
        String query = request.getQueryString();
        return query == null || query.isEmpty() ? path : path + "?" + query;
    }

    private void captureBookingDraft(HttpServletRequest request, HttpSession session) {
        String action = request.getParameter("action");
        if (!"POST".equalsIgnoreCase(request.getMethod()) || !"dobooking".equals(action)) {
            return;
        }

        try {
            session.setAttribute("bookingDraft", bookingService.buildDraft(request));
        } catch (Exception e) {
            session.setAttribute("bookingDraftError", "Booking information is invalid. Please check it again.");
        }
    }

    @Override
    public void destroy() {
    }
}
