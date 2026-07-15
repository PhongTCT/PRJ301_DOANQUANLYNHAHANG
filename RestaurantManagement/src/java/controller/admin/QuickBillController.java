package controller.admin;

import dao.DiningTableDAO;
import dao.MenuCategoryDAO;
import dao.MenuItemDAO;
import entity.DiningTable;
import entity.MenuCategory;
import entity.MenuItem;
import entity.User;
import enums.TableStatus;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "QuickBillController", urlPatterns = {"/admin/quick-bill"})
public class QuickBillController extends HttpServlet {

    private final DiningTableDAO diningTableDAO = new DiningTableDAO();
    private final MenuCategoryDAO menuCategoryDAO = new MenuCategoryDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || (!"ADMIN".equals(currentUser.getRole().name()) && !"STAFF".equals(currentUser.getRole().name()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Get available tables
        List<DiningTable> availableTables = diningTableDAO.getTablesByStatus(TableStatus.AVAILABLE);
        request.setAttribute("availableTables", availableTables);

        // Get menu categories and items
        List<MenuCategory> categories = menuCategoryDAO.ListAll();
        List<MenuItem> menuItems = menuItemDAO.ListAll();
        
        request.setAttribute("categories", categories);
        request.setAttribute("menuItems", menuItems);

        // Get active menu sets
        dao.MenuSetDAO menuSetDAO = new dao.MenuSetDAO();
        java.util.List<entity.MenuSet> menuSets = menuSetDAO.findActiveSets();
        request.setAttribute("menuSets", menuSets);

        request.getRequestDispatcher("/admin/quick-bill.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null || (!"ADMIN".equals(currentUser.getRole().name()) && !"STAFF".equals(currentUser.getRole().name()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        // Process Order Submission
        String diningType = request.getParameter("diningType");
        String tableIdStr = request.getParameter("tableId");
        String guestCountStr = request.getParameter("guestCount");
        String[] itemIds = request.getParameterValues("itemIds");
        String[] itemTypes = request.getParameterValues("itemTypes");
        String[] itemQtys = request.getParameterValues("itemQtys");

        if (itemIds == null || itemIds.length == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false, \"message\":\"No items in order.\"}");
            return;
        }

        int guestCount = 1;
        try {
            if (guestCountStr != null && !guestCountStr.isEmpty()) {
                guestCount = Integer.parseInt(guestCountStr);
            }
        } catch (NumberFormatException e) {
            // Default to 1
        }

        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            // 1. Create Reservation (Pseudo-reservation for walk-in quick bill)
            entity.Reservation res = new entity.Reservation();
            res.setGuestName("Walk-in " + ("DINE_IN".equals(diningType) ? "Dine-in" : "Take-away"));
            res.setGuestPhone("N/A");
            res.setAdultsCount(guestCount);
            res.setChildrenCount(0);
            res.setReservationDate(new java.util.Date());
            res.setReservationTime(new java.sql.Time(System.currentTimeMillis()));
            res.setStatus("DINE_IN".equals(diningType) ? enums.ReservationStatus.CHECKED_IN : enums.ReservationStatus.COMPLETED);
            
            // Set Event Type
            entity.EventType eventType = em.find(entity.EventType.class, 1);
            if (eventType != null) {
                res.setEventType(eventType);
            }
            
            em.persist(res);

            java.math.BigDecimal subtotal = java.math.BigDecimal.ZERO;
            java.math.BigDecimal tableFee = java.math.BigDecimal.ZERO;

            // 2. Handle Dine-in Table
            if ("DINE_IN".equals(diningType) && tableIdStr != null && !tableIdStr.isEmpty()) {
                DiningTable table = em.find(DiningTable.class, Integer.parseInt(tableIdStr));
                if (table != null) {
                    table.setStatus(TableStatus.OCCUPIED);
                    em.merge(table);

                    entity.ReservationTable rt = new entity.ReservationTable();
                    rt.setReservation(res);
                    rt.setDiningTable(table);
                    em.persist(rt);
                    
                    tableFee = table.getBookingFee();
                }
            }

            // 3. Handle Menu Items and Sets
            if (itemIds != null) {
                for (int i = 0; i < itemIds.length; i++) {
                    int itemId = Integer.parseInt(itemIds[i]);
                    int qty = Integer.parseInt(itemQtys[i]);
                    String type = (itemTypes != null && i < itemTypes.length) ? itemTypes[i] : "item";
                    
                    if ("set".equals(type)) {
                        entity.MenuSet menuSet = em.find(entity.MenuSet.class, itemId);
                        if (menuSet != null) {
                            entity.ReservationMenuItem rmi = new entity.ReservationMenuItem();
                            rmi.setReservation(res);
                            rmi.setMenuSet(menuSet);
                            rmi.setQuantity(qty);
                            rmi.setUnitPrice(menuSet.getDiscountedPrice());
                            em.persist(rmi);
                            
                            java.math.BigDecimal itemTotal = menuSet.getDiscountedPrice().multiply(new java.math.BigDecimal(qty));
                            subtotal = subtotal.add(itemTotal);
                        }
                    } else {
                        entity.MenuItem menuItem = em.find(entity.MenuItem.class, itemId);
                        if (menuItem != null) {
                            entity.ReservationMenuItem rmi = new entity.ReservationMenuItem();
                            rmi.setReservation(res);
                            rmi.setMenuItem(menuItem);
                            rmi.setQuantity(qty);
                            rmi.setUnitPrice(menuItem.getBasePrice());
                            em.persist(rmi);
                            
                            java.math.BigDecimal itemTotal = menuItem.getBasePrice().multiply(new java.math.BigDecimal(qty));
                            subtotal = subtotal.add(itemTotal);
                        }
                    }
                }
            }

            // 4. Create Invoice
            entity.Invoice invoice = new entity.Invoice();
            invoice.setReservation(res);
            invoice.setGuestName(res.getGuestName());
            invoice.setSubtotal(subtotal.add(tableFee));
            invoice.setTotalAmount(subtotal.add(tableFee)); // assuming no tax/surcharge for quick bill for now
            invoice.setPaymentStatus(enums.PaymentStatus.PAID);
            invoice.setPaymentMethod(enums.PaymentMethod.CASH);
            invoice.setPaidAt(new java.util.Date());
            invoice.setIssuedByStaff(currentUser);
            em.persist(invoice);

            em.getTransaction().commit();
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":true, \"invoiceId\":" + invoice.getId() + "}");
            
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        } finally {
            em.close();
        }
    }
}
