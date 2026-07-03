package dao;

import entity.Voucher;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import util.JPAUtil;

public class VoucherDAO extends AbstractDAO<Voucher, Integer> {
    public VoucherDAO() { super(Voucher.class); }

    public Voucher findByCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Voucher> list = em.createQuery("SELECT v FROM Voucher v WHERE UPPER(v.voucherCode) = :code", Voucher.class)
                    .setParameter("code", code.trim().toUpperCase())
                    .setMaxResults(1)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public List<Voucher> findActiveUsable(Date now) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT v FROM Voucher v WHERE v.isActive = TRUE AND v.validFrom <= :now AND v.validTo >= :now AND v.usageLimit > v.usedCount ORDER BY v.validTo ASC", Voucher.class)
                    .setParameter("now", now)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Voucher> findAvailableForUser(Long userId, Date now) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT v FROM Voucher v WHERE v.isActive = TRUE AND v.validFrom <= :now AND v.validTo >= :now "
                    + "AND v.usageLimit > v.usedCount "
                    + "AND NOT EXISTS (SELECT r.id FROM VoucherRedemption r WHERE r.voucher = v AND r.user.id = :userId) "
                    + "ORDER BY v.validTo ASC", Voucher.class)
                    .setParameter("now", now)
                    .setParameter("userId", userId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
