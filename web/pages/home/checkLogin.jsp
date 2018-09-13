<%@include file="../includes/connection.jsp" %>
<%@ page import="java.util.regex.*"
         import="java.io.File" %>
<%! String regex = "^([_a-zA-Z0-9-]+(\\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{1,6}))?$"; %>
<%
    ResultSet rs = null;
    int opz = Integer.parseInt(request.getParameter("opz"));
    String user = request.getParameter("user");
    String passw = request.getParameter("passw");
    switch(opz)
    {
        case 1:   rs = statement.executeQuery("SELECT ID_user FROM user WHERE username = '"+user+"'");
                  if(rs.next()) //Controllo se l'user è gia esistente
                  {
                      rs = statement.executeQuery("SELECT ID_user FROM user WHERE username = '"+user+"' AND password = '"+passw+"'");
                      String idUser = "";
                      if(rs.next()) //Controllo se la password coincide è gia esistente
                      {
                        idUser = rs.getString("ID_user");
                        session.setAttribute( "idUser", idUser);
                        session.setAttribute("online", "true");
                        String path = "opt/tomcat9/webapps/TesinaJSP/mediaSaved/" + idUser;
                        session.setAttribute( "userPath", path);
                        response.sendRedirect("../logged/logged.jsp?page=home.jsp");
                      }
                      else
                        response.sendRedirect("home.jsp?err=2&user="+user);
                  }
                  else
                    response.sendRedirect("home.jsp?err=1");
                  break;

        case 2: String[] errors = {"0","0"}; //Vettore errori [0]=errUser [1]=errMail

                String nome = request.getParameter("nome"); //richiedo nome
                String cognome = request.getParameter("cognome"); //richiedo cognome
                String dataNascita = request.getParameter("dataNascita"); //richiedo data di nascita
                String sesso = request.getParameter("sesso"); //richiedo sesso
                int sessoInt;
                if(sesso.equals("uomo"))
                  sessoInt=1;
                else
                  sessoInt=0;

                rs = statement.executeQuery("SELECT ID_user FROM user WHERE username = '"+user+"'");  //Controllo esistenza username nel db
                if(rs.next())
                  errors[0]="1"; //USERNAME GIA UTILIZZATO
                String email = request.getParameter("email"); //Richiedo email
                Pattern pattern = Pattern.compile(regex);
                Matcher matcher = pattern.matcher(email);
                if (!matcher.matches())
                    errors[1]="1";  //FORMATO EMAIL NON VALIDO
                else
                {
                  rs = statement.executeQuery("SELECT email FROM user WHERE email = '"+email+"'");
                  if(rs.next())
                    errors[1]="2"; //EMAIL GIA UTILIZZATA
                }

                String errUser="0", errMail="0";
                for(int i=0; i<errors.length; i++)
                {
                    switch(i) //Controllo vettore errori
                    {
                        case 0: if(errors[i]!="0")  errUser = errors[i];
                                  break;
                        case 1: if(errors[i]!="0")  errMail = errors[i];
                                  break;
                    }
                }
                if(!errMail.equals("0")&&!errUser.equals("0"))  //Controllo se sono stati rilevati degli errori
                  response.sendRedirect("signUp.jsp?errUser="+errUser+"&errMail="+errMail+"&nome="+nome+"&cognome="+cognome+"&dataNascita="+dataNascita);
                else if(errMail.equals("0")&&!errUser.equals("0"))
                  response.sendRedirect("signUp.jsp?errUser="+errUser+"&errMail="+errMail+"&nome="+nome+"&cognome="+cognome+"&dataNascita="+dataNascita+"&mail="+email);
                else if(!errMail.equals("0")&&errUser.equals("0"))
                  response.sendRedirect("signUp.jsp?errUser="+errUser+"&errMail="+errMail+"&nome="+nome+"&cognome="+cognome+"&dataNascita="+dataNascita+"&user="+user);
                else  //Se non ci sono errori eseguo la query di inserimento
                {
                  statement.executeUpdate("INSERT INTO user (username, password, nome, cognome, email, sesso, data_nascita) VALUES ('"+user+"','"+passw+"','"+nome+"','"+cognome+"','"+email+"','"+sessoInt+"','"+dataNascita+"')");
                  rs = statement.executeQuery("SELECT ID_user FROM user WHERE username = '"+user+"'");
                  String idUser = "";
                  if(rs.next())
                  {
                    idUser = rs.getString("ID_user");
                    session.setAttribute( "idUser", idUser);
                    session.setAttribute("online", "true");
                  }

                  //Creazione cartella utente e permessi
                  String path = "opt/tomcat9/webapps/TesinaJSP/mediaSaved/" + idUser;
                  File f1 = new File(path);
                  f1.mkdirs();
                  String command1 = "mkdir "+path+"/post";
                  Process process1 = Runtime.getRuntime().exec(command1,null);
                  session.setAttribute( "userPath", path);
                  String command2 = "sudo chown pi:pi "+path+"/post";
                  Process process2 = Runtime.getRuntime().exec(command2,null);
                  String command = "sudo chown pi:pi "+path;
                  Process process = Runtime.getRuntime().exec(command,null);
                  %>
                  <script>
                    window.top.location = '../logged/logged.jsp?page=home.jsp'; //Esco dall'iframe e ricarico tutta la pagina
                  </script>
                  <%
                }
                break;
    }
%>
