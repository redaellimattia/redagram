<%@include file="../includes/connection.jsp" %>
<html>
<script src="../../js/openPost.js"></script>
<div class="hashtagTable" style="overflow-y: auto;">
  <table style="border-spacing:50px;">
  <%
    ResultSet rs;
    rs=statement.executeQuery("SELECT P.img, P.data, P.ID_post, COUNT(L.ID_like) as totale "+
                              "FROM post P INNER JOIN likes L ON P.ID_post = L.id_post "+
                              "WHERE P.data >= DATE_ADD(CURDATE(), INTERVAL -1 DAY) "+
                              "GROUP BY P.ID_post "+
                              "ORDER BY totale DESC"); //Post con like nelle ultime 24H
    String desc = "", location = "", img = "", data = "", idPost="";
    int cont = 0;
    if(rs.next()) //Caso in cui ci siano post
    {
      rs.beforeFirst();
      %>
      <div class="container text-center p-0">
        <a class="display-2 list-inline text-center">Post in tendenza nelle ultime 24H</a>
      </div>
      <%
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
    else //Caso in cui non ci siano post da visualizzare
    {
      %>
      <div class="container text-center p-0">
        <a class="display-4 list-inline text-center">Non ci sono post in tendenza</a>
        <br>
          <a class="display-4 list-inline text-center">Creane subito uno:      <a class="display-4" style="color:black; font-weight:bold; text-decoration: none; " href="" data-toggle="modal" data-target="#modalUpload" title="Nuovo Post"><span class="oi oi-plus"></a></span></a>
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
