<%@include file="../includes/connection.jsp" %>
<%@include file="../includes/head.jsp" %>
<%@page import="java.util.ArrayList" %>
<link href="../../css/signUp.css" rel="stylesheet">
<%
  ResultSet rs = null;
  String idUser = (String) session.getAttribute("idUser");
  String user = request.getParameter("user");
  ArrayList<String> follower = new ArrayList<String>();
  ArrayList<String> image = new ArrayList<String>();
  ArrayList<String> following = new ArrayList<String>();
  ArrayList<String> image2 = new ArrayList<String>();
  rs = statement.executeQuery("SELECT ID_user FROM user WHERE username = '"+user+"'");
  int opz = 0; //opz = 1 profilo proprio, opz = 2 sto visitando un profilo, opz = 3 il profilo non esiste
  String id = "";
  if(!rs.next()) //Caso in cui stia visitando il proprio profilo
  {
      if(user.equals("0")) //Proprio profilo
      {
        opz = 1;
        id = idUser;
      }
      else //Profilo non esistente
        opz = 3;
  }
  else
  {
    id = rs.getString("ID_user");
    if(id.equals(idUser)) //Proprio profilo
      opz = 1;
    else //Profilo altrui
      opz = 2;
  }


  String username="", nome="", cognome="", pathImgProfilo="";
  if(opz!=3) //Caso in cui il profilo esista
  {
    rs = statement.executeQuery("SELECT username,nome,cognome,img_profilo FROM user WHERE ID_user = '"+id+"'");
    if(rs.next())
    {
        username = rs.getString("username");
        nome = rs.getString("nome");
        cognome = rs.getString("cognome");
        pathImgProfilo = rs.getString("img_profilo");
    }
  }

%>
<html>
  <%
    if(opz!=3) //Caso in cui il profilo esista
    {%>
    <div class="row">
      <div class="aside-left2">
        <figure class="figure ml-5">
          <div class="profile-img-container">
            <%
            out.print("<img src=\""+pathImgProfilo+"\" class=\"figure-img img-fluid rounded-circle img-center img-responsive\" style=\"max-height:450px;\" title=\"Immagine profilo\">");
            if(opz == 1)
            {
            %>
            <a id="changeImg" href="logged.jsp?page=modify.jsp?errUser=2&errMail=3" title="Modifica Profilo"><span class="oi oi-wrench"></span></a>
            <%}%>
          </div>
          <h3 class="list-inline text-center"><%=username%></h3>
          <ul class="list-inline text-center mt-3">
            <li class="list-inline-item"><%=nome%></li>
            <li class="list-inline-item"><%=cognome%></li>
          </ul>
          <ul class="list-group">
            <li class="list-group-item d-flex justify-content-between align-items-center">
              Followers
              <%
                String followers = "";
                rs = statement.executeQuery("SELECT COUNT(ID_follower) AS totale FROM follower WHERE id_user_profile = '"+id+"'");
                if(rs.next())
                  followers = rs.getString("totale");
                rs = statement.executeQuery("SELECT U.username,U.img_profilo FROM follower F INNER JOIN user U ON U.ID_user = F.id_user_follower WHERE F.id_user_profile = '"+id+"'");
                while(rs.next())
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
                rs = statement.executeQuery("SELECT COUNT(ID_following) AS totale FROM following WHERE id_user_profile = '"+id+"'");
                if(rs.next())
                  followings = rs.getString("totale");
                rs = statement.executeQuery("SELECT U.username,U.img_profilo FROM following F INNER JOIN user U ON U.ID_user = F.id_user_following WHERE F.id_user_profile = '"+id+"'");
                while(rs.next())
                {
                  following.add(rs.getString("U.username"));
                  image2.add(rs.getString("U.img_profilo"));
                }
              %>
              <a href="" data-toggle="modal" data-target="#modalFollowing" class="badge badge-primary badge-pill"><%=followings%></a>
            </li>
        </ul>
        <% if(opz == 2){%>
        <ul class="list-group mt-3">
          <li class="list-inline-item">
            <% rs = statement.executeQuery("SELECT * FROM following WHERE id_user_profile	 = '"+idUser+"' AND id_user_following	= '"+id+"'");
               if(rs.next())
               {%>
               <button onclick="window.location.href='../includes/follow.jsp?opz=2&user=<%=username%>&id=<%=id%>'" class="btn btn-danger" type="submit">Smetti di seguire</button>
               <%}
               else
               {%>
            <button onclick="window.location.href='../includes/follow.jsp?opz=1&user=<%=username%>&id=<%=id%>'" class="btn btn-success" type="submit">Segui</button>
            <%}%>
          </li>
        </ul>
        <%}%>
        </figure>
      </div>
      <div class="center2" style="overflow-y: auto;">
        <table style="border-spacing:100px;">

        <%
          int cont = 0;
          rs=statement.executeQuery("SELECT id_user, description, location, img, data,ID_post FROM post WHERE id_user = '"+id+"' ORDER BY data DESC");
          String desc = "", location = "", img = "", data = "", idPost="";
          if(rs.next())
          {
            rs.beforeFirst();
            while(rs.next())
            {

              if(cont%3==0)
              {
                out.print("<tr>");
                cont=0;
              }
              img = rs.getString("img");
              idPost = rs.getString("ID_post");
              %>
              <td style="width:30%; padding:2%;">
                <%out.print("<img data-whatever=\"f-"+idPost+"\" class=\"card-img-top rounded img-responsive\" data-toggle=\"modal\" data-target=\"#modalPost\" style=\"height:300px \" src=\""+img+"\">");%>
              </td>
              <%
              cont++;
              if(cont%3==0)
                out.print("</tr>");
            }
          for(int i=0;i<(3-cont);i++)
          { %>
            <td style="width:28%; padding:3%;">
            </td>
            <%
          }
          }
          else if(opz==1)
          { %>
            <div class="container text-center p-0">
              <a class="display-4 list-inline text-center">Ancora non hai condiviso nessun post</a>
              <br>
              <a class="display-4 list-inline text-center">Crea un post:      <a class="display-4" style="color:black; font-weight:bold; text-decoration: none; " href="" data-toggle="modal" data-target="#modalUpload" title="Nuovo Post"><span class="oi oi-plus"></a></span></a>
            </div>
            <%
          }
          else
          {%>
          <div class="container text-center p-0">
            <a class="display-4 list-inline text-center">Questo utente non ha ancora condiviso nessun post</a>
          </div>
          <%}%>
        </table>
      </div>
    </div>
    <%}
      else
      {%>
      <div class="hashtagTable">
        <div class="container text-center p-0">
          <a class="display-2 list-inline text-center">Il profilo che stai cercando non esiste.</a>
        </div>
      <%}%>
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
            out.print("<a class=\"navbar-brand\"  style=\"color:black; text-decoration: none;\" href=\"logged.jsp?page=profile.jsp?user="+follower.get(i)+"\"><li class=\"list-group-item\"><img src=\""+image.get(i)+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\">");
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
          out.print("<a class=\"navbar-brand\"  style=\"color:black; text-decoration: none;\" href=\"logged.jsp?page=profile.jsp?user="+following.get(i)+"\"><li class=\"list-group-item\"><img src=\""+image2.get(i)+"\" width=\"30\" height=\"30\" class=\"d-inline-block rounded-circle align-top\">");
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
