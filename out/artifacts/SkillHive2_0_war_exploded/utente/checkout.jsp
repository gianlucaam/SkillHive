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
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
    
    // Calcola il totale
    double total = 0.0;
    for (Service service : cart) {
        total += service.getPrice();
    }
    
    // Recupera eventuali messaggi di errore
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/checkout.css?v=<%= cacheBuster %>">
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
    <section class="checkout-section">
        <div class="container">
            <h1 class="page-title">Checkout</h1>
            
            <% if (errorMessage != null) { %>
                <div class="error-message">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <div class="checkout-container">
                <div class="checkout-form">
                    <h3 class="section-title">Billing Details</h3>
                    <form action="../checkout" method="post">
                        <div class="form-group">
                            <label for="fullname">Full Name</label>
                            <input type="text" id="fullname" name="fullname" value="<%= user.getUsername() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="address">Shipping Address</label>
                            <textarea id="address" name="address" required placeholder="Enter your street address"></textarea>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="city">City</label>
                                <input type="text" id="city" name="city" required>
                            </div>
                            <div class="form-group">
                                <label for="zip">ZIP Code</label>
                                <input type="text" id="zip" name="zip" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="country">Country</label>
                            <input type="text" id="country" name="country" required>
                        </div>
                        
                        <h3 class="section-title">Payment Information</h3>
                        <div class="form-group">
                            <label for="cardname">Name on Card</label>
                            <input type="text" id="cardname" name="cardname" required>
                        </div>
                        <div class="form-group">
                            <label for="cardnumber">Card Number</label>
                            <input type="text" id="cardnumber" name="cardnumber" placeholder="XXXX XXXX XXXX XXXX" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="expiry">Expiration Date</label>
                                <input type="text" id="expiry" name="expiry" placeholder="MM/YY" required>
                            </div>
                            <div class="form-group">
                                <label for="cvv">CVV</label>
                                <input type="text" id="cvv" name="cvv" placeholder="123" required>
                            </div>
                        </div>
                        
                        <button type="submit" class="checkout-btn">Complete Order</button>
                    </form>
                </div>
                
                <div class="order-summary">
                    <h3 class="section-title">Order Summary</h3>
                    <div class="order-items">
                        <% for (Service service : cart) { %>
                            <div class="order-item">
                                <div class="order-item-name"><%= service.getTitle() %></div>
                                <div class="order-item-price">€<%= String.format("%.2f", service.getPrice()) %></div>
                            </div>
                        <% } %>
                    </div>
                    <div class="order-total">
                        <span>Total</span>
                        <span>€<%= String.format("%.2f", total) %></span>
                    </div>
                </div>
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
