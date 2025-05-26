<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillhive.model.User" %>
<% 
    // Verifica sessione
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Genera un cache buster per i file statici
    String cacheBuster = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout Success - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/common.css?v=<%= cacheBuster %>">
    <link rel="stylesheet" href="../css/checkout-success.css?v=<%= cacheBuster %>">
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container header-content">
            <a href="dashboard.jsp" class="logo">
                <div class="honeycomb">
                    <div></div>
                    <div></div>
                    <div></div>
                    <div></div>
                    <div></div>
                    <div></div>
                    <div></div>
                </div>
                <span>SkillHive</span>
            </a>
            <div class="hamburger-menu">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
    </header>

    <!-- Checkout Success Section -->
    <section class="checkout-success-section">
        <div class="container">
            <div class="success-icon">✓</div>
            <h2>Thank You for Your Purchase!</h2>
            <p class="success-message">Your order has been successfully placed. You'll receive a confirmation email shortly with all the details.</p>
            
            <div class="order-info">
                <p>An order confirmation has been sent to your email address.</p>
                <p>You can view your order details in the "My Orders" section of your profile.</p>
            </div>
            
            <a href="dashboard.jsp" class="cta">Continue Shopping</a>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container footer-content">
            <div class="footer-left">
                <a href="dashboard.jsp" class="logo">
                    <div class="honeycomb">
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>
                    <span>SkillHive</span>
                </a>
                <p>Connect with skilled professionals for your digital service needs.</p>
                <div class="social-icons">
                    <a href="#">🐦</a>
                    <a href="#">📷</a>
                    <a href="#">📘</a>
                </div>
            </div>
            <div class="footer-links">
                <div class="footer-column">
                    <h4>Categories</h4>
                    <a href="#">Development</a>
                    <a href="#">Design</a>
                    <a href="#">Digital Marketing</a>
                    <a href="#">Writing & Translation</a>
                    <a href="#">Video & Animation</a>
                </div>
                <div class="footer-column">
                    <h4>About</h4>
                    <a href="#">About Us</a>
                    <a href="#">How It Works</a>
                    <a href="#">Become a Seller</a>
                    <a href="#">Trust & Safety</a>
                </div>
                <div class="footer-column">
                    <h4>Support</h4>
                    <a href="#">Help & Support</a>
                    <a href="#">FAQ</a>
                    <a href="#">Contact Us</a>
                    <a href="#">Privacy Policy</a>
                    <a href="#">Terms of Service</a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 SkillHive. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>