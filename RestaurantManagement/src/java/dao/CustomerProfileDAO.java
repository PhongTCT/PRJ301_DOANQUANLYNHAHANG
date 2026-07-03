package dao;

import entity.CustomerProfile;

public class CustomerProfileDAO extends AbstractDAO<CustomerProfile, Long> {
    public CustomerProfileDAO() { super(CustomerProfile.class); }

    public CustomerProfile findByUserId(Long userId) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            java.util.List<CustomerProfile> results = em.createQuery("SELECT p FROM CustomerProfile p WHERE p.user.id = :userId", CustomerProfile.class)
                    .setParameter("userId", userId)
                    .setMaxResults(1)
                    .getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }
}
