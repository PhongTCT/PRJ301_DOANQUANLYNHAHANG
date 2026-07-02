package dao;

import entity.HolidaySurcharge;

public class HolidaySurchargeDAO extends AbstractDAO<HolidaySurcharge, Integer> {
    public HolidaySurchargeDAO() { super(HolidaySurcharge.class); }

    public HolidaySurcharge findByDate(java.util.Date date) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            java.util.List<HolidaySurcharge> list = em.createQuery("SELECT h FROM HolidaySurcharge h WHERE h.surchargeDate = :date AND h.isActive = true", HolidaySurcharge.class)
                     .setParameter("date", date)
                     .setMaxResults(1)
                     .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
