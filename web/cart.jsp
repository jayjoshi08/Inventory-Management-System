<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.ConnectionProvider" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Cart</title>
        <link rel="icon" type="image/png" href="images/inventory.jpg">
        <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <link rel="stylesheet" href="cart.css" />
        <script src="cart.js"></script>
    </head>
    <body>
        <h1>Customer's Cart</h1>
        <div class="container">
            <div class="cart-section">
                <div class="customer-list">
                    <h3>Select Customer</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Mobile Number</th>
                                <th>Email</th>
                                <th>Address</th>
                            </tr>
                        </thead>
                        <tbody id="customerListBody">
                            <%
                                try {
                                    Connection con = ConnectionProvider.getConnection();
                                    PreparedStatement ps = con.prepareStatement("SELECT * FROM customer");
                                    ResultSet rs = ps.executeQuery();
                                    while (rs.next()) {
                            %>
                            <tr onclick="populateCustomerForm('<%= rs.getInt("customer_pk")%>',
                                            '<%= rs.getString("name")%>',
                                            '<%= rs.getString("mobileNumber")%>',
                                            '<%= rs.getString("email")%>',
                                            '<%= rs.getString("address")%>')">
                                <td><%= rs.getInt("customer_pk")%></td>
                                <td><%= rs.getString("name")%></td>
                                <td><%= rs.getString("mobileNumber")%></td>
                                <td><%= rs.getString("email")%></td>
                                <td><%= rs.getString("address")%></td>
                            </tr>
                            <%
                                    }
                                    rs.close();
                                    ps.close();
                                    con.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <div class="product-list">
                    <h3>Available Products</h3>
                    <table>
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
                                <th>Category Name</th>
                            </tr>
                        </thead>
                        <tbody id="productListBody">
                            <%
                                try {
                                    Connection con = ConnectionProvider.getConnection();
                                    PreparedStatement ps = con.prepareStatement("SELECT p.*, c.name AS category_name FROM product p INNER JOIN category c ON p.category_fk = c.category_pk");
                                    ResultSet rs = ps.executeQuery();
                                    while (rs.next()) {
                            %>
                            <tr onclick="populateProductForm('<%= rs.getInt("product_pk")%>',
                                            '<%= rs.getString("product_name")%>',
                                            '<%= rs.getString("build_number")%>',
                                            '<%= rs.getString("company_name")%>',
                                            '<%= rs.getString("product_type")%>',
                                            '<%= rs.getInt("quantity")%>',
                                            '<%= rs.getDouble("price")%>',
                                            '<%= rs.getString("description")%>',
                                            '<%= rs.getString("category_name")%>')">
                                <td><%= rs.getInt("product_pk")%></td>
                                <td><%= rs.getString("product_name")%></td>
                                <td><%= rs.getString("build_number")%></td>
                                <td><%= rs.getString("company_name")%></td>
                                <td><%= rs.getString("product_type")%></td>
                                <td><%= rs.getInt("quantity")%></td>
                                <td><%= rs.getDouble("price")%></td>
                                <td><%= rs.getString("description")%></td>
                                <td><%= rs.getString("category_name")%></td>
                            </tr>
                            <%
                                    }
                                    rs.close();
                                    ps.close();
                                    con.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="cart-form-container">
                <h3>Add to Cart</h3>
                <form id="cartForm" action="CartServlet" method="post">
                    <input type="hidden" name="action" value="addToCart">
                    <input type="hidden" name="customer_fk" id="customer_fk" readonly required>

                    <label for="customer_name">Customer Name:</label>
                    <input type="text" name="customer_name" id="customer_name" readonly>

                    <label for="mobile_number">Mobile Number:</label>
                    <input type="text" name="mobile_number" id="mobile_number" readonly>

                    <label for="email">Email:</label>
                    <input type="text" name="email" id="email" readonly>

                    <label for="address">Address:</label>
                    <input type="text" name="address" id="address" readonly>

                    <input type="hidden" name="product_fk" id="product_fk" readonly>
                    <label for="product_name">Product Name:</label>
                    <input type="text" name="product_name" id="product_name" readonly>

                    <input type="hidden" name="category_fk" id="category_fk" readonly>
                    <label for="category_name">Category Name:</label>
                    <input type="text" name="category_name" id="category_name" readonly>

                    <label for="build_number">Build Number:</label>
                    <input type="text" name="build_number" id="build_number" readonly>

                    <label for="company_name">Company Name:</label>
                    <input type="text" name="company_name" id="company_name" readonly>

                    <label for="product_type">Product Type:</label>
                    <input type="text" name="product_type" id="product_type" readonly>

                    <label for="quantity">Quantity:</label>
                    <input type="number" name="quantity" id="quantity" value="1" min="1" required>

                    <label for="price">Price per Unit:</label>
                    <input type="text" name="price" id="price" readonly>

                    <label for="description">Description:</label>
                    <textarea name="description" id="description" readonly></textarea>

                    <button type="submit">Add to Cart</button>
                    <div class="button-group">
                        <button type="button" onclick="viewCart()">View Cart / Place Order</button>
                        <button type="reset" onclick="resetForm()">Reset</button>
                        <button type="button" onclick="window.location.href = 'home.jsp';">Close</button>
                    </div>
                </form>
            </div>
        </div>
        <p>
            Inventory Management System, &copy;
            <script>
                document.write(new Date().getFullYear());
            </script>
            All rights reserved by Jay Joshi and Janmay Patel.
        </p>
    </body>
</html>