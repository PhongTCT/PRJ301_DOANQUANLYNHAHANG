package dao;

import entity.Reservation;

public class ReservationDAO extends AbstractDAO<Reservation, Long> {
    public ReservationDAO() { super(Reservation.class); }
}
