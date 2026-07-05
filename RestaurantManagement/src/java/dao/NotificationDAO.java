package dao;

import entity.Notification;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import util.JPAUtil;

public class NotificationDAO extends AbstractDAO<Notification, Long> {

    public NotificationDAO() { super(Notification.class); }

    public ArrayList<Notification> findByUserId(Long userId, int maxResults) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Notification> query = em.createQuery(
                "SELECT n FROM Notification n WHERE n.user.id = :userId ORDER BY n.createdAt DESC", Notification.class);
            query.setParameter("userId", userId);
            query.setMaxResults(maxResults);
            return new ArrayList<>(query.getResultList());
        } finally {
            em.close();
        }
    }

    public long countUnread(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(n) FROM Notification n WHERE n.user.id = :userId AND n.isRead = false", Long.class);
            query.setParameter("userId", userId);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public boolean markAsRead(Long notificationId, Long userId) {
        return executeInTransaction(em -> {
            Notification n = em.find(Notification.class, notificationId);
            if (n != null && n.getUser().getId().equals(userId)) {
                n.setIsRead(true);
                em.merge(n);
            }
        });
    }

    public int markAllAsRead(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            int updated = em.createQuery(
                "UPDATE Notification n SET n.isRead = true WHERE n.user.id = :userId AND n.isRead = false")
                .setParameter("userId", userId)
                .executeUpdate();
            em.getTransaction().commit();
            return updated;
        } catch (RuntimeException e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
