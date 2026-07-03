package controller.admin;

import dao.ReviewDAO;
import entity.Review;
import entity.User;
import enums.UserRole;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ReviewModerationController", urlPatterns = {"/admin/reviews"})
public class ReviewModerationController extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.STAFF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        request.setAttribute("reviews", reviewDAO.findAllModeration());
        request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        Review review = reviewDAO.searchById(Long.valueOf(request.getParameter("id")));
        if (review != null) {
            review.setIsVisible("show".equals(request.getParameter("action")));
            reviewDAO.update(review);
            request.getSession().setAttribute("successMessage", "Đã cập nhật trạng thái đánh giá.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }
}
