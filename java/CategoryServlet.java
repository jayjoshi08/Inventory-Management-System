/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */package com.java;

import dao.ConnectionProvider;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CategoryServlet extends HttpServlet {

    String message = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (null != action) {
            switch (action) {
                case "add":
                    addCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                default:
                    break;
            }
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("categoryName");

        try (Connection con = ConnectionProvider.getConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO category (name) VALUES (?)")) {
            ps.setString(1, name);
            ps.executeUpdate();
            message = "category " + name + " added succesfully!";
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            message = "Error adding category: " + e.getMessage();
        }
        response.sendRedirect("category.jsp?message=" + message);
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int categoryPK = Integer.parseInt(request.getParameter("id")); // Use 'id' from GET request


        try (Connection con = ConnectionProvider.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM category WHERE category_pk = ?")) {
            ps.setInt(1, categoryPK);
            ps.executeUpdate();
            message = "category id " + categoryPK + " Deleted succesfully!";
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            message = "Error deleting category: " + e.getMessage();
        }
        response.sendRedirect("category.jsp?message=" + message);
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int categoryPK = Integer.parseInt(request.getParameter("categoryPK"));
        String categoryName = request.getParameter("categoryName");

        try (Connection con = ConnectionProvider.getConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE category SET name = ? WHERE category_pk = ?")) {
            ps.setString(1, categoryName);
            ps.setInt(2, categoryPK);
            ps.executeUpdate();
            message = "category " + categoryName + " Updated succesfully!";
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            message = "Error updating category: " + e.getMessage();
        }
        response.sendRedirect("category.jsp?message=" + message);
    }
}