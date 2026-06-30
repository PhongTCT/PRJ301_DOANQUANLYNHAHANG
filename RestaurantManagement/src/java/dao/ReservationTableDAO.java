package dao;

import entity.ReservationTable;

public class ReservationTableDAO extends AbstractDAO<ReservationTable, Long> {
    public ReservationTableDAO() { super(ReservationTable.class); }

    public java.util.List<ReservationTable> findByReservationId(Long reservationId) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT rt FROM ReservationTable rt WHERE rt.reservation.id = :reservationId", ReservationTable.class)
                     .setParameter("reservationId", reservationId)
                     .getResultList();
        } finally {
            em.close();
        }
    }
}
