package dao;

import entity.LoyaltyTransaction;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;

public class LoyaltyTransactionDAO extends AbstractDAO<LoyaltyTransaction, Long> {
    public LoyaltyTransactionDAO() { super(LoyaltyTransaction.class); }

    public ArrayList<LoyaltyTransaction> findByUserIdOrderByCreatedAtDesc(Long userId) {
        EntityManager em = util.JPAUtil.getEntityManager();
        try {
            List<LoyaltyTransaction> result = em.createQuery(
                    "SELECT t FROM LoyaltyTransaction t WHERE t.user.id = :userId ORDER BY t.createdAt DESC",
                    LoyaltyTransaction.class)
                    .setParameter("userId", userId)
                    .setMaxResults(50)
                    .getResultList();
            return new ArrayList<>(result);
        } finally {
            em.close();
        }
    }
}