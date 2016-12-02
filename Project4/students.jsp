<%@ page import="java.sql.*" %>

<%
String connectionURL =
"jdbc:postgresql://cop4710-postgresql.cs.fiu.edu:5432/fall16_macos101?user=fall16_macos101&password=3914479";

Connection connection = null;
Statement statement = null;
ResultSet rs = null;


%>
<html><body>
<h1 style="text-align:center; background-color: #009688; color: white;">Student Table</h1>
<button type="button" style="background-color:  #ff9800;" name="back" onclick="history.back()">GO BACK TO PREVIOUS PAGE</button><br><br>
<form action="homepage.jsp">
  <input type ="submit" value="GO BACK TO HOMEPAGE" style="background-color: #8bc34a">
</form>
<center>
<div style="height:30%; overflow:auto">
<table style="text-align:center" border = "2">
    <thead bgcolor = "#e0e0e0">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Birthday</th>
            <th>Address</th>
            <th>Email</th>
            <th>Level</th>
        </tr>
    </thead>
<%
Class.forName("org.postgresql.Driver").newInstance();
connection = DriverManager.getConnection(connectionURL);
statement = connection.createStatement();
String name = request.getParameter("Name");
if(name != null){name = name.toLowerCase();}
if (name != null && name.length() > 0) {
  PreparedStatement ps = connection.prepareStatement(
                         "SELECT * FROM students WHERE LOWER(Name) = ?"); // ? = placeholder
  ps.setString(1, name); // Bind the value to the placeholder
  rs = ps.executeQuery(); // Execute the prepared statement and fetch results
} else {
    rs = statement.executeQuery("SELECT * FROM students");
}

// INSERT QUERY

String insertid = request.getParameter("insert-student-id");
String name1 = request.getParameter("insert-student-name");
String bday = request.getParameter("insert-student-bday");
String address = request.getParameter("insert-student-address");
String email = request.getParameter("insert-student-email");
String level = request.getParameter("insert-student-level");

boolean insertRequest = (insertid != null && insertid != "") && (name1 != null && name1 != "") && (bday != null && bday != "") &&
(address != null && address != "") && (email != null && email != "") && (level != null && level != "");

if(insertRequest){
PreparedStatement pst = connection.prepareStatement("INSERT into Students VALUES(?, ?, ?, ?, ?, ?)");

      pst.setInt(1, Integer.parseInt(insertid));
      pst.setString(2, name1);
      pst.setString(3, bday);
      pst.setString(4, address);
      pst.setString(5, email);
      pst.setString(6, level);


      if(pst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM students");
               }
               else{
                 out.println("failed to insert the data");
                }
      pst.close();
}
// DELETE QUERY
String delemail = request.getParameter("del-student-id");
boolean idTest = (delemail != null) && (delemail != "");
if(idTest){
PreparedStatement delpst = connection.prepareStatement("DELETE FROM students WHERE student_id = ?");

      delpst.setInt(1, Integer.parseInt(delemail));

      if(delpst.executeUpdate()!=0){
                 rs = statement.executeQuery("SELECT * FROM students");
               }
               else{
                 out.println("failed to delete the data");
                }
      delpst.close();
}

// UPDATE QUERY
String insertid1 = request.getParameter("update-student-id");
String name2 = request.getParameter("update-student-name");
String bday1 = request.getParameter("update-student-bday");
String address1 = request.getParameter("update-student-address");
String email1 = request.getParameter("update-student-email");
String level1 = request.getParameter("update-student-level");

boolean updateRequest = (insertid1 != null && insertid1 != "") && (name2 != null && name2 != "") && (bday1 != null && bday1 != "") &&
(address1 != null && address1 != "") && (email1 != null && email1 != "") && (level1 != null && level1 != "");



if(updateRequest){

  PreparedStatement updatepst = connection.prepareStatement("Update students SET name = ? , date_of_birth = ? , address = ? , email = ? , level = ? WHERE student_id = ?");


      updatepst.setString(1, name2);
      updatepst.setString(2, bday1);
      updatepst.setString(3, address1);
      updatepst.setString(4, email1);
      updatepst.setString(5, level1);
      updatepst.setInt(6, Integer.parseInt(insertid1));



      if(updatepst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM students");
               }
              else{
                 out.println("failed to update the data");
               }
      updatepst.close();
}


ResultSetMetaData metadata = rs.getMetaData();

 while (rs.next()) { %>
    <tr>
    <%
    for(int i = 1; i <= metadata.getColumnCount(); i++){ %>
        <td>
        <%=rs.getString(i)%>
        </td>
    <%
       }
    %>
    </tr>
<%
 }
%>
</table>
</div>
</center>
<%
rs.close();
%>
<br>

<form>
    <!-- SEARCH FORM-->
    <div style="width:100%;">
    <center>
    <div style="margin:0 auto;display: inline-block;width:50%;">
    <input type="text" name="Name">
    <input type ="submit" value="SEARCH" style="color:white; background-color:#0057e7;"><br><br><br>
    </div>

    <!-- DELETE FORM-->
    <div>
    <input type="number" name ="del-student-id" min="1" placeholder="Enter Student ID">
    <input type ="submit" value="DELETE" style="color:white; background-color:#d62d20;"><br><br><br>
    </div>
    </center>

  </div>
  <center>
    <!-- INSERT FORM-->
    <div style="width:100%;">
    <div style="float:left;width:50%;">

    <input type="number" name ="insert-student-id" min="1" placeholder="Enter Student ID"><br><br>
    <input type="text" name ="insert-student-name" placeholder="Enter Student Name"><br><br>
    <input type="text" name ="insert-student-bday" placeholder="Enter Student Birthday"><br><br>
    <input type="text" name ="insert-student-address" placeholder="Enter Student Address"><br><br>
    <input type="text" name ="insert-student-email" placeholder="Enter Student Email"><br><br>
    Enter Student Level:
    <select name ="insert-student-level">
      <option value="ugrad">ugrad</option>
      <option value="grad">grad</option>
    </select><br><br>
    <input type ="submit" value="INSERT" style="color:white; background-color:#008744;"><br><br><br>
    </div>


    <!-- UPDATE FORM-->
    <div style="float:right;width:50%;">
    <input type="number" name ="update-student-id" min="1" placeholder="Enter Student ID"><br><br>
    <input type="text" name ="update-student-name" placeholder="Enter Student Name"><br><br>
    <input type="text" name ="update-student-bday" placeholder="Enter Student Birthday"><br><br>
    <input type="text" name ="update-student-address" placeholder="Enter Student Address"><br><br>
    <input type="text" name ="update-student-email" placeholder="Enter Student Email"><br><br>
    Enter Student Level:
    <select name ="update-student-level">
      <option value="ugrad">ugrad</option>
      <option value="grad">grad</option>
    </select><br><br>
    <input type ="submit" value="UPDATE" style="color:white; background-color:#ffa700;">
    </div>
  </div>
</center>
</form>

</body></html>
