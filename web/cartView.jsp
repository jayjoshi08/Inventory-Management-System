<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.ConnectionProvider" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin View Customer Carts</title>
        <link rel="icon" type="image/png" href="images/inventory.jpg">
        <link rel="stylesheet" href="cart.css">
         <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
    </head>
    <body>
        <h1>Customer's Cart</h1>
        <div class="container">
            <div class="customer-list">
                <h2>Existing Customers</h2>
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
                            Connection conCustomers = null;
                            PreparedStatement psCustomers = null;
                            ResultSet rsCustomers = null;
                            try {
                                conCustomers = ConnectionProvider.getConnection();
                                psCustomers = conCustomers.prepareStatement("SELECT * FROM customer");
                                rsCustomers = psCustomers.executeQuery();
                                while (rsCustomers.next()) {
                        %>
                        <tr onclick="window.location.href = 'cartView.jsp?customerId=<%= rsCustomers.getInt("customer_pk")%>'">
                            <td><%= rsCustomers.getInt("customer_pk")%></td>
                            <td><%= rsCustomers.getString("name")%></td>
                            <td><%= rsCustomers.getString("mobileNumber")%></td>
                            <td><%= rsCustomers.getString("email")%></td>
                            <td><%= rsCustomers.getString("address")%></td>
                        </tr>
                        <%
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                                out.println("<p style='color:red;'>Error fetching customers.</p>");
                            } finally {
                                try {
                                    if (rsCustomers != null) {
                                        rsCustomers.close();
                                    }
                                } catch (SQLException e) {
                                }
                                try {
                                    if (psCustomers != null) {
                                        psCustomers.close();
                                    }
                                } catch (SQLException e) {
                                }
                                try {
                                    if (conCustomers != null) {
                                        conCustomers.close();
                                    }
                                } catch (SQLException e) {
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div class="cart-details">
                <h2>Customer Cart Details</h2>
                <div id="customerCartDetails" class="customer-cart-view">
                    <%
                        String selectedCustomerIdParam = request.getParameter("customerId");
                        if (selectedCustomerIdParam != null && !selectedCustomerIdParam.trim().isEmpty()) {
                            int selectedCustomerId = Integer.parseInt(selectedCustomerIdParam);

                            Connection conCustomerCart = null;
                            PreparedStatement psCustomerCart = null;
                            ResultSet rsCustomerCart = null;
                            double customerTotalPrice = 0;
                            boolean hasProductsInCart = false;

                            try {
                                conCustomerCart = ConnectionProvider.getConnection();
                                String sqlCustomerCart = "SELECT p.product_pk, p.product_name, p.build_number, p.company_name, p.product_type, c.quantity, p.price, p.description, cat.category_pk, cat.name AS category_name "
                                        + "FROM cart c "
                                        + "JOIN product p ON c.product_fk = p.product_pk "
                                        + "JOIN category cat ON p.category_fk = cat.category_pk "
                                        + "WHERE c.customer_fk = ?";
                                psCustomerCart = conCustomerCart.prepareStatement(sqlCustomerCart);
                                psCustomerCart.setInt(1, selectedCustomerId);
                                rsCustomerCart = psCustomerCart.executeQuery();

                    %>
                    <h3>Cart Details for Customer ID: <%= selectedCustomerId%></h3>
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Product ID</th>
                                <th>Product Name</th>
                                <th>Build Number</th>
                                <th>Company</th>
                                <th>Type</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Description</th>
                                <th>Category ID</th>
                                <th>Category Name</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rsCustomerCart.next()) {
                                    hasProductsInCart = true;
                                    int productId = rsCustomerCart.getInt("product_pk");
                                    String productName = rsCustomerCart.getString("product_name");
                                    String buildNumber = rsCustomerCart.getString("build_number");
                                    String companyName = rsCustomerCart.getString("company_name");
                                    String productType = rsCustomerCart.getString("product_type");
                                    int quantity = rsCustomerCart.getInt("quantity");
                                    double price = rsCustomerCart.getDouble("price");
                                    String description = rsCustomerCart.getString("description");
                                    int categoryIdRs = rsCustomerCart.getInt("category_pk");
                                    String categoryName = rsCustomerCart.getString("category_name");
                                    double subtotal = quantity * price;
                                    customerTotalPrice += subtotal;
                            %>
                            <tr>
                                <td><%= productId%></td>
                                <td><%= productName%></td>
                                <td><%= buildNumber%></td>
                                <td><%= companyName%></td>
                                <td><%= productType%></td>
                                <td><%= quantity%></td>
                                <td><%= price%></td>
                                <td><%= description%></td>
                                <td><%= categoryIdRs%></td>
                                <td><%= categoryName%></td>
                                <td><%= subtotal%></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="10" style="text-align: right;"><strong>Total Price:</strong></td>
                                <td><%= customerTotalPrice%></td>
                            </tr>
                        </tfoot>
                    </table>
                    <div class="invoiceButton">
                        <form action="GenerateInvoiceServlet" method="GET">
                            <input type="hidden" name="customerId" value="<%= selectedCustomerId%>">
                            <button type="submit" id="placeOrder" <%= !hasProductsInCart ? "disabled" : "" %>>Place Order</button>
                        </form>
                    </div>


                    <%

                            } catch (SQLException e) {
                                e.printStackTrace();
                                out.println("<p style='color:red;'>Error fetching cart items for customer.</p>");
                            } finally {
                                try {
                                    if (rsCustomerCart != null) {
                                        rsCustomerCart.close();
                                    }
                                } catch (SQLException e) {
                                }
                                try {
                                    if (psCustomerCart != null) {
                                        psCustomerCart.close();
                                    }
                                } catch (SQLException e) {
                                }
                                try {
                                    if (conCustomerCart != null) {
                                        conCustomerCart.close();
                                    }
                                } catch (SQLException e) {
                                }
                            }
                        } else {
                            out.println("<p>Please select a customer to see their cart details.</p>");
                        }
                    %>
                </div>
            </div>
            <div class="button-group-cart">
                <button type="button" onclick="window.location.href = 'cart.jsp';">Back to Cart</button>
            </div>
        </div>

        <script>
            function showCustomerCart(customerId) {
                window.location.href = 'cartView.jsp?customerId=' + customerId;
            }

            function generateInvoice(customerId) {
                alert("Invoice generated for Customer ID: " + customerId);
            }
            
            function handlePageShow(event) {
                if (event.persisted) {
                    window.location.reload();
                } 
            }

            window.addEventListener('pageshow', handlePageShow);

        </script>
        <p>
            Inventory Management System, &copy;
            <script>
                document.write(new Date().getFullYear());
            </script>
            All rights reserved by Jay Joshi and Janmay Patel.
        </p>
    </body>
</html>