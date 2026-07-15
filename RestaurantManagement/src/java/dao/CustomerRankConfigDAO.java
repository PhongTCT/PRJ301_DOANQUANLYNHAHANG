package dao;

import entity.CustomerRankConfig;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;

public class CustomerRankConfigDAO extends AbstractDAO<CustomerRankConfig, Integer> {
    public CustomerRankConfigDAO() { super(CustomerRankConfig.class); }

    public ArrayList<CustomerRankConfig> findAllActiveOrderByMinPointThreshold() {
        EntityManager em = util.JPAUtil.getEntityManager();
        try {
            List<CustomerRankConfig> result = em.createQuery(
                    "SELECT r FROM CustomerRankConfig r WHERE r.isActive = true ORDER BY r.minPointThreshold ASC",
                    CustomerRankConfig.class).getResultList();
            return new ArrayList<>(result);
        } finally {
            em.close();
        }
    }

    public CustomerRankConfig findByRankName(enums.RankName rankName) {
        EntityManager em = util.JPAUtil.getEntityManager();
        try {
            List<CustomerRankConfig> result = em.createQuery(
                    "SELECT r FROM CustomerRankConfig r WHERE r.rankName = :rankName",
                    CustomerRankConfig.class)
                    .setParameter("rankName", rankName)
                    .setMaxResults(1)
                    .getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }
}
