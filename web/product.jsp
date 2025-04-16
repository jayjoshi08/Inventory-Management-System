<%-- 
    Document   : customer
    Created on : 29 Mar, 2025, 11:30:23 PM
    Author     : jayjo
--%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.ConnectionProvider" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Management</title>
        <link rel="icon" type="image/png" href="images/inventory.jpg">
        <link rel="stylesheet" type="text/css" href="product.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <script src="showMessage.js"></script>
        <script>
            function populateForm(id, name, buildNumber, company, type, quantity, price, description, categoryId) {
                document.getElementById('productId').value = id;
                document.getElementById('productName').value = name;
                document.getElementById('buildNumber').value = buildNumber;
                document.getElementById('companyName').value = company;
                document.getElementById('productType').value = type;
                document.getElementById('quantity').value = quantity;
                document.getElementById('price').value = price;
                document.getElementById('description').value = description;
                document.getElementById('category').value = categoryId;

                document.getElementById('saveButton').disabled = true; // Disable Save button when editing
                document.getElementById('updateButton').disabled = false; // Enable Update button
            }
        </script>
    </head>
    <body>
        <h2>Product Management</h2>
        <div class="container">
            <div class="product-table-container">
                <h3>Available Products</h3>
                <div class="table-wrapper">
                <table border="1">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Product Name</th>
                        <th>Build Number</th>
                        <th>Company</th>
                        <th>Type</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Description</th>
                        <th>Category ID</th>
                        <th>Category Name</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    
                    <%
                        Connection con = ConnectionProvider.getConnection();
                        PreparedStatement ps = con.prepareStatement("SELECT * FROM product INNER JOIN category ON product.category_fk = category.category_pk");
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                    %>
                    <tr onclick="populateForm('<%= rs.getInt("product_pk")%>',
                                    '<%= rs.getString("product_name")%>',
                                    '<%= rs.getString("build_number")%>',
                                    '<%= rs.getString("company_name")%>',
                                    '<%= rs.getString("product_type")%>',
                                    '<%= rs.getString("quantity")%>',
                                    '<%= rs.getDouble("price")%>',
                                    '<%= rs.getString("description")%>',
                                    '<%= rs.getInt("category_fk")%>')">
                        <td><%= rs.getInt("product_pk")%></td>
                        <td><%= rs.getString("product_name")%></td>
                        <td><%= rs.getString("build_number")%></td>
                        <td><%= rs.getString("company_name")%></td>
                        <td><%= rs.getString("product_type")%></td>
                        <td><%= rs.getString("quantity")%></td>
                        <td><%= rs.getDouble("price")%></td>
                        <td><%= rs.getString("description")%></td>
                        <td><%= rs.getInt("category_fk")%></td>
                        <td><%= rs.getString("name")%></td>
                        <td>
                            <a href="ProductServlet?action=delete&id=<%= rs.getInt("product_pk")%>">Delete</a>
                        </td>
                    </tr>
                    <%
                        }
                        rs.close();
                        ps.close();
                        con.close();
                    %>
                    </tbody>
                </table>
                </div>
            </div>

            <div class="product-form">
                <form action="ProductServlet" method="post" id="productForm">
                    <input type="hidden" name="productId" id="productId">

                    <label>Product Name:</label>
                    <input type="text" name="productName" id="productName" required>

                    <label>Build/Manufacturing Number:</label>
                    <input type="text" name="buildNumber" id="buildNumber" required>

                    <label>Company Name:</label>
                    <input type="text" name="companyName" id="companyName" required>

                    <label>Product Type:</label>
                    <input type="text" name="productType" id="productType" required>

                    <label>Quantity:</label>
                    <input type="number" name="quantity" id="quantity" min="1" required>

                    <label>Price:</label>
                    <input type="number" name="price" id="price" min="1" required>

                    <label>Description:</label>
                    <textarea name="description" id="description" required></textarea>

                    <label>Category:</label>
                    <select name="category" id="category" required>
                        <%
                            con = ConnectionProvider.getConnection();
                            ps = con.prepareStatement("SELECT category_pk, name FROM category");
                            ResultSet rsCat = ps.executeQuery();
                            while (rsCat.next()) {
                        %>
                        <option value="<%= rsCat.getInt("category_pk")%>"><%= rsCat.getString("name")%></option>
                        <%
                            }
                            rsCat.close();
                            ps.close();
                            con.close();
                        %>
                    </select>

                    <div class="button-group">
                        <button type="submit" name="action" value="add" id="saveButton">Save</button>
                        <button type="submit" name="action" value="update" id="updateButton" disabled>Update</button>
                        <button type="reset" onclick="resetForm()">Reset</button>
                        <button type="button" onclick="window.location.href = 'home.jsp';">Close</button>
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
