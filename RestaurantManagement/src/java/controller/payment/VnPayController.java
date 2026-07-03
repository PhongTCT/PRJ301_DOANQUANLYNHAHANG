package controller.payment;

import entity.Invoice;
import entity.Reservation;
import entity.User;
import enums.PaymentMethod;
import enums.PaymentStatus;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.VnPayService;
import util.JPAUtil;

@WebServlet(name = "VnPayController", urlPatterns = {"/payment/vnpay-pay", "/payment/vnpay-return", "/payment/vnpay-ipn"})
public class VnPayController extends HttpServlet {
    private final VnPayService vnPayService = new VnPayService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        if (path.endsWith("/payment/vnpay-pay")) {
            redirectToPay(request, response);
        } else if (path.endsWith("/payment/vnpay-ipn")) {
            handleIpn(request, response);
        } else {
            handleReturn(request, response);
        }
    }

    private void redirectToPay(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        Long invoiceId = parseLong(request.getParameter("invoiceId"));
        Invoice invoice = findInvoice(invoiceId);
        if (invoice == null || invoice.getPaymentMethod() != PaymentMethod.VNPAY || invoice.getPaymentStatus() == PaymentStatus.PAID) {
            request.getSession().setAttribute("errorMessage", "Hóa đơn không thể thanh toán bằng VNPay.");
            response.sendRedirect(request.getContextPath() + "/customer/invoices");
            return;
        }
        if (!canAccessInvoice(user, invoice)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.sendRedirect(vnPayService.createPaymentUrl(request, invoice));
    }

    private void handleReturn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean valid = vnPayService.verifyReturn(request);
        Map<String, String> params = vnPayService.extractVnPayParams(request);
        Long invoiceId = vnPayService.invoiceIdFromTxnRef(params.get("vnp_TxnRef"));
        boolean paid = valid && "00".equals(params.get("vnp_ResponseCode")) && "00".equals(params.get("vnp_TransactionStatus"));

        Invoice invoice = paid ? markPaid(invoiceId, params) : findInvoice(invoiceId);
        if (invoice != null) {
            Reservation reservation = invoice.getReservation();
            if (reservation != null) {
                reservation.getId();
                reservation.getGuestName();
                reservation.getReservationDate();
                reservation.getReservationTime();
            }
            request.getSession().setAttribute("lastInvoice", invoice);
            request.getSession().setAttribute("lastReservation", reservation);
        }
        request.getSession().setAttribute(paid ? "successMessage" : "errorMessage",
                paid ? "Thanh toán VNPay thành công." : "Thanh toán VNPay chưa hoàn tất hoặc chữ ký không hợp lệ.");
        response.sendRedirect(request.getContextPath() + "/MainController?action=bookingConfirmation");
    }

    private void handleIpn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        if (!vnPayService.verifyReturn(request)) {
            response.getWriter().write("{\"RspCode\":\"97\",\"Message\":\"Invalid Checksum\"}");
            return;
        }

        Map<String, String> params = vnPayService.extractVnPayParams(request);
        Long invoiceId = vnPayService.invoiceIdFromTxnRef(params.get("vnp_TxnRef"));
        Invoice invoice = findInvoice(invoiceId);
        if (invoice == null) {
            response.getWriter().write("{\"RspCode\":\"01\",\"Message\":\"Order not found\"}");
            return;
        }
        if (!amountMatches(invoice, params.get("vnp_Amount"))) {
            response.getWriter().write("{\"RspCode\":\"04\",\"Message\":\"Invalid amount\"}");
            return;
        }
        if (invoice.getPaymentStatus() == PaymentStatus.PAID) {
            response.getWriter().write("{\"RspCode\":\"02\",\"Message\":\"Order already confirmed\"}");
            return;
        }
        if (!"00".equals(params.get("vnp_ResponseCode")) || !"00".equals(params.get("vnp_TransactionStatus"))) {
            response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            return;
        }

        markPaid(invoiceId, params);
        response.getWriter().write("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
    }

    private Invoice markPaid(Long invoiceId, Map<String, String> params) {
        if (invoiceId == null) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Invoice invoice = em.find(Invoice.class, invoiceId);
            if (invoice == null) {
                tx.rollback();
                return null;
            }
            if (invoice.getPaymentStatus() != PaymentStatus.PAID) {
                invoice.setPaymentMethod(PaymentMethod.VNPAY);
                invoice.setPaymentStatus(PaymentStatus.PAID);
                invoice.setPaidAt(new Date());
                String bankTranNo = params.get("vnp_BankTranNo");
                String transactionNo = params.get("vnp_TransactionNo");
                invoice.setTransactionRef(transactionNo != null && !transactionNo.trim().isEmpty()
                        ? transactionNo
                        : (bankTranNo != null && !bankTranNo.trim().isEmpty() ? bankTranNo : params.get("vnp_TxnRef")));
                em.merge(invoice);
            }
            if (invoice.getReservation() != null) {
                invoice.getReservation().getId();
                invoice.getReservation().getGuestName();
                invoice.getReservation().getReservationDate();
                invoice.getReservation().getReservationTime();
            }
            invoice.getTotalAmount();
            tx.commit();
            return invoice;
        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    private Invoice findInvoice(Long invoiceId) {
        if (invoiceId == null) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Invoice invoice = em.find(Invoice.class, invoiceId);
            if (invoice != null) {
                if (invoice.getUser() != null) {
                    invoice.getUser().getId();
                }
                if (invoice.getReservation() != null) {
                    invoice.getReservation().getId();
                    invoice.getReservation().getGuestName();
                    invoice.getReservation().getReservationDate();
                    invoice.getReservation().getReservationTime();
                }
            }
            return invoice;
        } finally {
            em.close();
        }
    }

    private boolean canAccessInvoice(User user, Invoice invoice) {
        if (user == null || invoice == null) {
            return false;
        }
        if (user.getRole() != null && ("ADMIN".equals(user.getRole().name()) || "STAFF".equals(user.getRole().name()))) {
            return true;
        }
        return invoice.getUser() != null && user.getId() != null && user.getId().equals(invoice.getUser().getId());
    }

    private boolean amountMatches(Invoice invoice, String vnpAmount) {
        if (invoice == null || invoice.getTotalAmount() == null || vnpAmount == null) {
            return false;
        }
        BigDecimal expected = invoice.getTotalAmount().multiply(new BigDecimal("100")).setScale(0, java.math.RoundingMode.HALF_UP);
        try {
            return expected.compareTo(new BigDecimal(vnpAmount)) == 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    private Long parseLong(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Long.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
