package controller;

import entity.MenuSet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import service.AdminRestaurantService;

public class AdminRestaurantController extends HttpServlet {
    private final AdminRestaurantService service = new AdminRestaurantService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "adminAreas";
        }

        try {
            if (isSaveAction(action)) {
                String redirect = handleSave(action, request);
                response.sendRedirect(redirect);
                return;
            }
            if (isToggleAction(action)) {
                handleToggle(action, request);
                response.sendRedirect("MainController?action=" + listActionForToggle(action) + "&saved=1");
                return;
            }
            if (isDeleteAction(action)) {
                handleDelete(action, request);
                response.sendRedirect(redirectAfterDelete(action, request));
                return;
            }
            prepareList(action, request);
            request.getRequestDispatcher(jspFor(action)).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage() == null ? "Could not process request." : e.getMessage());
            String listAction = fallbackListAction(action);
            prepareList(listAction, request);
            request.getRequestDispatcher(jspFor(listAction)).forward(request, response);
        }
    }

    private void prepareList(String action, HttpServletRequest request) {
        request.setAttribute("areas", service.getAreas());
        request.setAttribute("rooms", service.getRooms());
        request.setAttribute("categories", service.getCategories());
        request.setAttribute("menuItems", service.getMenuItems());
        request.setAttribute("menuSets", service.getMenuSets());
        request.setAttribute("sizes", service.getMenuItemSizes());

        if ("adminAreas".equals(action)) {
            request.setAttribute("areaList", service.getAreas());
            request.setAttribute("editArea", service.findArea(paramInt(request, "id")));
        } else if ("adminRooms".equals(action)) {
            request.setAttribute("roomList", service.getRooms());
            request.setAttribute("editRoom", service.findRoom(paramInt(request, "id")));
        } else if ("adminTables".equals(action)) {
            request.setAttribute("tableList", service.getTables());
            request.setAttribute("editTable", service.findTable(paramInt(request, "id")));
        } else if ("adminCategories".equals(action)) {
            request.setAttribute("categoryList", service.getCategories());
            request.setAttribute("editCategory", service.findCategory(paramInt(request, "id")));
        } else if ("adminMenuItems".equals(action)) {
            request.setAttribute("menuItemList", service.getMenuItems());
            request.setAttribute("editMenuItem", service.findMenuItem(paramInt(request, "id")));
        } else if ("adminMenuItemSizes".equals(action)) {
            request.setAttribute("sizeList", service.getMenuItemSizes());
            request.setAttribute("editSize", service.findMenuItemSize(paramInt(request, "id")));
        } else if ("adminMenuSets".equals(action)) {
            Integer selectedMenuSetId = paramInt(request, "id");
            if (selectedMenuSetId == null) {
                selectedMenuSetId = paramInt(request, "menuSetId");
            }
            MenuSet selectedMenuSet = service.findMenuSet(selectedMenuSetId);
            request.setAttribute("menuSetList", service.getMenuSets());
            request.setAttribute("editMenuSet", selectedMenuSet);
            request.setAttribute("selectedMenuSet", selectedMenuSet);
            request.setAttribute("selectedMenuSetItems", service.getMenuSetItemsBySet(selectedMenuSetId));
        } else if ("adminMenuSetItems".equals(action)) {
            request.setAttribute("menuSetItemList", service.getMenuSetItems());
            request.setAttribute("editMenuSetItem", service.findMenuSetItem(paramInt(request, "id")));
        } else if ("adminAddonServices".equals(action)) {
            request.setAttribute("addonList", service.getAddonServices());
            request.setAttribute("editAddon", service.findAddonService(paramInt(request, "id")));
        }
    }

    private String handleSave(String action, HttpServletRequest request) {
        if ("saveArea".equals(action)) {
            service.saveArea(request);
        } else if ("saveRoom".equals(action)) {
            service.saveRoom(request);
        } else if ("saveDiningTable".equals(action)) {
            service.saveDiningTable(request);
        } else if ("saveMenuCategory".equals(action)) {
            service.saveMenuCategory(request);
        } else if ("saveMenuItem".equals(action)) {
            service.saveMenuItem(request);
        } else if ("saveMenuItemSize".equals(action)) {
            service.saveMenuItemSize(request);
        } else if ("saveMenuSet".equals(action)) {
            MenuSet savedSet = service.saveMenuSet(request);
            return "MainController?action=adminMenuSets&id=" + savedSet.getId() + "&saved=1";
        } else if ("saveMenuSetItem".equals(action)) {
            service.saveMenuSetItem(request);
            if ("adminMenuSets".equals(request.getParameter("returnTo"))) {
                return "MainController?action=adminMenuSets&id=" + paramInt(request, "menuSetId") + "&saved=1";
            }
        } else if ("saveMenuSetCourseItems".equals(action)) {
            service.saveMenuSetCourseItems(request);
            return "MainController?action=adminMenuSets&id=" + paramInt(request, "menuSetId") + "&saved=1";
        } else if ("saveAddonService".equals(action)) {
            service.saveAddonService(request);
        }
        return "MainController?action=" + listActionForSave(action) + "&saved=1";
    }

    private void handleToggle(String action, HttpServletRequest request) {
        Integer id = paramInt(request, "id");
        boolean enabled = !"false".equalsIgnoreCase(request.getParameter("enabled"));
        if ("toggleArea".equals(action)) {
            service.setAreaActive(id, enabled);
        } else if ("toggleRoom".equals(action)) {
            service.setRoomActive(id, enabled);
        } else if ("toggleDiningTable".equals(action)) {
            service.setTableActive(id, enabled);
        } else if ("toggleMenuCategory".equals(action)) {
            service.setCategoryActive(id, enabled);
        } else if ("toggleMenuItem".equals(action)) {
            service.setMenuItemAvailable(id, enabled);
        } else if ("toggleMenuSet".equals(action)) {
            service.setMenuSetAvailable(id, enabled);
        } else if ("toggleAddonService".equals(action)) {
            service.setAddonAvailable(id, enabled);
        }
    }

    private void handleDelete(String action, HttpServletRequest request) {
        if ("deleteMenuSetItem".equals(action)) {
            service.deleteMenuSetItem(paramInt(request, "id"));
        }
    }

    private String jspFor(String action) {
        if ("adminRooms".equals(action)) return "admin/rooms.jsp";
        if ("adminTables".equals(action)) return "admin/tables.jsp";
        if ("adminCategories".equals(action)) return "admin/categories.jsp";
        if ("adminMenuItems".equals(action)) return "admin/menu-items.jsp";
        if ("adminMenuItemSizes".equals(action)) return "admin/menu-item-sizes.jsp";
        if ("adminMenuSets".equals(action)) return "admin/menu-sets.jsp";
        if ("adminMenuSetItems".equals(action)) return "admin/menu-set-items.jsp";
        if ("adminAddonServices".equals(action)) return "admin/addon-services.jsp";
        return "admin/areas.jsp";
    }

    private String listActionForSave(String action) {
        if ("saveRoom".equals(action)) return "adminRooms";
        if ("saveDiningTable".equals(action)) return "adminTables";
        if ("saveMenuCategory".equals(action)) return "adminCategories";
        if ("saveMenuItem".equals(action)) return "adminMenuItems";
        if ("saveMenuItemSize".equals(action)) return "adminMenuItemSizes";
        if ("saveMenuSet".equals(action)) return "adminMenuSets";
        if ("saveMenuSetItem".equals(action)) return "adminMenuSetItems";
        if ("saveAddonService".equals(action)) return "adminAddonServices";
        return "adminAreas";
    }

    private String listActionForToggle(String action) {
        if ("toggleRoom".equals(action)) return "adminRooms";
        if ("toggleDiningTable".equals(action)) return "adminTables";
        if ("toggleMenuCategory".equals(action)) return "adminCategories";
        if ("toggleMenuItem".equals(action)) return "adminMenuItems";
        if ("toggleMenuSet".equals(action)) return "adminMenuSets";
        if ("toggleAddonService".equals(action)) return "adminAddonServices";
        return "adminAreas";
    }

    private String listActionForDelete(String action) {
        if ("deleteMenuSetItem".equals(action)) return "adminMenuSetItems";
        return "adminAreas";
    }

    private String redirectAfterDelete(String action, HttpServletRequest request) {
        if ("deleteMenuSetItem".equals(action) && "adminMenuSets".equals(request.getParameter("returnTo"))) {
            return "MainController?action=adminMenuSets&id=" + paramInt(request, "menuSetId") + "&saved=1";
        }
        return "MainController?action=" + listActionForDelete(action) + "&saved=1";
    }

    private String fallbackListAction(String action) {
        if (isSaveAction(action)) return listActionForSave(action);
        if (isToggleAction(action)) return listActionForToggle(action);
        if (isDeleteAction(action)) return listActionForDelete(action);
        return action == null ? "adminAreas" : action;
    }

    private boolean isSaveAction(String action) {
        return action != null && action.startsWith("save");
    }

    private boolean isToggleAction(String action) {
        return action != null && action.startsWith("toggle");
    }

    private boolean isDeleteAction(String action) {
        return action != null && action.startsWith("delete");
    }

    private Integer paramInt(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
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
