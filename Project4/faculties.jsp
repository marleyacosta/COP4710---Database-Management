<%@ page import="java.sql.*" %>

<%
String connectionURL =
"jdbc:postgresql://cop4710-postgresql.cs.fiu.edu:5432/fall16_macos101?user=fall16_macos101&password=3914479";

Connection connection = null;
Statement statement = null;
ResultSet rs = null;
%>
<html><body>

<h1 style="text-align:center; background-color:  #673ab7; color: white;">Faculty Table</h1>
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
                         "SELECT * FROM faculties WHERE LOWER(Name) = ?"); // ? = placeholder
  ps.setString(1, name); // Bind the value to the placeholder
  rs = ps.executeQuery(); // Execute the prepared statement and fetch results
} else {
    rs = statement.executeQuery("SELECT * FROM faculties");
}

// INSERT QUERY
String insertid = request.getParameter("insert-faculty-id");
String name1 = request.getParameter("insert-faculty-name");
String bday = request.getParameter("insert-faculty-bday");
String address = request.getParameter("insert-faculty-address");
String email = request.getParameter("insert-faculty-email");
String level = request.getParameter("insert-faculty-level");

boolean insertRequest = (insertid != null && insertid != "") && (name1 != null && name1 != "") && (bday != null && bday != "") &&
(address != null && address != "") && (email != null && email != "") && (level != null && level != "");

if(insertRequest){
PreparedStatement pst = connection.prepareStatement("INSERT into faculties VALUES(?, ?, ?, ?, ?, ?)");

      pst.setInt(1, Integer.parseInt(insertid));
      pst.setString(2, name1);
      pst.setString(3, bday);
      pst.setString(4, address);
      pst.setString(5, email);
      pst.setString(6, level);


      if(pst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM faculties");
               }
               else{
                 out.println("failed to insert the data");
                }
      pst.close();
}
// DELETE QUERY
String delemail = request.getParameter("del-faculty-id");
boolean idTest = (delemail != null) && (delemail != "");
if(idTest){
PreparedStatement delpst = connection.prepareStatement("DELETE FROM faculties WHERE faculty_id = ?");

      delpst.setInt(1, Integer.parseInt(delemail));

      if(delpst.executeUpdate()!=0){
                 rs = statement.executeQuery("SELECT * FROM faculties");
               }
               else{
                 out.println("failed to delete the data");
                }
      delpst.close();
}

// UPDATE QUERY
String insertid1 = request.getParameter("update-faculty-id");
String name2 = request.getParameter("update-faculty-name");
String bday1 = request.getParameter("update-faculty-bday");
String address1 = request.getParameter("update-faculty-address");
String email1 = request.getParameter("update-faculty-email");
String level1 = request.getParameter("update-faculty-level");

boolean updateID = (insertid1 != null && insertid1 != "");
boolean updateName2 = (name2 != null && name2 != "");
boolean updateBday =  (bday1 != null && bday1 != "");
boolean updateAddress1 = (address1 != null && address1 != "");
boolean updateEmail1 = (email1 != null && email1 != "");
boolean updateLevel1 =  (level1 != null && level1 != "");

boolean executeQuery = updateID && updateName2 && updateBday && updateAddress1 && updateEmail1 && updateLevel1;


if(executeQuery){

  PreparedStatement updatepst = connection.prepareStatement("UPDATE faculties SET name = ? , date_of_birth = ? , address = ? , email = ? , level = ? WHERE faculty_id = ?");

      updatepst.setString(1, name2);
      updatepst.setString(2, bday1);
      updatepst.setString(3, address1);
      updatepst.setString(4, email1);
      updatepst.setString(5, level1);
      updatepst.setInt(6, Integer.parseInt(insertid1));

      if(updatepst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM faculties");
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
  <input type="text" name="Name" placeholder="Search By Name">
  <input type ="submit" value="SEARCH" style="color:white; background-color:#0057e7"><br><br>
  </div>

  <div>
    <!-- DELETE FORM-->
    <input type="number" name ="del-faculty-id" min="1" placeholder="Enter Faculty ID">
    <input type ="submit" value="DELETE" style="color:white; background-color:#d62d20;"> <br><br>
    </div>
    </center>

  </div>
  <center>
    <!-- INSERT FORM-->
    <div style="width:100%;">
    <div style="float:left;width:50%;">
    <input type="number" name ="insert-faculty-id" min="1" placeholder="Enter Faculty ID"><br><br>
    <input type="text" name ="insert-faculty-name" placeholder="Enter Faculty Name"><br><br>
    <input type="text" name ="insert-faculty-bday" placeholder="Enter Faculty Birthday"><br><br>
    <input type="text" name ="insert-faculty-address" placeholder="Enter Faculty Address"><br><br>
    <input type="text" name ="insert-faculty-email" placeholder="Enter Faculty Email"><br><br>
    Select Faculty Level:
    <select name ="insert-faculty-level">
      <option value="ugrad">ugrad</option>
      <option value="grad">grad</option>
    </select><br><br>
    <input type ="submit" value="INSERT" style="color:white; background-color:#008744;"><br><br><br>
    </div>


    <!-- UPDATE FORM-->
    <div style="float:right;width:50%;">
    <input type="number" name ="update-faculty-id" min="1" placeholder="Enter Faculty ID"><br><br>
    <input type="text" name ="update-faculty-name" placeholder="Enter Faculty Name"><br><br>
    <input type="text" name ="update-faculty-bday" placeholder="Enter Faculty Birthday"><br><br>
    <input type="text" name ="update-faculty-address" placeholder="Enter Faculty Address"><br><br>
    <input type="text" name ="update-faculty-email" placeholder="Enter Faculty Email"><br><br>
    Enter Faculty Level:
    <select name ="update-faculty-level">
      <option value="ugrad">ugrad</option>
      <option value="grad">grad</option>
    </select><br><br>
    <input type ="submit" value="UPDATE" style="color:white; background-color:#ffa700">
    </div>
  </div>
</center>
</form>

</body></html>
