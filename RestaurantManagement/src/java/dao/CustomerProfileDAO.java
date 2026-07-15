package dao;

import entity.CustomerProfile;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;

public class CustomerProfileDAO extends AbstractDAO<CustomerProfile, Long> {
    public CustomerProfileDAO() { super(CustomerProfile.class); }

    public CustomerProfile findByUserId(Long userId) {
        EntityManager em = util.JPAUtil.getEntityManager();
        try {
            List<CustomerProfile> results = em.createQuery(
                    "SELECT p FROM CustomerProfile p WHERE p.user.id = :userId", CustomerProfile.class)
                    .setParameter("userId", userId)
                    .setMaxResults(1)
                    .getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }

    public ArrayList<CustomerProfile> findProfilesEligibleForDecay(Date cutoffDate) {
        EntityManager em = util.JPAUtil.getEntityManager();
        try {
            List<CustomerProfile> result = em.createQuery(
                    "SELECT p FROM CustomerProfile p WHERE p.lastActivityAt < :cutoffDate "
                    + "AND p.loyaltyPoints > 0 "
                    + "AND (p.lastDecayAt IS NULL OR p.lastDecayAt < :cutoffDate)",
                    CustomerProfile.class)
                    .setParameter("cutoffDate", cutoffDate)
                    .getResultList();
            return new ArrayList<>(result);
        } finally {
            em.close();
        }
    }
}
