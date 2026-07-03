package dao;

import entity.Review;
import java.util.List;
import javax.persistence.EntityManager;
import util.JPAUtil;

public class ReviewDAO extends AbstractDAO<Review, Long> {
    public ReviewDAO() { super(Review.class); }

    public Review findByReservationId(Long reservationId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Review> results = em.createQuery("SELECT r FROM Review r WHERE r.reservation.id = :reservationId", Review.class)
                    .setParameter("reservationId", reservationId)
                    .setMaxResults(1)
                    .getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }

    public List<Review> findByUser(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Review> results = em.createQuery("SELECT r FROM Review r WHERE r.user.id = :userId ORDER BY r.createdAt DESC", Review.class)
                    .setParameter("userId", userId)
                    .getResultList();
            initialize(results);
            return results;
        } finally {
            em.close();
        }
    }

    public List<Review> findAllModeration() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Review> results = em.createQuery("SELECT r FROM Review r ORDER BY r.createdAt DESC", Review.class)
                    .getResultList();
            initialize(results);
            return results;
        } finally {
            em.close();
        }
    }

    private void initialize(List<Review> reviews) {
        for (Review review : reviews) {
            review.getUser().getFullName();
            review.getReservation().getId();
        }
    }
}
