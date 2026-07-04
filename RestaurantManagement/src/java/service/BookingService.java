package service;

import dao.DiningTableDAO;
import dao.EventTypeDAO;
import dto.BookingDraft;
import entity.DiningTable;
import entity.EventType;
import entity.Reservation;
import entity.ReservationTable;
import entity.User;
import entity.MenuItem;
import entity.MenuSet;
import entity.AddonService;
import entity.ReservationMenuItem;
import entity.ReservationAddon;
import dao.MenuItemDAO;
import dao.MenuSetDAO;
import dao.AddonServiceDAO;
import enums.ReservationStatus;
import enums.TableStatus;
import enums.PaymentMethod;
import entity.Invoice;
import entity.Voucher;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import util.JPAUtil;

public class BookingService {
    private final DiningTableDAO diningTableDAO = new DiningTableDAO();
    private final EventTypeDAO eventTypeDAO = new EventTypeDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final MenuSetDAO menuSetDAO = new MenuSetDAO();
    private final AddonServiceDAO addonServiceDAO = new AddonServiceDAO();
    private final BillingService billingService = new BillingService();

    public List<DiningTable> getAvailableTables(BookingDraft draft) {
        if (draft != null && draft.getReservationDate() != null && draft.getReservationTime() != null) {
            java.sql.Time time = parseTime(draft.getReservationTime());
            int totalGuests = (draft.getAdultsCount() != null ? draft.getAdultsCount() : 0) 
                            + (draft.getChildrenCount() != null ? draft.getChildrenCount() : 0);
            if (totalGuests == 0) totalGuests = 1; // Safeguard
            return diningTableDAO.findAvailableTables(draft.getReservationDate(), time, totalGuests);
        }
        // Fallback if no draft info
        return diningTableDAO.ListAll();
    }

    public List<EventType> getActiveEventTypes() {
        return eventTypeDAO.ListAll();
    }

    public List<MenuItem> getActiveMenuItems() {
        return menuItemDAO.ListAll();
    }

    public List<MenuSet> getActiveMenuSets() {
        return menuSetDAO.findActiveSets();
    }

    public List<AddonService> getActiveAddons() {
        return addonServiceDAO.findActiveAddons();
    }

    public BookingDraft buildDraft(HttpServletRequest request) throws ParseException {
        BookingDraft draft = new BookingDraft();
        String date = request.getParameter("reservationDate");
        if (date != null && !date.trim().isEmpty()) {
            draft.setReservationDate(new SimpleDateFormat("yyyy-MM-dd").parse(date.trim()));
            
            // Check holiday surcharge
            dao.HolidaySurchargeDAO hsDAO = new dao.HolidaySurchargeDAO();
            entity.HolidaySurcharge holiday = hsDAO.findByDate(draft.getReservationDate());
            if (holiday != null) {
                draft.setHasSurcharge(true);
                draft.setSurchargePercent(holiday.getSurchargePercent());
                request.getSession().setAttribute("surchargeWarning", "Ngày đặt bàn rơi vào dịp lễ (" + holiday.getHolidayName() + "). Hóa đơn sẽ có phụ thu " + holiday.getSurchargePercent() + "%.");
            } else {
                draft.setHasSurcharge(false);
                draft.setSurchargePercent(java.math.BigDecimal.ZERO);
                request.getSession().removeAttribute("surchargeWarning");
            }
        }
        draft.setReservationTime(request.getParameter("reservationTime"));
        draft.setAdultsCount(parseInt(request.getParameter("adultsCount"), 1));
        draft.setChildrenCount(parseInt(request.getParameter("childrenCount"), 0));
        draft.setEventTypeId(parseInt(request.getParameter("eventTypeId"), null));
        validateDraft(draft);
        return draft;
    }

    public Reservation selectTables(BookingDraft draft, List<Integer> tableIds, User currentUser) {
        if (draft == null) {
            throw new IllegalArgumentException("Please save your booking details before selecting a table.");
        }
        if (currentUser == null || currentUser.getId() == null) {
            throw new IllegalArgumentException("Please login before selecting a table.");
        }
        if (tableIds == null || tableIds.isEmpty()) {
            throw new IllegalArgumentException("Please select at least one valid table.");
        }

        validateDraft(draft);

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            java.util.List<DiningTable> selectedTables = new java.util.ArrayList<>();
            int totalCapacity = 0;

            for (Integer id : tableIds) {
                DiningTable table = em.find(DiningTable.class, id);
                if (table == null || !Boolean.TRUE.equals(table.getIsActive())) {
                    throw new IllegalArgumentException("One of the selected tables is not available.");
                }
                if (table.getStatus() != TableStatus.AVAILABLE) {
                    throw new IllegalArgumentException("One of the tables has already been reserved.");
                }
                selectedTables.add(table);
                if (table.getCapacity() != null) {
                    totalCapacity += table.getCapacity();
                }
            }

            int guests = safeCount(draft.getAdultsCount()) + safeCount(draft.getChildrenCount());
            if (totalCapacity > 0 && guests > totalCapacity) {
                throw new IllegalArgumentException("Selected tables do not have enough seats.");
            }

            EventType eventType = em.find(EventType.class, draft.getEventTypeId());
            if (eventType == null) {
                throw new IllegalArgumentException("Please select a valid event type.");
            }

            User user = em.find(User.class, currentUser.getId());
            if (user == null) {
                throw new IllegalArgumentException("User account is no longer available.");
            }

            Reservation reservation = new Reservation();
            reservation.setUser(user);
            reservation.setGuestName(user.getFullName());
            reservation.setGuestPhone(user.getPhone());
            reservation.setEventType(eventType);
            reservation.setReservationDate(draft.getReservationDate());
            reservation.setReservationTime(parseTime(draft.getReservationTime()));
            reservation.setAdultsCount(draft.getAdultsCount());
            reservation.setChildrenCount(draft.getChildrenCount());
            reservation.setHasChildren(safeCount(draft.getChildrenCount()) > 0);
            reservation.setStatus(ReservationStatus.PENDING);
            reservation.setIsOnline(true);

            em.persist(reservation);

            for (DiningTable table : selectedTables) {
                ReservationTable reservationTable = new ReservationTable();
                reservationTable.setReservation(reservation);
                reservationTable.setDiningTable(table);
                em.persist(reservationTable);

                table.setStatus(TableStatus.RESERVED);
                em.merge(table);
            }

            tx.commit();
            draft.setSelectedTableIds(tableIds);
            return reservation;
        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public List<Integer> parseTableIds(HttpServletRequest request) {
        String[] tableIdParams = request.getParameterValues("tableId");
        List<Integer> list = new java.util.ArrayList<>();
        if (tableIdParams != null) {
            for (String p : tableIdParams) {
                Integer id = parseInt(p, null);
                if (id != null) list.add(id);
            }
        }
        return list;
    }

    public Reservation saveFinalBooking(BookingDraft draft, User currentUser) {
        return saveFinalBooking(draft, currentUser, null, 0, PaymentMethod.CASH);
    }

    public Reservation saveFinalBooking(BookingDraft draft, User currentUser, String voucherCode, int pointsToUse, PaymentMethod paymentMethod) {
        if (draft == null) {
            throw new IllegalArgumentException("Booking details are missing.");
        }
        if (currentUser == null || currentUser.getId() == null) {
            throw new IllegalArgumentException("User not logged in.");
        }
        if (draft.getSelectedTableIds() == null || draft.getSelectedTableIds().isEmpty()) {
            throw new IllegalArgumentException("No tables selected.");
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            EventType eventType = em.find(EventType.class, draft.getEventTypeId());
            User user = em.find(User.class, currentUser.getId());
            BigDecimal subtotal = billingService.calculateDraftSubtotal(em, draft);
            BigDecimal surcharge = billingService.calculateSurcharge(subtotal, draft);
            Voucher voucher = billingService.validateVoucher(em, voucherCode, user, subtotal.add(surcharge));

            Reservation reservation = new Reservation();
            reservation.setUser(user);
            reservation.setGuestName(user.getFullName());
            reservation.setGuestPhone(user.getPhone());
            reservation.setEventType(eventType);
            reservation.setReservationDate(draft.getReservationDate());
            reservation.setReservationTime(parseTime(draft.getReservationTime()));
            reservation.setAdultsCount(draft.getAdultsCount());
            reservation.setChildrenCount(draft.getChildrenCount());
            reservation.setHasChildren(safeCount(draft.getChildrenCount()) > 0);
            reservation.setStatus(ReservationStatus.PENDING);
            reservation.setIsOnline(true);
            reservation.setHasSurcharge(draft.getHasSurcharge() != null ? draft.getHasSurcharge() : false);
            
            em.persist(reservation);

            // 1. Tables
            for (Integer tableId : draft.getSelectedTableIds()) {
                DiningTable table = em.find(DiningTable.class, tableId);
                if (table != null) {
                    ReservationTable rt = new ReservationTable();
                    rt.setReservation(reservation);
                    rt.setDiningTable(table);
                    em.persist(rt);
                    
                    table.setStatus(TableStatus.RESERVED);
                    em.merge(table);
                }
            }

            // 2. Menu Sets (Combos)
            if (draft.getMenuSets() != null) {
                for (BookingDraft.CartSetDTO setDto : draft.getMenuSets()) {
                    MenuSet menuSet = em.find(MenuSet.class, setDto.getMenuSetId());
                    if (menuSet != null) {
                        ReservationMenuItem rmi = new ReservationMenuItem();
                        rmi.setReservation(reservation);
                        rmi.setMenuSet(menuSet);
                        rmi.setQuantity(setDto.getQuantity());
                        rmi.setUnitPrice(menuSet.getDiscountedPrice() != null ? menuSet.getDiscountedPrice() : menuSet.getOriginalPrice());
                        em.persist(rmi);
                    }
                }
            }

            // 3. Menu Items
            if (draft.getMenuItems() != null) {
                for (BookingDraft.CartItemDTO itemDto : draft.getMenuItems()) {
                    MenuItem menuItem = em.find(MenuItem.class, itemDto.getMenuItemId());
                    if (menuItem != null) {
                        ReservationMenuItem rmi = new ReservationMenuItem();
                        rmi.setReservation(reservation);
                        rmi.setMenuItem(menuItem);
                        rmi.setQuantity(itemDto.getQuantity());
                        rmi.setUnitPrice(menuItem.getBasePrice()); // size logic could go here
                        em.persist(rmi);
                    }
                }
            }

            // 4. Addons
            if (draft.getAddons() != null) {
                for (BookingDraft.CartAddonDTO addonDto : draft.getAddons()) {
                    AddonService addon = em.find(AddonService.class, addonDto.getAddonId());
                    if (addon != null) {
                        ReservationAddon ra = new ReservationAddon();
                        ra.setReservation(reservation);
                        ra.setAddonService(addon);
                        ra.setQuantity(addonDto.getQuantity());
                        ra.setUnitPrice(addon.getPrice());
                        em.persist(ra);
                    }
                }
            }

            Invoice invoice = billingService.createInvoiceForReservation(em, reservation, user, null, subtotal, surcharge,
                    voucher, pointsToUse, paymentMethod, false);

            tx.commit();
            reservation.setInvoice(invoice);
            return reservation;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Error saving final booking: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }


    public void processStep3(BookingDraft draft, HttpServletRequest request) {
        if (draft == null) {
            throw new IllegalArgumentException("Booking session expired. Please start over.");
        }
        
        List<BookingDraft.CartItemDTO> menuItems = new java.util.ArrayList<>();
        String[] menuItemIds = request.getParameterValues("menuItemId");
        String[] menuItemQtys = request.getParameterValues("menuItemQty");
        if (menuItemIds != null && menuItemQtys != null) {
            for (int i = 0; i < menuItemIds.length; i++) {
                BookingDraft.CartItemDTO item = new BookingDraft.CartItemDTO();
                item.setMenuItemId(parseInt(menuItemIds[i], null));
                item.setQuantity(parseInt(i < menuItemQtys.length ? menuItemQtys[i] : "1", 1));
                if (item.getMenuItemId() != null && item.getQuantity() > 0) {
                    menuItems.add(item);
                }
            }
        }
        draft.setMenuItems(menuItems);

        List<BookingDraft.CartSetDTO> menuSets = new java.util.ArrayList<>();
        String[] menuSetIds = request.getParameterValues("menuSetId");
        String[] menuSetQtys = request.getParameterValues("menuSetQty");
        if (menuSetIds != null && menuSetQtys != null) {
            for (int i = 0; i < menuSetIds.length; i++) {
                BookingDraft.CartSetDTO set = new BookingDraft.CartSetDTO();
                set.setMenuSetId(parseInt(menuSetIds[i], null));
                set.setQuantity(parseInt(i < menuSetQtys.length ? menuSetQtys[i] : "1", 1));
                if (set.getMenuSetId() != null && set.getQuantity() > 0) {
                    menuSets.add(set);
                }
            }
        }
        draft.setMenuSets(menuSets);

        List<BookingDraft.CartAddonDTO> addons = new java.util.ArrayList<>();
        String[] addonIds = request.getParameterValues("addonId");
        String[] addonQtys = request.getParameterValues("addonQty");
        if (addonIds != null && addonQtys != null) {
            for (int i = 0; i < addonIds.length; i++) {
                BookingDraft.CartAddonDTO addon = new BookingDraft.CartAddonDTO();
                addon.setAddonId(parseInt(addonIds[i], null));
                addon.setQuantity(parseInt(i < addonQtys.length ? addonQtys[i] : "1", 1));
                if (addon.getAddonId() != null && addon.getQuantity() > 0) {
                    addons.add(addon);
                }
            }
        }
        draft.setAddons(addons);
    }

    private void validateDraft(BookingDraft draft) {
        if (draft.getReservationDate() == null) {
            throw new IllegalArgumentException("Please choose a reservation date.");
        }
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        if (draft.getReservationDate().before(cal.getTime())) {
            throw new IllegalArgumentException("Reservation date cannot be in the past.");
        }
        if (draft.getReservationTime() == null || draft.getReservationTime().trim().isEmpty()) {
            throw new IllegalArgumentException("Please choose a reservation time.");
        }
        
        String timeStr = draft.getReservationTime().trim();
        if (timeStr.length() >= 5) {
            try {
                int hour = Integer.parseInt(timeStr.substring(0, 2));
                int minute = Integer.parseInt(timeStr.substring(3, 5));
                
                if (minute != 0 && minute != 30) {
                    throw new IllegalArgumentException("Time must be in 30-minute intervals (e.g., 17:30, 18:00).");
                }
                
                boolean isDinner = (hour >= 18 && hour <= 20) || (hour == 17 && minute == 30) || (hour == 21 && minute == 0);
                
                if (!isDinner) {
                    throw new IllegalArgumentException("Please select a time during our service hours (17:30 - 21:00).");
                }
            } catch (NumberFormatException ignored) {}
        }
        if (draft.getEventTypeId() == null) {
            throw new IllegalArgumentException("Please choose an event type.");
        }
        if (safeCount(draft.getAdultsCount()) < 1) {
            throw new IllegalArgumentException("At least one adult guest is required.");
        }
        parseTime(draft.getReservationTime());
    }

    private Time parseTime(String value) {
        String normalized = value == null ? "" : value.trim();
        if (normalized.length() == 5) {
            normalized += ":00";
        }
        return Time.valueOf(normalized);
    }

    private int safeCount(Integer count) {
        return count == null ? 0 : count;
    }

    private Integer parseInt(String value, Integer fallback) {
        try {
            return value == null || value.trim().isEmpty() ? fallback : Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}


