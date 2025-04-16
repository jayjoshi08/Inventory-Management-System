<%@ page import="java.sql.*, dao.ConnectionProvider" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>View Orders</title>
        <link rel="icon" type="image/png" href="images/inventory.jpg">
        <link rel="stylesheet" href="viewOrder.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script>
            function loadOrderDetails(customerId) {
                let xhr = new XMLHttpRequest();
                xhr.open("GET", "GetOrderDetailsServlet?customerId=" + customerId, true);
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        document.getElementById("orderDetailsBody").innerHTML = xhr.responseText;
                        attachOrderClickListener();
                    }
                };
                xhr.send();
            }

            function openOrderPdf(orderId) {
                // Redirect the browser to a Servlet that handles PDF loading
                window.location.href = "ViewOrderPdfServlet?orderId=" + orderId;
            }

            function attachOrderClickListener() {
                const orderRows = document.querySelectorAll('#orderDetailsBody tr');
                orderRows.forEach(row => {
                    row.addEventListener('click', function () {
                        const orderId = this.querySelector('td:first-child').textContent;
                        openOrderPdf(orderId);
                    });
                    row.style.cursor = 'pointer';
                });
            }
        </script>
    </head>
    <body>
        <h1>Customer's Order Details</h1>
        <div class="container">
            <div class="customer-table-container">
                <h3>Existing Customers</h3>
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
                    <tbody>
                        <%
                            Connection con = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            try {
                                con = ConnectionProvider.getConnection();
                                ps = con.prepareStatement("SELECT customer_pk, name, mobileNumber, email, address FROM customer");
                                rs = ps.executeQuery();
                                while (rs.next()) {
                        %>
                        <tr onclick="loadOrderDetails(<%= rs.getInt("customer_pk")%>)">
                            <td><%= rs.getInt("customer_pk")%></td>
                            <td><%= rs.getString("name")%></td>
                            <td><%= rs.getString("mobileNumber")%></td>
                            <td><%= rs.getString("email")%></td>
                            <td><%= rs.getString("address")%></td>
                        </tr>
                        <%
                                }
                            } catch (SQLException e) {
                                out.println("<tr><td colspan='5'>Error loading customers: " + e.getMessage() + "</td></tr>");
                                e.printStackTrace();
                            } finally {
                                if (rs != null) {
                                    try {
                                        rs.close();
                                    } catch (SQLException ignored) {
                                    }
                                }
                                if (ps != null) {
                                    try {
                                        ps.close();
                                    } catch (SQLException ignored) {
                                    }
                                }
                                if (con != null) {
                                    try {
                                        con.close();
                                    } catch (SQLException ignored) {
                                    }
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="order-details-container">
                <h3>Order Details</h3>
                <table class="viewOrderDetails">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Date</th>
                            <th>Total Paid</th>
                        </tr>
                    </thead>
                    <tbody id="orderDetailsBody">
                        <tr>
                            <td colspan="3">Select a customer to view their orders.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <button type="button" onclick="window.location.href = 'home.jsp';">Close</button>
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