package controller;

import dto.FacebookLoginDraft;
import dto.GoogleLoginDraft;
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

        if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("MainController?action=home");
            return;
        }

        if ("dologin".equals(action)) {
            try {
                User user = authService.login(request.getParameter("email"), request.getParameter("password"));
                loginSuccess(request, response, session, user);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("googleLogin".equals(action)) {
            try {
                String accessToken = request.getParameter("accessToken");
                GoogleLoginDraft draft = (accessToken != null && !accessToken.trim().isEmpty())
                        ? authService.buildGoogleLoginDraftFromAccessToken(accessToken)
                        : authService.buildGoogleLoginDraftFromCredential(request.getParameter("credential"));

                if (authService.findExistingGoogleUser(draft) == null) {
                    session.setAttribute("pendingGoogleLogin", draft);
                    request.setAttribute("googleDraft", draft);
                    request.setAttribute("showGoogleInfoForm", true);
                    request.setAttribute("notice", "Please complete your information to create your account.");
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
        } else if ("completeGoogleProfile".equals(action)) {
            try {
                GoogleLoginDraft draft = (GoogleLoginDraft) session.getAttribute("pendingGoogleLogin");
                User user = authService.completeGoogleProfile(
                        draft,
                        request.getParameter("fullName"),
                        request.getParameter("phone"),
                        request.getParameter("dateOfBirth"));
                session.removeAttribute("pendingGoogleLogin");
                loginSuccess(request, response, session, user);
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

                if (authService.findExistingFacebookUser(draft) == null) {
                    session.setAttribute("pendingFacebookLogin", draft);
                    request.setAttribute("facebookDraft", draft);
                    request.setAttribute("showFacebookInfoForm", true);
                    request.setAttribute("notice", "Please complete your information to create your account.");
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
        } else if ("completeFacebookProfile".equals(action)) {
            try {
                FacebookLoginDraft draft = (FacebookLoginDraft) session.getAttribute("pendingFacebookLogin");
                User user = authService.completeFacebookProfile(
                        draft,
                        request.getParameter("fullName"),
                        request.getParameter("phone"),
                        request.getParameter("dateOfBirth"));
                session.removeAttribute("pendingFacebookLogin");
                loginSuccess(request, response, session, user);
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
