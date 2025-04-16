/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.java;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ConnectionProvider;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.http.HttpSession;

/**
 *
 * @author jayjo
 */

public class LoginServlet extends HttpServlet {
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String message = "";
        
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            message = "Please enter both username and password!";
            response.sendRedirect("login.jsp?message="+message);
            return;
        }
        
        try {
            Connection con = ConnectionProvider.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("select * from appuser where email='"+email+ "' and password='"+password+"' and status='Active' and name='Super Admin'");
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", rs.getString("name"));
                response.sendRedirect("home.jsp");
            } else {
                message = "Invalid username or password!";
                response.sendRedirect("login.jsp?message="+ message);
            }
        } catch (IOException | ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            message = "Database connection error!";
            response.sendRedirect("login.jsp?message="+ message);
        }
    }
}
