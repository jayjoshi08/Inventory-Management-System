function populateProductForm(productId, productName, buildNumber, companyName, productType, quantity, price, description, categoryName) {
    document.getElementById('category_fk').value = categoryName;
    document.getElementById('product_fk').value = productId;
    document.getElementById('product_name').value = productName;
    document.getElementById('build_number').value = buildNumber;
    document.getElementById('company_name').value = companyName;
    document.getElementById('product_type').value = productType;
    document.getElementById('quantity').value = 1;
    document.getElementById('price').value = price;
    document.getElementById('description').value = description;
    document.getElementById('category_name').value = categoryName;
}

function populateCustomerForm(customerId, customerName, mobileNumber, email, address) {
    document.getElementById('customer_fk').value = customerId;
    document.getElementById('customer_name').value = customerName;
    document.getElementById('mobile_number').value = mobileNumber;
    document.getElementById('email').value = email;
    document.getElementById('address').value = address;
}

function viewCart() {
    window.location.href = 'cartView.jsp';
}

window.onload = function () {
    const urlParams = new URLSearchParams(window.location.search);
    const message = urlParams.get("message");
    if (message) {
        alert(message); // Show pop-up alert
    }
};
