<%@ page import="com.mysql.jdbc.Driver" %>
<%@ page import="java.util.*" %>
<%
  try{
    String online = (String) session.getAttribute("online");
    if(online.equals("true"))
      response.sendRedirect("../logged/logged.jsp?page=home.jsp");
  }
  catch(Exception e){}

  String err = request.getParameter("err"); //Richiesta parametro per controlli in caso di inserimento errato
  String user = request.getParameter("user");
%>
<html>
  <head>
    <%@include file="../includes/head.jsp" %>
    <link href="../../css/index.css" rel="stylesheet">
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light"> <!--Menu di login-->
      <a class="navbar-brand ml-3" href="paragraph.html" target="frame">
        <img src="../../img/logo.png" width="30" height="30" class="d-inline-block align-top" alt=""> <!--Immagine piccola menu-->
          REDAGRAM
      </a>
      <ul class="navbar-nav ml-auto">
        <form class="form-inline my-2 float-sm-right needs-validation" novalidate method="post" action="checkLogin.jsp?opz=1"> <!--Form di login-->
          <%
            out.print("<input id=\"validationCustom01\" type=text placeholder=\"Utente\" aria-label=\"user\" name=\"user\" required class=\"form-control mr-sm-2"); //TextField user
            if(err.equals("1")) out.print("is-invalid"); //Caso errore
            else if(err.equals("2")) out.print("\"is-valid \" value="+user+" "); //Caso corretto
            out.print("\">");
          %>
          <%
            out.print("<input id=\"exampleInputPassword1\" type=\"password\" placeholder=\"Password\" aria-label=\"password\" name=\"passw\" required class=\"form-control mr-sm-2 "); //TextField password
            if(err.equals("1")||err.equals("2")) out.print("is-invalid"); //Caso errore
            out.print("\">");
          %>
          <button class="btn btn-outline-success my-2 my-sm-0" type="submit" target="frame">ACCEDI</button>
        </form>
      </ul>
      <ul class="navbar-nav ml-1">
        <li class="nav-item active">
          <a class="nav-link" href="signUp.jsp?errUser=2&errMail=3&nome=0&cognome=0&dataNascita=0&mail=0" target="frame">Registrati<span class="sr-only">(current)</span></a> <!--Pulsante registrati-->
        </li>
      </ul>
    </nav>
    <section class="imageTop"> <!--Immagine di sfondo-->
      <div class="content">
        <iframe allowtransparency="5" frameborder="0" scrolling="no" src="paragraph.html" name="frame"> <!--iFrame sopra sfondo-->
        </iframe>
      </div>
    </body>
    <div class="footer-copyright py-3 text-center bg-light"> <!--Footer-->
        <div class="container-fluid">
            2018 Copyright: <a href="home.jsp?err=0&user=0">redagram.com</a>
        </div>
    </div>
</html>
