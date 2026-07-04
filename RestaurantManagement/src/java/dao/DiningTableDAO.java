package dao;

import entity.DiningTable;
import util.JPAUtil;
import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.TemporalType;
import javax.persistence.TypedQuery;

public class DiningTableDAO extends AbstractDAO<DiningTable, Integer> {

    public DiningTableDAO() {
        super(DiningTable.class);
    }

    @Override
    public ArrayList<DiningTable> ListAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<DiningTable> query = em.createQuery(
                    "SELECT d FROM DiningTable d WHERE d.isActive = true ORDER BY d.room.roomName, d.tableCode",
                    DiningTable.class);
            return new ArrayList<>(query.getResultList());
        } finally {
            em.close();
        }
    }

    public ArrayList<DiningTable> getTablesByStatus(enums.TableStatus status) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<DiningTable> query = em.createQuery(
                    "SELECT d FROM DiningTable d WHERE d.isActive = true AND d.status = :status ORDER BY d.room.roomName, d.tableCode",
                    DiningTable.class);
            query.setParameter("status", status);
            return new ArrayList<>(query.getResultList());
        } finally {
            em.close();
        }
    }

    public ArrayList<DiningTable> findAvailableTables(java.util.Date reservationDate, java.sql.Time reservationTime, int totalGuests) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT d FROM DiningTable d WHERE d.isActive = true " +
                          "AND d.capacity >= :totalGuests " +
                          "AND d.id NOT IN (" +
                          "  SELECT rt.diningTable.id FROM ReservationTable rt " +
                          "  WHERE rt.reservation.reservationDate = :rDate " +
                          "  AND rt.reservation.reservationTime = :rTime " +
                          "  AND rt.reservation.status IN (enums.ReservationStatus.PENDING, enums.ReservationStatus.CONFIRMED, enums.ReservationStatus.CHECKED_IN) " +
                          ") ORDER BY d.room.roomName, d.tableCode";
            TypedQuery<DiningTable> query = em.createQuery(jpql, DiningTable.class);
            query.setParameter("rDate", reservationDate, TemporalType.DATE);
            query.setParameter("rTime", reservationTime, TemporalType.TIME);
            query.setParameter("totalGuests", totalGuests);
            return new ArrayList<>(query.getResultList());
        } finally {
            em.close();
        }
    }

    public ArrayList<DiningTable> findAllForAdmin() {
        return super.ListAll();
    }
}
