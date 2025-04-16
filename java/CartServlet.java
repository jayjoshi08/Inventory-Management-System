package com.java;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ConnectionProvider; // Replace with your connection provider class
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("addToCart".equals(action)) {
            try {
                addToCart(request, response);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(CartServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        // You can add more actions here if needed, like removing from cart
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ClassNotFoundException {
        int customerId = Integer.parseInt(request.getParameter("customer_fk"));
        int productId = Integer.parseInt(request.getParameter("product_fk"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double pricePerUnit = Double.parseDouble(request.getParameter("price"));
        int availableProductStock = 0;

        try (Connection con = ConnectionProvider.getConnection()) {
            // Step 1: Get the available stock of the selected product
            String query = "SELECT quantity FROM product WHERE product_pk = ?";
            PreparedStatement ps1 = con.prepareStatement(query);
            ps1.setInt(1, productId);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                availableProductStock = rs.getInt("quantity");
            }

            // Step 2: Check if requested quantity exceeds available stock
            if (quantity > availableProductStock) {
                String message = "The entered quantity exceeds stock";
                response.sendRedirect("cart.jsp?message=" + message);
                return; // Stop further execution
            }

            // Step 3: Insert into cart
            String sql = "INSERT INTO cart (customer_fk, product_fk, quantity, price_per_unit) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, productId);
                ps.setInt(3, quantity);
                ps.setDouble(4, pricePerUnit);
                ps.executeUpdate();
            }
            String message = "Product added to cart successfully!";
            response.sendRedirect("cart.jsp?message="+message); 
        } catch (SQLException e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("message", "Error adding product to cart: " + e.getMessage());
            response.sendRedirect("cart.jsp"); // Redirect back with error message
        }
    }

}
