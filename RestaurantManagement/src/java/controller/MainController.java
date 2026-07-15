package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        javax.servlet.http.HttpSession session = request.getSession();
        String langParam = request.getParameter("lang");
        if (langParam != null && (langParam.equals("en") || langParam.equals("vi"))) {
            session.setAttribute("lang", langParam);
        } else if (session.getAttribute("lang") == null) {
            session.setAttribute("lang", "en");
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "home";
        }

        String url;
        switch (action) {
            case "login":
            case "dologin":
            case "register":
            case "doregister":
            case "checkSession":
            case "googleLogin":
            case "registerGoogle":
            case "facebookLogin":
            case "registerFacebook":
            case "verify":
            case "logout":
                url = "LoginController";
                break;
            case "menu":
                url = "MenuController";
                break;
            case "booking":
            case "dobooking":
            case "selectTable":
            case "saveStep3":
            case "submitFinal":
            case "bookingConfirmation":

                url = "BookingController";
                break;
            case "adminAreas":
            case "saveArea":
            case "toggleArea":
            case "adminRooms":
            case "saveRoom":
            case "toggleRoom":
            case "adminTables":
            case "saveDiningTable":
            case "toggleDiningTable":
            case "adminCategories":
            case "saveMenuCategory":
            case "toggleMenuCategory":
            case "adminMenuItems":
            case "saveMenuItem":
            case "toggleMenuItem":
            case "adminMenuItemSizes":
            case "saveMenuItemSize":
            case "adminMenuSets":
            case "saveMenuSet":
            case "toggleMenuSet":
            case "adminMenuSetItems":
            case "saveMenuSetItem":
            case "saveMenuSetCourseItems":
            case "deleteMenuSetItem":
            case "adminAddonServices":
            case "saveAddonService":
            case "toggleAddonService":
                url = "AdminRestaurantController";
                break;
            case "home":
            default:
                url = "HomeController";
                break;
        }

        request.getRequestDispatcher(url).forward(request, response);
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
}
