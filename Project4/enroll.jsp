<%@ page import="java.sql.*" %>

<%
String connectionURL =
"jdbc:postgresql://cop4710-postgresql.cs.fiu.edu:5432/fall16_macos101?user=fall16_macos101&password=???????";

Connection connection = null;
Statement statement = null;
ResultSet rs = null;
%>
<html><body>
<h1 style="text-align:center; background-color: #2962ff; color: white;">Enroll Table</h1>
<button type="button" style="background-color:  #ff9800;" name="back" onclick="history.back()">GO BACK TO PREVIOUS PAGE</button><br><br>
<form action="homepage.jsp">
  <input type ="submit" value="GO BACK TO HOMEPAGE" style="background-color: #8bc34a">
</form>
<center>
<div style="height:54%; overflow:auto">
<table  style="text-align:center" border = "2">
    <thead bgcolor = "#e0e0e0">
        <tr>
            <th>Student ID</th>
            <th>Course ID</th>
            <th>Grade</th>
        </tr>
    </thead>
<%
Class.forName("org.postgresql.Driver").newInstance();
connection = DriverManager.getConnection(connectionURL);
statement = connection.createStatement();

String studentid = request.getParameter("search-student-id");

if (studentid != null && studentid.length() > 0) {
  PreparedStatement ps = connection.prepareStatement(
                         "SELECT * FROM Enroll WHERE student_id = ?"); // ? = placeholder
  ps.setInt(1, Integer.parseInt(studentid)); // Bind the value to the placeholder
  rs = ps.executeQuery(); // Execute the prepared statement and fetch results
} else {
    rs = statement.executeQuery("SELECT * FROM Enroll");
}

// INSERT QUERY
String insertstudentid = request.getParameter("insert-student-id");
String insertcourseid = request.getParameter("insert-course-id");
String grade = request.getParameter("insert-grade");


boolean insertRequest = (insertstudentid != null && insertstudentid != "") &&
(insertcourseid != null && insertcourseid != "") && (grade != null && grade != "");

if(insertRequest){
PreparedStatement pst = connection.prepareStatement("INSERT into Enroll VALUES(?, ?, ?)");

      pst.setInt(1, Integer.parseInt(insertstudentid));
      pst.setInt(2, Integer.parseInt(insertcourseid));
      pst.setString(3, grade);


      if(pst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM Enroll");
               }
               else{
                 out.println("failed to insert the data");
                }
      pst.close();
}
// DELETE QUERY
String delstudentid = request.getParameter("del-student-id");
String delcourseid = request.getParameter("del-course-id");

boolean idTest = (delstudentid != null && delstudentid != "") && (delcourseid != null && delcourseid != "");

if(idTest){
PreparedStatement delpst = connection.prepareStatement("DELETE FROM Enroll WHERE student_id = ? AND course_id = ?");

      delpst.setInt(1, Integer.parseInt(delstudentid));
      delpst.setInt(2, Integer.parseInt(delcourseid));

      if(delpst.executeUpdate()!=0){
                 rs = statement.executeQuery("SELECT * FROM Enroll");
               }
               else{
                 out.println("failed to delete the data");
                }
      delpst.close();
}

// UPDATE QUERY
String updateCourseID = request.getParameter("update-course-id");
String updateStudentID = request.getParameter("update-student-id");
String updateGrade = request.getParameter("update-grade");

boolean courseID = (updateCourseID != null && updateCourseID != "");
boolean studentID = (updateStudentID != null && updateStudentID != "");
boolean gradeTest =  (updateGrade != null && updateGrade != "");

boolean executeQuery = courseID && studentID && gradeTest;


if(executeQuery){

  PreparedStatement updatepst = connection.prepareStatement("UPDATE Enroll SET grade = ? WHERE student_id = ? AND course_id = ?");

      updatepst.setString(1, updateGrade);
      updatepst.setInt(2, Integer.parseInt(updateStudentID));
      updatepst.setInt(3, Integer.parseInt(updateCourseID));


      if(updatepst.executeUpdate() != 0){
                 rs = statement.executeQuery("SELECT * FROM Enroll");
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
    <center>
    <input type="number" name="search-student-id" min="1" placeholder="Search By Student ID">
    <input type ="submit" value="SEARCH" style="color:white; background-color:#0057e7"><br><br><br>
    </center>

      <!-- INSERT FORM -->
      <div style="width:100%;">
      <div style="float:left;width:33.33%;">
      <input type="number" name ="insert-student-id" min="1" placeholder="Enter Student ID"><br><br>
      <input type="number" name ="insert-course-id" min="1" placeholder="Enter Course ID"><br><br>
      Enter Grade:
      <select name ="insert-grade">
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
        <option value="D">D</option>
        <option value="F">F</option>
      </select><br><br>
      <input type ="submit" value="INSERT" style="color:white; background-color:#008744;">

    </div>

      <!-- DELETE FORM-->
      <div style="margin:0 auto;display: inline-block;width:33.33%;">
      <input type="number" name ="del-student-id" min="1" placeholder="Enter Student ID"><br><br>
      <input type="number" name ="del-course-id" min="1" placeholder="Enter Course ID"><br><br>
      <input type ="submit" value="DELETE" style="color:white; background-color:#d62d20">
      </div>

      <!-- UPDATE FORM-->
      <div style="float:right;width:33.33%;">
      <input type="number" name ="update-student-id" min="1" placeholder="Enter Student ID"><br><br>
      <input type="number" name ="update-course-id" min="1" placeholder="Enter Course ID"><br><br>

      Enter Grade:
      <select name ="update-grade">
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
        <option value="D">D</option>
        <option value="F">F</option>
      </select><br><br>
      <input type ="submit" value="UPDATE" style="color:white; background-color:#ffa700">
      </div>
    </div>
  </form>

</body></html>
