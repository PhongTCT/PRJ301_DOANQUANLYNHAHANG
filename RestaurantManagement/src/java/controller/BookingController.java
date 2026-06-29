package controller;

import dto.BookingDraft;
import entity.Reservation;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import service.BookingService;

public class BookingController extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String stepParam = request.getParameter("step");
        int step = 1;
        if (stepParam != null && !stepParam.isEmpty()) {
            try { step = Integer.parseInt(stepParam); } catch (NumberFormatException ignored) {}
        }

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        BookingDraft draft = (BookingDraft) session.getAttribute("bookingDraft");

        if ("dobooking".equals(action)) {
            try {
                draft = bookingService.buildDraft(request);
                session.setAttribute("bookingDraft", draft);
                response.sendRedirect("MainController?action=booking&step=2");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage() == null ? "Booking information is invalid." : e.getMessage());
                step = 1; // stay on step 1
            }
        }

        if ("selectTable".equals(action)) {
            try {
                if (draft == null) {
                    response.sendRedirect("MainController?action=booking&step=1");
                    return;
                }
                draft.setSelectedTableIds(bookingService.parseTableIds(request));
                response.sendRedirect("MainController?action=booking&step=3");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage() == null ? "Could not select table(s)." : e.getMessage());
                step = 2;
            }
        }

        Object bookingDraftError = session.getAttribute("bookingDraftError");
        if (bookingDraftError != null && request.getAttribute("error") == null) {
            request.setAttribute("error", bookingDraftError);
            session.removeAttribute("bookingDraftError");
        }

        try {
            if (step == 1) {
                request.setAttribute("eventTypes", bookingService.getActiveEventTypes());
            } else if (step == 2) {
                request.setAttribute("tables", bookingService.getAvailableTables()); // Ideally filter by date/time
            }
        } catch (Exception e) {
            request.setAttribute("pageError", "Booking data is temporarily unavailable.");
        }

        String targetJsp = "common/booking-step" + step + ".jsp";
        request.getRequestDispatcher(targetJsp).forward(request, response);
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
