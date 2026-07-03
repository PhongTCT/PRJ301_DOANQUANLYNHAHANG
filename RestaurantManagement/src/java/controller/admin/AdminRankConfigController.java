package controller.admin;

import dao.CustomerRankConfigDAO;
import entity.CustomerRankConfig;
import entity.User;
import enums.RankName;
import enums.UserRole;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.LoyaltyService;

@WebServlet(name = "AdminRankConfigController", urlPatterns = {"/admin/rank-config"})
public class AdminRankConfigController extends HttpServlet {

    private final CustomerRankConfigDAO rankConfigDAO = new CustomerRankConfigDAO();
    private final LoyaltyService loyaltyService = new LoyaltyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("ranks", loyaltyService.getAllRanks());
        request.setAttribute("rankNames", RankName.values());
        request.getRequestDispatcher("/admin/rank-config.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() != UserRole.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                CustomerRankConfig config = new CustomerRankConfig();
                config.setRankName(RankName.valueOf(request.getParameter("rankName")));
                config.setMinPointThreshold(Integer.valueOf(request.getParameter("minPointThreshold")));
                config.setDiscountPercent(new BigDecimal(request.getParameter("discountPercent")));
                config.setPointsPerThousandVnd(Integer.valueOf(request.getParameter("pointsPerThousandVnd")));
                config.setCanBookVip("true".equals(request.getParameter("canBookVip")));
                config.setCanBookVvip("true".equals(request.getParameter("canBookVvip")));
                config.setIsActive("true".equals(request.getParameter("isActive")));
                rankConfigDAO.insert(config);
                request.getSession().setAttribute("successMessage", "Da tao cau hinh hang moi.");
            } else {
                CustomerRankConfig config = new CustomerRankConfig();
                config.setId(Integer.valueOf(idStr));
                config.setMinPointThreshold(Integer.valueOf(request.getParameter("minPointThreshold")));
                config.setDiscountPercent(new BigDecimal(request.getParameter("discountPercent")));
                config.setPointsPerThousandVnd(Integer.valueOf(request.getParameter("pointsPerThousandVnd")));
                config.setCanBookVip("true".equals(request.getParameter("canBookVip")));
                config.setCanBookVvip("true".equals(request.getParameter("canBookVvip")));
                config.setIsActive("true".equals(request.getParameter("isActive")));
                loyaltyService.updateRankConfig(config);
                request.getSession().setAttribute("successMessage", "Da cap nhat cau hinh hang.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Loi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/rank-config");
    }
}