package controller;

import dao.AddonServiceDAO;
import dao.AreaDAO;
import dao.DiningTableDAO;
import dao.MenuCategoryDAO;
import dao.MenuItemDAO;
import dao.MenuItemSizeDAO;
import dao.MenuSetDAO;
import dao.MenuSetItemDAO;
import dao.RoomDAO;
import entity.AddonService;
import entity.Area;
import entity.DiningTable;
import entity.MenuCategory;
import entity.MenuItem;
import entity.MenuItemSize;
import entity.MenuSet;
import entity.MenuSetItem;
import entity.Room;
import enums.MealTime;
import enums.TableStatus;
import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.OptimisticLockException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.JPAUtil;

public class RestaurantApiController extends HttpServlet {
    private final AreaDAO areaDAO = new AreaDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final DiningTableDAO tableDAO = new DiningTableDAO();
    private final MenuCategoryDAO categoryDAO = new MenuCategoryDAO();
    private final MenuItemDAO itemDAO = new MenuItemDAO();
    private final MenuItemSizeDAO sizeDAO = new MenuItemSizeDAO();
    private final MenuSetDAO setDAO = new MenuSetDAO();
    private final MenuSetItemDAO setItemDAO = new MenuSetItemDAO();
    private final AddonServiceDAO addonDAO = new AddonServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareJson(response);
        String path = normalizePath(request.getPathInfo());
        try {
            if ("/areas".equals(path)) {
                writeOk(response, areasJson(activeAreas()));
            } else if (path.matches("^/areas/\\d+/rooms$")) {
                Integer areaId = extractId(path, 2);
                writeOk(response, roomsJson(activeRoomsByArea(areaId)));
            } else if (path.matches("^/rooms/\\d+/tables$")) {
                Integer roomId = extractId(path, 2);
                writeOk(response, tablesJson(activeTablesByRoom(roomId)));
            } else if ("/tables/available".equals(path)) {
                writeOk(response, tablesJson(availableTables(request)));
            } else if ("/menu/categories".equals(path)) {
                writeOk(response, categoriesJson(activeCategories(request.getParameter("mealTime"))));
            } else if ("/menu/items".equals(path)) {
                writeOk(response, menuItemsJson(activeItems(request.getParameter("categoryId"), request.getParameter("mealTime"))));
            } else if ("/menu/sets".equals(path)) {
                writeOk(response, menuSetsJson(activeSets(request.getParameter("mealTime"))));
            } else if ("/addon-services".equals(path)) {
                writeOk(response, addonsJson(addonDAO.findActiveAddons()));
            } else {
                writeError(response, HttpServletResponse.SC_NOT_FOUND, "API endpoint not found.");
            }
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected server error.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        prepareJson(response);
        String path = normalizePath(request.getPathInfo());
        try {
            if ("/booking/hold-table".equals(path)) {
                String body = readBody(request);
                Integer tableId = intValue(request, body, "tableId");
                Integer version = intValue(request, body, "version");
                holdTable(tableId, version);
                writeOk(response, "{\"success\":true,\"message\":\"Table held successfully.\"}");
            } else {
                writeError(response, HttpServletResponse.SC_NOT_FOUND, "API endpoint not found.");
            }
        } catch (OptimisticLockException e) {
            writeError(response, HttpServletResponse.SC_CONFLICT, "Table was changed by another request. Please reload and choose again.");
        } catch (IllegalStateException e) {
            writeError(response, HttpServletResponse.SC_CONFLICT, e.getMessage());
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected server error.");
        }
    }

    private List<Area> activeAreas() {
        List<Area> result = new ArrayList<>();
        for (Area area : areaDAO.ListAll()) {
            if (Boolean.TRUE.equals(area.getIsActive())) {
                result.add(area);
            }
        }
        return result;
    }

    private List<Room> activeRoomsByArea(Integer areaId) {
        requireId(areaId, "Area id");
        List<Room> result = new ArrayList<>();
        for (Room room : roomDAO.ListAll()) {
            if (Boolean.TRUE.equals(room.getIsActive()) && room.getArea() != null && areaId.equals(room.getArea().getId())) {
                result.add(room);
            }
        }
        return result;
    }

    private List<DiningTable> activeTablesByRoom(Integer roomId) {
        requireId(roomId, "Room id");
        List<DiningTable> result = new ArrayList<>();
        for (DiningTable table : tableDAO.findAllForAdmin()) {
            if (Boolean.TRUE.equals(table.getIsActive()) && table.getRoom() != null && roomId.equals(table.getRoom().getId())) {
                result.add(table);
            }
        }
        return result;
    }

    private List<DiningTable> availableTables(HttpServletRequest request) throws Exception {
        String dateParam = required(request.getParameter("date"), "date");
        String timeParam = required(request.getParameter("time"), "time");
        Integer capacity = parsePositiveInt(request.getParameter("capacity"), "capacity");
        Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateParam);
        Time time = Time.valueOf(timeParam.length() == 5 ? timeParam + ":00" : timeParam);
        return tableDAO.findAvailableTables(date, time, capacity);
    }

    private List<MenuCategory> activeCategories(String mealTimeParam) {
        MealTime mealTime = optionalMealTime(mealTimeParam);
        List<MenuCategory> result = new ArrayList<>();
        for (MenuCategory category : categoryDAO.ListAll()) {
            boolean active = Boolean.TRUE.equals(category.getIsActive());
            boolean mealMatches = mealTime == null || category.getMealTime() == MealTime.ALL_DAY || category.getMealTime() == mealTime;
            if (active && mealMatches) {
                result.add(category);
            }
        }
        return result;
    }

    private List<MenuItem> activeItems(String categoryIdParam, String mealTimeParam) {
        Integer categoryId = optionalInt(categoryIdParam, "categoryId");
        MealTime mealTime = optionalMealTime(mealTimeParam);
        List<MenuItem> result = new ArrayList<>();
        for (MenuItem item : itemDAO.ListAll()) {
            boolean categoryMatches = categoryId == null || (item.getCategory() != null && categoryId.equals(item.getCategory().getId()));
            boolean mealMatches = true;
            if (mealTime != null) {
                MealTime categoryMealTime = item.getCategory() == null ? null : item.getCategory().getMealTime();
                mealMatches = categoryMealTime == MealTime.ALL_DAY || categoryMealTime == mealTime;
            }
            if (Boolean.TRUE.equals(item.getIsAvailable()) && categoryMatches && mealMatches) {
                result.add(item);
            }
        }
        return result;
    }

    private List<MenuSet> activeSets(String mealTimeParam) {
        MealTime mealTime = optionalMealTime(mealTimeParam);
        List<MenuSet> result = new ArrayList<>();
        for (MenuSet set : setDAO.findActiveSets()) {
            boolean mealMatches = mealTime == null || set.getMealTime() == MealTime.ALL_DAY || set.getMealTime() == mealTime;
            if (mealMatches) {
                result.add(set);
            }
        }
        return result;
    }

    private void holdTable(Integer tableId, Integer version) {
        requireId(tableId, "Table id");
        if (version == null) {
            throw new IllegalArgumentException("version is required.");
        }
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            DiningTable table = em.find(DiningTable.class, tableId);
            if (table == null || !Boolean.TRUE.equals(table.getIsActive())) {
                throw new IllegalArgumentException("Table not found.");
            }
            if (!version.equals(table.getVersion())) {
                throw new IllegalStateException("Table version changed. Please reload and choose again.");
            }
            if (table.getStatus() != TableStatus.AVAILABLE) {
                throw new IllegalStateException("Table is no longer available.");
            }
            table.setStatus(TableStatus.RESERVED);
            em.merge(table);
            tx.commit();
        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    private String areasJson(List<Area> areas) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < areas.size(); i++) {
            Area area = areas.get(i);
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(area.getId())
                    .append(",\"name\":").append(q(area.getName()))
                    .append(",\"description\":").append(q(area.getDescription()))
                    .append(",\"priceModifier\":").append(num(area.getPriceModifier()))
                    .append(",\"active\":").append(Boolean.TRUE.equals(area.getIsActive()))
                    .append('}');
        }
        return okArray(json);
    }

    private String roomsJson(List<Room> rooms) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < rooms.size(); i++) {
            Room room = rooms.get(i);
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(room.getId())
                    .append(",\"areaId\":").append(room.getArea() == null ? "null" : room.getArea().getId())
                    .append(",\"roomName\":").append(q(room.getRoomName()))
                    .append(",\"roomType\":").append(q(room.getRoomType()))
                    .append(",\"capacity\":").append(room.getCapacity())
                    .append(",\"pricePerSession\":").append(num(room.getPricePerSession()))
                    .append(",\"active\":").append(Boolean.TRUE.equals(room.getIsActive()))
                    .append('}');
        }
        return okArray(json);
    }

    private String tablesJson(List<DiningTable> tables) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < tables.size(); i++) {
            DiningTable table = tables.get(i);
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(table.getId())
                    .append(",\"roomId\":").append(table.getRoom() == null ? "null" : table.getRoom().getId())
                    .append(",\"tableCode\":").append(q(table.getTableCode()))
                    .append(",\"capacity\":").append(table.getCapacity())
                    .append(",\"basePrice\":").append(num(table.getBasePrice()))
                    .append(",\"imageUrl\":").append(q(table.getImageUrl()))
                    .append(",\"status\":").append(q(table.getStatus()))
                    .append(",\"version\":").append(table.getVersion())
                    .append(",\"active\":").append(Boolean.TRUE.equals(table.getIsActive()))
                    .append('}');
        }
        return okArray(json);
    }

    private String categoriesJson(List<MenuCategory> categories) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < categories.size(); i++) {
            MenuCategory category = categories.get(i);
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(category.getId())
                    .append(",\"categoryName\":").append(q(category.getCategoryName()))
                    .append(",\"mealTime\":").append(q(category.getMealTime()))
                    .append(",\"categoryType\":").append(q(category.getCategoryType()))
                    .append(",\"sortOrder\":").append(category.getSortOrder())
                    .append(",\"active\":").append(Boolean.TRUE.equals(category.getIsActive()))
                    .append('}');
        }
        return okArray(json);
    }

    private String menuItemsJson(List<MenuItem> items) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < items.size(); i++) {
            MenuItem item = items.get(i);
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(item.getId())
                    .append(",\"categoryId\":").append(item.getCategory() == null ? "null" : item.getCategory().getId())
                    .append(",\"categoryName\":").append(item.getCategory() == null ? "null" : q(item.getCategory().getCategoryName()))
                    .append(",\"categoryType\":").append(item.getCategory() == null ? "null" : q(item.getCategory().getCategoryType()))
                    .append(",\"mealTime\":").append(item.getCategory() == null ? "null" : q(item.getCategory().getMealTime()))
                    .append(",\"itemName\":").append(q(item.getItemName()))
                    .append(",\"description\":").append(q(item.getDescription()))
                    .append(",\"imageUrl\":").append(q(item.getImageUrl()))
                    .append(",\"basePrice\":").append(num(item.getBasePrice()))
                    .append(",\"sizes\":").append(sizesJson(item.getId()))
                    .append(",\"available\":").append(Boolean.TRUE.equals(item.getIsAvailable()))
                    .append('}');
        }
        return okArray(json);
    }

    private String sizesJson(Integer menuItemId) {
        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        for (MenuItemSize size : sizeDAO.ListAll()) {
            if (size.getMenuItem() == null || !menuItemId.equals(size.getMenuItem().getId())) {
                continue;
            }
            if (!first) {
                json.append(',');
            }
            json.append("{\"id\":").append(size.getId())
                    .append(",\"sizeName\":").append(q(size.getSizeName()))
                    .append(",\"priceModifier\":").append(num(size.getPriceModifier()))
                    .append('}');
            first = false;
        }
        json.append(']');
        return json.toString();
    }

    private String menuSetsJson(List<MenuSet> sets) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < sets.size(); i++) {
            MenuSet set = sets.get(i);
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(set.getId())
                    .append(",\"setName\":").append(q(set.getSetName()))
                    .append(",\"setNameVi\":").append(q(set.getSetNameVi()))
                    .append(",\"description\":").append(q(set.getDescription()))
                    .append(",\"descriptionVi\":").append(q(set.getDescriptionVi()))
                    .append(",\"mealTime\":").append(q(set.getMealTime()))
                    .append(",\"originalPrice\":").append(num(set.getOriginalPrice()))
                    .append(",\"discountedPrice\":").append(num(set.getDiscountedPrice()))
                    .append(",\"imageUrl\":").append(q(set.getImageUrl()))
                    .append(",\"items\":").append(setItemsJson(set.getId()))
                    .append(",\"available\":").append(Boolean.TRUE.equals(set.getIsAvailable()))
                    .append('}');
        }
        return okArray(json);
    }

    private String setItemsJson(Integer menuSetId) {
        StringBuilder json = new StringBuilder("[");
        List<MenuSetItem> items = setItemDAO.findByMenuSet(menuSetId);
        for (int i = 0; i < items.size(); i++) {
            MenuSetItem setItem = items.get(i);
            MenuItem item = setItem.getMenuItem();
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(setItem.getId())
                    .append(",\"menuItemId\":").append(item == null ? "null" : item.getId())
                    .append(",\"itemName\":").append(item == null ? "null" : q(item.getItemName()))
                    .append(",\"itemNameVi\":").append(item == null ? "null" : q(item.getItemNameVi()))
                    .append(",\"courseName\":").append(q(setItem.getCourseName()))
                    .append(",\"courseNameVi\":").append(q(setItem.getCourseNameVi()))
                    .append(",\"categoryType\":").append(item == null || item.getCategory() == null ? "null" : q(item.getCategory().getCategoryType()))
                    .append(",\"defaultSizeId\":").append(setItem.getDefaultSize() == null ? "null" : setItem.getDefaultSize().getId())
                    .append(",\"defaultSizeName\":").append(setItem.getDefaultSize() == null ? "null" : q(setItem.getDefaultSize().getSizeName()))
                    .append(",\"quantity\":").append(setItem.getQuantity() == null ? 1 : setItem.getQuantity())
                    .append('}');
        }
        json.append(']');
        return json.toString();
    }

    private String addonsJson(List<AddonService> addons) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < addons.size(); i++) {
            AddonService addon = addons.get(i);
            if (i > 0) json.append(',');
            json.append("{\"id\":").append(addon.getId())
                    .append(",\"serviceName\":").append(q(addon.getServiceName()))
                    .append(",\"description\":").append(q(addon.getDescription()))
                    .append(",\"price\":").append(num(addon.getPrice()))
                    .append(",\"imageUrl\":").append(q(addon.getImageUrl()))
                    .append(",\"available\":").append(Boolean.TRUE.equals(addon.getIsAvailable()))
                    .append('}');
        }
        return okArray(json);
    }

    private String okArray(StringBuilder array) {
        array.append(']');
        return "{\"success\":true,\"data\":" + array.toString() + "}";
    }

    private void prepareJson(HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
    }

    private void writeOk(HttpServletResponse response, String json) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(json);
    }

    private void writeError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.getWriter().write("{\"success\":false,\"message\":" + q(message) + "}");
    }

    private String normalizePath(String pathInfo) {
        if (pathInfo == null || pathInfo.trim().isEmpty() || "/".equals(pathInfo)) {
            return "/";
        }
        return pathInfo;
    }

    private Integer extractId(String path, int index) {
        String[] parts = path.split("/");
        if (parts.length <= index) {
            return null;
        }
        return parsePositiveInt(parts[index], "id");
    }

    private void requireId(Integer id, String label) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException(label + " is required.");
        }
    }

    private String required(String value, String name) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(name + " is required.");
        }
        return value.trim();
    }

    private Integer optionalInt(String value, String name) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return parsePositiveInt(value, name);
    }

    private Integer parsePositiveInt(String value, String name) {
        try {
            Integer parsed = Integer.valueOf(value.trim());
            if (parsed <= 0) {
                throw new IllegalArgumentException(name + " must be greater than 0.");
            }
            return parsed;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(name + " must be a valid number.");
        }
    }

    private MealTime optionalMealTime(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return MealTime.valueOf(value.trim());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("mealTime is invalid.");
        }
    }

    private Integer intValue(HttpServletRequest request, String body, String name) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            value = jsonValue(body, name);
        }
        return value == null ? null : parsePositiveInt(value, name);
    }

    private String jsonValue(String body, String name) {
        if (body == null) {
            return null;
        }
        String marker = "\"" + name + "\"";
        int key = body.indexOf(marker);
        if (key < 0) {
            return null;
        }
        int colon = body.indexOf(':', key + marker.length());
        if (colon < 0) {
            return null;
        }
        int start = colon + 1;
        while (start < body.length() && Character.isWhitespace(body.charAt(start))) {
            start++;
        }
        int end = start;
        while (end < body.length() && (Character.isDigit(body.charAt(end)) || body.charAt(end) == '-')) {
            end++;
        }
        return body.substring(start, end);
    }

    private String readBody(HttpServletRequest request) throws IOException {
        StringBuilder body = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            body.append(line);
        }
        return body.toString();
    }

    private String q(Object value) {
        if (value == null) {
            return "null";
        }
        String text = String.valueOf(value);
        StringBuilder escaped = new StringBuilder("\"");
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            if (ch == '\\' || ch == '"') {
                escaped.append('\\').append(ch);
            } else if (ch == '\n') {
                escaped.append("\\n");
            } else if (ch == '\r') {
                escaped.append("\\r");
            } else if (ch == '\t') {
                escaped.append("\\t");
            } else {
                escaped.append(ch);
            }
        }
        escaped.append('"');
        return escaped.toString();
    }

    private String num(BigDecimal value) {
        return value == null ? "0" : value.stripTrailingZeros().toPlainString();
    }
}
