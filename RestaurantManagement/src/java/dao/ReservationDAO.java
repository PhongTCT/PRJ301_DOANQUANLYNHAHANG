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
            java.util.List<Reservation> results = em.createQuery("SELECT r FROM Reservation r WHERE r.user.id = :userId ORDER BY r.reservationDate DESC, r.reservationTime DESC", Reservation.class)
                     .setParameter("userId", userId)
                     .getResultList();
            for (Reservation r : results) {
                em.refresh(r);
                r.getReservationTables().size();
                r.getReservationMenuItems().size();
                r.getReservationAddons().size();
            }
            return results;
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

    public java.util.List<Reservation> findAllWithFilter(java.util.Date date, enums.ReservationStatus status, String phone) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT r FROM Reservation r WHERE 1=1");
            if (date != null) {
                jpql.append(" AND r.reservationDate = :date");
            }
            if (status != null) {
                jpql.append(" AND r.status = :status");
            }
            if (phone != null && !phone.trim().isEmpty()) {
                jpql.append(" AND r.guestPhone LIKE :phone");
            }
            jpql.append(" ORDER BY r.reservationDate DESC, r.reservationTime DESC");

            javax.persistence.TypedQuery<Reservation> query = em.createQuery(jpql.toString(), Reservation.class);
            if (date != null) {
                query.setParameter("date", date);
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            if (phone != null && !phone.trim().isEmpty()) {
                query.setParameter("phone", "%" + phone.trim() + "%");
            }
            java.util.List<Reservation> results = query.getResultList();
            for (Reservation r : results) {
                em.refresh(r);
                r.getReservationTables().size();
                r.getReservationMenuItems().size();
                r.getReservationAddons().size();
            }
            return results;
        } finally {
            em.close();
        }
    }

    public Reservation findByIdWithDetails(Long id) {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            Reservation r = em.find(Reservation.class, id);
            if (r != null) {
                em.refresh(r);
                // Initialize lazy collections
                r.getReservationTables().size();
                r.getReservationMenuItems().size();
                r.getReservationAddons().size();
            }
            return r;
        } finally {
            em.close();
        }
    }

    public java.util.List<Reservation> findNoShowCandidates() {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT r FROM Reservation r WHERE r.status = :status";
            java.util.List<Reservation> allConfirmed = em.createQuery(jpql, Reservation.class)
                     .setParameter("status", enums.ReservationStatus.CONFIRMED)
                     .getResultList();
                     
            java.util.List<Reservation> noShows = new java.util.ArrayList<>();
            java.util.Calendar cal = java.util.Calendar.getInstance();
            int currentHour = cal.get(java.util.Calendar.HOUR_OF_DAY);
            int currentMinute = cal.get(java.util.Calendar.MINUTE);
            int currentTotalMinutes = currentHour * 60 + currentMinute;
            
            java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat("yyyy-MM-dd");
            String todayStr = fmt.format(new java.util.Date());
            
            for (Reservation r : allConfirmed) {
                if (r.getReservationDate() != null && fmt.format(r.getReservationDate()).equals(todayStr)) {
                    if (r.getReservationTime() != null) {
                        cal.setTime(r.getReservationTime());
                        int resHour = cal.get(java.util.Calendar.HOUR_OF_DAY);
                        int resMinute = cal.get(java.util.Calendar.MINUTE);
                        int resTotalMinutes = resHour * 60 + resMinute;
                        
                        if (currentTotalMinutes - resTotalMinutes > 15) {
                            noShows.add(r);
                        }
                    }
                }
            }
            return noShows;
        } finally {
            em.close();
        }
    }

    public java.util.List<Reservation> findPastCheckedInCandidates() {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            String jpql = "SELECT r FROM Reservation r WHERE r.status = :status";
            java.util.List<Reservation> allCheckedIn = em.createQuery(jpql, Reservation.class)
                     .setParameter("status", enums.ReservationStatus.CHECKED_IN)
                     .getResultList();
                     
            java.util.List<Reservation> pastCheckedIn = new java.util.ArrayList<>();
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
            java.util.Date todayMidnight = cal.getTime();
            
            for (Reservation r : allCheckedIn) {
                if (r.getReservationDate() != null && r.getReservationDate().before(todayMidnight)) {
                    pastCheckedIn.add(r);
                }
            }
            return pastCheckedIn;
        } finally {
            em.close();
        }
    }
}
