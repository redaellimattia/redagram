<%@include file="connection.jsp" %>
<%
String idUser = (String) session.getAttribute("idUser");
String idPost = request.getParameter("post");
ResultSet rs= null;
rs=statement.executeQuery("SELECT * FROM likes WHERE id_user='"+idUser+"' AND id_post='"+idPost+"'");
if(rs.next())
{
  out.println("1,");//cancello
  statement.executeUpdate("DELETE FROM likes WHERE id_user='"+idUser+"' AND id_post='"+idPost+"'");
}
else
{
  out.println("2,");//aggiungo
  statement.executeUpdate("INSERT INTO likes (id_user,id_post,data) VALUES ('"+idUser+"','"+idPost+"',NOW())",Statement.RETURN_GENERATED_KEYS);
  int idLikeMax = 0;
  ResultSet rs2,rs3;
  rs2 = statement.getGeneratedKeys();
  if (rs2.next())
    idLikeMax=rs2.getInt(1);
  rs3 = statement.executeQuery("SELECT * FROM post WHERE ID_post = '"+idPost+"' AND id_user = '"+idUser+"'");
  Statement statement2 = conn.createStatement();
  if(!rs3.next())
    statement2.executeUpdate("INSERT INTO notifiche (id_like) VALUES ('"+idLikeMax+"')");
}
  out.println(idPost);
//response.sendRedirect("../logged/logged.jsp?page=home.jsp");
%>
