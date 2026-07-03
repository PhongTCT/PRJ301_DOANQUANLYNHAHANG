<%@page import="dao.ReservationDAO"%>
<%@page import="entity.Reservation"%>
<%@page import="entity.ReservationTable"%>
<%@page import="entity.DiningTable"%>
<%@page import="java.util.List"%>
<%
    try {
        ReservationDAO dao = new ReservationDAO();
        List<Reservation> list = dao.findAllWithFilter(null, null, null);
        out.println("Total: " + list.size() + "<br>");
        for (Reservation res : list) {
            out.println("ID: " + res.getId() + "<br>");
            if (res.getReservationTables() != null) {
                for (ReservationTable rt : res.getReservationTables()) {
                    DiningTable dt = rt.getDiningTable();
                    out.println("Table: " + (dt != null ? dt.getTableNumber() : "null") + ", ");
                    out.println("BasePrice: " + (dt != null ? dt.getBasePrice() : "null") + "<br>");
                }
            }
        }
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage() + "<br>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
