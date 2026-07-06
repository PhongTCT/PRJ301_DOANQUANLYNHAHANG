package controller;

import dto.FacebookLoginDraft;
import dto.GoogleLoginDraft;
import entity.User;
import enums.UserStatus;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.AuthService;
import util.EmailUtil;

public class LoginController extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    public void init() throws ServletException {
        EmailUtil.init(getServletContext());
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("1".equals(request.getParameter("clearGoogleDraft"))) {
            session.removeAttribute("pendingGoogleLogin");
        }
        if ("1".equals(request.getParameter("clearFacebookDraft"))) {
            session.removeAttribute("pendingFacebookLogin");
        }
        if ("login".equals(action)
                && request.getParameter("clearGoogleDraft") == null
                && request.getParameter("clearFacebookDraft") == null) {
            session.removeAttribute("pendingGoogleLogin");
            session.removeAttribute("pendingFacebookLogin");
        }

        if ("checkSession".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            User u = (User) session.getAttribute("currentUser");
            if (u != null) {
                response.getWriter().write("{\"authenticated\":true,\"user\":{\"id\":" + u.getId()
                        + ",\"fullName\":\"" + u.getFullName() + "\",\"role\":\"" + u.getRole().name() + "\"}}");
            } else {
                response.getWriter().write("{\"authenticated\":false}");
            }
            return;
        }

        if ("register".equals(action)) {
            request.setAttribute("showRegisterForm", true);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if ("doregister".equals(action)) {
            try {
                authService.registerUser(
                        request.getParameter("username"),
                        request.getParameter("email"),
                        request.getParameter("password"),
                        request.getParameter("fullName"),
                        request.getParameter("phone"));
                request.setAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.");
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("showRegisterForm", true);
            }
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("MainController?action=home");
            return;
        }

        if ("dologin".equals(action)) {
            try {
                User user = authService.login(request.getParameter("username"), request.getParameter("password"));
                loginSuccess(request, response, session, user);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            return;
        }
        
        if ("dologinAjax".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");
            try {
                User user = authService.login(request.getParameter("username"), request.getParameter("password"));
                session.setAttribute("currentUser", user);
                response.getWriter().write("{\"success\":true,\"user\":{\"id\":" + user.getId() + ",\"fullName\":\"" + user.getFullName() + "\"}}");
            } catch (IllegalArgumentException e) {
                response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            }
            return;
        }
        
        if ("googleLogin".equals(action)) {
            try {
                String accessToken = request.getParameter("accessToken");
                GoogleLoginDraft draft = (accessToken != null && !accessToken.trim().isEmpty())
                        ? authService.buildGoogleLoginDraftFromAccessToken(accessToken)
                        : authService.buildGoogleLoginDraftFromCredential(request.getParameter("credential"));

                User existingUser = authService.findExistingGoogleUser(draft);

                if (existingUser == null) {
                    session.setAttribute("pendingGoogleLogin", draft);
                    request.setAttribute("googleDraft", draft);
                    request.setAttribute("showGoogleInfoForm", true);
                    request.setAttribute("notice", "Please complete your information to create your account.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                if (existingUser.getStatus() != UserStatus.ACTIVE) {
                    request.setAttribute("notice", "Your account is pending verification. Please check your email to verify your account.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                loginSuccess(request, response, session, authService.loginExistingGoogleUser(draft));
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (RuntimeException e) {
                request.setAttribute("error", "Google login could not be completed. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("registerGoogle".equals(action)) {
            try {
                GoogleLoginDraft draft = (GoogleLoginDraft) session.getAttribute("pendingGoogleLogin");
                authService.registerGoogleUser(
                        draft,
                        request.getParameter("fullName"),
                        request.getParameter("phone"),
                        request.getParameter("dateOfBirth"));
                session.removeAttribute("pendingGoogleLogin");
                request.setAttribute("success", "Account created! Please check your email to verify your account.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("showGoogleInfoForm", true);
                request.setAttribute("googleDraft", session.getAttribute("pendingGoogleLogin"));
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (RuntimeException e) {
                request.setAttribute("error", "Could not complete your Google account. Please try again.");
                request.setAttribute("showGoogleInfoForm", true);
                request.setAttribute("googleDraft", session.getAttribute("pendingGoogleLogin"));
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("facebookLogin".equals(action)) {
            try {
                FacebookLoginDraft draft = authService.buildFacebookLoginDraftFromAccessToken(request.getParameter("facebookAccessToken"));

                User existingUser = authService.findExistingFacebookUser(draft);

                if (existingUser == null) {
                    session.setAttribute("pendingFacebookLogin", draft);
                    request.setAttribute("facebookDraft", draft);
                    request.setAttribute("showFacebookInfoForm", true);
                    request.setAttribute("notice", "Please complete your information to create your account.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                if (existingUser.getStatus() != UserStatus.ACTIVE) {
                    request.setAttribute("notice", "Your account is pending verification. Please check your email to verify your account.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                loginSuccess(request, response, session, authService.loginExistingFacebookUser(draft));
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (RuntimeException e) {
                request.setAttribute("error", "Facebook login could not be completed. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("registerFacebook".equals(action)) {
            try {
                FacebookLoginDraft draft = (FacebookLoginDraft) session.getAttribute("pendingFacebookLogin");
                authService.registerFacebookUser(
                        draft,
                        request.getParameter("fullName"),
                        request.getParameter("phone"),
                        request.getParameter("dateOfBirth"));
                session.removeAttribute("pendingFacebookLogin");
                request.setAttribute("success", "Account created! Please check your email to verify your account.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("showFacebookInfoForm", true);
                request.setAttribute("facebookDraft", session.getAttribute("pendingFacebookLogin"));
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } catch (RuntimeException e) {
                request.setAttribute("error", "Could not complete your Facebook account. Please try again.");
                request.setAttribute("showFacebookInfoForm", true);
                request.setAttribute("facebookDraft", session.getAttribute("pendingFacebookLogin"));
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("verify".equals(action)) {
            String token = request.getParameter("token");
            String error = authService.verifyEmail(token);
            if (error != null) {
                request.setAttribute("error", error);
            } else {
                request.setAttribute("success", "Email verified successfully! You can now login.");
            }
            request.getRequestDispatcher("login.jsp").forward(request, response);
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

    private void loginSuccess(HttpServletRequest request, HttpServletResponse response, HttpSession session, User user)
            throws IOException {
        session.setAttribute("currentUser", user);
        session.setAttribute("loginUser", user);
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("unreadCount", new service.NotificationService().getUnreadCount(user));
        String redirectAfterLogin = (String) session.getAttribute("redirectAfterLogin");
        session.removeAttribute("redirectAfterLogin");

        if (user.getRole() != null
                && ("ADMIN".equals(user.getRole().name()) || "STAFF".equals(user.getRole().name()))) {
            response.sendRedirect(request.getContextPath() + "/admin/quick-bill");
        } else if (redirectAfterLogin != null && redirectAfterLogin.startsWith("/")) {
            response.sendRedirect(request.getContextPath() + redirectAfterLogin);
        } else {
            response.sendRedirect("MainController?action=home");
        }
    }
}
