package dao;

import entity.AddonService;

public class AddonServiceDAO extends AbstractDAO<AddonService, Integer> {
    public AddonServiceDAO() { super(AddonService.class); }

    public java.util.List<AddonService> findActiveAddons() {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT a FROM AddonService a WHERE a.isAvailable = true", AddonService.class).getResultList();
        } finally {
            em.close();
        }
    }
}
