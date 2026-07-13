<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.ReservationDAO"%>
<%@page import="entity.Reservation"%>
<%@page import="enums.ReservationStatus"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
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
    <title><fmt:message key="admin.triggernoshow.title"/></title>
</head>
<body>
    <h2><fmt:message key="admin.triggernoshow.title"/></h2>
    <p><fmt:message key="admin.triggernoshow.confirmed"/> <%= allConfirmed.size() %></p>
    <ul>
    <% for(Reservation r : allConfirmed) { %>
        <li>ID: <%= r.getId() %> | Date: <%= r.getReservationDate() %> | Time: <%= r.getReservationTime() %></li>
    <% } %>
    </ul>
    
    <p><fmt:message key="admin.triggernoshow.today"/> <%= todayConfirmed.size() %></p>
    <ul>
    <% for(Reservation r : todayConfirmed) { %>
        <li>ID: <%= r.getId() %> | Date: <%= r.getReservationDate() %> | Time: <%= r.getReservationTime() %></li>
    <% } %>
    </ul>
</body>
</html>
