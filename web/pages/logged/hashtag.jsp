<%@include file="../includes/connection.jsp" %>
<%
String hash = request.getParameter("hashtag"); //Richiedo hashtag per poi eseguire la query
%>
<html>
<script src="../../js/openPost.js"></script> <!--Script jquery per l'apertura dei post.-->
<div class="hashtagTable">
  <div class="container text-center p-0">
    <a class="display-2 list-inline text-center">#<%=hash%></a>
  </div>
  <table style="border-spacing:50px;">
  <%
    ResultSet rs;
    rs=statement.executeQuery("SELECT P.img, P.data, P.ID_post "+
                              "FROM post P INNER JOIN hashtag_post H ON P.ID_post = H.id_post "+
                              "INNER JOIN hashtag HA ON HA.ID_hashtag = H.id_hashtag "+
                              "WHERE HA.hashtag = '"+hash+"' ORDER BY data DESC"); //Seleziona img, data e id del post, tramite inner join tra post e entita asscociativa tra hashtag e post, la condizione where è sull'hashtag
    String desc = "", location = "", img = "", data = "", idPost="";
    int cont = 0;
    if(rs.next()) //Query restituisce risultati
    {
      rs.beforeFirst(); //Riporto indietro rs, dopo rs.next()
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
    else //Caso in cui non ci siano post con questo hashtag
    {
      %>
      <div class="container text-center p-0">
        <a class="display-4 list-inline text-center">Questo hashtag non ha ancora un post :(</a>
        <br>
          <a class="display-4 list-inline text-center">Crea un post:      <a class="display-4" style="color:black; font-weight:bold; text-decoration: none; " href="" data-toggle="modal" data-target="#modalUpload" title="Nuovo Post"><span class="oi oi-plus"></a></span></a>
        </div>
      <%
    }
  %>
  </table>
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
