package controller.customer;

import dao.CustomerRankConfigDAO;
import entity.CustomerRankConfig;
import entity.RankTopUp;
import entity.User;
import enums.RankName;
import enums.TopUpType;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.LoyaltyService;
import service.TopUpService;
import service.VnPayService;
import util.JsonUtil;

public class CustomerRankController extends HttpServlet {

    private final LoyaltyService loyaltyService = new LoyaltyService();
    private final TopUpService topUpService = new TopUpService();
    private final CustomerRankConfigDAO rankConfigDAO = new CustomerRankConfigDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        String action = request.getParameter("action");
        if ("history".equals(action)) {
            request.setAttribute("transactions", loyaltyService.getTransactionHistory(user));
            request.getRequestDispatcher("/customer/rank-history.jsp").forward(request, response);
            return;
        }

        Map<String, Object> rankInfo = loyaltyService.getRankInfo(user);
        request.setAttribute("rankInfo", rankInfo);
        request.getRequestDispatcher("/customer/rank-topup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.getWriter().write("{\"error\":\"Vui lòng đăng nhập.\"}");
            return;
        }

        String action = request.getParameter("action");
        switch (action) {
            case "applyVoucher":
                handleApplyVoucher(request, response);
                break;
            case "checkoutRank":
                handleCheckoutRank(request, response, user);
                break;
            case "checkoutXu":
                handleCheckoutXu(request, response, user);
                break;
            default:
                response.getWriter().write("{\"error\":\"Thao tác không hợp lệ.\"}");
        }
    }

    private void handleApplyVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String typeStr = request.getParameter("topupType");
            String voucherCode = request.getParameter("voucherCode");
            String amountStr = request.getParameter("originalAmount");

            TopUpType type = TopUpType.valueOf(typeStr);
            BigDecimal originalAmount = new BigDecimal(amountStr != null ? amountStr : "0");

            String applied = topUpService.applyVoucher(type, voucherCode, getServletContext());
            BigDecimal finalAmount = topUpService.calculateFinalAmount(type, originalAmount, voucherCode, getServletContext());

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("valid", applied != null);
            result.put("finalAmount", finalAmount);
            result.put("originalAmount", originalAmount);
            result.put("isFree", finalAmount.compareTo(BigDecimal.ZERO) == 0);
            result.put("vnpAmount", finalAmount.max(VnPayService.MIN_VNPAY_AMOUNT));
            result.put("code", applied);
            response.getWriter().write(JsonUtil.toJson(result));
        } catch (Exception e) {
            response.getWriter().write("{\"error\":" + JsonUtil.quote(e.getMessage()) + "}");
        }
    }

    private void handleCheckoutRank(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        try {
            String targetRankStr = request.getParameter("targetRank");
            String amountStr = request.getParameter("originalAmount");
            String voucherCode = request.getParameter("voucherCode");

            RankName targetRank = RankName.valueOf(targetRankStr);
            BigDecimal originalAmount = new BigDecimal(amountStr != null ? amountStr : "0");
            BigDecimal finalAmount = topUpService.calculateFinalAmount(TopUpType.RANK, originalAmount, voucherCode, getServletContext());

            RankTopUp topUp = topUpService.createTopUp(user, TopUpType.RANK, targetRank,
                    originalAmount, finalAmount, voucherCode);

            String paymentUrl = request.getContextPath() + "/payment/vnpay-pay?type=topup&topUpId=" + topUp.getId();
            response.getWriter().write("{\"success\":true,\"paymentUrl\":\"" + paymentUrl + "\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"error\":" + JsonUtil.quote(e.getMessage()) + "}");
        }
    }

    private void handleCheckoutXu(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
        try {
            String amountStr = request.getParameter("originalAmount");
            String voucherCode = request.getParameter("voucherCode");

            BigDecimal originalAmount = new BigDecimal(amountStr != null ? amountStr : "0");
            BigDecimal finalAmount = topUpService.calculateFinalAmount(TopUpType.XU, originalAmount, voucherCode, getServletContext());

            RankTopUp topUp = topUpService.createTopUp(user, TopUpType.XU, null,
                    originalAmount, finalAmount, voucherCode);

            String paymentUrl = request.getContextPath() + "/payment/vnpay-pay?type=topup&topUpId=" + topUp.getId();
            response.getWriter().write("{\"success\":true,\"paymentUrl\":\"" + paymentUrl + "\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"error\":" + JsonUtil.quote(e.getMessage()) + "}");
        }
    }
}
