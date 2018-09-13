<%@ page import="java.sql.*"
import="com.mysql.jdbc.Driver" %>
<%!
    String connectionURL = "jdbc:mysql://localhost:3306/redagram";
    String username= "pi";
    String password= "raspberry";

    Connection conn = null;
    Statement statement = null;
%>
<%
    try
    {
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection(connectionURL, username, password);
        statement = conn.createStatement();
        //out.println("CONNECTED");
    }
    catch(Exception ex){ex.printStackTrace();}
%>
