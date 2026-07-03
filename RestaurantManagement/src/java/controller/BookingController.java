package controller;

import dto.BookingDraft;
import entity.Reservation;
import entity.User;
import entity.Voucher;
import enums.PaymentMethod;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.persistence.EntityManager;
import service.BookingService;
import service.BillingService;
import util.JPAUtil;

public class BookingController extends HttpServlet {

    private final BookingService bookingService = new BookingService();
    private final BillingService billingService = new BillingService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String stepParam = request.getParameter("step");
        int step = 1;
        if (stepParam != null && !stepParam.isEmpty()) {
            try { step = Integer.parseInt(stepParam); } catch (NumberFormatException ignored) {}
        }

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        BookingDraft draft = (BookingDraft) session.getAttribute("bookingDraft");

        if ("bookingConfirmation".equals(action)) {
            request.getRequestDispatcher("common/booking-confirmation.jsp").forward(request, response);
            return;
        }

        if ("dobooking".equals(action)) {
            try {
                draft = bookingService.buildDraft(request);
                session.setAttribute("bookingDraft", draft);
                response.sendRedirect("MainController?action=booking&step=2");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage() == null ? "Booking information is invalid." : e.getMessage());
                step = 1; // stay on step 1
            }
        }

        if ("selectTable".equals(action)) {
            try {
                if (draft == null) {
                    response.sendRedirect("MainController?action=booking&step=1");
                    return;
                }
                draft.setSelectedTableIds(bookingService.parseTableIds(request));
                response.sendRedirect("MainController?action=booking&step=3");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage() == null ? "Could not select table(s)." : e.getMessage());
                step = 2;
            }
        }

        if ("true".equals(request.getParameter("submitFinal"))) {
            try {
                if (draft == null) {
                    response.sendRedirect("MainController?action=booking&step=1");
                    return;
                }
                User user = (User) session.getAttribute("currentUser");
                if (user == null) {
                    response.sendRedirect("MainController?action=login");
                    return;
                }
                String voucherCode = request.getParameter("voucherCode");
                int pointsToUse = parseInt(request.getParameter("pointsToUse"), 0);
                PaymentMethod paymentMethod = billingService.parsePaymentMethod(request.getParameter("paymentMethod"));
                draft.setVoucherCode(voucherCode);
                draft.setPointsToUse(pointsToUse);
                draft.setPaymentMethod(paymentMethod.name());

                Reservation reservation = bookingService.saveFinalBooking(draft, user, voucherCode, pointsToUse, paymentMethod);
                
                // Log audit
                new dao.AuditLogDAO().logAction(user, "CUSTOMER_CREATED_RESERVATION", "Reservation", reservation.getId(), null, "PENDING", request.getRemoteAddr());
                
                session.removeAttribute("bookingDraft");
                session.setAttribute("lastReservation", reservation);
                session.setAttribute("lastInvoice", reservation.getInvoice());
                session.setAttribute("successMessage", "Đặt bàn thành công! Mã đặt bàn của bạn là #" + reservation.getId());
                response.sendRedirect("MainController?action=bookingConfirmation");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage() == null ? "Could not finalize booking." : e.getMessage());
                step = 4;
            }
        }


        if ("saveStep3".equals(action)) {
            try {
                if (draft == null) {
                    response.sendRedirect("MainController?action=booking&step=1");
                    return;
                }
                bookingService.processStep3(draft, request);
                // Go to step 4 (Review) - Assuming it will be step=4
                response.sendRedirect("MainController?action=booking&step=4");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage() == null ? "Could not save menu selections." : e.getMessage());
                step = 3;
            }
        }

        Object bookingDraftError = session.getAttribute("bookingDraftError");
        if (bookingDraftError != null && request.getAttribute("error") == null) {
            request.setAttribute("error", bookingDraftError);
            session.removeAttribute("bookingDraftError");
        }

        try {
            if (step == 1) {
                request.setAttribute("eventTypes", bookingService.getActiveEventTypes());
            } else if (step == 2) {
                if (draft == null || draft.getReservationDate() == null) {
                    response.sendRedirect("MainController?action=booking&step=1");
                    return;
                }
                request.setAttribute("tables", bookingService.getAvailableTables(draft));
            } else if (step == 3) {
                request.setAttribute("menuItems", bookingService.getActiveMenuItems());
                request.setAttribute("menuSets", bookingService.getActiveMenuSets());
                request.setAttribute("addons", bookingService.getActiveAddons());
            } else if (step == 4) {
                prepareStep4(request, draft);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("pageError", "Booking data is temporarily unavailable. Error: " + e.getMessage());
        }

        String targetJsp = "common/booking-step" + step + ".jsp";
        request.getRequestDispatcher(targetJsp).forward(request, response);
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

    private void prepareStep4(HttpServletRequest request, BookingDraft draft) {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (draft == null || user == null) {
            return;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            BigDecimal subtotal = billingService.calculateDraftSubtotal(em, draft);
            BigDecimal surcharge = billingService.calculateSurcharge(subtotal, draft);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("surcharge", surcharge);
            request.setAttribute("grossTotal", subtotal.add(surcharge));

            dao.CustomerProfileDAO profileDAO = new dao.CustomerProfileDAO();
            entity.CustomerProfile profile = profileDAO.findByUserId(user.getId());
            request.setAttribute("loyaltyPoints", profile == null || profile.getLoyaltyPoints() == null ? 0 : profile.getLoyaltyPoints());

            List<Voucher> vouchers = new dao.VoucherDAO().findAvailableForUser(user.getId(), new Date());
            request.setAttribute("availableVouchers", vouchers);
        } finally {
            em.close();
        }
    }

    private int parseInt(String value, int fallback) {
        try {
            return value == null || value.trim().isEmpty() ? fallback : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}

