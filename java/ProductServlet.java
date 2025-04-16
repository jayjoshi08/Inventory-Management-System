package com.java;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ConnectionProvider;

public class ProductServlet extends HttpServlet {

    String message = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response); // Forward GET requests to doPost()
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("product.jsp");
            return;
        }

        try (Connection con = ConnectionProvider.getConnection()) {
            switch (action) {
                case "add":
                    addProduct(request, response, con);
                    break;
                case "update":
                    updateProduct(request, response, con);
                    break;
                case "delete":
                    deleteProduct(request,response, con);
                    break;
                default:
                    break;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response, Connection con) throws SQLException, IOException {
        String name = request.getParameter("productName");
        String buildNumber = request.getParameter("buildNumber");
        String companyName = request.getParameter("companyName");
        String productType = request.getParameter("productType");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        int category = Integer.parseInt(request.getParameter("category"));

        String sql = "INSERT INTO product (product_name, build_number, company_name, product_type, quantity, price, description, category_fk) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, buildNumber);
            ps.setString(3, companyName);
            ps.setString(4, productType);
            ps.setInt(5, quantity);
            ps.setDouble(6, price);
            ps.setString(7, description);
            ps.setInt(8, category);
            ps.executeUpdate();
            message = "Product " + name + " added succesfully!";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Error adding product! " + e.getMessage();
        }
        response.sendRedirect("product.jsp?message=" + message);
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response, Connection con) throws SQLException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        String buildNumber = request.getParameter("buildNumber");
        String companyName = request.getParameter("companyName");
        String productType = request.getParameter("productType");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double tempPrice = Double.parseDouble(request.getParameter("price"));
        int price = (int) tempPrice;
        String description = request.getParameter("description");
        int category = Integer.parseInt(request.getParameter("category"));

        String sql = "UPDATE product SET product_name=?, build_number=?, company_name=?, product_type=?, quantity=?, price=?, description=?, category_fk=? WHERE product_pk=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, productName);
            ps.setString(2, buildNumber);
            ps.setString(3, companyName);
            ps.setString(4, productType);
            ps.setInt(5, quantity);
            ps.setDouble(6, price);
            ps.setString(7, description);
            ps.setInt(8, category);
            ps.setInt(9, productId);
            ps.executeUpdate();
            message = "Product " + productName + " Updated succesfully!";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Error updating product! " + e.getMessage();
        }
        response.sendRedirect("product.jsp?message=" + message);
    }

    private void deleteProduct(HttpServletRequest request,HttpServletResponse response, Connection con) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        String sql = "DELETE FROM product WHERE product_pk=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            message = "Product " + id + " deleted successfully";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Error deleting product !"+e.getMessage();
        }
        response.sendRedirect("product.jsp?message=" + message);
    }
}
