<%@include file="connection.jsp" %>
<%
  String opz = request.getParameter("opz");
  String idUser = (String) session.getAttribute("idUser");
  switch(opz)
  {
    case "1": String idNotifica = request.getParameter("idNotifica");
              statement.executeUpdate("UPDATE notifiche SET visualizzato = '1' WHERE ID_notifica = '"+idNotifica+"'");
              break;
    case "2": ResultSet rs;
              String query =  "SELECT R.*,N.id_commento "+
                              "FROM (SELECT N.ID_notifica, U.username, P.ID_post, P.img, N.data as dataDesc, 'commento' AS tipo "+
                              "FROM notifiche N INNER JOIN comment C ON C.ID_comment = N.id_commento "+
                                               "INNER JOIN user U ON U.ID_user = C.id_user "+
                                               "INNER JOIN post P ON P.ID_post = C.id_post "+
                              "WHERE N.visualizzato=0 AND P.id_user = '"+idUser+"' "+
                              "UNION "+
                              "SELECT  N.ID_notifica, U.username, P.ID_post, P.img, N.data as dataDesc, 'tag' AS tipo "+
                              "FROM notifiche N INNER JOIN tag T ON T.ID_tag = N.id_tag "+
                                               "INNER JOIN user U ON U.ID_user = T.id_user_tagging "+
                                               "INNER JOIN post P ON P.ID_post = T.id_post "+
                              "WHERE N.visualizzato=0 AND T.id_user_tagged = '"+idUser+"' "+
                              "UNION "+
                              "SELECT  N.ID_notifica, U.username, P.ID_post, P.img, N.data as dataDesc, 'like' AS tipo "+
                              "FROM notifiche N INNER JOIN likes L ON L.ID_like = N.id_like "+
                                               "INNER JOIN user U ON U.ID_user = L.id_user "+
                                               "INNER JOIN post P ON P.ID_post = L.id_post "+
                              "WHERE N.visualizzato=0 AND P.id_user = '"+idUser+"' "+
                              "UNION "+
                              "SELECT N.ID_notifica, U.username, null, null, N.data as dataDesc, 'follow' AS tipo "+
                              "FROM notifiche N INNER JOIN follower F ON F.ID_follower = N.id_follower "+
                                               "INNER JOIN user U ON U.ID_user = F.id_user_follower "+
                              "WHERE N.visualizzato=0 AND id_user_profile = '"+idUser+"') "+
                              "R INNER JOIN notifiche N ON R.ID_notifica = N.ID_notifica "+
                              "ORDER BY dataDesc DESC LIMIT 5";
                              rs=statement.executeQuery(query);
                              while(rs.next())
                              {
                                String tipo = rs.getString("tipo");
                                switch(tipo)
                                {
                                  case "commento": out.print("<a class=\"dropdown-item notifica\" id=\"n-"+rs.getString("ID_notifica")+"\" data-whatever=\"f-"+rs.getString("ID_post")+"\" data-toggle=\"modal\" data-target=\"#modalPost\" href=\"\"><b>"+rs.getString("username")+"</b> ha commentato il tuo post: <img src=\""+rs.getString("img")+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\"></a>");
                                                  break;
                                  case "tag": out.print("<a class=\"dropdown-item notifica\" id=\"n-"+rs.getString("ID_notifica")+"\" data-whatever=\"f-"+rs.getString("ID_post")+"\" data-toggle=\"modal\" data-target=\"#modalPost\" href=\"\"><b>"+rs.getString("username")+"</b> ti ha taggato nel post: <img src=\""+rs.getString("img")+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\"></a>");
                                              break;
                                  case "like": out.print("<a class=\"dropdown-item notifica\" id=\"n-"+rs.getString("ID_notifica")+"\" data-whatever=\"f-"+rs.getString("ID_post")+"\" data-toggle=\"modal\" data-target=\"#modalPost\" href=\"\"><b>"+rs.getString("username")+"</b> ha messo mi piace al tuo post: <img src=\""+rs.getString("img")+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\"></a>");
                                              break;
                                  case "follow": out.print("<a class=\"dropdown-item notifica\" id=\"n-"+rs.getString("ID_notifica")+"\" href=\"logged.jsp?page=profile.jsp?user="+rs.getString("username")+"\"><b>"+rs.getString("username")+"</b> ha incominciato a seguirti</a>");
                                                break;
                                }
                              }
                              out.print("<a class=\"dropdown-item\" href=\"logged.jsp?page=notifiche.jsp\"><b>Tutte le notifiche...</b></a>");
                              break;
  }
%>
