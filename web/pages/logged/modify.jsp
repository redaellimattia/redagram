<%@include file="../includes/connection.jsp" %>
<link href="../../css/signUp.css" rel="stylesheet">
<%
  ResultSet rs = null;
  String errUser = request.getParameter("errUser"); //Richiesta parametro per controlli in caso di inserimento errato
  String errMail = request.getParameter("errMail");
  String idUser = (String) session.getAttribute("idUser");
  String pathImgProfilo="", user ="", nome = "", cognome = "", dataNascita = "", mail = "", sesso = "";
  rs = statement.executeQuery("SELECT username, nome, cognome, data_nascita, email, sesso, img_profilo FROM user WHERE ID_user = '"+idUser+"'");
  if(rs.next()) //Dati da modificare
  {
    user = rs.getString("username");
    nome = rs.getString("nome");
    cognome = rs.getString("cognome");
    dataNascita = rs.getString("data_nascita");
    mail = rs.getString("email");
    sesso = rs.getString("sesso");
    pathImgProfilo = rs.getString("img_profilo");
  }
%>
<script src="../../js/imgPreview.js"></script>
<html>
  <div class="row">
    <div class="aside-left2">
      <figure class="figure ml-5">
        <div class="profile-img-container">
          <form action="../includes/upload.jsp?opz=2" method="post" enctype="multipart/form-data">
          <%
          out.print("<img src=\""+pathImgProfilo+"\" id=\"output\" class=\"figure-img img-fluid rounded-circle img-center img-responsive\" style=\"max-height: 450px;\">"); %>
          <a href="javascript:void(0)" onclick="test();" id="changeImg" title="Cambia Immagine"><span class="oi oi-image"></span></a>
        </div>
        <input type="file" accept=".png, .jpg, .jpeg" name="file" class="custom-file-input" id="custom-file" onchange="loadFile(event)"/>
      </figure>
    </div>
    <div class="center2">
      <br><br>
        <div class="form-row">
          <div class="col-md-4 mb-3">
            <% out.print("<input type=\"text\" value="+nome+" name=\"nome\" class=\"form-control\" id=\"validationCustom01\" required placeholder=\"Nome\">");%>
          </div>
          <div class="col-md-4 mb-3">
            <% out.print("<input type=\"text\" value="+cognome+" name=\"cognome\" class=\"form-control\" id=\"validationCustom02\" required placeholder=\"Cognome\" >");%>
          </div>
          </div>
          <div class="form-row">
          <div class="col-md-4 mb-3">
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text" id="inputGroupPrepend">@</span>
              </div>
              <%
                out.print("<input id=\"validationCustom03\" value="+user+" type=text placeholder=\"Inserisci Username\" aria-label=\"user\" name=\"user\" required class=\"form-control mr-sm-2 "); //TextField user
                if(errUser.equals("1"))
                  {
                    out.print("is-invalid\">"); //Caso errore
                    out.println("<div class=\"invalid-feedback\">Username gia utilizzato.</div>");
                  }
                else if(errUser.equals("0")) out.print("\"is-valid\">"); //Caso corretto
              %>
              <!--div class="invalid-feedback"></div-->
            </div>
        </div>
          <div class="col-md-4 mb-3">
            <input type="password" name="passw" class="form-control" id="passwordReg" placeholder="Inserisci Password" required>
          </div>
          </div>
          <div class="form-row">
          <div class="col-md-4 mb-3">
            <%
              out.print("<input id=\"exampleInputEmail1\"  value="+mail+" type=email placeholder=\"Inserisci Email\" aria-describedby=\"emailHelp\" name=\"mail\" required class=\"form-control "); //TextField user
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
              else if(errMail.equals("0")) out.print("\"is-valid\">"); //Caso corretto
            %>
            <!--div class="invalid-feedback">
            </div-->
          </div>
        <div class="col-md-4 mb-3">
          <%
            out.print("<input type=\"date\" value="+dataNascita+" name=\"dataNascita\" class=\"form-control\" id=\"validateEmail\" required min=\"1900-01-01\">");
            out.println("<div class=\"invalid-feedback\">Inserisci una data di nascita valida.</div>");
          %>
          <script src="../../js/maxDate.js"></script>
        </div>
        </div>
        <div class="form-group"> <!--SESSO-->
          <div class="custom-control custom-radio custom-control-inline">
            <% if(sesso.equals("1")) out.print("<input type=\"radio\" id=\"customRadioInline1\" name=\"sesso\" value=\"uomo\" checked class=\"custom-control-input\" required>");
               else out.print("<input type=\"radio\" id=\"customRadioInline1\" name=\"sesso\" value=\"uomo\" class=\"custom-control-input\" required>");
            %>
            <label class="custom-control-label" for="customRadioInline1">Uomo</label>
          </div>
          <div class="custom-control custom-radio custom-control-inline">
            <% if(sesso.equals("2")) out.print("<input type=\"radio\" id=\"customRadioInline2\" name=\"sesso\" value=\"donna\" checked class=\"custom-control-input\" required>");
               else out.print("<input type=\"radio\" id=\"customRadioInline2\" name=\"sesso\" value=\"donna\" class=\"custom-control-input\" required>");
            %>
            <label class="custom-control-label" for="customRadioInline2">Donna</label>
          </div>
        </div>
        <button class="btn btn-success" type="submit">Aggiorna</button>
  </form>
  <br><br>
  <form  method="post" action="../includes/delete.jsp?opz=1">
    <button class="btn btn-danger" type="submit">Elimina Profilo</button>
  </form>
    </div>
  </div>
</html>
