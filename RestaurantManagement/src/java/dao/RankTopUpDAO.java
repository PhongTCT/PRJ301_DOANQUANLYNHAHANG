package dao;

import entity.RankTopUp;
import enums.TransactionStatus;
import javax.persistence.EntityManager;
import util.JPAUtil;

public class RankTopUpDAO extends AbstractDAO<RankTopUp, Long> {
    public RankTopUpDAO() { super(RankTopUp.class); }

    public Object[] getTopUpRevenue() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Object[] result = (Object[]) em.createQuery(
                "SELECT COALESCE(SUM(t.amount), 0), COUNT(t) FROM RankTopUp t WHERE t.status = :status")
                    .setParameter("status", TransactionStatus.SUCCESS)
                    .getSingleResult();
            return result;
        } finally {
            em.close();
        }
    }
}
