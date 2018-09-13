<%@ page import="com.mysql.jdbc.Driver" %>
<%
  String errUser = request.getParameter("errUser"); //Richiesta parametro per controlli in caso di inserimento errato
  String errMail = request.getParameter("errMail");
  String nome = request.getParameter("nome");
  String cognome = request.getParameter("cognome");
  String dataNascita = request.getParameter("dataNascita");
  String mail = request.getParameter("mail");
  String user = request.getParameter("user");
%>
<html>
<head>
  <%@include file="../includes/head.jsp" %>
  <link href="../../css/signUp.css" rel="stylesheet">
</head>
<body>
    <form class="needs-validation" novalidate method="post" action="checkLogin.jsp?opz=2">
      <div class="form-row">
        <div class="col-md-4 mb-3">
          <% out.print("<input type=\"text\" name=\"nome\" class=\"form-control\" id=\"validationCustom01\" required placeholder=\"Nome\" ");
           if(!errUser.equals("2")) out.print(" value="+nome+">");
           else out.print("\">");
          %>
        </div>
        <div class="col-md-4 mb-3">
          <% out.print("<input type=\"text\" name=\"cognome\" class=\"form-control\" id=\"validationCustom02\" required placeholder=\"Cognome\" ");
           if(!errUser.equals("2")) out.print(" value="+cognome+">");
           else out.print("\">");
          %>
        </div>
        <div class="col-md-4 mb-3">
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text" id="inputGroupPrepend">@</span>
            </div>
            <%
              out.print("<input id=\"validationCustom05\" type=text placeholder=\"Inserisci Username\" aria-label=\"user\" name=\"user\" required class=\"form-control mr-sm-2 "); //TextField user
              if(errUser.equals("1"))
                {
                  out.print("is-invalid\">"); //Caso errore
                  out.println("<div class=\"invalid-feedback\">Username gia utilizzato.</div>");
                }
              else if(errUser.equals("0")) out.print("\"is-valid\" value="+user+">"); //Caso corretto
            %>
            <!--div class="invalid-feedback"></div-->
          </div>
        </div>
      </div>
      <div class="form-row">
        <div class="col-md-4 mb-3">
          <input type="password" name="passw" class="form-control" id="passwordReg" placeholder="Inserisci Password" required>
        </div>
        <div class="col-md-4 mb-3">
          <%
            out.print("<input id=\"exampleInputEmail1\" type=email placeholder=\"Inserisci Email\" aria-describedby=\"emailHelp\" name=\"email\" required class=\"form-control "); //TextField user
            if(errMail.equals("1"))
            {
              out.print("is-invalid\">"); //Caso errore
              out.println("<div class=\"invalid-feedback\">Mail non valida.</div>");
            }
            else if(errMail.equals("2"))
            {
              out.print("is-invalid\">"); //Caso errore
              out.println("<div class=\"invalid-feedback\">Mail gia utilizzata.</div>");
            }
            else if(errMail.equals("0")) out.print("\"is-valid\" value="+mail+">"); //Caso corretto
          %>
          <!--div class="invalid-feedback"></div-->
        </div>
      <div class="col-md-4 mb-3">
        <%
          out.print("<input data-toggle=\"popover\" data-trigger=\"focus\" data-placement=\"bottom\"  data-content=\"Inserisci la tua data di nascita\" type=\"date\" name=\"dataNascita\" class=\"form-control\" id=\"validateEmail\" required min=\"1900-01-01\"");
          if(!errUser.equals("2")) out.print(" value="+dataNascita+">");
          else out.print("\">");
          out.println("<div class=\"invalid-feedback\">Inserisci una data di nascita valida.</div>");
        %>
        <script>
          $(document).ready(function () {
              $('#validateEmail').popover();
          });
        </script>

        <script src="../../js/maxDate.js"></script>
      </div>
      </div>
      <div class="form-group"> <!--SESSO-->
        <div class="custom-control custom-radio custom-control-inline">
          <input type="radio" id="customRadioInline1" name="sesso" value="uomo" class="custom-control-input" required>
          <label class="custom-control-label" for="customRadioInline1">Uomo</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input type="radio" id="customRadioInline2" name="sesso" value="donna" class="custom-control-input" required>
          <label class="custom-control-label" for="customRadioInline2">Donna</label>
        </div>
      </div>
      <button class="btn btn-success" type="submit">Registrati</button>
</form>
</body>
</html>
