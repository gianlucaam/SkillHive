<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.skillhive.model.Service, com.skillhive.model.User" %>
<% 
    // Verifica sessione
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Genera un cache buster per i file statici
    String cacheBuster = String.valueOf(System.currentTimeMillis());

    // Carica il carrello dalla sessione
    List<Service> cart = (List<Service>) session.getAttribute("cart");
    double total = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/cart.css?v=<%= cacheBuster %>">
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
           
            
            <!-- Desktop Nav -->
            <nav class="desktop-nav">
                <div class="user-menu">
                    <span class="user-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 256 256" class="user-icon-svg">
                            <path fill="currentColor" d="M128 24a104 104 0 1 0 104 104A104.11 104.11 0 0 0 128 24Zm0 16a88 88 0 1 1-88 88a88.1 88.1 0 0 1 88-88Zm0 32a40 40 0 1 0 40 40a40 40 0 0 0-40-40Zm0 64a24 24 0 1 1 24-24a24 24 0 0 1-24 24Zm48 48a8 8 0 0 1-8 8h-80a8 8 0 0 1 0-16h80a8 8 0 0 1 8 8Z"/>
                        </svg>
                    </span>
                    <span><%= user.getUsername() %></span>
                    <div class="user-menu-dropdown">
                        <a href="profile.jsp">My Profile</a>
                        <a href="../logout">Logout</a>
                    </div>
                </div>
            </nav>
            <div class="hamburger-menu">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </div>
        <!-- Mobile Nav -->
        <nav class="mobile-nav">
            <a href="profile.jsp">My Profile</a>
            <a href="../logout" class="logout-btn">Logout</a>
        </nav>
    </header>

    <!-- Cart Section -->
    <section class="cart-section">
        <div class="container">
            <h2>Your Cart</h2>
            <%
                if (cart == null || cart.isEmpty()) {
            %>
                <div class="empty-cart-container">
                    <svg class="empty-cart-icon" viewBox="0 0 24.38 30.52" height="64px" width="64px" xmlns="http://www.w3.org/2000/svg">
                        <title>icon-cart</title>
                        <path transform="translate(-3.62 -0.85)" fill="currentColor" d="M28,27.3,26.24,7.51a.75.75,0,0,0-.76-.69h-3.7a6,6,0,0,0-12,0H6.13a.76.76,0,0,0-.76.69L3.62,27.3v.07a4.29,4.29,0,0,0,4.52,4H23.48a4.29,4.29,0,0,0,4.52-4ZM15.81,2.37a4.47,4.47,0,0,1,4.46,4.45H11.35a4.47,4.47,0,0,1,4.46-4.45Zm7.67,27.48H8.13a2.79,2.79,0,0,1-3-2.45L6.83,8.34h3V11a.76.76,0,0,0,1.52,0V8.34h8.92V11a.76.76,0,0,0,1.52,0V8.34h3L26.48,27.4a2.79,2.79,0,0,1-3,2.44Zm0,0"></path>
                    </svg>
                    <p class="empty-cart">Your cart is empty.</p>
                    <a href="dashboard.jsp" class="cta">Explore Services</a>
                </div>
            <%
                } else {
            %>
                <div class="cart-items">
                    <% for (Service service : cart) { 
                        total += service.getPrice();
                    %>
                        <div class="cart-item">
                            <div class="cart-item-image">
                                <img src="<%= service.getImage() != null && !service.getImage().isEmpty() ? service.getImage() : "https://via.placeholder.com/100x100?text=Service+Image+Not+Available" %>" alt="<%= service.getTitle() %>">
                            </div>
                            <div class="cart-item-details">
                                <h3><%= service.getTitle() %></h3>
                                <p>Seller ID: <%= service.getSellerId() %></p>
                                <p class="price">$<%= String.format("%.2f", service.getPrice()) %></p>
                            </div>
                            <form action="../remove-from-cart" method="post" class="cart-item-actions">
                                <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                                <button type="submit" class="remove-btn">Remove</button>
                            </form>
                        </div>
                    <% } %>
                </div>
                <div class="cart-summary">
                    <h3>Total: $<%= String.format("%.2f", total) %></h3>
                    <form action="../checkout" method="post">
                        <button type="submit" class="checkout-btn">Checkout</button>
                    </form>
                </div>
            <%
                }
            %>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container footer-content">
            <div class="footer-left">
                <a href="../index.jsp" class="logo">
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
                    <a href="#" class="social-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 256 256" class="social-icon-svg">
                            <path fill="currentColor" d="M240 150.15c0 27.1-9.24 49.71-24.89 66.94a91.9 91.9 0 0 1-58.65 31.26a4 4 0 0 1-4.73-3.88v-29.79c0-23-6.3-41.93-24.49-41.93c-9.48 0-18.37 5.52-25.47 14.73V150a4 4 0 0 1-4-4v-16a4 4 0 0 1 4-4h12a4 4 0 0 1 4 4v5.38c0 12.85 8.82 24.62 25.47 24.62c12.28 0 20.53-7.59 20.53-24.15c0-12.45-8-21.84-19.88-24.24c-11-2.22-31.46-4.91-31.46-24.15c0-15.14 12.05-24.62 25.47-24.62c9.72 0 17.97 5 23 13.59V90a4 4 0 0 1 4-4h16a4 4 0 0 1 4 4v12.31a4 4 0 0 1-3.47 4c-2.73.38-5.47 1.83-7.52 4.53c-5.46-9.72-16-15.91-28-15.91c-19 0-33.47 14.39-33.47 32.62c0 12.12 6 23.27 16.91 28.62c-10.39 4.14-16.91 14.39-16.91 27.51v29.94a4 4 0 0 1-4.73 3.93A92 92 0 0 1 40.89 217c-15.65-17.23-24.89-39.84-24.89-66.94C16 98.94 59.82 55.85 112 56a8 8 0 0 1 8 8v16a8 8 0 0 1-8 8c-35.29 0-64 27.83-64 62c0 20.2 10.37 37.38 25.47 48.62c-15.1 11.24-25.47 28.42-25.47 48.62a4 4 0 0 1-4 4H32a4 4 0 0 1-4-4c0-54.39 43-98.77 96-99.92V64a8 8 0 0 1 8-8c52.18-.15 96 42.94 96 94.15Z"/>
                        </svg>
                    </a>
                    <a href="#" class="social-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 256 256" class="social-icon-svg">
                            <path fill="currentColor" d="M240 150.15c0 27.1-9.24 49.71-24.89 66.94a91.9 91.9 0 0 1-58.65 31.26a4 4 0 0 1-4.73-3.88v-29.79c0-23-6.3-41.93-24.49-41.93c-9.48 0-18.37 5.52-25.47 14.73V150a4 4 0 0 1-4-4v-16a4 4 0 0 1 4-4h12a4 4 0 0 1 4 4v5.38c0 12.85 8.82 24.62 25.47 24.62c12.28 0 20.53-7.59 20.53-24.15c0-12.45-8-21.84-19.88-24.24c-11-2.22-31.46-4.91-31.46-24.15c0-15.14 12.05-24.62 25.47-24.62c9.72 0 17.97 5 23 13.59V90a4 4 0 0 1 4-4h16a4 4 0 0 1 4 4v12.31a4 4 0 0 1-3.47 4c-2.73.38-5.47 1.83-7.52 4.53c-5.46-9.72-16-15.91-28-15.91c-19 0-33.47 14.39-33.47 32.62c0 12.12 6 23.27 16.91 28.62c-10.39 4.14-16.91 14.39-16.91 27.51v29.94a4 4 0 0 1-4.73 3.93A92 92 0 0 1 40.89 217c-15.65-17.23-24.89-39.84-24.89-66.94C16 98.94 59.82 55.85 112 56a8 8 0 0 1 8 8v16a8 8 0 0 1-8 8c-35.29 0-64 27.83-64 62c0 20.2 10.37 37.38 25.47 48.62c-15.1 11.24-25.47 28.42-25.47 48.62a4 4 0 0 1-4 4H32a4 4 0 0 1-4-4c0-54.39 43-98.77 96-99.92V64a8 8 0 0 1 8-8c52.18-.15 96 42.94 96 94.15Z"/>
                        </svg>
                    </a>
                    <a href="#" class="social-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 256 256" class="social-icon-svg">
                            <path fill="currentColor" d="M224 76h-48V48a12 12 0 0 0-12-12h-72a12 12 0 0 0-12 12v28H32a12 12 0 0 0-8.65 20.29l96 105.82a12 12 0 0 0 17.3 0l96-105.82A12 12 0 0 0 224 76Zm-92 91.35L52.62 80H128v-32h24v32h75.38ZM224 168a12 12 0 0 1-12 12h-24a12 12 0 0 1 0-24h24a12 12 0 0 1 12 12Z"/>
                        </svg>
                    </a>
                    <a href="#" class="social-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 256 256" class="social-icon-svg">
                            <path fill="currentColor" d="M208 28H48a20 20 0 0 0-20 20v160a20 20 0 0 0 20 20h160a20 20 0 0 0 20-20V48a20 20 0 0 0-20-20Zm-44 24a12 12 0 1 1-12 12a12 12 0 0 1 12-12Zm-76 48a40 40 0 1 1 40 40a40 40 0 0 1-40-40Zm120 104H48v-28a68 68 0 0 1 136 0Zm-20-28a52 52 0 0 0-104 0v16h104Z"/>
                        </svg>
                    </a>
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
                <div class="footer-column">
                    <h4>Language</h4>
                    <select class="language-selector">
                        <option>EN</option>
                        <option>IT</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>© 2025 SkillHive. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        // Toggle hamburger menu
        document.querySelector('.hamburger-menu').addEventListener('click', function() {
            this.classList.toggle('active');
            document.querySelector('.mobile-nav').classList.toggle('active');
            document.body.classList.toggle('menu-open');
        });

        // Toggle user menu dropdown
        document.querySelector('.user-menu').addEventListener('click', function(e) {
            e.stopPropagation();
            document.querySelector('.user-menu-dropdown').classList.toggle('active');
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!document.querySelector('.user-menu').contains(e.target)) {
                document.querySelector('.user-menu-dropdown').classList.remove('active');
            }
        });

        // Funzione di ricerca (corretta per evitare l'errore EL)
        function searchServices() {
            var searchInput = document.getElementById("search-input").value.toLowerCase();
            window.location.href = "dashboard.jsp?search=" + encodeURIComponent(searchInput);
        }
    </script>
</body>
</html>