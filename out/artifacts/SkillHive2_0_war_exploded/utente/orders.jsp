<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat, com.skillhive.model.Order, com.skillhive.model.Service, com.skillhive.model.User, com.skillhive.dao.DataStub" %>
<% 
    // Verifica sessione
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Genera un cache buster per i file statici
    String cacheBuster = String.valueOf(System.currentTimeMillis());
    
    // Recupera gli ordini dell'utente
    List<Order> userOrders = DataStub.getOrdersByUserId(user.getId());
    
    // Formattatore per le date
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/dashboard.css?v=<%= cacheBuster %>">
    <link rel="stylesheet" href="../css/orders.css?v=<%= cacheBuster %>">
    <script src="../js/messages.js" defer></script>
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
                <a href="cart.jsp" class="cart-icon">
                    <svg class="icon-cart" viewBox="0 0 24.38 30.52" height="2em" width="2em" xmlns="http://www.w3.org/2000/svg">
            			<title>icon-cart</title>
            			<path transform="translate(-3.62 -0.85)" fill='white' d="M28,27.3,26.24,7.51a.75.75,0,0,0-.76-.69h-3.7a6,6,0,0,0-12,0H6.13a.76.76,0,0,0-.76.69L3.62,27.3v.07a4.29,4.29,0,0,0,4.52,4H23.48a4.29,4.29,0,0,0,4.52-4ZM15.81,2.37a4.47,4.47,0,0,1,4.46,4.45H11.35a4.47,4.47,0,0,1,4.46-4.45Zm7.67,27.48H8.13a2.79,2.79,0,0,1-3-2.45L6.83,8.34h3V11a.76.76,0,0,0,1.52,0V8.34h8.92V11a.76.76,0,0,0,1.52,0V8.34h3L26.48,27.4a2.79,2.79,0,0,1-3,2.44Zm0,0"></path>
          			</svg>
                </a>
                <div class="user-menu">
                    <span class="user-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 256 256" class="user-icon-svg">
                            <path fill="currentColor" d="M128 24a104 104 0 1 0 104 104A104.11 104.11 0 0 0 128 24Zm0 16a88 88 0 1 1-88 88a88.1 88.1 0 0 1 88-88Zm0 32a40 40 0 1 0 40 40a40 40 0 0 0-40-40Zm0 64a24 24 0 1 1 24-24a24 24 0 0 1-24 24Zm48 48a8 8 0 0 1-8 8h-80a8 8 0 0 1 0-16h80a8 8 0 0 1 8 8Z"/>
                        </svg>
                    </span>
                    <span><%= user.getUsername() %></span>
                    <div class="user-menu-dropdown">
                        <a href="profile.jsp">My Profile</a>
                        <a href="orders.jsp">My Orders</a>
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
            <a href="cart.jsp" class="cart-icon">
                <svg class="icon-cart" viewBox="0 0 24.38 30.52" height="2em" width="2em" xmlns="http://www.w3.org/2000/svg">
                    <title>icon-cart</title>
                    <path transform="translate(-3.62 -0.85)" fill='white' d="M28,27.3,26.24,7.51a.75.75,0,0,0-.76-.69h-3.7a6,6,0,0,0-12,0H6.13a.76.76,0,0,0-.76.69L3.62,27.3v.07a4.29,4.29,0,0,0,4.52,4H23.48a4.29,4.29,0,0,0,4.52-4ZM15.81,2.37a4.47,4.47,0,0,1,4.46,4.45H11.35a4.47,4.47,0,0,1,4.46-4.45Zm7.67,27.48H8.13a2.79,2.79,0,0,1-3-2.45L6.83,8.34h3V11a.76.76,0,0,0,1.52,0V8.34h8.92V11a.76.76,0,0,0,1.52,0V8.34h3L26.48,27.4a2.79,2.79,0,0,1-3,2.44Zm0,0"></path>
                </svg>
            </a>
            <a href="profile.jsp">My Profile</a>
            <a href="orders.jsp">My Orders</a>
            <a href="../logout" class="logout-btn">Logout</a>
        </nav>
    </header>

    <!-- Main Content -->
    <section class="profile-section">
        <div class="container">
            <h1 class="page-title">My Orders</h1>
            
            <div class="profile-content">
                <% if (userOrders != null && !userOrders.isEmpty()) { %>
                    <div class="orders-grid">
                        <% for (Order order : userOrders) { %>
                            <div class="order-card">
                                <div class="order-header">
                                    <h3>Order #<%= order.getId() %></h3>
                                    <span class="order-date"><%= dateFormat.format(order.getOrderDate()) %></span>
                                </div>
                                <div class="order-details">
                                    <p><strong>Shipping Address:</strong> <%= order.getShippingAddress() %></p>
                                    <p><strong>Payment Method:</strong> <%= order.getPaymentMethod() %></p>
                                    <p><strong>Total:</strong> €<%= String.format("%.2f", order.getTotal()) %></p>
                                    <p class="status">Status: <%= order.getStatus() %></p>
                                </div>
                                <div class="order-items">
                                    <h4>Items:</h4>
                                    <ul>
                                    <% for (Service service : order.getServices()) { %>
                                        <li>
                                            <%= service.getTitle() %> - €<%= String.format("%.2f", service.getPrice()) %>
                                        </li>
                                    <% } %>
                                    </ul>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="no-orders-message">
                        <p>You haven't placed any orders yet.</p>
                        <p>Explore our services and make your first purchase!</p>
                        <a href="dashboard.jsp" class="explore-btn">Explore Services</a>
                    </div>
                <% } %>
            </div>
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
                    <a href="#"><img src="../images/img_discordlogo.svg" alt="Discord" width="32" height="32"></a>
                    <a href="#"><img src="../images/img_youtubelogo.svg" alt="YouTube" width="32" height="32"></a>
                    <a href="#"><img src="../images/img_twitterlogo.svg" alt="Twitter" width="32" height="32"></a>
                    <a href="#"><img src="../images/img_instagramlogo.svg" alt="Instagram" width="32" height="32"></a>
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
            <p>&copy; 2025 SkillHive. All rights reserved.</p>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        document.querySelector('.hamburger-menu').addEventListener('click', function() {
            this.classList.toggle('active');
            document.querySelector('.mobile-nav').classList.toggle('active');
        });

        document.querySelector('.user-menu').addEventListener('click', function() {
            var dropdown = document.querySelector('.user-menu-dropdown');
            dropdown.classList.toggle('active');
        });
    </script>
</body>
</html>
