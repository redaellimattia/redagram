<%@include file="connection.jsp" %>
<%@page import="java.util.ArrayList" %>
<%
String opz = request.getParameter("opz");
String idPost = request.getParameter("idPost");
String idUser = (String) session.getAttribute("idUser");
ResultSet rs= null;
switch(opz)
{
  case "1":rs = statement.executeQuery("SELECT U.username,U.img_profilo "+
                              "FROM likes L INNER JOIN post P ON P.ID_post = L.id_post "+
                                           "INNER JOIN user U ON L.id_user = U.ID_user "+
                              "WHERE L.id_post = '"+idPost+"'");
            while(rs.next())
            {
                out.print("<a class=\"navbar-brand\" style=\"color:black; text-decoration: none;\" href=\"logged.jsp?page=profile.jsp?user="+rs.getString("username")+"\"><li class=\"list-group-item\"><img src=\""+rs.getString("img_profilo")+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\">");
                out.print("   "+rs.getString("username")+"</li></a>");
            }
            break;
  case "2":rs = statement.executeQuery("SELECT U.username,C.comment,C.data,U.img_profilo "+
                              "FROM comment C INNER JOIN post P ON P.ID_post = C.id_post "+
                                           "INNER JOIN user U ON C.id_user = U.ID_user "+
                              "WHERE C.id_post = '"+idPost+"'");
            while(rs.next())
            {
              out.print("<p><a class=\"navbar-brand\" style=\"color:black; font-weight:bold; text-decoration: none;\" href=\"logged.jsp?page=profile.jsp?user="+rs.getString("username")+"\"><li class=\"list-group-item\"><img src=\""+rs.getString("img_profilo")+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\">");
              out.print(rs.getString("username")+": </a>"+rs.getString("comment")+"</li></p>");
            }
            break;
  case "3": String commento = request.getParameter("comment");
            String sql = "INSERT INTO comment (id_user, id_post, comment, data) VALUES (?,?,?,NOW())";
            PreparedStatement prpstm = null;
            prpstm = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            prpstm.setString(1, idUser);
            prpstm.setString(2, idPost);
            prpstm.setString(3, commento);
            ResultSet rs3,rs4=null;
            int idCommentMax = 0;
            prpstm.executeUpdate();
            rs4 = prpstm.getGeneratedKeys();
            if (rs4.next())
              idCommentMax=rs4.getInt(1);
            rs3 = statement.executeQuery("SELECT * FROM post WHERE ID_post = '"+idPost+"' AND id_user = '"+idUser+"'");
            Statement statement3 = conn.createStatement();
            if(!rs3.next())
              statement3.executeUpdate("INSERT INTO notifiche (id_commento) VALUES ('"+idCommentMax+"')");
            out.print("");
            break;
  case "4": rs = statement.executeQuery("SELECT P.description, P.id_user, P.location, P.img, U.username, DATE_FORMAT(P.data,'%d/%m/%Y') AS dateFormatted, COUNT(L.ID_like) as totale "+
                                         "FROM post P LEFT JOIN comment C ON C.id_post = P.ID_post "+
                                         "LEFT JOIN likes L ON P.ID_post = L.id_post "+
                                         "INNER JOIN user U ON P.id_user = U.ID_user "+
                                         "WHERE P.ID_post = '"+idPost+"' "+
                                         "GROUP BY P.ID_post");
            if(rs.next())
            {
              out.print("<a href=\"../logged/logged.jsp?page=profile.jsp?user="+rs.getString("username")+"\" class=\"card-link text-dark\"><h5 class=\"card-title\">"+rs.getString("username")+"</h5></a>");
              out.println("<h6 class=\"card-subtitle mb-2 text-muted\">"+rs.getString("location")+"");
              if(idUser.equals(rs.getString("id_user")))
                out.print("<a id=\"deletePost\" style=\"float:right; font-size=1.3em; color:black; margin-bottom: 2%;\" href=\"../includes/delete.jsp?opz=2&idPost="+idPost+"\" title=\"Elimina Post\"><span class=\"oi oi-trash\"></span></a></h6>");
              else
                out.print("</h6>");
              out.println("<img class=\"card-img-top rounded img-responsive\" style=\"max-height: 450px;\" src=\""+rs.getString("img")+"\"><br><br>");
              out.println("<a href=\"\" data-toggle=\"modal\" data-target=\"#modalLike\" id=\"m-"+idPost+"\" class=\"badge badge-danger badge-pill likes\">"+rs.getString("totale")+" Likes</a><br>");
              Statement statement2 = conn.createStatement();
              ResultSet rs2;
              rs2=statement2.executeQuery("SELECT * FROM likes WHERE id_post = '"+idPost+"' AND id_user = '"+idUser+"'");
              if(rs2.next())
                out.println("<a class=\"red-like like-href\" id=\"a-"+idPost+"\" title=\"Like\"><span id=\""+idPost+"\" class=\"oi oi-heart\"></span></a>");
              else
                out.println("<a class=\"black-like like-href\" id=\"a-"+idPost+"\" title=\"Like\"><span id=\""+idPost+"\" class=\"oi oi-heart\"></span></a>");
              out.println("<a class=\"black-comment comment-href\" id=\"c-"+idPost+"\" title=\"Commento\" data-toggle=\"modal\" data-target=\"#modalCommento\"><span id=\""+idPost+"\" class=\"oi oi-comment-square\"></span></a>");
              out.print("<p class=\"card-text\">");
              String desc = rs.getString("description");
              ArrayList<String> output = new ArrayList<String>();
              int start = 0;
              String str = "";
              boolean ctrl = false;
              desc += " ";
              for(int i=0; i<desc.length();i++) //for ricerca caratteri
              {
                  if(desc.charAt(i)=='@'||desc.charAt(i)=='#'&&!ctrl)
                  {
                    if(!str.equals(""))
                    {
                      output.add(str);
                      str = "";
                    }
                    start = i;
                    ctrl = true;
                  }
                  else if(desc.charAt(i)==' '&&ctrl)
                  {
                    output.add(desc.substring(start,i));
                    start = i;
                    ctrl = false;
                  }
                  else if(desc.charAt(i)!='@'&&desc.charAt(i)!='#'&&!ctrl)
                    str += ""+desc.charAt(i);
              }
              if(!str.equals(""))
                output.add(str);
              for(int i=0; i<output.size();i++) //for di stampa
              {
                String tag= "", link = "";
                if(output.get(i).indexOf("@")!=-1)
                {
                  tag = output.get(i);
                  link = tag.replace("@","");
                  out.print("<a class=\"list-inline text-center\" href=\"logged.jsp?page=profile.jsp?user="+link+"\" style=\"font-weight:bold; text-decoration: none; font-size:1.1em;\"> "+tag+"</a>");

                }
                else if(output.get(i).indexOf("#")!=-1)
                {
                  tag = output.get(i);
                  link = tag.replace("#","");
                  out.print("<a class=\"list-inline text-center\" href=\"logged.jsp?page=hashtag.jsp?hashtag="+link+"\" style=\"font-weight:bold; text-decoration: none; font-size:1.1em;\"> "+tag+"</a>");
                }
                else
                {
                  String text = output.get(i);
                  out.print(" "+text);
                }
              }
              out.print("</p>");
              out.println("<p class=\"card-text text-right font-italic\">"+rs.getString("dateFormatted")+"</p>");
            }
            break;
}
%>
