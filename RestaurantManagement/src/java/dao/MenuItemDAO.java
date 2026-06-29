package dao;

import entity.MenuItem;
import util.JPAUtil;
import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

public class MenuItemDAO extends AbstractDAO<MenuItem, Integer> {

    public MenuItemDAO() {
        super(MenuItem.class);
    }

    @Override
    public ArrayList<MenuItem> ListAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<MenuItem> query = em.createQuery(
                    "SELECT m FROM MenuItem m WHERE m.isAvailable = true ORDER BY m.category.sortOrder, m.itemName",
                    MenuItem.class);
            return new ArrayList<>(query.getResultList());
        } finally {
            em.close();
        }
    }
}
