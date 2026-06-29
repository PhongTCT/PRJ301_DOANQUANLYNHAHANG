package service;

import dao.MenuItemDAO;
import entity.MenuItem;
import java.util.List;

public class MenuService {
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    public List<MenuItem> getAvailableMenuItems() {
        return menuItemDAO.ListAll();
    }
}
