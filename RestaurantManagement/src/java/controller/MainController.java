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

        String action = request.getParameter("action");
        if (action == null) {
            action = "home";
        }

        String url;
        switch (action) {
            case "login":
            case "dologin":
            case "googleLogin":
            case "completeGoogleProfile":
            case "facebookLogin":
            case "completeFacebookProfile":
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
