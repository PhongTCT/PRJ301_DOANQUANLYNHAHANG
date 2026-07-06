<%@page import="dao.MenuSetDAO,entity.MenuSet,java.util.List" %>
<%
    MenuSetDAO dao = new MenuSetDAO();
    List<MenuSet> sets = dao.findActiveSets();
    for (MenuSet s : sets) {
        out.println(s.getId() + " | EN (setName): " + s.getSetName() + " | VI (setNameVi): " + s.getSetNameVi() + "<br>");
    }
%>
