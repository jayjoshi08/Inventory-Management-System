# Inventory-Management-System
The Inventory Management System is a web-based application developed using JSP, 
Servlets, HTML, CSS, JavaScript, and Apache Derby. It provides a structured way to 
manage admin, products, cart, customers and orders within an inventory system. The system 
enables admin users to add, update, delete, and track inventory items, while customers can 
browse and place orders. 
The system features Super Admin authentication with EmailJS API for email-based 
authentication and secure login. The system allows product categorization, inventory tracking, 
and order generation with PDF invoices using the iText JAR library. The project ensures 
efficient inventory tracking and streamlines order processing for better business management. 
Key Contributions: 
• Automated Workflows: Reduces human error in stock management and order 
processing. 
• Role-Based Access: Admins manage inventory, while customers browse products and 
place orders. 
• Enhanced Security: Email-based authentication using EmailJS API ensures secure user 
logins. 
• Efficiency: Automated PDF invoice generation via iText JAR accelerates billing 
processes. 
This system empowers businesses to maintain accurate stock levels, improve customer 
satisfaction, and optimize operational efficiency.
# Implementation files
Main JSP Pages:

• home.jsp: Homepage  
• login.jsp: User login page with email authentication  
• customer.jsp: customer detail page  
• manageAdmin.jsp: Admin management under super admin   
• product.jsp: Product description page  
• cart.jsp: Customer cart page  
• category.jsp: category information page  
• viewOrder.jsp: Admin order management page  

Servlets: 

• LoginServlet.java: Handles Super Admin authentication  
• VerifySuperAdminServlet.java: Email authentication process to verify Super Admin  
• AdminServlet.java: Manages Admin registration  
• ProductServlet.java: Handles product CRUD operations  
• CustomerServlet.java: Hadnles customer related operations  
• CategoryServlet.java: Manages Category information   
• CartServlet.java: Manages cart related actions  
• GenerateInvoiceServlet.java: Generate Invoice based on order place  
• OrderServlet.java: Manages order processing  
• ViewOrderPdfServlet.java: Opens the generated invoice as a pdf  

Database Tables: 

• appuser (appuser_pk, userRole, name, mobileNumber, email, password, address, 
status)  
• customers (customer_pk, name,mobileNumber, email, address)  
• product (product_pk, product_name, company_name, build_Number, product_type, 
category, price, quantity, description)  
• order_details (order_pk, order_id, customer_fk, order_date, totalPaid) 
• cart (cart_pk, customer_fk, product_fk, quantity, price_per_quantity)  
• category (category_pk, name) 
