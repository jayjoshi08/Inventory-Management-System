<%-- 
    Document   : category
    Created on : 29 Mar, 2025, 2:52:39 PM
    Author     : jayjo
--%>
<%--
    Document    : category
    Created on : 29 Mar, 2025, 2:52:39 PM
    Author      : jayjo
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="dao.ConnectionProvider" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Category</title>
    <link rel="icon" type="image/png" href="images/inventory.jpg">
    <link rel="stylesheet" type="text/css" href="category.css">
    <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
    />
    <script src="showMessage.js"></script>
    <script>
        function populateForm(id, name) {
            document.getElementById('categoryPK').value = id;
            document.getElementById('categoryName').value = name;
            document.getElementById('saveButton').disabled = true;
            document.getElementById('updateButton').disabled = false;
        }
        </script>
</head>
<body>
<h2>Manage Category</h2>
<div class="container">
    <div class="category-list">
        <h3>Existing Categories</h3>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                try {
                    Connection con = ConnectionProvider.getConnection();
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM category");
                    while (rs.next()) {
            %>
            <tr onclick="populateForm('<%= rs.getInt("category_pk")%>', '<%= rs.getString("name")%>')">
                <td><%= rs.getInt("category_pk")%></td>
                <td><%= rs.getString("name")%></td>
                <td>
                    <a href="CategoryServlet?action=delete&id=<%= rs.getInt("category_pk")%>">Delete</a>
                </td>
            </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("Error: " + e.getMessage());
                }
            %>
            </tbody>
        </table>
    </div>
    <div class="category-form">
        <form action="CategoryServlet" method="post">
            <input type="hidden" id="categoryPK" name="categoryPK">
            <div class="form-group">
                <label for="categoryName">Name</label>
                <input type="text" id="categoryName" name="categoryName" required>
            </div>
            <div class="button-group">
                <button type="submit" id="saveButton" name="action" value="add">Save</button>
                <button type="submit" name="action" value="update" id = "updateButton" disabled>Update</button>
                <button type="reset" onclick="resetForm()">Reset</button>
                <button type="button" onclick="window.location.href = 'home.jsp'">Close</button>
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
            }

                document.write(new Date().getFullYear());
            </script>
            All rights reserved by Jay Joshi and Janmay Patel.
        </p>
</body>
</html>