/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.java;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ConnectionProvider;
import java.util.logging.Level;
import java.util.logging.Logger;
public class GetOrderDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String customerIdParam = request.getParameter("customerId");

        if (customerIdParam != null) {
            Connection conOrder = null;
            PreparedStatement psOrder = null;
            ResultSet rsOrder = null;
            try {
                conOrder = ConnectionProvider.getConnection();
                psOrder = conOrder.prepareStatement("SELECT orderId, orderDate, totalPaid FROM orderDetail WHERE customer_fk = ?",
                        ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                int customerId = Integer.parseInt(customerIdParam);
                psOrder.setInt(1, customerId);
                rsOrder = psOrder.executeQuery();
                StringBuilder orderRows = new StringBuilder();
                if (!rsOrder.isBeforeFirst()) {
                    orderRows.append("<tr><td colspan='3'>No orders found for this customer.</td></tr>");
                } else {
                    while (rsOrder.next()) {
                        orderRows.append("<tr>");
                        orderRows.append("<td>").append(rsOrder.getString("orderId")).append("</td>");
                        orderRows.append("<td>").append(rsOrder.getString("orderDate")).append("</td>");
                        orderRows.append("<td>").append(rsOrder.getDouble("totalPaid")).append("</td>");
                        orderRows.append("</tr>");
                    }
                }
                out.print(orderRows.toString()); // Send only the table rows
            } catch (SQLException e) {
                out.print("<tr><td colspan='3'>Error loading orders: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            } catch (NumberFormatException e) {
                out.print("<tr><td colspan='3'>Invalid Customer ID.</td></tr>");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(GetOrderDetailsServlet.class.getName()).log(Level.SEVERE, null, ex);
            } finally {
                if (rsOrder != null) try { rsOrder.close(); } catch (SQLException ignored) {}
                if (psOrder != null) try { psOrder.close(); } catch (SQLException ignored) {}
                if (conOrder != null) try { conOrder.close(); } catch (SQLException ignored) {}
            }
        } else {
            out.print("<tr><td colspan='3'>Select a customer to view their orders.</td></tr>");
        }
    }
}
