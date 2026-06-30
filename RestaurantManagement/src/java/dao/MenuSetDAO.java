package dao;

import entity.MenuSet;

public class MenuSetDAO extends AbstractDAO<MenuSet, Integer> {
    public MenuSetDAO() { super(MenuSet.class); }

    public java.util.List<MenuSet> findActiveSets() {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT m FROM MenuSet m WHERE m.isAvailable = true", MenuSet.class).getResultList();
        } finally {
            em.close();
        }
    }
}
