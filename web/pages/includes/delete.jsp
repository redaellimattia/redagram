<%@include file="connection.jsp" %>
<%
  String idUser = (String) session.getAttribute("idUser");
  String opz = request.getParameter("opz");
  switch(opz)
  {
    case "1": statement.executeUpdate("DELETE FROM user WHERE ID_user = '"+idUser+"'");
              session.setAttribute("online", "false");
              response.sendRedirect("../../index.jsp");
              break;
    case "2": String idPost = request.getParameter("idPost");
              statement.executeUpdate("DELETE FROM post WHERE ID_post = '"+idPost+"'");
              response.sendRedirect("../logged/logged.jsp?page=profile.jsp?user=0");
              break;
  }
%>
