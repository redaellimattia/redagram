<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@include file="../includes/connection.jsp" %>
<%@ page import="java.util.regex.*"
         import="java.io.File" %>
<%! String regex = "^([_a-zA-Z0-9-]+(\\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{1,6}))?$"; %>
<%
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   String idUser = (String) session.getAttribute("idUser"); //Leggo idUser dalla sessione
   int opz = Integer.parseInt(request.getParameter("opz")); //Leggo parametro in GET cosi da distinguere img profilo dai post
   String pathQuery = "",desc = "",location = "";
   String user ="", nome = "", cognome = "", password="", dataNascita = "", mail = "", sesso = "";
   int sessoInt = 3;
   boolean ctrl = false;
   ResultSet rs = null;
   String[] errors = {"0","0"}; //Vettore errori [0]=errUser [1]=errMail
   ServletContext context = pageContext.getServletContext();
   String filePath = context.getInitParameter("file-upload");
   switch(opz)
   {
     case 1: filePath+=idUser+"/post/"; //Carico la immagine nella cartella dei post
             break;
     case 2: filePath+=idUser+"/"; //Carico la immagine nella cartella user
                     break;
   }
   String pathCommand = "";
   String contentType = request.getContentType();
   if ((contentType.indexOf("multipart/form-data") >= 0))
   {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(maxMemSize);
        // Location to save data that is larger than maxMemSize.
        factory.setRepository(new File("/opt/tomcat9/temp"));
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax( maxFileSize );
        try
        {
           List fileItems = upload.parseRequest(request);
           Iterator i = fileItems.iterator();
           while ( i.hasNext () )
           {
              FileItem fi = (FileItem)i.next();
              if ( !fi.isFormField () )
              {
                 String fieldName = fi.getFieldName();
                 String fileName = fi.getName();
                 boolean isInMemory = fi.isInMemory();
                 long sizeInBytes = fi.getSize();
                 if( fileName.lastIndexOf("\\") >= 0 )
                 {
                    String filePathFinal = filePath + fileName.substring( fileName.lastIndexOf("\\"));
                    pathQuery = filePathFinal;
                    pathCommand = filePathFinal;
                    pathQuery = pathQuery.replace("/opt/tomcat9/webapps", "");
                    file = new File( filePathFinal);
                 }
                 else
                 {
                   String filePathFinal = filePath + fileName.substring(fileName.lastIndexOf("\\")+1);
                   pathQuery = filePathFinal;
                   pathCommand = filePathFinal;
                   pathQuery = pathQuery.replace("/opt/tomcat9/webapps", "");
                   file = new File(filePathFinal);
                 }
                 if(!fileName.equals(""))
                 {
                   ctrl = true;
                   fi.write( file );
                 }

              }
              else
              {
                String fieldName = fi.getFieldName();
                String value = fi.getString();
                if(opz == 1)
                {
                  switch(fieldName)
                  {
                    case "desc": desc = value;
                                 break;
                    case "location": location = value;
                                     break;
                  }
                }
                else
                {
                  switch(fieldName)
                  {
                    case "user": user = value;
                                 break;
                    case "nome": nome = value;
                                 break;
                    case "cognome": cognome = value;
                                    break;
                    case "mail": mail = value;
                                 break;
                    case "passw": password = value;
                                 break;
                    case "dataNascita": dataNascita = value;
                                        break;
                    case "sesso": sesso = value;
                                  if(sesso.equals("uomo"))
                                    sessoInt=1;
                                  else
                                    sessoInt=0;
                                  break;
                  }
                }
              }
           }
        } catch(Exception ex) {  out.println(ex); }
    }
    String command = "sudo chown pi:pi "+pathCommand;
    Process process = Runtime.getRuntime().exec(command,null);
    if(opz == 1)
    {
      int idPostMax;
      String query = "INSERT INTO post (id_user, description, location, img, data) VALUES ('"+idUser+"','"+desc+"','"+location+"','"+pathQuery+"', NOW())";
      idPostMax = statement.executeUpdate(query, Statement.RETURN_GENERATED_KEYS);
      rs = statement.getGeneratedKeys();
      if (rs.next())
        idPostMax=rs.getInt(1);
      ArrayList<String> output = new ArrayList<String>();
      int start = 0;
      String str = "";
      boolean ctrl2 = false;
      desc += " ";
      for(int i=0; i<desc.length();i++) //for ricerca caratteri
      {

          if(desc.charAt(i)=='@'||desc.charAt(i)=='#'&&!ctrl2)
          {
            if(!str.equals(""))
            {
              output.add(str);
              str = "";
            }
            start = i;
            ctrl2 = true;
          }
          else if(desc.charAt(i)==' '&&ctrl2)
          {
            output.add(desc.substring(start,i));
            start = i;
            ctrl2 = false;
          }
      }
      for(int i=0; i<output.size();i++) //for di stampa
      {
        if(output.get(i).indexOf("@")!=-1)
        {
          String tag = output.get(i).replace("@","");
          rs = statement.executeQuery("SELECT ID_user FROM user WHERE username = '"+tag+"'");
          if(rs.next())
          {
            String idUserTagged = rs.getString("ID_user");
            Statement statement3 = conn.createStatement();
            int idTagMax;
            ResultSet rs2;
            idTagMax = statement3.executeUpdate("INSERT INTO tag (id_user_tagging, id_user_tagged, id_post) VALUES ('"+idUser+"','"+idUserTagged+"','"+idPostMax+"')",Statement.RETURN_GENERATED_KEYS);
            rs2 = statement3.getGeneratedKeys();
            if (rs2.next())
              idTagMax=rs2.getInt(1);
            statement3.executeUpdate("INSERT INTO notifiche (id_tag) VALUES ('"+idTagMax+"')");
          }
        }
        else if(output.get(i).indexOf("#")!=-1)
        {
          String tag = output.get(i).replace("#","");
          rs = statement.executeQuery("SELECT * FROM hashtag WHERE hashtag = '"+tag+"'");
          if(!rs.next())
          {
            int idHashtagMax;
            query = "INSERT INTO hashtag (hashtag) VALUES ('"+tag+"')";
            Statement statement2 = conn.createStatement();
            ResultSet rs2;
            idHashtagMax = statement2.executeUpdate(query, Statement.RETURN_GENERATED_KEYS);
            rs2 = statement2.getGeneratedKeys();
            if (rs2.next())
            {
              idHashtagMax=rs2.getInt(1);
              statement2.executeUpdate("INSERT INTO hashtag_post (id_hashtag, id_post) VALUES ('"+idHashtagMax+"','"+idPostMax+"')");
            }
          }
          else
          {
            int idHashtag = rs.getInt("ID_hashtag");
            Statement statement2 = conn.createStatement();
            statement2.executeUpdate("INSERT INTO hashtag_post (id_hashtag, id_post) VALUES ('"+idHashtag+"','"+idPostMax+"')");
          }
        }
      }
      response.sendRedirect("../logged/logged.jsp?page=home.jsp");
    }
    else
    {
      rs = statement.executeQuery("SELECT ID_user FROM user WHERE username = '"+user+"' AND ID_user != '"+idUser+"'");  //Controllo esistenza username nel db
      if(rs.next())
        errors[0]="1"; //USERNAME GIA UTILIZZATO
      Pattern pattern = Pattern.compile(regex);
      Matcher matcher = pattern.matcher(mail);
      if (!matcher.matches())
          errors[1]="1";  //FORMATO EMAIL NON VALIDO
      else
      {
        rs = statement.executeQuery("SELECT email FROM user WHERE email = '"+mail+"' AND ID_user != '"+idUser+"'");
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
        response.sendRedirect("../logged/logged.jsp?page=modify.jsp?errUser="+errUser+"&errMail="+errMail);
      else if(errMail.equals("0")&&!errUser.equals("0"))
        response.sendRedirect("../logged/logged.jsp?page=modify.jsp?errUser="+errUser+"&errMail="+errMail);
      else if(!errMail.equals("0")&&errUser.equals("0"))
        response.sendRedirect("../logged/logged.jsp?page=modify.jsp?errUser="+errUser+"&errMail="+errMail);
      else  //Se non ci sono errori eseguo la query di aggiornamento
      {
        if(ctrl)
          statement.executeUpdate("UPDATE user SET username = '"+user+"', password = '"+password+"', nome = '"+nome+"', cognome = '"+cognome+"', data_nascita = '"+dataNascita+"', email = '"+mail+"', sesso = '"+sessoInt+"', img_profilo = '"+pathQuery+"' WHERE ID_user = '"+idUser+"'");
        else
          statement.executeUpdate("UPDATE user SET username = '"+user+"', password = '"+password+"', nome = '"+nome+"', cognome = '"+cognome+"', data_nascita = '"+dataNascita+"', email = '"+mail+"', sesso = '"+sessoInt+"' WHERE ID_user = '"+idUser+"'");
        response.sendRedirect("../logged/logged.jsp?page=profile.jsp?user=0");
      }
    }
%>
