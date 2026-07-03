package controller.admin;

import dao.HolidaySurchargeDAO;
import entity.HolidaySurcharge;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SurchargeController", urlPatterns = {"/admin/surcharges"})
public class SurchargeController extends HttpServlet {

    private HolidaySurchargeDAO surchargeDAO;

    @Override
    public void init() throws ServletException {
        surchargeDAO = new HolidaySurchargeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        List<HolidaySurcharge> surcharges = surchargeDAO.ListAll();
        request.setAttribute("surcharges", surcharges);
        request.getRequestDispatcher("/admin/surcharges.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                HolidaySurcharge surcharge = new HolidaySurcharge();
                surcharge.setHolidayName(request.getParameter("holidayName"));
                
                String dateStr = request.getParameter("surchargeDate");
                Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
                surcharge.setSurchargeDate(date);
                
                surcharge.setSurchargePercent(new BigDecimal(request.getParameter("surchargePercent")));
                surcharge.setIsActive(true);
                
                surchargeDAO.insert(surcharge);
                request.getSession().setAttribute("successMessage", "Thêm ngày lễ thành công!");
                
            } else if ("update".equals(action)) {
                Integer id = Integer.parseInt(request.getParameter("id"));
                HolidaySurcharge surcharge = surchargeDAO.searchById(id);
                
                if (surcharge != null) {
                    surcharge.setHolidayName(request.getParameter("holidayName"));
                    
                    String dateStr = request.getParameter("surchargeDate");
                    Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
                    surcharge.setSurchargeDate(date);
                    
                    surcharge.setSurchargePercent(new BigDecimal(request.getParameter("surchargePercent")));
                    surcharge.setIsActive("true".equals(request.getParameter("isActive")));
                    
                    surchargeDAO.update(surcharge);
                    request.getSession().setAttribute("successMessage", "Cập nhật ngày lễ thành công!");
                }
                
            } else if ("delete".equals(action)) {
                Integer id = Integer.parseInt(request.getParameter("id"));
                HolidaySurcharge surcharge = surchargeDAO.searchById(id);
                
                if (surcharge != null) {
                    surcharge.setIsActive(false); // Soft delete
                    surchargeDAO.update(surcharge);
                    request.getSession().setAttribute("successMessage", "Xóa ngày lễ thành công!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/surcharges");
    }
}
