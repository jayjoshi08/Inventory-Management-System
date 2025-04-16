<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dao.ConnectionProvider" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Inventory Management System</title>
    <link rel="icon" type="image/png" href="images/inventory.jpg">
    <link href="https://fonts.googleapis.com/css2?family=Anton+SC&family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="login.css" />

    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@4/dist/email.min.js"></script>
    <script src="showMessage.js"></script>
    <script src="emailVerification.js" defer></script>
</head>
<body>

<%
    String message = "";
    boolean loginSuccess = false;
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (email != null && password != null) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = ConnectionProvider.getConnection();
            String query = "SELECT * FROM appuser WHERE email=? AND password=? AND status='Active' AND userRole='SuperAdmin'";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("username", rs.getString("name"));
                loginSuccess = true; // Login successful
            } else {
                message = "Invalid username or password for Super Admin!";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database connection error!";
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    }
%>


<input type="hidden" id="loginStatus" value="<%= loginSuccess %>">
<input type="hidden" id="userEmail" value="<%= email != null ? email : "" %>">

<!-- Login Form -->
<div id="loginToVerify" class="login-container" style="<%= loginSuccess ? "display:none;" : "" %>">
    <div class="login-title">Inventory Management System</div>
    <form action="login.jsp" method="post">
        <div class="input-box">
            <input type="email" name="email" id="email" required>
            <label for="email">Email</label>
        </div>
        <div class="input-box">
            <input type="password" name="password" required>
            <label for="password">Password</label>
        </div>
        <button type="submit" class="login-btn">Login</button>
    </form>
    <% if (!message.isEmpty()) { %>
    <p style="color: red;"><%= message %></p>
    <% } %>
</div>

<!-- Verification form -->
<div class="verification" id="verification" style="<%= loginSuccess ? "display:block;" : "display:none;" %>">
    <form>
        <h2>OTP Verification</h2>
        <p>A One-Time Password has been sent to <strong id="verifyEmail"></strong></p>
        <div class="otp-form">
            <p>Enter the 4-digit code sent via Email:</p>
            <div class="otp-group">
                <input type="number" maxlength="1" required>
                <input type="number" maxlength="1" required>
                <input type="number" maxlength="1" required>
                <input type="number" maxlength="1" required>
            </div>
        </div>
        <button class="verifyButton" id="verifyButton" disabled>Verify &rarr;</button>
    </form>
</div>

<!-- Footer -->
<p>
    Inventory Management System, &copy;
    <script>document.write(new Date().getFullYear());</script>
    All rights reserved by Jay Joshi and Janmay Patel.
</p>

</body>
</html>
