package controller.admin;

import dao.InvoiceDAO;
import dao.ReservationDAO;
import entity.User;
import enums.UserRole;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin", "/admin/"})
public class AdminDashboardController extends HttpServlet {
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.STAFF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Object[] summary = invoiceDAO.getRevenueSummary();
        request.setAttribute("summary", summary);
        request.setAttribute("todayReservations", reservationDAO.findAllWithFilter(today(), null, null).size());
        request.setAttribute("noShowCandidates", reservationDAO.findNoShowCandidates().size());
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private Date today() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }
}
