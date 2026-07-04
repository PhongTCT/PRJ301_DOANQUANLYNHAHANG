package controller.customer;

import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.NotificationService;

public class NotificationController extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        long unreadCount = notificationService.getUnreadCount(user);
        request.setAttribute("notifications", notificationService.getRecentNotifications(user, 50));
        request.setAttribute("unreadCount", unreadCount);
        request.getSession().setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("/customer/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        String action = request.getParameter("action");
        if ("read".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                notificationService.markAsRead(Long.valueOf(idStr.trim()), user);
            }
        } else if ("readAll".equals(action)) {
            notificationService.markAllAsRead(user);
        }

        String redirect = request.getParameter("redirect");
        response.sendRedirect(request.getContextPath() + (redirect != null ? redirect : "/customer/notifications"));
    }
}
