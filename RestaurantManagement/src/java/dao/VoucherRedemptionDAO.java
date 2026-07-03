package dao;

import entity.VoucherRedemption;
import java.util.List;
import javax.persistence.EntityManager;
import util.JPAUtil;

public class VoucherRedemptionDAO extends AbstractDAO<VoucherRedemption, Long> {
    public VoucherRedemptionDAO() { super(VoucherRedemption.class); }

    public boolean hasUserRedeemed(Long userId, Integer voucherId) {
        if (userId == null || voucherId == null) {
            return false;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery("SELECT COUNT(r) FROM VoucherRedemption r WHERE r.user.id = :userId AND r.voucher.id = :voucherId", Long.class)
                    .setParameter("userId", userId)
                    .setParameter("voucherId", voucherId)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    public List<VoucherRedemption> findByUser(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<VoucherRedemption> results = em.createQuery("SELECT r FROM VoucherRedemption r WHERE r.user.id = :userId ORDER BY r.usedAt DESC", VoucherRedemption.class)
                    .setParameter("userId", userId)
                    .getResultList();
            for (VoucherRedemption redemption : results) {
                redemption.getVoucher().getVoucherCode();
                redemption.getInvoice().getId();
            }
            return results;
        } finally {
            em.close();
        }
    }
}
