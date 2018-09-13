<%@include file="../includes/connection.jsp" %>
<%@ page import="java.util.*"
         import="java.io.*" %>
<%
  String online = (String) session.getAttribute("online");
  Enumeration e = session.getAttributeNames();
  if(e.hasMoreElements()&&!online.equals("true"))
    response.sendRedirect("../../index.jsp");
  String idUser = (String) session.getAttribute("idUser");
  String userPath = (String) session.getAttribute("userPath");
  String pageToLoad = request.getParameter("page");
  String queryNotifiche = "SELECT N.ID_notifica "+
                          "FROM notifiche N INNER JOIN comment C ON C.ID_comment = N.id_commento "+
                                           "INNER JOIN user U ON U.ID_user = C.id_user "+
                                           "INNER JOIN post P ON P.ID_post = C.id_post "+
                          "WHERE N.visualizzato=0 AND P.id_user = '"+idUser+"' "+
                          "UNION "+
                          "SELECT  N.ID_notifica "+
                          "FROM notifiche N INNER JOIN tag T ON T.ID_tag = N.id_tag "+
                                           "INNER JOIN user U ON U.ID_user = T.id_user_tagging "+
                                           "INNER JOIN post P ON P.ID_post = T.id_post "+
                          "WHERE N.visualizzato=0 AND T.id_user_tagged = '"+idUser+"' "+
                          "UNION "+
                          "SELECT  N.ID_notifica "+
                          "FROM notifiche N INNER JOIN likes L ON L.ID_like = N.id_like "+
                                           "INNER JOIN user U ON U.ID_user = L.id_user "+
                                           "INNER JOIN post P ON P.ID_post = L.id_post "+
                          "WHERE N.visualizzato=0 AND P.id_user = '"+idUser+"' "+
                          "UNION "+
                          "SELECT N.ID_notifica "+
                          "FROM notifiche N INNER JOIN follower F ON F.ID_follower = N.id_follower "+
                                           "INNER JOIN user U ON U.ID_user = F.id_user_follower "+
                          "WHERE N.visualizzato=0 AND id_user_profile = '"+idUser+"'";
  ResultSet rsNot = statement.executeQuery(queryNotifiche);
  boolean red = false;
  if(rsNot.next()) //Presenza di notifiche da visualizzare
    red = true;
%>
<html>
  <head>
    <%@include file="../includes/head.jsp" %>
    <script src="../../js/openPost.js"></script>
    <script src="../../js/searchList.js"></script>
    <script src="../../js/searchUser.js"></script>
    <script src="../../js/like.js"></script>
    <script src="../../js/likeAndComment.js"></script>
    <script src="../../js/notification.js"></script>
    <link href="../../css/signUp.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/open-iconic/1.1.1/font/css/open-iconic-bootstrap.min.css" integrity="sha256-BJ/G+e+y7bQdrYkS2RBTyNfBHpA9IuGaPmf9htub5MQ=" crossorigin="anonymous" />
  </head>
  <body>
    <nav class="navbar fixed-top navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand ml-3" href="logged.jsp?page=home.jsp"  title="Home">
        <img src="../../img/logo.png" width="30" height="30" class="d-inline-block align-top"> <!--Immagine piccola menu-->
          REDAGRAM
      </a>
      <ul class="nav navbar-nav ml-auto mr-auto">
        <% for(int i=0; i<4; i++){
          %>
        <li class="nav-item active">
          <span class="nav-link"></span> <!-- SPAZIATURA -->
        </li>
        <%}%>
        <li class="nav-item active">
          <a class="nav-link" href="../includes/logOut.jsp" title="Logout"><span class="oi oi-account-logout"></span></a>
        </li>
        <li class="nav-item active">
          <a class="nav-link" href="logged.jsp?page=tendenze.jsp" title="Tendenze"><span class="oi oi-fire"></span></a>
        </li>
        <li class="nav-item active">
          <a class="nav-link" id="plus" href="" data-toggle="modal" data-target="#modalUpload" title="Nuovo Post"><span class="oi oi-plus"></span></a>
        </li>
        <li class="nav-item active">
          <div class="dropdown">
          <a class="nav-link openNotifiche" role="button" href="" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" title="Notifiche"><span id="notifiche" class="oi oi-bookmark"></span></a>
          <% if(red) //Nel caso in cui ci siano notifiche lo evidenzio di blu
          {%>
          <script type="text/javascript">
            $(".openNotifiche").addClass('text-primary');
          </script>
          <%}%>
          <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
          </div>
        </div>
        </li>
        <li class="nav-item active">
          <a class="nav-link" href="logged.jsp?page=profile.jsp?user=0" title="Profilo"><span class="oi oi-person"></span></a>
        </li>
      </ul>
      <ul class="navbar-nav navbar-right">
        <form class="form-inline my-2 float-sm-right needs-validation" novalidate role="search" action="../includes/hashOrProf.jsp" method="post">
          <div class="input-group">
              <input type="text" data-toggle="popover" data-trigger="focus" data-placement="right" title="Assicurati di precedere i profili con @ e gli hashtag con #" data-content="Esempio: @profile, #hashtag" class="form-control" placeholder="Cerca" name="user" id="srch-term" required>
              <div class="input-group-prepend">
                  <button class="btn btn-default" type="submit"><i class="oi oi-magnifying-glass"></i></button>
              </div>
          </div>
          </form>
      </ul>
    </nav>
    <script>
      $(document).ready(function () {
          $('#srch-term').popover();
      });
    </script>
    <jsp:include page="<%=pageToLoad%>" ></jsp:include>
    </body>
    <script src="../../js/imgPreview.js"></script>
    <div class="modal fade" id="modalLike" style="z-index: 2000;" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLongTitle">Likes</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <ul class="list-group lista">
          </ul>
        </div>
      </div>
    </div>
    </div>
    <div class="modal fade" id="modalPost" style="z-index: 1999;" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
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
    <div class="modal fade" id="modalCommento" style="z-index: 2000;" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLongTitle">Commenti</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <ul class="list-group listaComment">
          </ul>
              <textarea type="text" class="form-control mt-3" id="textAreaComment" placeholder="Commenta..." name="comment" rows="2" required></textarea>
        <div class="modal-footer">
          <input type="submit"  value="Commenta.." class="btn btn-success leaveComment">
        </div>
      </div>
    </div>
    </div>
    </div>
</html>
