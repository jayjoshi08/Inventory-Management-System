/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.java;

import dao.ConnectionProvider;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author jayjo
 */
public class AdminServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String name = request.getParameter("name");
            String mobileNumber = request.getParameter("mobileNumber");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            String status = request.getParameter("status");

            Connection con = ConnectionProvider.getConnection();
            String message;

            if ("save".equals(action)) {
                if (isUserExists(con, name)) {
                    message = "Admin " + name + " already exists!";
                } else {
                    saveAdmin(con, name, mobileNumber, email, address, password, status);
                    message = "Admin " + name + " saved successfully!";
                }
            } else if ("update".equals(action)) {
                int appuserPK = Integer.parseInt(request.getParameter("appuserPK"));
                updateAdmin(con, appuserPK, name, mobileNumber, email, address, password, status);
                message = "Admin " + name + " updated successfully!";
            } else if ("delete".equals(action)) {
                int appuserPK = Integer.parseInt(request.getParameter("appuserPK"));
                deleteAdmin(con, appuserPK);
                message = "Admin " +name + " Removed Successfully";
            } else {
                 message = "No proper action is done! ";
            }

            response.sendRedirect("manageAdmins.jsp?message=" + message);
        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private boolean isUserExists(Connection con, String name) throws SQLException {
        String query = "SELECT COUNT(*) FROM appuser WHERE name = ?";
        try (PreparedStatement pst = con.prepareStatement(query)) {
            pst.setString(1, name);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        }
        return false;
    }

    private void saveAdmin(Connection con, String name, String mobile, String email, String address, String password, String status) throws SQLException {
        String query = "INSERT INTO appuser (userRole,name, mobileNumber, email, address, password, status) VALUES ('Admin',?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pst = con.prepareStatement(query)) {
            pst.setString(1, name);
            pst.setString(2, mobile);
            pst.setString(3, email);
            pst.setString(4, address);
            pst.setString(5, password);
            pst.setString(6, status);
            pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void updateAdmin(Connection con, int appuserPK, String name, String mobile, String email, String address, String password, String status) throws SQLException {
        String query = "UPDATE appuser SET name=?, mobileNumber=?, email=?, address=?, password=?, status=? WHERE appuser_pk=?";

        try (PreparedStatement pst = con.prepareStatement(query)) {
            pst.setString(1, name);
            pst.setString(2, mobile);
            pst.setString(3, email);
            pst.setString(4, address);
            pst.setString(5, password);
            pst.setString(6, status);
            pst.setInt(7, appuserPK);
            pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void deleteAdmin(Connection con, int appuserPK) throws UnsupportedOperationException, SQLException {
        String query = "DELETE FROM appuser WHERE appuser_pk=?";
        try (PreparedStatement pst = con.prepareStatement(query)) {
        pst.setInt(1, appuserPK);
        pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
