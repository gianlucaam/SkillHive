<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, com.skillhive.model.User, com.skillhive.model.Service, com.skillhive.dao.DataStub, com.skillhive.model.Order" %>
<% 
    // Imposta intestazioni HTTP per disabilitare la cache
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Genera un cache buster per i file statici
    String cacheBuster = String.valueOf(System.currentTimeMillis());

    // Verifica sessione
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Recupera servizi dell'utente
    List<Service> allServices = DataStub.getServices();
    List<Service> userServices = new ArrayList<>();
    for (Service service : allServices) {
        if (service.getSellerId() == user.getId()) {
            userServices.add(service);
        }
    }
    
    // Recupera ordini dell'utente
    List<Order> userOrders = DataStub.getOrdersByUserId(user.getId());
    
    // Calcola statistiche
    int totalOrders = userOrders.size();
    int totalPublishedServices = userServices.size();
    double totalSpent = 0;
    for (Order order : userOrders) {
        totalSpent += order.getTotal();
    }
    
    // Recupera eventuali messaggi di successo
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/profile.css?v=<%= cacheBuster %>">
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

    <!-- Messages -->
    <% if (successMessage != null) { %>
        <div class="card success">
            <svg class="wave" viewBox="0 0 1440 320" xmlns="http://www.w3.org/2000/svg">
                <path
                    d="M0,256L11.4,240C22.9,224,46,192,69,192C91.4,192,114,224,137,234.7C160,245,183,235,206,213.3C228.6,192,251,160,274,149.3C297.1,139,320,149,343,181.3C365.7,213,389,267,411,282.7C434.3,299,457,277,480,250.7C502.9,224,526,192,549,181.3C571.4,171,594,181,617,208C640,235,663,277,686,256C708.6,235,731,149,754,122.7C777.1,96,800,128,823,165.3C845.7,203,869,245,891,224C914.3,203,937,117,960,112C982.9,107,1006,181,1029,197.3C1051.4,213,1074,171,1097,144C1120,117,1143,107,1166,133.3C1188.6,160,1211,224,1234,218.7C1257.1,213,1280,139,1303,133.3C1325.7,128,1349,192,1371,192C1394.3,192,1417,128,1429,96L1440,64L1440,320L1428.6,320C1417.1,320,1394,320,1371,320C1348.6,320,1326,320,1303,320C1280,320,1257,320,1234,320C1211.4,320,1189,320,1166,320C1142.9,320,1120,320,1097,320C1074.3,320,1051,320,1029,320C1005.7,320,983,320,960,320C937.1,320,914,320,891,320C868.6,320,846,320,823,320C800,320,777,320,754,320C731.4,320,709,320,686,320C662.9,320,640,320,617,320C594.3,320,571,320,549,320C525.7,320,503,320,480,320C457.1,320,434,320,411,320C388.6,320,366,320,343,320C320,320,297,320,274,320C251.4,320,229,320,206,320C182.9,320,160,320,137,320C114.3,320,91,320,69,320C45.7,320,23,320,11,320L0,320Z"
                    fill-opacity="1" fill="#4CAF50"></path>
            </svg>
            <div class="card-content">
                <h3>Success!</h3>
                <p><%= successMessage %></p>
            </div>
            <button class="close-button" onclick="this.parentElement.style.display='none';">×</button>
        </div>
    <% } %>

    <!-- Main Content -->
    <section class="profile-section">
        <div class="container">
            <h1 class="page-title">My Profile</h1>
            
            <div class="profile-content">
                <div class="profile-card">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 256 256">
                                <path fill="currentColor" d="M128 24a104 104 0 1 0 104 104A104.11 104.11 0 0 0 128 24Zm0 16a88 88 0 1 1-88 88a88.1 88.1 0 0 1 88-88Zm0 32a40 40 0 1 0 40 40a40 40 0 0 0-40-40Zm0 64a24 24 0 1 1 24-24a24 24 0 0 1-24 24Zm48 48a8 8 0 0 1-8 8h-80a8 8 0 0 1 0-16h80a8 8 0 0 1 8 8Z"/>
                            </svg>
                        </div>
                        <div class="profile-info">
                            <h2><%= user.getUsername() %></h2>
                            <p>Member since <%= new java.text.SimpleDateFormat("MMMM yyyy").format(new java.util.Date(System.currentTimeMillis() - (long)(Math.random() * 31536000000L))) %></p>
                        </div>
                    </div>
                    
                    <div class="profile-stats">
                        <div class="stat-card">
                            <div class="stat-number"><%= totalPublishedServices %></div>
                            <div class="stat-label">Services Published</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number"><%= totalOrders %></div>
                            <div class="stat-label">Orders Completed</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">$<%= String.format("%.2f", totalSpent) %></div>
                            <div class="stat-label">Total Spent</div>
                        </div>
                    </div>
                    
                    <div class="profile-details">
                        <h3>Personal Information</h3>
                        <form action="../update-profile" method="post" class="profile-form">
                            <div class="form-group">
                                <label for="username">Username:</label>
                                <input type="text" id="username" name="username" value="<%= user.getUsername() %>" readonly>
                            </div>
                            <div class="form-group">
                                <label for="email">Email:</label>
                                <input type="email" id="email" name="email" value="<%= user.getUsername() %>@example.com" required>
                            </div>
                            <div class="form-group">
                                <label for="fullname">Full Name:</label>
                                <input type="text" id="fullname" name="fullname" placeholder="Enter your full name" required>
                            </div>
                            <div class="form-group">
                                <label for="bio">Bio:</label>
                                <textarea id="bio" name="bio" rows="4" placeholder="Tell us about yourself"></textarea>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="save-btn">Save Changes</button>
                            </div>
                        </form>
                    </div>
                    
                    <div class="profile-actions">
                        <a href="dashboard.jsp" class="back-btn">Back to Dashboard</a>
                        <a href="orders.jsp" class="orders-btn">View My Orders</a>
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
