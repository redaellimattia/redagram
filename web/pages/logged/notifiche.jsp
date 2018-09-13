<%@include file="../includes/connection.jsp" %>
<html>
<div class="hashtagTable">
  <div class="container text-center p-0">
    <a class="display-2 list-inline text-center">Tutte le notifiche</a>
  </div>
  <br>
  <%
    String idUser = (String) session.getAttribute("idUser");
    ResultSet rs;
    String query =  "SELECT R.*,N.id_commento "+
          "FROM (SELECT N.ID_notifica, N.visualizzato, U.username, P.ID_post, P.img, N.data as dataDesc, 'commento' AS tipo "+
          "FROM notifiche N INNER JOIN comment C ON C.ID_comment = N.id_commento "+
                           "INNER JOIN user U ON U.ID_user = C.id_user "+
                           "INNER JOIN post P ON P.ID_post = C.id_post "+
          "WHERE P.id_user = '"+idUser+"' "+
          "UNION "+
          "SELECT  N.ID_notifica, N.visualizzato, U.username, P.ID_post, P.img, N.data as dataDesc, 'tag' AS tipo "+
          "FROM notifiche N INNER JOIN tag T ON T.ID_tag = N.id_tag "+
                           "INNER JOIN user U ON U.ID_user = T.id_user_tagging "+
                           "INNER JOIN post P ON P.ID_post = T.id_post "+
          "WHERE  T.id_user_tagged = '"+idUser+"' "+
          "UNION "+
          "SELECT  N.ID_notifica, N.visualizzato, U.username, P.ID_post, P.img, N.data as dataDesc, 'like' AS tipo "+
          "FROM notifiche N INNER JOIN likes L ON L.ID_like = N.id_like "+
                           "INNER JOIN user U ON U.ID_user = L.id_user "+
                           "INNER JOIN post P ON P.ID_post = L.id_post "+
          "WHERE  P.id_user = '"+idUser+"' "+
          "UNION "+
          "SELECT N.ID_notifica, N.visualizzato, U.username, null, null, N.data as dataDesc, 'follow' AS tipo "+
          "FROM notifiche N INNER JOIN follower F ON F.ID_follower = N.id_follower "+
                           "INNER JOIN user U ON U.ID_user = F.id_user_follower "+
          "WHERE  id_user_profile = '"+idUser+"') "+
          "R INNER JOIN notifiche N ON R.ID_notifica = N.ID_notifica "+
          "ORDER BY dataDesc DESC";
          rs=statement.executeQuery(query);
          while(rs.next()) //Stampa di tutte le notifiche
          {
            int visual = rs.getInt("visualizzato");
            String tipo = rs.getString("tipo");
            String idNotifica = rs.getString("ID_notifica");
            switch(tipo)
            {
              case "commento": out.print("<a class=\"dropdown-item notifica text-center\" style=\"font-size: 2em;\" id=\"n-"+idNotifica+"\" data-whatever=\"f-"+rs.getString("ID_post")+"\" data-toggle=\"modal\" data-target=\"#modalPost\" href=\"\"><b>"+rs.getString("username")+"</b> ha commentato il tuo post: <img src=\""+rs.getString("img")+"\" width=\"45\" height=\"45\" class=\"d-inline-block rounded-circle align-top\"></a>");
                              break;
              case "tag": out.print("<a class=\"dropdown-item notifica text-center\" style=\"font-size: 2em;\" id=\"n-"+idNotifica+"\" data-whatever=\"f-"+rs.getString("ID_post")+"\" data-toggle=\"modal\" data-target=\"#modalPost\" href=\"\"><b>"+rs.getString("username")+"</b> ti ha taggato nel post: <img src=\""+rs.getString("img")+"\" width=\"45\" height=\"45\" class=\"d-inline-block rounded-circle align-top\"></a>");
                          break;
              case "like": out.print("<a class=\"dropdown-item notifica text-center\" style=\"font-size: 2em;\" id=\"n-"+idNotifica+"\" data-whatever=\"f-"+rs.getString("ID_post")+"\" data-toggle=\"modal\" data-target=\"#modalPost\" href=\"\"><b>"+rs.getString("username")+"</b> ha messo mi piace al tuo post: <img src=\""+rs.getString("img")+"\" width=\"45\" height=\"45\" class=\"d-inline-block rounded-circle align-top\"></a>");
                          break;
              case "follow": out.print("<a class=\"dropdown-item notifica text-center\" style=\"font-size: 2em;\" id=\"n-"+idNotifica+"\" href=\"logged.jsp?page=profile.jsp?user="+rs.getString("username")+"\"><b>"+rs.getString("username")+"</b> ha incominciato a seguirti</a>");
                            break;
            }
            if(visual==0)
            {%>
            <script type="text/javascript">
              $("#n-<%=idNotifica%>").addClass('text-primary');
            </script>
            <%}
          }
  %>
</div>
<div class="modal fade" id="modalPost" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
<div class="modal-dialog" role="document">
  <div class="modal-content">
    <div class="modal-header">
      <h5 class="modal-title" id="exampleModalLabel ">Post</h5>
      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body bodyContent">
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
