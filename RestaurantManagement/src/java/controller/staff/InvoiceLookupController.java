package controller.staff;

import dao.InvoiceDAO;
import entity.Invoice;
import entity.Reservation;
import entity.User;
import enums.PaymentStatus;
import enums.UserRole;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.BillingService;
import service.LoyaltyService;
import util.JPAUtil;

@WebServlet(name = "InvoiceLookupController", urlPatterns = {"/staff/invoices", "/admin/invoices", "/customer/invoices"})
public class InvoiceLookupController extends HttpServlet {
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final BillingService billingService = new BillingService();
    private final LoyaltyService loyaltyService = new LoyaltyService();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        String uri = request.getRequestURI();
        if (uri.contains("/customer/")) {
            request.setAttribute("invoices", invoiceDAO.findByUser(user.getId()));
            request.getRequestDispatcher("/customer/my-invoices.jsp").forward(request, response);
            return;
        }

        if (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.STAFF) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        Date from = parseDate(request.getParameter("from"));
        Date to = addDays(parseDate(request.getParameter("to")), 1);
        request.setAttribute("invoices", invoiceDAO.search(request.getParameter("q"), from, to, false));
        request.getRequestDispatcher("/staff/invoices.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.STAFF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String action = request.getParameter("action");
        Long paidInvoiceId = null;
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if ("markPaid".equals(action)) {
                Invoice invoice = em.find(Invoice.class, Long.valueOf(request.getParameter("id")));
                invoice.setPaymentStatus(PaymentStatus.PAID);
                invoice.setPaidAt(new Date());
                invoice.setIssuedByStaff(em.find(User.class, user.getId()));
                em.merge(invoice);
                paidInvoiceId = invoice.getId();
                request.getSession().setAttribute("successMessage", "Đã xác nhận thanh toán hóa đơn.");
            } else if ("generate".equals(action)) {
                Reservation reservation = em.find(Reservation.class, Long.valueOf(request.getParameter("reservationId")));
                if (reservation == null) {
                    throw new IllegalArgumentException("Không tìm thấy mã đặt bàn.");
                }
                reservation.getReservationTables().size();
                reservation.getReservationMenuItems().size();
                reservation.getReservationAddons().size();
                if (reservation.getInvoice() != null) {
                    throw new IllegalArgumentException("Đơn này đã có hóa đơn.");
                }
                java.math.BigDecimal subtotal = billingService.calculateReservationSubtotal(reservation);
                
                java.math.BigDecimal surcharge = java.math.BigDecimal.ZERO;
                if (reservation.getReservationDate() != null) {
                    dao.HolidaySurchargeDAO hsDAO = new dao.HolidaySurchargeDAO();
                    entity.HolidaySurcharge holiday = hsDAO.findByDate(reservation.getReservationDate());
                    if (holiday != null) {
                        java.math.BigDecimal percent = holiday.getSurchargePercent().divide(new java.math.BigDecimal(100));
                        surcharge = subtotal.multiply(percent);
                    }
                }
                
                billingService.createInvoiceForReservation(em, reservation, reservation.getUser(), em.find(User.class, user.getId()), subtotal, surcharge, null, 0, enums.PaymentMethod.CASH, false);
                request.getSession().setAttribute("successMessage", "Đã tạo hóa đơn cho khách hàng.");
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            request.getSession().setAttribute("errorMessage", e.getMessage());
        } finally {
            em.close();
        }
        if (paidInvoiceId != null) {
            try {
                loyaltyService.processPaidInvoice(paidInvoiceId);
            } catch (Exception e) {
                System.err.println("Loyalty processing failed for invoice " + paidInvoiceId + ": " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + (request.getRequestURI().contains("/admin/") ? "/admin/invoices" : "/staff/invoices"));
    }

    private Date parseDate(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : dateFormat.parse(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Date addDays(Date date, int days) {
        if (date == null) {
            return null;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DATE, days);
        return calendar.getTime();
    }
}
