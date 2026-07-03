package dao;

import entity.MenuSetItem;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import util.JPAUtil;

public class MenuSetItemDAO extends AbstractDAO<MenuSetItem, Integer> {
    public MenuSetItemDAO() { super(MenuSetItem.class); }

    public ArrayList<MenuSetItem> findAllForAdmin() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<MenuSetItem> result = em.createQuery(
                    "SELECT msi FROM MenuSetItem msi " +
                    "JOIN FETCH msi.menuSet " +
                    "JOIN FETCH msi.menuItem " +
                    "LEFT JOIN FETCH msi.defaultSize " +
                    "ORDER BY msi.menuSet.setName, msi.menuItem.itemName",
                    MenuSetItem.class).getResultList();
            return new ArrayList<>(result);
        } finally {
            em.close();
        }
    }

    public ArrayList<MenuSetItem> findByMenuSet(Integer menuSetId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<MenuSetItem> result = em.createQuery(
                    "SELECT msi FROM MenuSetItem msi " +
                    "JOIN FETCH msi.menuSet " +
                    "JOIN FETCH msi.menuItem " +
                    "LEFT JOIN FETCH msi.defaultSize " +
                    "WHERE msi.menuSet.id = :menuSetId " +
                    "ORDER BY msi.menuItem.itemName",
                    MenuSetItem.class)
                    .setParameter("menuSetId", menuSetId)
                    .getResultList();
            return new ArrayList<>(result);
        } finally {
            em.close();
        }
    }

    public MenuSetItem findByIdForAdmin(Integer id) {
        if (id == null) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<MenuSetItem> result = em.createQuery(
                    "SELECT msi FROM MenuSetItem msi " +
                    "JOIN FETCH msi.menuSet " +
                    "JOIN FETCH msi.menuItem " +
                    "LEFT JOIN FETCH msi.defaultSize " +
                    "WHERE msi.id = :id",
                    MenuSetItem.class)
                    .setParameter("id", id)
                    .getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public boolean existsDuplicate(Integer menuSetId, Integer menuItemId, Integer defaultSizeId, Integer excludeId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT COUNT(msi) FROM MenuSetItem msi " +
                    "WHERE msi.menuSet.id = :menuSetId " +
                    "AND msi.menuItem.id = :menuItemId " +
                    "AND " + (defaultSizeId == null ? "msi.defaultSize IS NULL " : "msi.defaultSize.id = :defaultSizeId ") +
                    (excludeId == null ? "" : "AND msi.id <> :excludeId");
            javax.persistence.Query query = em.createQuery(jpql)
                    .setParameter("menuSetId", menuSetId)
                    .setParameter("menuItemId", menuItemId);
            if (defaultSizeId != null) {
                query.setParameter("defaultSizeId", defaultSizeId);
            }
            if (excludeId != null) {
                query.setParameter("excludeId", excludeId);
            }
            return ((Long) query.getSingleResult()) > 0;
        } finally {
            em.close();
        }
    }

    public boolean deleteById(Integer id) {
        if (id == null) {
            return false;
        }
        return executeInTransaction(em -> {
            MenuSetItem entity = em.find(MenuSetItem.class, id);
            if (entity != null) {
                em.remove(entity);
            }
        });
    }
}
