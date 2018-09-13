<%
String search = request.getParameter("user");
if(search.indexOf("@")!=-1)
  response.sendRedirect("../logged/logged.jsp?page=profile.jsp?user="+search.replace("@",""));
else if(search.indexOf("#")!=-1)
  response.sendRedirect("../logged/logged.jsp?page=hashtag.jsp?hashtag="+search.replace("#",""));
else
  response.sendRedirect("../logged/logged.jsp?page=home.jsp");
%>
