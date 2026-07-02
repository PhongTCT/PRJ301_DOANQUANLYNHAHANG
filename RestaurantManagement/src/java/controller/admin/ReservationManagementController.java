package controller.admin;

import dao.DiningTableDAO;
import dao.ReservationDAO;
import entity.DiningTable;
import entity.Reservation;
import entity.ReservationTable;
import entity.User;
import enums.ReservationStatus;
import enums.TableStatus;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ReservationManagementController", urlPatterns = {"/admin/reservations"})
public class ReservationManagementController extends HttpServlet {

    private ReservationDAO reservationDAO = new ReservationDAO();
    private DiningTableDAO diningTableDAO = new DiningTableDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Ensure user is Admin or Staff
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || (!"ADMIN".equals(currentUser.getRole().name()) && !"STAFF".equals(currentUser.getRole().name()))) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        // Parse filters
        String dateStr = request.getParameter("date");
        String statusStr = request.getParameter("status");
        String phoneStr = request.getParameter("phone");

        Date filterDate = null;
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            try {
                filterDate = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
            } catch (Exception e) {}
        }

        ReservationStatus filterStatus = null;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try {
                filterStatus = ReservationStatus.valueOf(statusStr);
            } catch (Exception e) {}
        }

        List<Reservation> list = reservationDAO.findAllWithFilter(filterDate, filterStatus, phoneStr);
        request.setAttribute("reservations", list);
        
        request.getRequestDispatcher("/admin/reservations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || (!"ADMIN".equals(currentUser.getRole().name()) && !"STAFF".equals(currentUser.getRole().name()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (idStr == null || action == null) {
            response.sendRedirect("reservations");
            return;
        }

        try {
            Long resId = Long.parseLong(idStr);
            Reservation res = reservationDAO.findByIdWithDetails(resId);
            
            if (res != null) {
                if ("updateStatus".equals(action)) {
                    String newStatusStr = request.getParameter("status");
                    ReservationStatus newStatus = ReservationStatus.valueOf(newStatusStr);
                    
                    res.setStatus(newStatus);
                    if (newStatus == ReservationStatus.CHECKED_IN && res.getCheckinAt() == null) {
                        res.setCheckinAt(new Date());
                    }
                    
                    reservationDAO.update(res);

                    // Auto-update table status
                    if (res.getReservationTables() != null) {
                        for (ReservationTable rt : res.getReservationTables()) {
                            DiningTable table = rt.getDiningTable();
                            if (newStatus == ReservationStatus.CHECKED_IN) {
                                table.setStatus(TableStatus.OCCUPIED);
                                diningTableDAO.update(table);
                            } else if (newStatus == ReservationStatus.COMPLETED || newStatus == ReservationStatus.CANCELLED || newStatus == ReservationStatus.NO_SHOW) {
                                table.setStatus(TableStatus.AVAILABLE);
                                diningTableDAO.update(table);
                            } else if (newStatus == ReservationStatus.CONFIRMED || newStatus == ReservationStatus.PENDING) {
                                table.setStatus(TableStatus.RESERVED);
                                diningTableDAO.update(table);
                            }
                        }
                    }
                    
                    request.getSession().setAttribute("successMessage", "Status updated successfully!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error updating reservation.");
        }

        response.sendRedirect("reservations");
    }
}
