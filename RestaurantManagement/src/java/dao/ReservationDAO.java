package dao;

import entity.Reservation;

public class ReservationDAO extends AbstractDAO<Reservation, Long> {
    public ReservationDAO() { super(Reservation.class); }

    public java.util.List<Reservation> findByDateAndStatus(java.util.Date date, enums.ReservationStatus status) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT r FROM Reservation r WHERE r.reservationDate = :date";
            if (status != null) {
                jpql += " AND r.status = :status";
            }
            jpql += " ORDER BY r.reservationTime ASC";
            
            javax.persistence.TypedQuery<Reservation> query = em.createQuery(jpql, Reservation.class).setParameter("date", date);
            if (status != null) {
                query.setParameter("status", status);
            }
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public java.util.List<Reservation> findByUserId(Long userId) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT r FROM Reservation r WHERE r.user.id = :userId ORDER BY r.reservationDate DESC, r.reservationTime DESC", Reservation.class)
                     .setParameter("userId", userId)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public java.util.List<Reservation> findNoShowsByTimeThreshold(java.util.Date threshold) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT r FROM Reservation r WHERE r.status = :status AND r.reservationDate <= CURRENT_DATE AND r.reservationTime < :threshold", Reservation.class)
                     .setParameter("status", enums.ReservationStatus.PENDING)
                     .setParameter("threshold", new java.sql.Time(threshold.getTime()))
                     .getResultList();
        } finally {
            em.close();
        }
    }
}
