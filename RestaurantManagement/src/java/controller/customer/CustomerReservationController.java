package controller.customer;

import dao.DiningTableDAO;
import dao.ReservationDAO;
import entity.DiningTable;
import entity.Reservation;
import entity.ReservationTable;
import entity.User;
import enums.ReservationStatus;
import enums.TableStatus;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CustomerReservationController", urlPatterns = {"/customer/reservations"})
public class CustomerReservationController extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final DiningTableDAO diningTableDAO = new DiningTableDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        List<Reservation> myReservations = reservationDAO.findByUserId(currentUser.getId());
        request.setAttribute("myReservations", myReservations);
        
        request.getRequestDispatcher("/customer/my-reservations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("cancel".equals(action) && idStr != null) {
            try {
                Long resId = Long.parseLong(idStr);
                Reservation res = reservationDAO.findByIdWithDetails(resId);
                
                if (res != null && res.getUser() != null && res.getUser().getId().equals(currentUser.getId())) {
                    if (res.getStatus() == ReservationStatus.PENDING || res.getStatus() == ReservationStatus.CONFIRMED) {
                        String oldStatusStr = res.getStatus().name();
                        res.setStatus(ReservationStatus.CANCELLED);
                        reservationDAO.update(res);
                        
                        // Log audit
                        new dao.AuditLogDAO().logAction(currentUser, "CUSTOMER_CANCELLED", "Reservation", res.getId(), oldStatusStr, "CANCELLED", request.getRemoteAddr());

                        if (res.getReservationTables() != null) {
                            for (ReservationTable rt : res.getReservationTables()) {
                                DiningTable table = rt.getDiningTable();
                                table.setStatus(TableStatus.AVAILABLE);
                                diningTableDAO.update(table);
                            }
                        }
                        request.getSession().setAttribute("successMessage", "Reservation cancelled successfully.");
                    } else {
                        request.getSession().setAttribute("errorMessage", "Cannot cancel this reservation.");
                    }
                } else {
                    request.getSession().setAttribute("errorMessage", "Reservation not found or unauthorized.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Error cancelling reservation.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/customer/reservations");
    }
}
