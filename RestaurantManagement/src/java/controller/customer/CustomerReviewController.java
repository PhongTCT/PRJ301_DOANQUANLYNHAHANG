package controller.customer;

import dao.ReservationDAO;
import dao.ReviewDAO;
import entity.Reservation;
import entity.Review;
import entity.User;
import enums.ReservationStatus;
import java.io.IOException;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.JPAUtil;

@WebServlet(name = "CustomerReviewController", urlPatterns = {"/customer/reviews"})
public class CustomerReviewController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }
        request.setAttribute("myReservations", new ReservationDAO().findByUserId(user.getId()));
        request.setAttribute("myReviews", new ReviewDAO().findByUser(user.getId()));
        request.getRequestDispatcher("/customer/my-reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Long reservationId = Long.valueOf(request.getParameter("reservationId"));
            Reservation reservation = em.find(Reservation.class, reservationId);
            if (reservation == null || reservation.getUser() == null || !reservation.getUser().getId().equals(user.getId())) {
                throw new IllegalArgumentException("Không tìm thấy đặt bàn hợp lệ.");
            }
            if (reservation.getStatus() != ReservationStatus.COMPLETED) {
                throw new IllegalArgumentException("Chỉ có thể đánh giá đơn đã hoàn thành.");
            }
            Review review = new ReviewDAO().findByReservationId(reservationId);
            if (review == null) {
                review = new Review();
                review.setUser(em.find(User.class, user.getId()));
                review.setReservation(reservation);
                review.setIsVisible(false);
                em.persist(review);
            } else {
                review = em.merge(review);
                review.setIsVisible(false);
            }
            int rating = Math.max(1, Math.min(5, Integer.parseInt(request.getParameter("rating"))));
            review.setRating(rating);
            review.setComment(request.getParameter("comment"));
            review.setImageUrl(request.getParameter("imageUrl"));
            tx.commit();
            request.getSession().setAttribute("successMessage", "Đã gửi đánh giá, vui lòng chờ admin duyệt.");
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            request.getSession().setAttribute("errorMessage", e.getMessage());
        } finally {
            em.close();
        }
        response.sendRedirect(request.getContextPath() + "/customer/reviews");
    }
}
