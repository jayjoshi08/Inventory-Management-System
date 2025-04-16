<%@ page session="true" %>
<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*" %>
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
        <title>Home - Inventory Management</title>
        <link rel="icon" type="image/png" href="images/inventory.jpg">
        <link rel="stylesheet" type="text/css" href="home.css">
        <link
            href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
            rel="stylesheet"
            />
        <script src="showMessage.js"></script>
    </head>
    <body>
        <div class="navbar">
            <button onclick="location.href = 'manageAdmins.jsp'">
                <img src="images/Users.png" alt="Admins"> Admins
            </button>
            <button onclick="location.href = 'category.jsp'">
                <img src="images/category.png" alt="Category"> Category
            </button>
            <button onclick="location.href = 'product.jsp'">
                <img src="images/product.png" alt="Product"> Product
            </button>
            <button onclick="location.href = 'customer.jsp'">
                <img src="images/customers.png" alt="Customers"> Customer
            </button>
            <button onclick="location.href = 'cart.jsp'">
                <img src="images/cart.png" alt="cart"> Cart
            </button>
            <button onclick="location.href = 'cartView.jsp'">
                <img src="images/Orders.png" alt="Order"> Order
            </button>
            <button onclick="location.href = 'viewOrders.jsp'">
                <img src="images/View-orders.png" alt="View Order"> View Order
            </button>
            <button onclick="location.href = 'login.jsp'">
                <img src="images/Exit.png" alt="Logout"> Log out
            </button>
        </div>
        <div class="container">
            <h1>Welcome, <%= username%>!</h1>
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
