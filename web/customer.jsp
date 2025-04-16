<%-- 
    Document   : customer
    Created on : 30 Mar, 2025, 1:30:23 AM
    Author     : jayjo
--%>
<%@ page import="java.sql.*" %>
<%@ page import="dao.ConnectionProvider" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Customer Management</title>
        <link rel="icon" type="image/png" href="images/inventory.jpg">
        <link rel="stylesheet" type="text/css" href="customer.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <script src="showMessage.js"></script>
        <script>
            function populateForm(id, name, phone, email, address) {
                document.getElementById('customerId').value = id;
                document.getElementById('customerName').value = name;
                document.getElementById('customerPhone').value = phone;
                document.getElementById('customerEmail').value = email;
                document.getElementById('customerAddress').value = address;

                document.getElementById('saveButton').disabled = true;
                document.getElementById('updateButton').disabled = false;
            }
             function validateForm() {
                let customerName = document.getElementById('customerName').value.trim();
                let customerPhone = document.getElementById('customerPhone').value.trim();
                let customerEmail = document.getElementById('customerEmail').value.trim();

                // Name validation: At least 3 words
                let nameWords = customerName.split(/\s+/).filter(word => word.length > 0);
                if (nameWords.length < 3) {
                    alert('Name must contain at least 3 words.');
                    return false;
                }

                // Mobile number validation: Exactly 10 digits
                if (!/^\d{10}$/.test(customerPhone)) {
                    alert('Mobile number must be exactly 10 digits.');
                    return false;
                }

                // Email validation: Proper format using a regular expression
                let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(customerEmail)) {
                    alert('Invalid email format.');
                    return false;
                }

                return true; // Form is valid
            }
        </script>
    </head>
    <body>
        <h2>Customer Management</h2>
        <div class="container">
            <div class="customer-table-container">
                <h3>Existing Customers</h3>
                <table border="1">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Mobile Number</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection con = ConnectionProvider.getConnection();
                            PreparedStatement ps = con.prepareStatement("SELECT * FROM customer");
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                        %>

                        <tr onclick="populateForm('<%= rs.getInt("customer_pk")%>',
                                        '<%= rs.getString("name")%>',
                                        '<%= rs.getString("mobileNumber")%>',
                                        '<%= rs.getString("email")%>',
                                        '<%= rs.getString("address")%>')">
                            <td><%= rs.getInt("customer_pk")%></td>
                            <td><%= rs.getString("name")%></td>
                            <td><%= rs.getString("mobileNumber")%></td>
                            <td><%= rs.getString("email")%></td>
                            <td><%= rs.getString("address")%></td>
                            <td>
                                <a href="CustomerServlet?action=delete&id=<%= rs.getInt("customer_pk")%>">Delete</a>
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
            <div class="customer-form">
                <form action="CustomerServlet" method="post" id="customerForm">
                    <input type="hidden" name="customerId" id="customerId">

                    <label>Name:</label>
                    <input type="text" name="customerName" id="customerName" required>

                    <label>Phone:</label>
                    <input type="text" name="customerPhone" id="customerPhone" required>

                    <label>Email:</label>
                    <input type="email" name="customerEmail" id="customerEmail" required>


                    <label>Address:</label>
                    <textarea name="customerAddress" id="customerAddress" required></textarea>

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