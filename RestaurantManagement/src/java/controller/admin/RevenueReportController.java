package controller.admin;

import dao.InvoiceDAO;
import entity.User;
import enums.UserRole;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RevenueReportController", urlPatterns = {"/admin/reports"})
public class RevenueReportController extends HttpServlet {
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.STAFF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        Date to = addDays(new Date(), 1);
        Date from = addDays(new Date(), -30);
        if (request.getParameter("from") != null) {
            Date parsed = parseDate(request.getParameter("from"));
            if (parsed != null) {
                from = parsed;
            }
        }
        if (request.getParameter("to") != null) {
            Date parsed = parseDate(request.getParameter("to"));
            if (parsed != null) {
                to = addDays(parsed, 1);
            }
        }
        request.setAttribute("summary", invoiceDAO.getRevenueSummary());
        request.setAttribute("revenueRows", invoiceDAO.getRevenueByDay(from, to));
        request.setAttribute("fromValue", dateFormat.format(from));
        request.setAttribute("toValue", dateFormat.format(addDays(to, -1)));
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }

    private Date parseDate(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : dateFormat.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Date addDays(Date date, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DATE, days);
        return calendar.getTime();
    }
}
