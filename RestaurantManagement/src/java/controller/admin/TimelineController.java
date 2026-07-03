package controller.admin;

import dao.ReservationDAO;
import entity.Reservation;
import entity.User;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.StringJoiner;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "TimelineController", urlPatterns = {"/admin/timeline"})
public class TimelineController extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || (!"ADMIN".equals(currentUser.getRole().name()) && !"STAFF".equals(currentUser.getRole().name()))) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }
        
        List<Reservation> reservations = reservationDAO.findAllWithFilter(null, null, null);
        
        StringJoiner sj = new StringJoiner(",");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
        
        for (Reservation r : reservations) {
            if (r.getReservationDate() == null || r.getReservationTime() == null) continue;
            
            int totalGuests = (r.getAdultsCount() != null ? r.getAdultsCount() : 0) + (r.getChildrenCount() != null ? r.getChildrenCount() : 0);
            String title = r.getGuestName() + " (" + totalGuests + " pax)";
            String start = dateFormat.format(r.getReservationDate()) + "T" + timeFormat.format(r.getReservationTime());
            String color = "#4F46E5"; 
            if (r.getStatus() != null) {
                switch (r.getStatus()) {
                    case CONFIRMED: color = "#059669"; break; 
                    case CHECKED_IN: color = "#0284c7"; break; 
                    case COMPLETED: color = "#64748b"; break; 
                    case CANCELLED:
                    case NO_SHOW: color = "#e11d48"; break; 
                }
            }
            
            String jsonEvent = "{"
                    + "\"id\":\"" + r.getId() + "\","
                    + "\"title\":\"" + title + "\","
                    + "\"start\":\"" + start + "\","
                    + "\"color\":\"" + color + "\""
                    + "}";
            sj.add(jsonEvent);
        }
        
        request.setAttribute("eventsJson", "[" + sj.toString() + "]");
        
        request.getRequestDispatcher("/admin/timeline.jsp").forward(request, response);
    }
}
