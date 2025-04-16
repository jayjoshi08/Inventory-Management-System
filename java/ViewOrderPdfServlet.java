package com.java; // Adjust package name as needed

import dao.InventoryUtils;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class ViewOrderPdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");

        if (orderId != null && !orderId.trim().isEmpty()) {
            String pdfPath = Paths.get(InventoryUtils.billPath, orderId + ".pdf").toString();
            File pdfFile = new File(pdfPath);

            if (pdfFile.exists()) {
                response.setContentType("application/pdf");
                response.setContentLength((int) pdfFile.length());
                response.setHeader("Content-Disposition", "inline; filename=order_" + orderId + ".pdf");

                FileInputStream fileInputStream = null;
                OutputStream responseOutputStream = null;

                try {
                    fileInputStream = new FileInputStream(pdfFile);
                    responseOutputStream = response.getOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                        responseOutputStream.write(buffer, 0, bytesRead);
                    }
                } catch (IOException e) {
                    response.getWriter().println("Error loading PDF: " + e.getMessage());
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    e.printStackTrace();
                } finally {
                    if (fileInputStream != null) try { fileInputStream.close(); } catch (IOException ignored) {}
                    if (responseOutputStream != null) try { responseOutputStream.close(); } catch (IOException ignored) {}
                }
            } else {
                response.getWriter().println("PDF not found for Order ID: " + orderId);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            response.getWriter().println("Invalid Order ID.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}