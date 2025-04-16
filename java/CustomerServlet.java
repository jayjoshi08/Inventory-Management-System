
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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

public class CustomerServlet extends HttpServlet {

    String message = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response); // Forward GET requests to doPost()
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("customer.jsp");
            return;
        }

        try (Connection con = ConnectionProvider.getConnection()) {
            switch (action) {
                case "add":
                    addCustomer(request, response, con);
                    break;
                case "update":
                    updateCustomer(request, response, con);
                    break;
                case "delete":
                    deleteCustomer(request, response, con);
                    break;
                default:
                    break;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response, Connection con) throws SQLException, IOException {
        String customerName = request.getParameter("customerName");
        String email = request.getParameter("customerEmail");
        String customerPhone = request.getParameter("customerPhone");
        String address = request.getParameter("customerAddress");

        String sql = "INSERT INTO customer (name,mobileNumber,email,address) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, customerName);
            ps.setString(2, customerPhone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.executeUpdate();
            message = "Customer " + customerName + " added successfully!";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Error adding customer! " + e.getMessage();
        }
        response.sendRedirect("customer.jsp?message=" + message);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response, Connection con) throws SQLException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String customerName = request.getParameter("customerName");
        String email = request.getParameter("customerEmail");
        String customerPhone = request.getParameter("customerPhone");
        String address = request.getParameter("customerAddress");

        String sql = "UPDATE customer SET name=?, mobileNumber=?, email=?, address=? WHERE customer_pk=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, customerName);
            ps.setString(2, customerPhone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setInt(5, customerId);
            ps.executeUpdate();
            message = "Customer " + customerName + " updated successfully!";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Error updating customer! " + e.getMessage();
        }
        response.sendRedirect("customer.jsp?message=" + message);
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response, Connection con) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        String sql = "DELETE FROM customer WHERE customer_pk=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            message = "Customer " + id + " deleted successfully";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Error deleting customer! " + e.getMessage();
        }
        response.sendRedirect("customer.jsp?message=" + message);
    }
}