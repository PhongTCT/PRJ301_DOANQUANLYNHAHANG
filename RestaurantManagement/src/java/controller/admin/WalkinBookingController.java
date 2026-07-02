package controller.admin;

import dao.AuditLogDAO;
import dao.DiningTableDAO;
import dao.ReservationDAO;
import dao.UserDAO;
import entity.DiningTable;
import entity.Reservation;
import entity.ReservationTable;
import entity.User;
import enums.ReservationStatus;
import enums.TableStatus;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "WalkinBookingController", urlPatterns = {"/admin/walkin"})
public class WalkinBookingController extends HttpServlet {

    private final DiningTableDAO diningTableDAO = new DiningTableDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || (currentUser.getRole() != enums.UserRole.ADMIN && currentUser.getRole() != enums.UserRole.STAFF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if ("checkPhone".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String phone = request.getParameter("phone");
            User customer = userDAO.searchByPhone(phone);
            if (customer != null) {
                java.util.List<entity.Reservation> userRes = reservationDAO.findByUserId(customer.getId());
                if (userRes != null) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                    String todayStr = sdf.format(new java.util.Date());
                    for (entity.Reservation r : userRes) {
                        if (r.getReservationDate() != null && sdf.format(r.getReservationDate()).equals(todayStr)) {
                            if (r.getStatus() == enums.ReservationStatus.PENDING || 
                                r.getStatus() == enums.ReservationStatus.CONFIRMED || 
                                r.getStatus() == enums.ReservationStatus.CHECKED_IN) {
                                response.getWriter().write("{\"hasActive\": true, \"customerName\": \"" + customer.getFullName() + "\"}");
                                return;
                            }
                        }
                    }
                }
                response.getWriter().write("{\"hasActive\": false, \"customerName\": \"" + customer.getFullName() + "\"}");
            } else {
                response.getWriter().write("{\"hasActive\": false, \"customerName\": null}");
            }
            return;
        }

        // Get all available tables right now
        List<DiningTable> availableTables = diningTableDAO.getTablesByStatus(TableStatus.AVAILABLE);
        request.setAttribute("availableTables", availableTables);

        // Get Event Types for staff to select (Optional)
        dao.EventTypeDAO eventTypeDAO = new dao.EventTypeDAO();
        request.setAttribute("eventTypes", eventTypeDAO.findActiveEventTypes());

        request.getRequestDispatcher("/admin/walkin-booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || (currentUser.getRole() != enums.UserRole.ADMIN && currentUser.getRole() != enums.UserRole.STAFF)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String phone = request.getParameter("phone");
        String tableIdStr = request.getParameter("tableId");
        String adultsStr = request.getParameter("adultsCount");
        String childrenStr = request.getParameter("childrenCount");

        try {
            Integer tableId = Integer.parseInt(tableIdStr);
            int adults = Integer.parseInt(adultsStr);
            int children = Integer.parseInt(childrenStr);

            // 1. Find User by Phone (Type A)
            User customer = userDAO.searchByPhone(phone);
            if (customer == null) {
                session.setAttribute("errorMessage", "Customer not found. Please create an account for them first (Type C).");
                response.sendRedirect(request.getContextPath() + "/admin/walkin");
                return;
            }

            // Check if customer already has an active reservation today
            java.util.List<entity.Reservation> userRes = reservationDAO.findByUserId(customer.getId());
            if (userRes != null) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                String todayStr = sdf.format(new java.util.Date());
                for (entity.Reservation r : userRes) {
                    if (r.getReservationDate() != null && sdf.format(r.getReservationDate()).equals(todayStr)) {
                        if (r.getStatus() == enums.ReservationStatus.PENDING || 
                            r.getStatus() == enums.ReservationStatus.CONFIRMED || 
                            r.getStatus() == enums.ReservationStatus.CHECKED_IN) {
                            session.setAttribute("errorMessage", "Customer " + customer.getFullName() + " already has an active reservation today. Cannot create another walk-in order.");
                            response.sendRedirect(request.getContextPath() + "/admin/walkin");
                            return;
                        }
                    }
                }
            }

            // 2. Validate Table
            DiningTable table = diningTableDAO.searchById(tableId);
            if (table == null || table.getStatus() != TableStatus.AVAILABLE) {
                session.setAttribute("errorMessage", "Selected table is not available.");
                response.sendRedirect(request.getContextPath() + "/admin/walkin");
                return;
            }

            // 3. Create Reservation
            Reservation res = new Reservation();
            res.setUser(customer);
            res.setGuestName(customer.getFullName());
            res.setGuestPhone(customer.getPhone());
            res.setReservationDate(new java.sql.Date(System.currentTimeMillis()));
            res.setReservationTime(new java.sql.Time(System.currentTimeMillis()));
            res.setAdultsCount(adults);
            res.setChildrenCount(children);
            res.setHasChildren(children > 0);
            res.setStatus(ReservationStatus.CHECKED_IN);
            res.setCheckinAt(new Date());
            res.setIsOnline(false);
            res.setCreatedByStaff(currentUser);

            // Assign EventType
            String eventTypeIdStr = request.getParameter("eventTypeId");
            dao.EventTypeDAO eventTypeDAO = new dao.EventTypeDAO();
            if (eventTypeIdStr != null && !eventTypeIdStr.isEmpty()) {
                entity.EventType et = eventTypeDAO.searchById(Integer.parseInt(eventTypeIdStr));
                if (et != null) res.setEventType(et);
            } else {
                // Assign default EventType (e.g., Normal Dining) if none selected
                java.util.List<entity.EventType> eventTypes = eventTypeDAO.findActiveEventTypes();
                if (eventTypes != null && !eventTypes.isEmpty()) {
                    res.setEventType(eventTypes.get(0));
                }
            }

            reservationDAO.insert(res);

            // 4. Create ReservationTable
            ReservationTable rt = new ReservationTable();
            rt.setReservation(res);
            rt.setDiningTable(table);
            new dao.AbstractDAO<ReservationTable, Long>(ReservationTable.class) {}.insert(rt);

            // 5. Update Table Status
            table.setStatus(TableStatus.OCCUPIED);
            diningTableDAO.update(table);

            // 6. Audit Log
            auditLogDAO.logAction(currentUser, "WALKIN_BOOKING_TYPE_A", "Reservation", res.getId(), null, "CHECKED_IN", request.getRemoteAddr());

            session.setAttribute("successMessage", "Walk-in order created successfully for " + customer.getFullName() + "!");
            // Redirect to reservation details to order food
            response.sendRedirect(request.getContextPath() + "/admin/reservations?action=details&id=" + res.getId());

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage() + " | Cause: " + (e.getCause() != null ? e.getCause().getMessage() : "None"));
            response.sendRedirect(request.getContextPath() + "/admin/walkin");
        }
    }
}
