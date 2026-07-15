package service;

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
import enums.MenuCategoryType;
import enums.RoomType;
import enums.TableStatus;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;
import util.CloudinaryUtil;

public class AdminRestaurantService {
    private final AreaDAO areaDAO = new AreaDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final DiningTableDAO diningTableDAO = new DiningTableDAO();
    private final MenuCategoryDAO menuCategoryDAO = new MenuCategoryDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final MenuItemSizeDAO menuItemSizeDAO = new MenuItemSizeDAO();
    private final MenuSetDAO menuSetDAO = new MenuSetDAO();
    private final MenuSetItemDAO menuSetItemDAO = new MenuSetItemDAO();
    private final AddonServiceDAO addonServiceDAO = new AddonServiceDAO();

    public List<Area> getAreas() { return areaDAO.ListAll(); }
    public List<Room> getRooms() { return roomDAO.ListAll(); }
    public List<DiningTable> getTables() { return diningTableDAO.findAllForAdmin(); }
    public List<MenuCategory> getCategories() { return menuCategoryDAO.ListAll(); }
    public List<MenuItem> getMenuItems() { return menuItemDAO.findAllForAdmin(); }
    public List<MenuItemSize> getMenuItemSizes() { return menuItemSizeDAO.ListAll(); }
    public List<MenuSet> getMenuSets() { return menuSetDAO.ListAll(); }
    public List<MenuSetItem> getMenuSetItems() { return menuSetItemDAO.findAllForAdmin(); }
    public List<MenuSetItem> getMenuSetItemsBySet(Integer menuSetId) { return menuSetId == null ? menuSetItemDAO.findAllForAdmin() : menuSetItemDAO.findByMenuSet(menuSetId); }
    public List<AddonService> getAddonServices() { return addonServiceDAO.ListAll(); }

    public Area findArea(Integer id) { return areaDAO.searchById(id); }
    public Room findRoom(Integer id) { return roomDAO.searchById(id); }
    public DiningTable findTable(Integer id) { return diningTableDAO.searchById(id); }
    public MenuCategory findCategory(Integer id) { return menuCategoryDAO.searchById(id); }
    public MenuItem findMenuItem(Integer id) { return menuItemDAO.searchById(id); }
    public MenuItemSize findMenuItemSize(Integer id) { return menuItemSizeDAO.searchById(id); }
    public MenuSet findMenuSet(Integer id) { return menuSetDAO.searchById(id); }
    public MenuSetItem findMenuSetItem(Integer id) { return menuSetItemDAO.findByIdForAdmin(id); }
    public AddonService findAddonService(Integer id) { return addonServiceDAO.searchById(id); }

    public void saveArea(HttpServletRequest request) {
        Area area = getOrNewArea(paramInt(request, "id"));
        String nameVi = required(request, "nameVi", "Area name (VI)");
        String nameEn = trim(request.getParameter("name"));
        String descVi = trim(request.getParameter("descriptionVi"));
        String descEn = trim(request.getParameter("description"));
        area.setNameVi(nameVi);
        area.setName(nameEn != null ? nameEn : nameVi);
        area.setDescriptionVi(descVi);
        area.setDescription(descEn != null ? descEn : descVi);
        area.setPriceModifier(nonNegativeMoney(request, "priceModifier", "Price modifier"));
        area.setIsActive(paramBool(request, "isActive"));
        save(areaDAO, area, area.getId());
    }

    public void saveRoom(HttpServletRequest request) {
        Room room = getOrNewRoom(paramInt(request, "id"));
        Area area = requireArea(paramInt(request, "areaId"));
        room.setArea(area);
        room.setRoomName(required(request, "roomName", "Room name"));
        room.setRoomType(enumValue(RoomType.class, request.getParameter("roomType"), "Room type"));
        room.setCapacity(positiveInt(request, "capacity", "Capacity"));
        room.setPricePerSession(nonNegativeMoney(request, "pricePerSession", "Price per session"));
        room.setIsActive(paramBool(request, "isActive"));
        save(roomDAO, room, room.getId());
    }

    public void saveDiningTable(HttpServletRequest request) {
        DiningTable table = getOrNewTable(paramInt(request, "id"));
        Room room = requireRoom(paramInt(request, "roomId"));
        table.setRoom(room);
        table.setTableCode(required(request, "tableCode", "Table code"));
        table.setCapacity(positiveInt(request, "capacity", "Capacity"));
        table.setBasePrice(nonNegativeMoney(request, "basePrice", "Base price"));
        table.setImageUrl(resolveImageUrl(request, "tables", trim(request.getParameter("imageUrl"))));
        table.setStatus(enumValue(TableStatus.class, request.getParameter("status"), "Status"));
        table.setIsActive(paramBool(request, "isActive"));
        save(diningTableDAO, table, table.getId());
    }

    public void saveMenuCategory(HttpServletRequest request) {
        MenuCategory category = getOrNewCategory(paramInt(request, "id"));
        String categoryNameVi = required(request, "categoryNameVi", "Category name (VI)");
        String categoryName = trim(request.getParameter("categoryName"));
        category.setCategoryName(categoryName == null || categoryName.isEmpty() ? categoryNameVi : categoryName);
        category.setCategoryNameVi(categoryNameVi);
        category.setMealTime(MealTime.DINNER);
        category.setCategoryType(enumValue(MenuCategoryType.class, request.getParameter("categoryType"), "Category type"));
        category.setSortOrder(positiveInt(request, "sortOrder", "Sort order"));
        category.setIsActive(paramBool(request, "isActive"));
        save(menuCategoryDAO, category, category.getId());
    }

    public void saveMenuItem(HttpServletRequest request) {
        MenuItem item = getOrNewMenuItem(paramInt(request, "id"));
        MenuCategory category = requireCategory(paramInt(request, "categoryId"));
        String itemNameVi = required(request, "itemNameVi", "Item name (VI)");
        String itemName = trim(request.getParameter("itemName"));
        String descriptionVi = trim(request.getParameter("descriptionVi"));
        String description = trim(request.getParameter("description"));
        item.setCategory(category);
        item.setItemName(itemName == null || itemName.isEmpty() ? itemNameVi : itemName);
        item.setItemNameVi(itemNameVi);
        item.setDescription(description == null || description.isEmpty() ? descriptionVi : description);
        item.setDescriptionVi(descriptionVi);
        item.setImageUrl(resolveImageUrl(request, "menu-items", trim(request.getParameter("imageUrl"))));
        item.setBasePrice(nonNegativeMoney(request, "basePrice", "Base price"));
        item.setIsAvailable(paramBool(request, "isAvailable"));
        save(menuItemDAO, item, item.getId());
    }

    public void saveMenuItemSize(HttpServletRequest request) {
        MenuItemSize size = getOrNewMenuItemSize(paramInt(request, "id"));
        MenuItem item = requireMenuItem(paramInt(request, "menuItemId"));
        size.setMenuItem(item);
        size.setSizeName(required(request, "sizeName", "Size name"));
        size.setPriceModifier(nonNegativeMoney(request, "priceModifier", "Price modifier"));
        save(menuItemSizeDAO, size, size.getId());
    }

    public MenuSet saveMenuSet(HttpServletRequest request) {
        MenuSet set = getOrNewMenuSet(paramInt(request, "id"));
        String setNameVi = required(request, "setNameVi", "Set name (VI)");
        String setName = trim(request.getParameter("setName"));
        String descriptionVi = trim(request.getParameter("descriptionVi"));
        String description = trim(request.getParameter("description"));
        set.setSetName(setName == null || setName.isEmpty() ? setNameVi : setName);
        set.setSetNameVi(setNameVi);
        set.setDescription(description == null || description.isEmpty() ? descriptionVi : description);
        set.setDescriptionVi(descriptionVi);
        set.setMealTime(MealTime.DINNER);
        if (set.getId() == null || menuSetItemDAO.findByMenuSet(set.getId()).isEmpty()) {
            set.setOriginalPrice(nonNegativeMoney(request, "originalPrice", "Original price"));
        }
        set.setDiscountedPrice(nonNegativeMoney(request, "discountedPrice", "Discounted price"));
        set.setImageUrl(resolveImageUrl(request, "menu-sets", trim(request.getParameter("imageUrl"))));
        set.setIsAvailable(paramBool(request, "isAvailable"));
        save(menuSetDAO, set, set.getId());
        return set;
    }

    public void saveMenuSetItem(HttpServletRequest request) {
        MenuSetItem setItem = getOrNewMenuSetItem(paramInt(request, "id"));
        MenuSet menuSet = requireMenuSet(paramInt(request, "menuSetId"));
        MenuItem menuItem = requireMenuItem(paramInt(request, "menuItemId"));
        Integer defaultSizeId = paramInt(request, "defaultSizeId");
        MenuItemSize defaultSize = null;
        if (defaultSizeId != null) {
            defaultSize = requireMenuItemSize(defaultSizeId);
            if (defaultSize.getMenuItem() == null || !menuItem.getId().equals(defaultSize.getMenuItem().getId())) {
                throw new IllegalArgumentException("Default size must belong to the selected menu item.");
            }
        }
        if (menuSetItemDAO.existsDuplicate(menuSet.getId(), menuItem.getId(), defaultSizeId, setItem.getId())) {
            throw new IllegalArgumentException("This menu item and size already exists in the selected set.");
        }
        setItem.setMenuSet(menuSet);
        setItem.setMenuItem(menuItem);
        setItem.setDefaultSize(defaultSize);
        setItem.setCourseName(trim(request.getParameter("courseName")));
        setItem.setCourseNameVi(trim(request.getParameter("courseNameVi")));
        setItem.setQuantity(positiveInt(request, "quantity", "Quantity"));
        save(menuSetItemDAO, setItem, setItem.getId());
        recalculateMenuSetOriginalPrice(menuSet.getId());
    }

    public void saveMenuSetCourseItems(HttpServletRequest request) {
        Integer menuSetId = paramInt(request, "menuSetId");
        MenuSet menuSet = requireMenuSet(menuSetId);
        String[] menuItemIds = request.getParameterValues("menuItemId");
        String[] defaultSizeIds = request.getParameterValues("defaultSizeId");
        String[] quantities = request.getParameterValues("quantity");
        if (menuItemIds == null || menuItemIds.length == 0) {
            throw new IllegalArgumentException("Choose at least one dish before saving.");
        }
        for (int i = 0; i < menuItemIds.length; i++) {
            MenuItem menuItem = requireMenuItem(parseInt(menuItemIds[i], "Menu item"));
            Integer defaultSizeId = valueAt(defaultSizeIds, i) == null || valueAt(defaultSizeIds, i).isEmpty()
                    ? null
                    : parseInt(valueAt(defaultSizeIds, i), "Default size");
            MenuItemSize defaultSize = null;
            if (defaultSizeId != null) {
                defaultSize = requireMenuItemSize(defaultSizeId);
                if (defaultSize.getMenuItem() == null || !menuItem.getId().equals(defaultSize.getMenuItem().getId())) {
                    throw new IllegalArgumentException("Default size must belong to the selected menu item.");
                }
            }
            if (!menuSetItemDAO.existsDuplicate(menuSet.getId(), menuItem.getId(), defaultSizeId, null)) {
                MenuSetItem setItem = new MenuSetItem();
                setItem.setMenuSet(menuSet);
                setItem.setMenuItem(menuItem);
                setItem.setDefaultSize(defaultSize);
                setItem.setQuantity(parsePositiveInt(valueAt(quantities, i), "Quantity"));
                save(menuSetItemDAO, setItem, null);
            }
        }
        recalculateMenuSetOriginalPrice(menuSet.getId());
    }

    public void saveAddonService(HttpServletRequest request) {
        AddonService addon = getOrNewAddonService(paramInt(request, "id"));
        String serviceNameVi = required(request, "serviceNameVi", "Service name (VI)");
        String serviceName = trim(request.getParameter("serviceName"));
        String descriptionVi = trim(request.getParameter("descriptionVi"));
        String description = trim(request.getParameter("description"));
        addon.setServiceName(serviceName == null || serviceName.isEmpty() ? serviceNameVi : serviceName);
        addon.setServiceNameVi(serviceNameVi);
        addon.setDescription(description == null || description.isEmpty() ? descriptionVi : description);
        addon.setDescriptionVi(descriptionVi);
        addon.setPrice(nonNegativeMoney(request, "price", "Price"));
        addon.setImageUrl(resolveImageUrl(request, "addon-services", trim(request.getParameter("imageUrl"))));
        addon.setIsAvailable(paramBool(request, "isAvailable"));
        save(addonServiceDAO, addon, addon.getId());
    }

    public void setAreaActive(Integer id, boolean active) {
        Area entity = requireArea(id);
        entity.setIsActive(active);
        areaDAO.update(entity);
    }

    public void setRoomActive(Integer id, boolean active) {
        Room entity = requireRoom(id);
        entity.setIsActive(active);
        roomDAO.update(entity);
    }

    public void setTableActive(Integer id, boolean active) {
        DiningTable entity = requireTable(id);
        entity.setIsActive(active);
        diningTableDAO.update(entity);
    }

    public void setCategoryActive(Integer id, boolean active) {
        MenuCategory entity = requireCategory(id);
        entity.setIsActive(active);
        menuCategoryDAO.update(entity);
    }

    public void setMenuItemAvailable(Integer id, boolean available) {
        MenuItem entity = requireMenuItem(id);
        entity.setIsAvailable(available);
        menuItemDAO.update(entity);
    }

    public void setMenuSetAvailable(Integer id, boolean available) {
        MenuSet entity = requireMenuSet(id);
        entity.setIsAvailable(available);
        menuSetDAO.update(entity);
    }

    public void deleteMenuSetItem(Integer id) {
        MenuSetItem setItem = requireMenuSetItem(id);
        Integer menuSetId = setItem.getMenuSet() == null ? null : setItem.getMenuSet().getId();
        menuSetItemDAO.deleteById(id);
        if (menuSetId != null) {
            recalculateMenuSetOriginalPrice(menuSetId);
        }
    }

    public void setAddonAvailable(Integer id, boolean available) {
        AddonService entity = requireAddonService(id);
        entity.setIsAvailable(available);
        addonServiceDAO.update(entity);
    }

    private Area getOrNewArea(Integer id) { return id == null ? new Area() : requireArea(id); }
    private Room getOrNewRoom(Integer id) { return id == null ? new Room() : requireRoom(id); }
    private DiningTable getOrNewTable(Integer id) { return id == null ? new DiningTable() : requireTable(id); }
    private MenuCategory getOrNewCategory(Integer id) { return id == null ? new MenuCategory() : requireCategory(id); }
    private MenuItem getOrNewMenuItem(Integer id) { return id == null ? new MenuItem() : requireMenuItem(id); }
    private MenuItemSize getOrNewMenuItemSize(Integer id) { return id == null ? new MenuItemSize() : requireMenuItemSize(id); }
    private MenuSet getOrNewMenuSet(Integer id) { return id == null ? new MenuSet() : requireMenuSet(id); }
    private MenuSetItem getOrNewMenuSetItem(Integer id) { return id == null ? new MenuSetItem() : requireMenuSetItem(id); }
    private AddonService getOrNewAddonService(Integer id) { return id == null ? new AddonService() : requireAddonService(id); }

    private Area requireArea(Integer id) { return require(areaDAO.searchById(id), "Area"); }
    private Room requireRoom(Integer id) { return require(roomDAO.searchById(id), "Room"); }
    private DiningTable requireTable(Integer id) { return require(diningTableDAO.searchById(id), "Table"); }
    private MenuCategory requireCategory(Integer id) { return require(menuCategoryDAO.searchById(id), "Category"); }
    private MenuItem requireMenuItem(Integer id) { return require(menuItemDAO.searchById(id), "Menu item"); }
    private MenuItemSize requireMenuItemSize(Integer id) { return require(menuItemSizeDAO.searchById(id), "Menu item size"); }
    private MenuSet requireMenuSet(Integer id) { return require(menuSetDAO.searchById(id), "Menu set"); }
    private MenuSetItem requireMenuSetItem(Integer id) { return require(menuSetItemDAO.findByIdForAdmin(id), "Menu set item"); }
    private AddonService requireAddonService(Integer id) { return require(addonServiceDAO.searchById(id), "Addon service"); }

    private void recalculateMenuSetOriginalPrice(Integer menuSetId) {
        MenuSet menuSet = requireMenuSet(menuSetId);
        BigDecimal total = BigDecimal.ZERO;
        for (MenuSetItem item : menuSetItemDAO.findByMenuSet(menuSetId)) {
            BigDecimal itemPrice = item.getMenuItem() == null || item.getMenuItem().getBasePrice() == null
                    ? BigDecimal.ZERO
                    : item.getMenuItem().getBasePrice();
            if (item.getDefaultSize() != null && item.getDefaultSize().getPriceModifier() != null) {
                itemPrice = itemPrice.add(item.getDefaultSize().getPriceModifier());
            }
            int quantity = item.getQuantity() == null ? 1 : item.getQuantity();
            total = total.add(itemPrice.multiply(new BigDecimal(quantity)));
        }
        menuSet.setOriginalPrice(total);
        if (menuSet.getDiscountedPrice() == null || menuSet.getDiscountedPrice().compareTo(BigDecimal.ZERO) <= 0) {
            menuSet.setDiscountedPrice(total);
        }
        menuSetDAO.update(menuSet);
    }

    private <T> T require(T entity, String label) {
        if (entity == null) {
            throw new IllegalArgumentException(label + " not found.");
        }
        return entity;
    }

    private <T> void save(dao.AbstractDAO<T, Integer> dao, T entity, Integer id) {
        if (id == null) {
            dao.insert(entity);
        } else {
            dao.update(entity);
        }
    }

    private String required(HttpServletRequest request, String name, String label) {
        String value = trim(request.getParameter(name));
        if (value == null || value.isEmpty()) {
            throw new IllegalArgumentException(label + " is required.");
        }
        return value;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private String resolveImageUrl(HttpServletRequest request, String folder, String fallbackUrl) {
        String contentType = request.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("multipart/")) {
            return fallbackUrl;
        }
        try {
            Part imagePart = request.getPart("imageFile");
            String uploadedUrl = CloudinaryUtil.uploadImage(imagePart, "le-royal/" + folder);
            return uploadedUrl == null || uploadedUrl.trim().isEmpty() ? fallbackUrl : uploadedUrl;
        } catch (IllegalStateException e) {
            throw new IllegalArgumentException("Image file is too large.");
        } catch (IOException | ServletException e) {
            throw new IllegalArgumentException("Could not read uploaded image.");
        }
    }

    private Integer paramInt(HttpServletRequest request, String name) {
        String value = trim(request.getParameter(name));
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(name + " must be a valid number.");
        }
    }

    private String valueAt(String[] values, int index) {
        return values == null || index >= values.length ? null : trim(values[index]);
    }

    private Integer parseInt(String value, String label) {
        String trimmed = trim(value);
        if (trimmed == null || trimmed.isEmpty()) {
            throw new IllegalArgumentException(label + " is required.");
        }
        try {
            return Integer.valueOf(trimmed);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(label + " must be a valid number.");
        }
    }

    private Integer parsePositiveInt(String value, String label) {
        Integer number = parseInt(value, label);
        if (number <= 0) {
            throw new IllegalArgumentException(label + " must be greater than 0.");
        }
        return number;
    }

    private Integer positiveInt(HttpServletRequest request, String name, String label) {
        Integer value = paramInt(request, name);
        if (value == null || value <= 0) {
            throw new IllegalArgumentException(label + " must be greater than 0.");
        }
        return value;
    }

    private BigDecimal nonNegativeMoney(HttpServletRequest request, String name, String label) {
        String value = trim(request.getParameter(name));
        if (value == null || value.isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            BigDecimal number = new BigDecimal(value);
            if (number.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException(label + " cannot be negative.");
            }
            return number;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(label + " must be a valid amount.");
        }
    }

    private boolean paramBool(HttpServletRequest request, String name) {
        return "true".equalsIgnoreCase(request.getParameter(name)) || "on".equalsIgnoreCase(request.getParameter(name));
    }

    private <E extends Enum<E>> E enumValue(Class<E> type, String value, String label) {
        String normalized = trim(value);
        if (normalized == null || normalized.isEmpty()) {
            throw new IllegalArgumentException(label + " is required.");
        }
        try {
            return Enum.valueOf(type, normalized);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(label + " is invalid.");
        }
    }
}
