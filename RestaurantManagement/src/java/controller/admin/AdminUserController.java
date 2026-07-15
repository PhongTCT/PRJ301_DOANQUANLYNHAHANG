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
import service.LoyaltyService;
import util.BCryptUtil;

public class AdminUserController extends HttpServlet {

    private UserDAO userDAO;
    private LoyaltyService loyaltyService;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        loyaltyService = new LoyaltyService();
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
        request.setAttribute("isStaff", currentUser.getRole() == UserRole.STAFF);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                if (!isAdminOrStaff(currentUser)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                UserRole selectedRole = resolveNewUserRole(currentUser, request.getParameter("role"));

                if (username == null || username.trim().isEmpty()) {
                    throw new IllegalArgumentException("Username is required.");
                }
                if (email == null || email.trim().isEmpty()) {
                    throw new IllegalArgumentException("Email is required.");
                }
                if (password == null || password.length() < 6) {
                    throw new IllegalArgumentException("Password must be at least 6 characters.");
                }
                if (fullName == null || fullName.trim().isEmpty()) {
                    throw new IllegalArgumentException("Full name is required.");
                }
                if (userDAO.searchByUsername(username.trim()) != null) {
                    throw new IllegalArgumentException("Username already exists.");
                }
                if (userDAO.searchByEmail(email.trim()) != null) {
                    throw new IllegalArgumentException("Email already exists.");
                }

                User newUser = new User();
                newUser.setUsername(username.trim());
                newUser.setEmail(email.trim());
                newUser.setPassword(BCryptUtil.hashPassword(password));
                newUser.setFullName(fullName.trim());
                newUser.setPhone(phone != null ? phone.trim() : null);
                newUser.setRole(selectedRole);
                newUser.setStatus(UserStatus.ACTIVE);
                userDAO.insert(newUser);

                newUser = userDAO.searchByUsername(username.trim());
                if (newUser != null && selectedRole == UserRole.CUSTOMER) {
                    loyaltyService.getOrCreateProfile(newUser);
                }

                request.getSession().setAttribute("successMessage", "User created successfully.");
            } else {
                if (currentUser.getRole() != UserRole.ADMIN) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
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
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        String keyword = request.getParameter("keyword");
        response.sendRedirect(request.getContextPath() + "/admin/users"
                + (keyword != null && !keyword.trim().isEmpty() ? "?keyword=" + java.net.URLEncoder.encode(keyword.trim(), "UTF-8") : ""));
    }

    private boolean isAdminOrStaff(User user) {
        return user.getRole() == UserRole.ADMIN || user.getRole() == UserRole.STAFF;
    }
    private UserRole resolveNewUserRole(User currentUser, String requestedRole) {
        if (currentUser.getRole() == UserRole.STAFF) {
            return UserRole.CUSTOMER;
        }
        try {
            return UserRole.valueOf(requestedRole == null ? UserRole.CUSTOMER.name() : requestedRole.trim());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid user role.");
        }
    }
}