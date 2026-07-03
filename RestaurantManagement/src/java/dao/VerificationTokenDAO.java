package dao;

import entity.VerificationToken;
import enums.VerificationTokenType;
import util.JPAUtil;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

public class VerificationTokenDAO extends AbstractDAO<VerificationToken, Long> {

    public VerificationTokenDAO() {
        super(VerificationToken.class);
    }

    public VerificationToken findByToken(String token) {
        if (token == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<VerificationToken> query = em.createQuery(
                "SELECT t FROM VerificationToken t WHERE t.token = :token", VerificationToken.class);
            query.setParameter("token", token);
            List<VerificationToken> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public int deleteExpiredTokens() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int deleted = em.createQuery(
                "DELETE FROM VerificationToken t WHERE t.expiresAt < :now OR t.usedAt IS NOT NULL")
                .setParameter("now", new Date())
                .executeUpdate();
            em.getTransaction().commit();
            return deleted;
        } finally {
            em.close();
        }
    }

    public VerificationToken findValidToken(String token, VerificationTokenType type) {
        if (token == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<VerificationToken> query = em.createQuery(
                "SELECT t FROM VerificationToken t WHERE t.token = :token AND t.type = :type AND t.usedAt IS NULL AND t.expiresAt > :now",
                VerificationToken.class);
            query.setParameter("token", token);
            query.setParameter("type", type);
            query.setParameter("now", new Date());
            List<VerificationToken> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
