package dao;

import entity.ReservationAddon;

public class ReservationAddonDAO extends AbstractDAO<ReservationAddon, Long> {
    public ReservationAddonDAO() { super(ReservationAddon.class); }

    public java.util.List<ReservationAddon> findByReservationId(Long reservationId) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT ra FROM ReservationAddon ra WHERE ra.reservation.id = :reservationId", ReservationAddon.class)
                     .setParameter("reservationId", reservationId)
                     .getResultList();
        } finally {
            em.close();
        }
    }
}
