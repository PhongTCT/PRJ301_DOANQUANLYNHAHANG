package controller.admin;

import dao.UserDAO;
import entity.User;
import enums.UserRole;
import enums.UserStatus;
import java.io.IOException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.BCryptUtil;

@WebServlet(name = "CustomerCreationController", urlPatterns = {"/admin/create-customer"})
public class CustomerCreationController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/create-customer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        if (fullName == null || fullName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Full name and phone number are required.");
            request.getRequestDispatcher("/admin/create-customer.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if phone already exists
            if (userDAO.searchByPhone(phone) != null) {
                request.setAttribute("error", "A user with this phone number already exists.");
                request.getRequestDispatcher("/admin/create-customer.jsp").forward(request, response);
                return;
            }
            
            User newUser = new User();
            newUser.setFullName(fullName);
            newUser.setPhone(phone);
            newUser.setEmail(email != null && !email.trim().isEmpty() ? email : null);
            newUser.setUsername(phone); // Use phone as username
            
            // Set password to phone number, securely hashed
            String hashedPassword = BCryptUtil.hashPassword(phone);
            newUser.setPassword(hashedPassword);
            
            newUser.setRole(UserRole.CUSTOMER);
            newUser.setStatus(UserStatus.ACTIVE);
            
            userDAO.insert(newUser);
            
            request.getSession().setAttribute("successMessage", "Customer created successfully! They can now be selected for booking/billing.");
            response.sendRedirect(request.getContextPath() + "/admin/walkin");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Could not create customer: " + e.getMessage());
            request.getRequestDispatcher("/admin/create-customer.jsp").forward(request, response);
        }
    }
}
