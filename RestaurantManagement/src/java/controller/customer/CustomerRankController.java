package controller.customer;

import dao.CustomerRankConfigDAO;
import dao.RankTopUpDAO;
import entity.CustomerRankConfig;
import entity.RankTopUp;
import entity.User;
import enums.PaymentMethod;
import enums.RankName;
import enums.TransactionStatus;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.LoyaltyService;

@WebServlet(name = "CustomerRankController", urlPatterns = {"/customer/rank"})
public class CustomerRankController extends HttpServlet {

    private final LoyaltyService loyaltyService = new LoyaltyService();
    private final CustomerRankConfigDAO rankConfigDAO = new CustomerRankConfigDAO();
    private final RankTopUpDAO topUpDAO = new RankTopUpDAO();

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
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }

        String action = request.getParameter("action");
        if ("topup".equals(action)) {
            handleTopUp(request, response, user);
        }
    }

    private void handleTopUp(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException, ServletException {
        try {
            String targetRankStr = request.getParameter("targetRank");
            RankName targetRank = RankName.valueOf(targetRankStr);
            String amountStr = request.getParameter("amount");
            BigDecimal amount = new BigDecimal(amountStr);

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.getSession().setAttribute("errorMessage", "So tien khong hop le.");
                response.sendRedirect(request.getContextPath() + "/customer/rank");
                return;
            }

            CustomerRankConfig rankConfig = rankConfigDAO.findByRankName(targetRank);
            if (rankConfig == null) {
                request.getSession().setAttribute("errorMessage", "Hang khong ton tai.");
                response.sendRedirect(request.getContextPath() + "/customer/rank");
                return;
            }

            RankTopUp topUp = loyaltyService.createTopUpOrder(user, targetRank, amount, PaymentMethod.VNPAY);
            request.getSession().setAttribute("successMessage",
                    "Da tao yeu cau nap tien. Vui long thanh toan qua VNPay.");
            response.sendRedirect(request.getContextPath() + "/customer/rank");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Loi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/customer/rank");
        }
    }
}