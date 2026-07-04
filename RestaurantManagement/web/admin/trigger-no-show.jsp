<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ReservationDAO"%>
<%@page import="entity.Reservation"%>
<%@page import="enums.ReservationStatus"%>
<%
    javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
    String jpql = "SELECT r FROM Reservation r WHERE r.status = :status";
    java.util.List<Reservation> allConfirmed = em.createQuery(jpql, Reservation.class)
             .setParameter("status", enums.ReservationStatus.CONFIRMED)
             .getResultList();
             
    String jpqlToday = "SELECT r FROM Reservation r WHERE r.status = :status AND r.reservationDate = CURRENT_DATE";
    java.util.List<Reservation> todayConfirmed = em.createQuery(jpqlToday, Reservation.class)
             .setParameter("status", enums.ReservationStatus.CONFIRMED)
             .getResultList();
             
%>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Info</title>
</head>
<body>
    <h2>Debug Info</h2>
    <p>Total CONFIRMED reservations: <%= allConfirmed.size() %></p>
    <ul>
    <% for(Reservation r : allConfirmed) { %>
        <li>ID: <%= r.getId() %> | Date: <%= r.getReservationDate() %> | Time: <%= r.getReservationTime() %></li>
    <% } %>
    </ul>
    
    <p>Today CONFIRMED reservations (CURRENT_DATE filter): <%= todayConfirmed.size() %></p>
    <ul>
    <% for(Reservation r : todayConfirmed) { %>
        <li>ID: <%= r.getId() %> | Date: <%= r.getReservationDate() %> | Time: <%= r.getReservationTime() %></li>
    <% } %>
    </ul>
</body>
</html>
