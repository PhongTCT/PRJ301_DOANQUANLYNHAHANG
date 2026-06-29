package service;

import dao.DiningTableDAO;
import dao.MenuItemDAO;
import entity.DiningTable;
import entity.MenuItem;
import java.util.List;

public class HomeService {
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final DiningTableDAO diningTableDAO = new DiningTableDAO();

    public List<MenuItem> getFeaturedMenu() {
        List<MenuItem> items = menuItemDAO.ListAll();
        return items.size() > 3 ? items.subList(0, 3) : items;
    }

    public List<DiningTable> getTablePreview() {
        List<DiningTable> tables = diningTableDAO.ListAll();
        return tables.size() > 4 ? tables.subList(0, 4) : tables;
    }
}
