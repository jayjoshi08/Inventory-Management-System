<%-- 
    Document   : manageAdmins
    Created on : 29 Mar, 2025, 9:14:04 AM
    Author     : jayjo
--%>

<%@ page session="true" %>
<%@ page import="java.io.*, java.util.*, java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="dao.ConnectionProvider" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?error=no session is created");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Manage Admins</title>
        <link rel="icon" type="image/png" href="images/inventory.jpg">
        <link rel="stylesheet" type="text/css" href="admins.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <script src="showMessage.js"></script>
        <script>
            function populateForm(id, name, mobile, email, address, password, status) {
                document.getElementById('appuserPK').value = id;
                document.getElementById('name').value = name;
                document.getElementById('mobileNumber').value = mobile;
                document.getElementById('email').value = email;
                document.getElementById('address').value = address;
                document.getElementById('password').value = password;
                document.getElementById('status').value = status;
                document.getElementById('saveButton').disabled = true;
                document.getElementById('updateButton').disabled = false;
                document.getElementById('deleteButton').disabled = false;

            }

            function validateForm() {
                let name = document.getElementById('name').value.trim();
                let mobileNumber = document.getElementById('mobileNumber').value.trim();
                let email = document.getElementById('email').value.trim();

                // Name validation: At least 3 words
                let nameWords = name.split(/\s+/).filter(word => word.length > 0);
                if (nameWords.length < 3) {
                    alert('Name must contain at least 3 words.');
                    return false;
                }

                // Mobile number validation: Exactly 10 digits
                if (!/^\d{10}$/.test(mobileNumber)) {
                    alert('Mobile number must be exactly 10 digits.');
                    return false;
                }

                // Email validation: Proper format using a regular expression
                let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Invalid email format.');
                    return false;
                }

                return true; // Form is valid
            }
        </script>

    </head>
    <body>
        <h1>Manage Admin</h1>
        <div class="container">
            <div class="left-panel">
                <h3>Current Admins</h3>
                <table border="1">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Mobile Number</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Password</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Connection con = ConnectionProvider.getConnection();
                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM appuser where userRole = 'Admin'");
                                while (rs.next()) {
                        %>
                        <tr onclick="populateForm('<%= rs.getInt("appuser_pk")%>', '<%= rs.getString("name")%>', '<%= rs.getString("mobileNumber")%>', '<%= rs.getString("email")%>', '<%= rs.getString("address")%>', '<%= rs.getString("password")%>', '<%= rs.getString("status")%>')">
                            <td><%= rs.getInt("appuser_pk")%></td>
                            <td><%= rs.getString("name")%></td>
                            <td><%= rs.getString("mobileNumber")%></td>
                            <td><%= rs.getString("email")%></td>
                            <td><%= rs.getString("address")%></td>
                            <td><%= rs.getString("password")%></td>
                            <td><%= rs.getString("status")%></td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="right-panel">
                <form action="AdminServlet" method="POST" onsubmit="return validateForm()">
                    <label>ID</label>
                    <input type="number" name="appuserPK" id="appuserPK" min="1" readonly>
                    <label>Name</label>
                    <input type="text" name="name" id="name" required>
                    <label>Mobile Number</label>
                    <input type="text" name="mobileNumber" id="mobileNumber" required>
                    <label>Email</label>
                    <input type="email" name="email" id="email" required>
                    <label>Address</label>
                    <input type="text" name="address" id="address" required>
                    <label>Password</label>
                    <input type="password" name="password" id="password" required>
                    <label>Status</label>

                    <select name="status" id="status">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                    <div class="button-group">
                        <button type="submit" name="action" value="save" id="saveButton">Save</button>
                        <button type="submit" name="action" value="update" id="updateButton" disabled>Update</button>
                        <button type="reset" onclick="resetForm()">Reset</button>
                        <button type="submit" name="action" value="delete" id="deleteButton" disabled>Delete</button>
                        <button type="button" onclick="location.href = 'home.jsp'">Close</button>
                    </div>
                </form>
            </div>
        </div>
        <p>
            Inventory Management System, &copy;
            <script>
                function resetForm() {
                    document.getElementById('saveButton').disabled = false;
                    document.getElementById('updateButton').disabled = true;
                    document.getElementById('deleteButton').disabled = true;
                }

                document.write(new Date().getFullYear());
            </script>
            All rights reserved by Jay Joshi and Janmay Patel.
        </p>
    </body>
</html>
