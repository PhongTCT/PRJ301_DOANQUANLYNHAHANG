package controller.admin;

import dao.UserDAO;
import entity.User;
import enums.UserRole;
import enums.UserStatus;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.BCryptUtil;

public class AdminUserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        String keyword = request.getParameter("keyword");
        ArrayList<User> users = (keyword != null && !keyword.trim().isEmpty())
                ? userDAO.searchByKeyword(keyword.trim())
                : userDAO.ListAll();

        request.setAttribute("users", users);
        request.setAttribute("keyword", keyword);
        request.setAttribute("isAdmin", currentUser.getRole() == UserRole.ADMIN);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("ban".equals(action)) {
                Long userId = Long.valueOf(request.getParameter("userId"));
                User user = userDAO.searchById(userId);
                if (user != null && user.getRole() != UserRole.ADMIN) {
                    user.setStatus(UserStatus.BANNED);
                    userDAO.update(user);
                    request.getSession().setAttribute("successMessage", "User has been banned.");
                }
            } else if ("unban".equals(action)) {
                Long userId = Long.valueOf(request.getParameter("userId"));
                User user = userDAO.searchById(userId);
                if (user != null) {
                    user.setStatus(UserStatus.ACTIVE);
                    userDAO.update(user);
                    request.getSession().setAttribute("successMessage", "User has been unbanned.");
                }
            } else if ("changeRole".equals(action)) {
                Long userId = Long.valueOf(request.getParameter("userId"));
                String newRole = request.getParameter("role");
                User user = userDAO.searchById(userId);
                if (user != null && user.getRole() != UserRole.ADMIN) {
                    user.setRole(UserRole.valueOf(newRole));
                    userDAO.update(user);
                    request.getSession().setAttribute("successMessage", "User role updated.");
                }
            } else if ("resetPassword".equals(action)) {
                Long userId = Long.valueOf(request.getParameter("userId"));
                String newPassword = request.getParameter("newPassword");
                if (newPassword == null || newPassword.length() < 6) {
                    throw new IllegalArgumentException("Password must be at least 6 characters.");
                }
                User user = userDAO.searchById(userId);
                if (user != null) {
                    user.setPassword(BCryptUtil.hashPassword(newPassword));
                    userDAO.update(user);
                    request.getSession().setAttribute("successMessage", "Password has been reset.");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        String keyword = request.getParameter("keyword");
        response.sendRedirect(request.getContextPath() + "/admin/users"
                + (keyword != null && !keyword.trim().isEmpty() ? "?keyword=" + java.net.URLEncoder.encode(keyword.trim(), "UTF-8") : ""));
    }
}
