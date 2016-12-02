<%@ page import="java.sql.*" %>

<%
String connectionURL =
"jdbc:postgresql://cop4710-postgresql.cs.fiu.edu:5432/fall16_macos101?user=fall16_macos101&password=3914479";

Connection connection = null;
Statement statement = null;
ResultSet rs = null;
%>
<html><body>
<h1 style="text-align:center; background-color: #ff5722; color: white;">Courses Table</h1>
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
            <th>Description</th>
            <th>Level</th>
            <th>Instructor</th>
            <th>Semester</th>
        </tr>
    </thead>
<%
Class.forName("org.postgresql.Driver").newInstance();
connection = DriverManager.getConnection(connectionURL);
statement = connection.createStatement();
String Description = request.getParameter("Description");
if(Description != null){Description = Description.toLowerCase();}
if (Description != null && Description.length() > 0) {
  PreparedStatement ps = connection.prepareStatement(
                         "SELECT * FROM Courses WHERE LOWER(Description) = ?"); // ? = placeholder
  ps.setString(1, Description); // Bind the value to the placeholder
  rs = ps.executeQuery(); // Execute the prepared statement and fetch results
} else {
    rs = statement.executeQuery("SELECT * FROM Courses");
}

// INSERT QUERY

String insertid = request.getParameter("insert-course-id");
String insertDescription = request.getParameter("insert-description");
String insertLevel = request.getParameter("insert-level");
String insertInstructor = request.getParameter("insert-instructor");
String insertSemester = request.getParameter("insert-semester");


boolean insertID = (insertid != null && insertid != "");
boolean insertdes = (insertDescription != null && insertDescription != "");
boolean insertle = (insertLevel != null && insertLevel != "");
boolean insertIns =  (insertInstructor != null && insertInstructor != "");
boolean insertSes = (insertSemester != null && insertSemester != "");

boolean insertRequest = insertID && insertdes && insertle && insertIns && insertSes;

if(insertRequest){
PreparedStatement pst = connection.prepareStatement("INSERT into Courses VALUES(?, ?, ?, ?, ?)");

      pst.setInt(1, Integer.parseInt(insertid));
      pst.setString(2, insertDescription);
      pst.setString(3, insertLevel);
      pst.setInt(4, Integer.parseInt(insertInstructor));
      pst.setString(5, insertSemester);

      if(pst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM Courses");
               }
               else{
                 out.println("failed to insert the data");
                }
      pst.close();
}

// DELETE QUERY
String delcourseid = request.getParameter("delete-course-id");
boolean idTest = (delcourseid != null) && (delcourseid != "");
if(idTest){
PreparedStatement delpst = connection.prepareStatement("DELETE FROM Courses WHERE course_id = ?");

      delpst.setInt(1, Integer.parseInt(delcourseid));

      if(delpst.executeUpdate()!=0){
                 rs = statement.executeQuery("SELECT * FROM Courses");
               }
      else{
        out.println("failed to delete the data");
        }
      delpst.close();
}

// UPDATE QUERY
String insertid1 = request.getParameter("update-course-id");
String updateDescription = request.getParameter("update-description");
String updateLevel = request.getParameter("update-level");
String updateInstructor = request.getParameter("update-instructor");
String updateSemester = request.getParameter("update-semester");

boolean updateID = (insertid1 != null && insertid1 != "");
boolean updateDes = (updateDescription != null && updateDescription != "");
boolean updateLev =  (updateLevel != null && updateLevel != "");
boolean updateIns = (updateInstructor != null && updateInstructor != "");
boolean updateSemes = (updateSemester != null && updateSemester != "");


boolean executeQuery = updateID && updateDes && updateLev && updateIns && updateSemes;


if(executeQuery){

  PreparedStatement updatepst = connection.prepareStatement("UPDATE Courses SET description = ? , level = ? , semester = ? WHERE course_id = ? AND instructor = ?");


      updatepst.setString(1, updateDescription);
      updatepst.setString(2, updateLevel);
      updatepst.setString(3, updateSemester);
      updatepst.setInt(4, Integer.parseInt(insertid1));
      updatepst.setInt(5, Integer.parseInt(updateInstructor));


      if(updatepst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM Courses");
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
        <!-- Search FORM -->
        <div style="width:100%;">
        <center>
        <div style="margin:0 auto;display: inline-block;width:50%;">
        <input type="text" name ="Description" placeholder="Search By Description">
        <input type ="submit" value="SEARCH" style="color:white; background-color:#0057e7"> <br><br><br>
        </div>

        <div>
          <!-- DELETE FORM-->

          <input type="number" name ="delete-course-id" placeholder="Enter Course ID">
          <input type ="submit" value="DELETE" style="color:white; background-color:#d62d20;"> <br><br><br>

        </div>
        </center>


      </div>
      <center>
        <!-- INSERT FORM-->
        <div style="width:100%;">
        <div style="float:left;width:50%;">
        <input type="number" name ="insert-course-id" min="1" placeholder="Enter Course ID"><br><br>
         <input type="text" name ="insert-description" placeholder="Enter Description:"><br><br>
        Select Level:
        <select name ="insert-level">
          <option value="ugrad">ugrad</option>
          <option value="grad">grad</option>
        </select><br><br>
        <input type="number" name ="insert-instructor" placeholder="Enter Instructor"><br><br>
        <input type="text" name ="insert-semester" placeholder="Enter Semester"><br><br>
        <input type ="submit" value="INSERT" style="color:white; background-color:#008744;"><br><br><br>
        </div>



        <!-- UPDATE FORM-->
        <div style="float:right;width:50%;">
        <input type="number" name ="update-course-id" min="1" placeholder="Enter Course ID"><br><br>
        <input type="text" name ="update-description" placeholder="Enter Description"><br><br>
        Select Level:
        <select name ="update-level">
          <option value="ugrad">ugrad</option>
          <option value="grad">grad</option>
        </select><br><br>
        <input type="number" name ="update-instructor" placeholder="Enter Instructor"><br><br>
        <input type="text" name ="update-semester" placeholder="Enter Semester"><br><br>
        <input type ="submit" value="UPDATE" style="color:white; background-color:#ffa700;">
        </div>
      </div>
    </center>
    </form>

</body></html>
