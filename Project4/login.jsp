
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Project4 Login</title>
    </head>
    <body>
        <form method="post" action="validate.jsp">
            <center>
            <table border="1" cellpadding="5" cellspacing="2" bgcolor = "#9ccc65">
                <thead>
                    <tr>
                        <th colspan="2">Login Page</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Username</td>
                        <td><input type="text" name="username" required/></td>
                    </tr>
                    <tr>
                        <td>Password</td>
                        <td><input type="password" name="password" required/></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center"><input type="submit" value="LOGIN" />
                            &nbsp;&nbsp;
                        </td>
                    </tr>
                </tbody>
            </table>
            </center>
        </form>
    </body>
</html>
