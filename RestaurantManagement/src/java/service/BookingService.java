package service;

import dao.DiningTableDAO;
import dao.EventTypeDAO;
import dto.BookingDraft;
import entity.DiningTable;
import entity.EventType;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

public class BookingService {
    private final DiningTableDAO diningTableDAO = new DiningTableDAO();
    private final EventTypeDAO eventTypeDAO = new EventTypeDAO();

    public List<DiningTable> getAvailableTables() {
        return diningTableDAO.ListAll();
    }

    public List<EventType> getActiveEventTypes() {
        return eventTypeDAO.ListAll();
    }

    public BookingDraft buildDraft(HttpServletRequest request) throws ParseException {
        BookingDraft draft = new BookingDraft();
        String date = request.getParameter("reservationDate");
        if (date != null && !date.trim().isEmpty()) {
            draft.setReservationDate(new SimpleDateFormat("yyyy-MM-dd").parse(date.trim()));
        }
        draft.setReservationTime(request.getParameter("reservationTime"));
        draft.setAdultsCount(parseInt(request.getParameter("adultsCount"), 1));
        draft.setChildrenCount(parseInt(request.getParameter("childrenCount"), 0));
        draft.setEventTypeId(parseInt(request.getParameter("eventTypeId"), null));
        return draft;
    }

    private Integer parseInt(String value, Integer fallback) {
        try {
            return value == null || value.trim().isEmpty() ? fallback : Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
