<%@include file="connection.jsp" %>
<%
  String id = request.getParameter("id");
  String opz = request.getParameter("opz");
  String user = request.getParameter("user");
  String idUser = (String) session.getAttribute("idUser");
  switch(opz)
  {
    case "1": //Segui
              statement.executeUpdate("INSERT INTO follower (id_user_profile,id_user_follower) values ('"+id+"','"+idUser+"')",Statement.RETURN_GENERATED_KEYS);
              int idFollowerMax = 0;
              ResultSet rs;
              rs = statement.getGeneratedKeys();
              if (rs.next())
                idFollowerMax=rs.getInt(1);
              statement.executeUpdate("INSERT INTO following (id_user_profile,id_user_following) values ('"+idUser+"','"+id+"')");
              statement.executeUpdate("INSERT INTO notifiche (id_follower) VALUES ('"+idFollowerMax+"')");
              break;
    case "2": //Smetti di seguire
              statement.executeUpdate("DELETE FROM follower WHERE id_user_profile = '"+id+"' AND id_user_follower ='"+idUser+"'");
              statement.executeUpdate("DELETE FROM following WHERE id_user_profile = '"+idUser+"' AND id_user_following ='"+id+"'");
              break;
  }
  response.sendRedirect("../logged/logged.jsp?page=profile.jsp?user="+user);
%>
