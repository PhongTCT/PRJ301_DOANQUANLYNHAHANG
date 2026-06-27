package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.BookingService;

public class BookingController extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("dobooking".equals(action)) {
            try {
                request.getSession().setAttribute("bookingDraft", bookingService.buildDraft(request));
                request.setAttribute("success", "Booking draft saved. Please choose a table to continue.");
            } catch (Exception e) {
                request.setAttribute("error", "Booking information is invalid.");
            }
        }

        try {
            request.setAttribute("tables", bookingService.getAvailableTables());
            request.setAttribute("eventTypes", bookingService.getActiveEventTypes());
        } catch (Exception e) {
            request.setAttribute("pageError", "Booking data is temporarily unavailable.");
        }

        request.getRequestDispatcher("booking.jsp").forward(request, response);
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
