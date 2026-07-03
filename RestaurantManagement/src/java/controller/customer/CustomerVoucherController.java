package controller.customer;

import dao.VoucherDAO;
import dao.VoucherRedemptionDAO;
import entity.User;
import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CustomerVoucherController", urlPatterns = {"/customer/vouchers"})
public class CustomerVoucherController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=login");
            return;
        }
        request.setAttribute("availableVouchers", new VoucherDAO().findAvailableForUser(user.getId(), new Date()));
        request.setAttribute("usedVouchers", new VoucherRedemptionDAO().findByUser(user.getId()));
        request.getRequestDispatcher("/customer/my-vouchers.jsp").forward(request, response);
    }
}
