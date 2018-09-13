<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@page language="java" %>
<%@include file="connection.jsp" %>

<%
    int opz = Integer.parseInt(request.getParameter("opz"));
    String query = (String)request.getParameter("search");
    switch(opz)
    {
      case 1: try
              {
                  String[] searchString = query.split(";");

                  for( String o : searchString)
                  {
                    ResultSet rs;
                    rs=statement.executeQuery("SELECT username FROM user WHERE username LIKE '"+o+"%'");
                    while(rs.next())
                      out.print(rs.getString("username")+";");
                  }
              }
              catch(Exception e1)
              {
                out.println(e1);
              }
              break;
      case 2: try
              {
                  String[] searchString = query.split(";");

                  for( String o : searchString)
                  {
                    ResultSet rs;
                    rs=statement.executeQuery("SELECT hashtag FROM hashtag WHERE hashtag LIKE '"+o+"%'");
                    while(rs.next())
                      out.print(rs.getString("hashtag")+";");
                  }
              }
              catch(Exception e1)
              {
                out.println(e1);
              }
              break;
      case 3: try
              {
                  ResultSet rs;
                  rs=statement.executeQuery("SELECT username FROM user WHERE username LIKE '"+query+"%'");
                  while(rs.next())
                    out.print("@"+rs.getString("username")+";");
                  rs=statement.executeQuery("SELECT hashtag FROM hashtag WHERE hashtag LIKE '"+query+"%'");
                  while(rs.next())
                    out.print("#"+rs.getString("hashtag")+";");

              }
              catch(Exception e1)
              {
                out.println(e1);
              }
              break;
    }

%>
