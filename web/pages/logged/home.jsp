<%@include file="../includes/connection.jsp" %>
<%@page import="java.util.ArrayList" %>
<%
  ResultSet rs = null;
  String idUser = (String) session.getAttribute("idUser");
  String username="", nome="", cognome="", pathImgProfilo="", userPost="";
  rs = statement.executeQuery("SELECT username,nome,cognome,img_profilo FROM user WHERE ID_user = '"+idUser+"'");
  if(rs.next()) //Query per poi stampare valori username, img...
  {
      username = rs.getString("username");
      nome = rs.getString("nome");
      cognome = rs.getString("cognome");
      pathImgProfilo = rs.getString("img_profilo");
  }
%>
<html>
  <div class="row">
    <div class="aside-left"> <!--Stampa a sinistra-->
      <figure class="figure ">
        <div class="profile-img-container">
          <%
          out.print("<img src=\""+pathImgProfilo+"\" class=\"figure-img img-fluid rounded-circle img-center img-responsive\" style=\"max-height:450px;\" title=\"Immagine profilo\">");%>
          <a id="changeImg" href="logged.jsp?page=profile.jsp?user=0" title="Visita Profilo"><span class="oi oi-eye"></span></a>
        </div>
        <a class="list-inline text-center" href="logged.jsp?page=profile.jsp?user=0" style="color:black; font-weight:bold; text-decoration: none; font-size:1.3em;"><%=username%></a>
        <ul class="list-inline text-center mt-3">
          <li class="list-inline-item" ><%=nome%></li>
          <li class="list-inline-item"><%=cognome%></li>
        </ul>
        <ul class="list-group">
          <li class="list-group-item d-flex justify-content-between align-items-center">
            Followers
            <%
              String followers = "";
              ArrayList<String> follower = new ArrayList<String>();
              ArrayList<String> image = new ArrayList<String>();
              ArrayList<String> following = new ArrayList<String>();
              ArrayList<String> image2 = new ArrayList<String>();
              rs = statement.executeQuery("SELECT COUNT(ID_follower) AS totale FROM follower WHERE id_user_profile = '"+idUser+"'");
              if(rs.next()) //Query con followers
                followers = rs.getString("totale");
              rs = statement.executeQuery("SELECT U.username,U.img_profilo FROM follower F INNER JOIN user U ON U.ID_user = F.id_user_follower WHERE F.id_user_profile = '"+idUser+"'");
              while(rs.next()) //Aggiungo i followers al vettore dinamico
              {
                follower.add(rs.getString("U.username"));
                image.add(rs.getString("U.img_profilo"));
              }
            %>
            <a href="" data-toggle="modal" data-target="#modalFollower" class="badge badge-primary badge-pill"><%=followers%></a>
          </li>
          <li class="list-group-item d-flex justify-content-between align-items-center">
            Following
            <%
              String followings = "";
              rs = statement.executeQuery("SELECT COUNT(ID_following) AS totale FROM following WHERE id_user_profile = '"+idUser+"'");
              if(rs.next())
                followings = rs.getString("totale");
              rs = statement.executeQuery("SELECT U.username,U.img_profilo FROM following F INNER JOIN user U ON U.ID_user = F.id_user_following WHERE F.id_user_profile = '"+idUser+"'");
              while(rs.next())
              {
                following.add(rs.getString("U.username"));
                image2.add(rs.getString("U.img_profilo"));
              }
            %>
            <a href="" data-toggle="modal" data-target="#modalFollowing" class="badge badge-primary badge-pill"><%=followings%></a>
          </li>
      </ul>
      </figure>
    </div>
    <div class="center" style="overflow-y: auto;">
      <%
        rs=statement.executeQuery("SELECT P.ID_post, U.username, P.description, P.location, P.img, P.data, DATE_FORMAT(P.data,'%d/%m/%Y') AS dateFormatted, COUNT(L.ID_like) AS totale "+
                                  "FROM post P INNER JOIN following F ON F.id_user_following = P.id_user "+
                                              "INNER JOIN user U ON U.ID_user=P.id_user "+
                                              "LEFT JOIN likes L ON L.id_post=P.ID_post "+
                                  "WHERE F.id_user_profile = '"+idUser+"' "+
                                  "GROUP BY P.ID_post "+
                                  "UNION "+
                                  "SELECT P.ID_post, U.username, P.description, P.location, P.img, P.data, DATE_FORMAT(P.data,'%d/%m/%Y') AS dateFormatted, COUNT(L.ID_like) AS totale "+
                                  "FROM post P INNER JOIN user U ON P.id_user = U.ID_user "+
                                  "LEFT JOIN likes L ON L.id_post=P.ID_post "+
                                  "WHERE U.ID_user = '"+idUser+"'"+
                                  "GROUP BY P.ID_post "+
                                  "ORDER BY data DESC");
        String desc = "", location = "", img = "", data = "",idPost = "", totale="";
        if(rs.next()) //Caso in cui ci siano dei post da visualizzare
        {
          rs.beforeFirst();
          while(rs.next())
          {
            desc = rs.getString("description");
            location = rs.getString("location");
            img = rs.getString("img");
            data = rs.getString("dateFormatted");
            userPost = rs.getString("username");
            idPost=rs.getString("ID_post");
            totale = rs.getString("totale");
            %>
            <div class="w-75">
                <a href="logged.jsp?page=profile.jsp?user=<%=userPost%>" class="card-link text-dark"><h5 class="card-title"><%=userPost%></h5></a>
                <h6 class="card-subtitle mb-2 text-muted"><%=location%></h6>
                <%out.print("<img class=\"card-img-top rounded img-responsive\" style=\"max-height: 600px;\" src=\""+img+"\">");%>
                <br>
                <br>
                <a href="" data-toggle="modal" data-target="#modalLike" id="m-<%=idPost%>" class="badge badge-danger badge-pill likes"><%=totale%> Likes</a>
                <br>
                  <%
                      Statement statement2 = conn.createStatement();
                      ResultSet rs2;
                      rs2=statement2.executeQuery("SELECT * FROM likes WHERE id_post = '"+idPost+"' AND id_user = '"+idUser+"'");
                      if(rs2.next()) //Caso in cui l'utente abbia gia messo like
                      {
                        %>
                        <a class="red-like like-href" id="a-<%=idPost%>" title="Like"><span id="<%=idPost%>" class="oi oi-heart"></span></a>
                        <%
                      }
                      else //Caso in cui l'utente non abbia ancora messo like
                      {
                        %>
                        <a class="black-like like-href" id="a-<%=idPost%>" title="Like"><span id="<%=idPost%>" class="oi oi-heart"></span></a>
                    <%}%>
                    <a class="black-comment comment-href" id="c-<%=idPost%>" title="Commento" data-toggle="modal" data-target="#modalCommento"><span id="<%=idPost%>" class="oi oi-comment-square"></span></a>
                <p class="card-text">
                  <%
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
                    if(output.get(i).indexOf("@")!=-1) //Stampo un tag cliccabile
                    {
                      String tag = output.get(i);
                      String link = tag.replace("@","");
                      %>
                      <a class="list-inline text-center" href="logged.jsp?page=profile.jsp?user=<%=link%>" style="font-weight:bold; text-decoration: none; font-size:1.1em;"><%=tag%></a>
                      <%
                    }
                    else if(output.get(i).indexOf("#")!=-1) //Stampo un hashtag cliccabile
                    {
                      String tag = output.get(i);
                      String link = tag.replace("#","");
                      %>
                      <a class="list-inline text-center" href="logged.jsp?page=hashtag.jsp?hashtag=<%=link%>" style="font-weight:bold; text-decoration: none; font-size:1.1em;"><%=tag%></a>
                      <%
                    }
                    else //Stampo caratteri normali
                    {
                      String text = output.get(i);
                      %>
                      <%=text%>
                      <%
                    }
                  }
                  %>
                  </p>
                <p class="card-text text-right font-italic"><%=data%></p>
                <hr class="my-4">
            </div>
            <%
          }
          %>
      </div>
      <%
    }
    else //Caso in cui non ci siano post da visualizzare
    {
      %>
      <div class="container text-center p-0">
        <a class="display-4 list-inline text-center">Ancora non hai nessun post da visualizzare</a>
        <br>
        <a class="display-4 list-inline text-center">Controlla le tendenze:      <a href="logged.jsp?page=tendenze.jsp" class="display-4" style="color:black; font-weight:bold; text-decoration: none; "><span class="oi oi-fire"></a></span></a>
      </div>
      <%
    }
    %>
  </div>
  <div class="modal fade" id="modalFollower" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Follower</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <ul class="list-group">
          <%
            for(int i=0; i<follower.size(); i++)
            {
              out.print("<a class=\"navbar-brand\" style=\"color:black; text-decoration: none;\" href=\"logged.jsp?page=profile.jsp?user="+follower.get(i)+"\"><li class=\"list-group-item\"><img src=\""+image.get(i)+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\">");
              out.print("   "+follower.get(i)+"</li></a>");
            }
          %>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="modalFollowing" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
<div class="modal-dialog" role="document">
  <div class="modal-content">
    <div class="modal-header">
      <h5 class="modal-title" id="exampleModalLongTitle">Following</h5>
      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body">
      <ul class="list-group">
        <%
          for(int i=0; i<following.size(); i++)
          {
            out.print("<a class=\"navbar-brand\" style=\"color:black; text-decoration: none;\" href=\"logged.jsp?page=profile.jsp?user="+following.get(i)+"\"><li class=\"list-group-item\"><img src=\""+image2.get(i)+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\">");
            out.print("   "+following.get(i)+"</li></a>");
          }
        %>
      </ul>
    </div>
  </div>
</div>
</div>
<div class="modal fade" id="modalUpload" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Nuovo Post</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form action="../includes/upload.jsp?opz=1" method="post" enctype="multipart/form-data">
          <figure class="figure text-center">
            <div class="profile-img-container w-50">
              <%
              out.print("<img src=\"../../../mediaSaved/noimagefound.jpg\" id=\"output\" class=\"img-fluid rounded img-center img-responsive\" title=\"Immagine\">");%>
              <a href="javascript:void(0)" onclick="test();" id="changeImg" title="Cambia Immagine"><span class="oi oi-image"></span></a>
            </div>
            <input type="file" accept=".png, .jpg, .jpeg, .gif" name="file" class="custom-file-input" id="custom-file" onchange="loadFile(event)" required/>
          <ul class="list-inline text-center">
            <textarea data-toggle="popover" data-trigger="focus" data-placement="left" title="Puoi taggare persone o creare hashtag!" data-content="Esempio: @profile, #hashtag" type="text" class="form-control mt-3" id="textAreaDesc" placeholder="Descrizione" name="desc" rows="2"></textarea>
            <script>
              $(document).ready(function () {
                  $('#textAreaDesc').popover();
              });
            </script>
          </ul>
          <ul class="list-inline text-center mt-3">
            <input type="text" class="form-control mt-3" placeholder="Location" name="location"></input>
          </ul>
        </figure>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Annulla</button>
        <input type="submit" value="Conferma" class="btn btn-primary">
        </form>
        </div>
      </div>
    </div>
  </div>
  </div>
</html>
