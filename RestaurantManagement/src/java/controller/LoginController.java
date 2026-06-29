package controller;

import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.AuthService;

public class LoginController extends HttpServlet {

    private final AuthService authService = new AuthService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("MainController?action=home");
            return;
        }

        if ("dologin".equals(action)) {
            try {
                User user = authService.login(request.getParameter("email"), request.getParameter("password"));
                session.setAttribute("currentUser", user);
                session.setAttribute("loginUser", user);
                session.setAttribute("userRole", user.getRole());
                session.setAttribute("userName", user.getFullName());
                String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
                session.removeAttribute("redirectAfterLogin");

                if (redirectAfterLogin != null && redirectAfterLogin.startsWith("/")) {
                    response.sendRedirect(request.getContextPath() + redirectAfterLogin);
                } else {
                    response.sendRedirect("MainController?action=home");
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            if ("1".equals(request.getParameter("required"))) {
                request.setAttribute("notice", "Please login before using this feature.");
            }
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
