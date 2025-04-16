package com.java;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import dao.ConnectionProvider;

public class GenerateInvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String orderId = "Bill-" + System.currentTimeMillis();

        // Define the path to save the PDF on the E drive
        String filePath = "E:\\" + orderId + ".pdf";

        Connection con = null;
        PreparedStatement psCustomer = null;
        ResultSet rsCustomer = null;
        PreparedStatement psCart = null;
        ResultSet rsCart = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDeleteCart = null;
        PreparedStatement psDeleteCustomer = null;

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, new FileOutputStream(filePath)); // Save to file
            document.open();

            con = ConnectionProvider.getConnection();
            psCustomer = con.prepareStatement("SELECT name, mobileNumber, email,address FROM customer WHERE customer_pk = ?");
            psCustomer.setInt(1, customerId);
            rsCustomer = psCustomer.executeQuery();
            String customerName = "", customerMobile = "", customerEmail = "", customerAddress = "";
            if (rsCustomer.next()) {
                customerName = rsCustomer.getString("name");
                customerMobile = rsCustomer.getString("mobileNumber");
                customerEmail = rsCustomer.getString("email");
                customerAddress = rsCustomer.getString("address");
            }

            SimpleDateFormat myFormat = new SimpleDateFormat("dd-MM-yyyy");
            Calendar cal = Calendar.getInstance();
            String orderDate = myFormat.format(cal.getTime());

            // Add invoice header
            document.add(new Paragraph("                                         Inventory Management System\n", new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD)));
            document.add(new Paragraph("****************************************************************************************************************\n"));
            document.add(new Paragraph("Order ID: " + orderId + "\nCustomer Name: " + customerName + "\nCustomer Mobile: " + customerMobile + "\nCustomer Email: " + customerEmail + "\nCustomer Address: " + customerAddress + "\nDate: " + orderDate + "\n"));
            document.add(new Paragraph("****************************************************************************************************************\n"));

            // Table for order details
            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            PdfPCell cell;
            BaseColor bgColor = new BaseColor(255, 204, 251);

            String[] headers = {"Name", "Description", "Price per Unit", "Quantity", "Subtotal"};
            for (String header : headers) {
                cell = new PdfPCell(new Phrase(header));
                cell.setBackgroundColor(bgColor);
                table.addCell(cell);
            }

            double totalAmount = 0;
            psCart = con.prepareStatement(
                    "SELECT p.product_name, p.description, p.price, c.quantity FROM cart c "
                    + "JOIN product p ON c.product_fk = p.product_pk WHERE c.customer_fk = ?");
            psCart.setInt(1, customerId);
            rsCart = psCart.executeQuery();

            while (rsCart.next()) {
                String productName = rsCart.getString("product_name");
                String description = rsCart.getString("description");
                double price = rsCart.getDouble("price");
                int quantity = rsCart.getInt("quantity");
                double subtotal = price * quantity;
                totalAmount += subtotal;

                table.addCell(productName);
                table.addCell(description);
                table.addCell(String.valueOf(price));
                table.addCell(String.valueOf(quantity));
                table.addCell(String.valueOf(subtotal));
            }
            table.addCell(String.valueOf(totalAmount));

            document.add(table);
            document.add(new Paragraph("****************************************************************************************************************\n"));
            document.add(new Paragraph("Total Paid: ₹" + totalAmount + "\n"));
            document.add(new Paragraph("Thank you, Please Visit again..\n"));
            document.close();

            // Update order details in database
            psOrder = con.prepareStatement(
                    "INSERT INTO orderDetail (orderId, customer_fk, orderDate, totalPaid) VALUES (?,?,?,?)");
            psOrder.setString(1, orderId);
            psOrder.setInt(2, customerId);
            psOrder.setString(3, orderDate);
            psOrder.setDouble(4, totalAmount);
            psOrder.executeUpdate();

            psCart = con.prepareStatement("SELECT product_fk, quantity FROM cart WHERE customer_fk = ?");
            psCart.setInt(1, customerId);
            rsCart = psCart.executeQuery();

            PreparedStatement psUpdateProduct = con.prepareStatement("UPDATE product SET quantity = quantity - ? WHERE product_pk = ?");

            while (rsCart.next()) {
                int productId = rsCart.getInt("product_fk");
                int quantityPurchased = rsCart.getInt("quantity");

                System.out.println("Updating product ID: " + productId + " by reducing quantity: " + quantityPurchased);

                psUpdateProduct.setInt(1, quantityPurchased);
                psUpdateProduct.setInt(2, productId);
                int rowsUpdated = psUpdateProduct.executeUpdate();  // Execute update

                System.out.println("Rows affected: " + rowsUpdated);
            }

            psUpdateProduct.close();

            // Delete customer's cart details
            psDeleteCart = con.prepareStatement("DELETE FROM cart WHERE customer_fk = ?");
            psDeleteCart.setInt(1, customerId);
            psDeleteCart.executeUpdate();

            // Delete customer's cart details
            psDeleteCart = con.prepareStatement("DELETE FROM cart WHERE customer_fk = ?");
            psDeleteCart.setInt(1, customerId);
            psDeleteCart.executeUpdate();

            // After saving and deleting, redirect the browser to the ViewOrderPdfServlet to display the saved PDF
            response.sendRedirect("ViewOrderPdfServlet?orderId=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error generating invoice: " + e.getMessage());
        } finally {
            // Close resources in a finally block to ensure they are closed even if an exception occurs
            try {
                if (rsCustomer != null) {
                    rsCustomer.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (psCustomer != null) {
                    psCustomer.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (rsCart != null) {
                    rsCart.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (psCart != null) {
                    psCart.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (psOrder != null) {
                    psOrder.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (psDeleteCart != null) {
                    psDeleteCart.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (psDeleteCustomer != null) {
                    psDeleteCustomer.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
