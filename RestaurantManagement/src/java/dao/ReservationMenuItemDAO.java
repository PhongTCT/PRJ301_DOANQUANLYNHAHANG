package dao;

import entity.ReservationMenuItem;

public class ReservationMenuItemDAO extends AbstractDAO<ReservationMenuItem, Long> {
    public ReservationMenuItemDAO() { super(ReservationMenuItem.class); }

    public java.util.List<ReservationMenuItem> findByReservationId(Long reservationId) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT rm FROM ReservationMenuItem rm WHERE rm.reservation.id = :reservationId", ReservationMenuItem.class)
                     .setParameter("reservationId", reservationId)
                     .getResultList();
        } finally {
            em.close();
        }
    }
}
