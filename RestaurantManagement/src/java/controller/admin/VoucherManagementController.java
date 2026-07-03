package controller.admin;

import dao.VoucherDAO;
import entity.Voucher;
import enums.UserRole;
import enums.VoucherType;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "VoucherManagementController", urlPatterns = {"/admin/vouchers"})
public class VoucherManagementController extends HttpServlet {
    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        entity.User user = (entity.User) request.getSession().getAttribute("currentUser");
        if (user == null || (user.getRole() != UserRole.ADMIN && user.getRole() != UserRole.STAFF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        request.setAttribute("vouchers", voucherDAO.ListAll());
        request.setAttribute("voucherTypes", VoucherType.values());
        request.getRequestDispatcher("/admin/vouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        entity.User user = (entity.User) request.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            String action = request.getParameter("action");
            if ("save".equals(action)) {
                Voucher voucher = buildVoucher(request, parseInt(request.getParameter("id"), null));
                if (voucher.getId() == null) {
                    voucherDAO.insert(voucher);
                    request.getSession().setAttribute("successMessage", "Đã tạo voucher mới.");
                } else {
                    Voucher existing = voucherDAO.searchById(voucher.getId());
                    existing.setVoucherCode(voucher.getVoucherCode());
                    existing.setVoucherType(voucher.getVoucherType());
                    existing.setDiscountPercent(voucher.getDiscountPercent());
                    existing.setDiscountAmount(voucher.getDiscountAmount());
                    existing.setMinOrderValue(voucher.getMinOrderValue());
                    existing.setMaxDiscount(voucher.getMaxDiscount());
                    existing.setValidFrom(voucher.getValidFrom());
                    existing.setValidTo(voucher.getValidTo());
                    existing.setUsageLimit(voucher.getUsageLimit());
                    existing.setIsActive(voucher.getIsActive());
                    voucherDAO.update(existing);
                    request.getSession().setAttribute("successMessage", "Đã cập nhật voucher.");
                }
            } else if ("toggle".equals(action)) {
                Voucher voucher = voucherDAO.searchById(parseInt(request.getParameter("id"), null));
                if (voucher != null) {
                    voucher.setIsActive(!Boolean.TRUE.equals(voucher.getIsActive()));
                    voucherDAO.update(voucher);
                    request.getSession().setAttribute("successMessage", "Đã đổi trạng thái voucher.");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Không thể lưu voucher: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }

    private Voucher buildVoucher(HttpServletRequest request, Integer id) throws Exception {
        Voucher voucher = new Voucher();
        voucher.setId(id);
        voucher.setVoucherCode(request.getParameter("voucherCode").trim().toUpperCase());
        voucher.setVoucherType(VoucherType.valueOf(request.getParameter("voucherType")));
        voucher.setDiscountPercent(parseDecimal(request.getParameter("discountPercent")));
        voucher.setDiscountAmount(parseDecimal(request.getParameter("discountAmount")));
        voucher.setMinOrderValue(defaultDecimal(request.getParameter("minOrderValue")));
        voucher.setMaxDiscount(parseDecimal(request.getParameter("maxDiscount")));
        voucher.setUsageLimit(parseInt(request.getParameter("usageLimit"), 1));
        voucher.setUsedCount(parseInt(request.getParameter("usedCount"), 0));
        voucher.setIsActive("true".equals(request.getParameter("isActive")));
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        voucher.setValidFrom(dateTimeFormat.parse(request.getParameter("validFrom")));
        voucher.setValidTo(dateTimeFormat.parse(request.getParameter("validTo")));
        return voucher;
    }

    private BigDecimal parseDecimal(String value) {
        return value == null || value.trim().isEmpty() ? null : new BigDecimal(value.trim());
    }

    private BigDecimal defaultDecimal(String value) {
        BigDecimal parsed = parseDecimal(value);
        return parsed == null ? BigDecimal.ZERO : parsed;
    }

    private Integer parseInt(String value, Integer fallback) {
        try {
            return value == null || value.trim().isEmpty() ? fallback : Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
