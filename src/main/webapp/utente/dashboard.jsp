<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, java.text.SimpleDateFormat, com.skillhive.model.Order, com.skillhive.model.Service, com.skillhive.model.User, com.skillhive.dao.DataStub" %>
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

    // Recupera servizi e carrello
    List<Service> allServices = DataStub.getServices();
    List<Service> userServices = new ArrayList<>();
    for (Service service : allServices) {
        if (service.getSellerId() == user.getId()) {
            userServices.add(service);
        }
    }
    List<Service> cart = (List<Service>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }
    
    // Recupera gli ordini dell'utente
    List<Order> userOrders = DataStub.getOrdersByUserId(user.getId());
    
    // Formattatore per le date
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Tab attivo
    String activeTab = request.getParameter("tab");
    if (activeTab == null) activeTab = "explore-services";

    // Messaggi
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/dashboard.css?v=<%= cacheBuster %>">
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
            
            <!-- Barra di ricerca -->
            <div class="search-bar">
                <input type="text" placeholder="Search for services..." id="search-input" oninput="searchServices()">
            </div>
            
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
                        <% if (user.isAdmin()) { %>
                        <a href="${pageContext.request.contextPath}/admin/support">Admin Panel</a>
                        <% } %>
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
            <% if (user.isAdmin()) { %>
            <a href="${pageContext.request.contextPath}/admin/support">Admin Panel</a>
            <% } %>
            <a href="../logout" class="logout-btn">Logout</a>
        </nav>
    </header>

    <!-- Categories Bar -->
    <div class="categories-bar">
        <div class="container">
            <a href="#" class="category-link" data-category="Development & IT" onclick="filterByCategory(event, 'Development & IT')">Development & IT</a>
            <a href="#" class="category-link" data-category="Design & Creative" onclick="filterByCategory(event, 'Design & Creative')">Design & Creative</a>
            <a href="#" class="category-link" data-category="Digital Marketing" onclick="filterByCategory(event, 'Digital Marketing')">Digital Marketing</a>
            <a href="#" class="category-link" data-category="Writing & Translation" onclick="filterByCategory(event, 'Writing & Translation')">Writing & Translation</a>
            <a href="#" class="category-link" data-category="Video & Animation" onclick="filterByCategory(event, 'Video & Animation')">Video & Animation</a>
            <a href="#" class="category-link" data-category="Music & Audio" onclick="filterByCategory(event, 'Music & Audio')">Music & Audio</a>
            <a href="#" class="category-link" data-category="Photography" onclick="filterByCategory(event, 'Photography')">Photography</a>
            <a href="#" class="category-link" data-category="Business" onclick="filterByCategory(event, 'Business')">Business</a>
        </div>
    </div>

    <!-- Messages -->
    <% if (errorMessage != null) { %>
        <div class="card error">
            <svg class="wave" viewBox="0 0 1440 320" xmlns="http://www.w3.org/2000/svg">
                <path
                    d="M0,256L11.4,240C22.9,224,46,192,69,192C91.4,192,114,224,137,234.7C160,245,183,235,206,213.3C228.6,192,251,160,274,149.3C297.1,139,320,149,343,181.3C365.7,213,389,267,411,282.7C434.3,299,457,277,480,250.7C502.9,224,526,192,549,181.3C571.4,171,594,181,617,208C640,235,663,277,686,256C708.6,235,731,149,754,122.7C777.1,96,800,128,823,165.3C845.7,203,869,245,891,224C914.3,203,937,117,960,112C982.9,107,1006,181,1029,197.3C1051.4,213,1074,171,1097,144C1120,117,1143,107,1166,133.3C1188.6,160,1211,224,1234,218.7C1257.1,213,1280,139,1303,133.3C1325.7,128,1349,192,1371,192C1394.3,192,1417,128,1429,96L1440,64L1440,320L1428.6,320C1417.1,320,1394,320,1371,320C1348.6,320,1326,320,1303,320C1280,320,1257,320,1234,320C1211.4,320,1189,320,1166,320C1142.9,320,1120,320,1097,320C1074.3,320,1051,320,1029,320C1005.7,320,983,320,960,320C937.1,320,914,320,891,320C868.6,320,846,320,823,320C800,320,777,320,754,320C731.4,320,709,320,686,320C662.9,320,640,320,617,320C594.3,320,571,320,549,320C525.7,320,503,320,480,320C457.1,320,434,320,411,320C388.6,320,366,320,343,320C320,320,297,320,274,320C251.4,320,229,320,206,320C182.9,320,160,320,137,320C114.3,320,91,320,69,320C45.7,320,23,320,11,320L0,320Z"
                    fill="#dc35453a"
                ></path>
            </svg>
            <div class="icon-container">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 256 256" class="icon">
                    <path fill="currentColor" d="M128 24a104 104 0 1 0 104 104A104.11 104.11 0 0 0 128 24Zm0 192a88 88 0 1 1 88-88a88.1 88.1 0 0 1-88 88Zm-8-80a8 8 0 0 1-16 0v-16a8 8 0 0 1 16 0Zm24 0a8 8 0 0 1-16 0v-16a8 8 0 0 1 16 0Zm-8 40a8 8 0 0 1-8 8h-16a8 8 0 0 1 0-16h16a8 8 0 0 1 8 8Z"/>
                </svg>
            </div>
            <div class="message-text-container">
                <p class="message-text">Errore</p>
                <p class="sub-text"><%= errorMessage %></p>
            </div>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 256 256" class="cross-icon">
                <path fill="currentColor" d="M208 32H48a16 16 0 0 0-16 16v160a16 16 0 0 0 16 16h160a16 16 0 0 0 16-16V48a16 16 0 0 0-16-16Zm-26.34 149.66a8 8 0 0 1-11.32 11.32L128 150.63l-42.34 42.35a8 8 0 0 1-11.32-11.32L116.69 128L74.34 85.66a8 8 0 0 1 11.32-11.32L128 116.69l42.34-42.35a8 8 0 0 1 11.32 11.32L139.31 128Z"/>
            </svg>
        </div>
    <% } %>
    <% if (successMessage != null) { %>
        <div class="card success">
            <svg class="wave" viewBox="0 0 1440 320" xmlns="http://www.w3.org/2000/svg">
                <path
                    d="M0,256L11.4,240C22.9,224,46,192,69,192C91.4,192,114,224,137,234.7C160,245,183,235,206,213.3C228.6,192,251,160,274,149.3C297.1,139,320,149,343,181.3C365.7,213,389,267,411,282.7C434.3,299,457,277,480,250.7C502.9,224,526,192,549,181.3C571.4,171,594,181,617,208C640,235,663,277,686,256C708.6,235,731,149,754,122.7C777.1,96,800,128,823,165.3C845.7,203,869,245,891,224C914.3,203,937,117,960,112C982.9,107,1006,181,1029,197.3C1051.4,213,1074,171,1097,144C1120,117,1143,107,1166,133.3C1188.6,160,1211,224,1234,218.7C1257.1,213,1280,139,1303,133.3C1325.7,128,1349,192,1371,192C1394.3,192,1417,128,1429,96L1440,64L1440,320L1428.6,320C1417.1,320,1394,320,1371,320C1348.6,320,1326,320,1303,320C1280,320,1257,320,1234,320C1211.4,320,1189,320,1166,320C1142.9,320,1120,320,1097,320C1074.3,320,1051,320,1029,320C1005.7,320,983,320,960,320C937.1,320,914,320,891,320C868.6,320,846,320,823,320C800,320,777,320,754,320C731.4,320,709,320,686,320C662.9,320,640,320,617,320C594.3,320,571,320,549,320C525.7,320,503,320,480,320C457.1,320,434,320,411,320C388.6,320,366,320,343,320C320,320,297,320,274,320C251.4,320,229,320,206,320C182.9,320,160,320,137,320C114.3,320,91,320,69,320C45.7,320,23,320,11,320L0,320Z"
                    fill="#04e4003a"
                ></path>
            </svg>
            <div class="icon-container">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 256 256" class="icon">
                    <path fill="currentColor" d="M128 24a104 104 0 1 0 104 104A104.11 104.11 0 0 0 128 24Zm0 192a88 88 0 1 1 88-88a88.1 88.1 0 0 1-88 88Zm61.65-93.65l-56 56a12 12 0 0 1-17 0l-24-24a12 12 0 0 1 17-17L128 155.71l47.51-47.52a12 12 0 0 1 17 17Z"/>
                </svg>
            </div>
            <div class="message-text-container">
                <p class="message-text">Successo</p>
                <p class="sub-text"><%= successMessage %></p>
            </div>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 256 256" class="cross-icon">
                <path fill="currentColor" d="M208 32H48a16 16 0 0 0-16 16v160a16 16 0 0 0 16 16h160a16 16 0 0 0 16-16V48a16 16 0 0 0-16-16Zm-26.34 149.66a8 8 0 0 1-11.32 11.32L128 150.63l-42.34 42.35a8 8 0 0 1-11.32-11.32L116.69 128L74.34 85.66a8 8 0 0 1 11.32-11.32L128 116.69l42.34-42.35a8 8 0 0 1 11.32 11.32L139.31 128Z"/>
            </svg>
        </div>
        <% session.removeAttribute("successMessage"); %>
    <% } %>

    <!-- Dashboard Section -->
    <section class="dashboard-section">
        <div class="container">
            <div class="dashboard-tabs">
                <button class="tab-button <%= activeTab.equals("explore-services") ? "active" : "" %>" onclick="openTab(event, 'explore-services')">Explore Services</button>
                <a href="sales-dashboard.jsp" class="tab-button">Sales Dashboard</a>
            </div>

            <!-- Explore Services Tab -->
            <div id="explore-services" class="tab-content <%= activeTab.equals("explore-services") ? "active" : "" %>">
                <div class="filter-toggle">
                    <button class="filter-toggle-btn" onclick="toggleFilters()">Filters</button>
                </div>
                <div class="filters" id="filters-section">
                    <div class="filter-group">
                        <label for="category-filter">Category:</label>
                        <select id="category-filter" name="category" onchange="applyFilters()">
                            <option value="">All Categories</option>
                            <option value="Development & IT">Development & IT</option>
                            <option value="Design & Creative">Design & Creative</option>
                            <option value="Digital Marketing">Digital Marketing</option>
                            <option value="Writing & Translation">Writing & Translation</option>
                            <option value="Video & Animation">Video & Animation</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="price-min">Price Range:</label>
                        <input type="number" id="price-min" name="price-min" placeholder="Min" min="0">
                        <input type="number" id="price-max" name="price-max" placeholder="Max" min="0">
                    </div>
                    <div class="filter-group">
                        <label for="delivery-time">Delivery Time:</label>
                        <select id="delivery-time" name="delivery-time">
                            <option value="">Any</option>
                            <option value="1">1 Day</option>
                            <option value="3">3 Days</option>
                            <option value="7">7 Days</option>
                        </select>
                    </div>
                    <button class="filter-btn" onclick="applyFilters()">Apply Filters</button>
                </div>
                <div class="services-grid">
                    <% 
                        if (allServices != null && !allServices.isEmpty()) {
                            for (Service service : allServices) {
                    %>
                        <div class="service-card" data-category="<%= service.getCategory() %>">
                            <div class="service-image-wrapper">
                                <img src="../<%= service.getImage() %>" alt="<%= service.getTitle() %>">
                            </div>
                            <div class="service-content">
                                <h3><%= service.getTitle() %></h3>
                                <p class="service-description"><%= service.getDescription() %></p>
                                <div class="service-details">
                                    <span class="delivery-time">Delivery in 5 days</span>
                                    <span class="rating">⭐ 4.9 (156 reviews)</span>
                                </div>
                                <div class="service-footer">
                                    <a href="#" class="seller">by Seller <%= service.getSellerId() %></a>
                                    <span class="price">$<%= String.format("%.2f", service.getPrice()) %></span>
                                </div>
                                <div class="service-actions">
                                    <form action="../add-to-cart" method="post">
                                        <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                                        <input type="hidden" name="title" value="<%= service.getTitle() %>">
                                        <input type="hidden" name="price" value="<%= service.getPrice() %>">
                                        <input type="hidden" name="sellerId" value="<%= service.getSellerId() %>">
                                        <button type="submit" class="add-to-cart">
                                            Add to Cart
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 256 256" class="add-to-cart-icon">
                                                <path fill="currentColor" d="M236 92a12 12 0 0 1-12 12h-4.17a4 4 0 0 1-4-4.37l4.29-30a4 4 0 0 0-1-3.24C209.61 57.76 191.56 52 172 52c-32.26 0-56.32 12.86-73.37 34H88a4 4 0 0 0-4 4v24a4 4 0 0 0 4 4h24a4 4 0 0 0 4-4V90a4 4 0 0 0-1.34-3c-12.46-10.67-28.31-16-45.66-16a60.69 60.69 0 0 0-12 1.18V216a4 4 0 0 0 4 4h152a4 4 0 0 0 4-4v-16a4 4 0 0 0-4-4h-84a4 4 0 0 0 0 8h80v-98.28c11.88-1.42 24-5.46 34.85-12.88a4 4 0 0 0 1.32-3.13l-4.29-30A12 12 0 0 1 224 48h12a12 12 0 0 1 12 12v20a12 12 0 0 1-12 12Zm-136 96a16 16 0 1 1 16-16a16 16 0 0 1-16 16Zm88 0a16 16 0 1 1 16-16a16 16 0 0 1-16 16Z"/>
                                            </svg>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    <% 
                            }
                        } else {
                    %>
                        <p class="error-message">No services available.</p>
                    <% } %>
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
        function toggleFullScreen(video) {
            if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {
                if (video.requestFullscreen) {
                    video.requestFullscreen();
                } else if (video.mozRequestFullScreen) {
                    video.mozRequestFullScreen();
                } else if (video.webkitRequestFullscreen) {
                    video.webkitRequestFullscreen();
                } else if (video.msRequestFullscreen) {
                    video.msRequestFullscreen();
                }
            } else {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                } else if (document.mozCancelFullScreen) {
                    document.mozCancelFullScreen();
                } else if (document.webkitExitFullscreen) {
                    document.webkitExitFullscreen();
                } else if (document.msExitFullscreen) {
                    document.msExitFullscreen();
                }
            }
        }

        function openTab(event, tabName) {
            var tabContents = document.getElementsByClassName("tab-content");
            for (var i = 0; i < tabContents.length; i++) {
                tabContents[i].classList.remove("active");
            }
            var tabButtons = document.getElementsByClassName("tab-button");
            for (var i = 0; i < tabButtons.length; i++) {
                tabButtons[i].classList.remove("active");
            }
            document.getElementById(tabName).classList.add("active");
            event.currentTarget.classList.add("active");
        }

        function toggleFilters() {
            var filtersSection = document.getElementById("filters-section");
            filtersSection.classList.toggle("active");
        }

        function applyFilters() {
            var category = document.getElementById("category-filter").value;
            var priceMin = document.getElementById("price-min").value;
            var priceMax = document.getElementById("price-max").value;
            var deliveryTime = document.getElementById("delivery-time").value;

            priceMin = priceMin ? parseFloat(priceMin) : 0;
            priceMax = priceMax ? parseFloat(priceMax) : Infinity;

            var services = document.getElementsByClassName("service-card");

            for (var i = 0; i < services.length; i++) {
                var service = services[i];
                var servicePrice = parseFloat(service.querySelector(".price").textContent.replace("$", ""));
                var serviceCategory = service.getAttribute("data-category");

                var showService = true;
                if (category && serviceCategory !== category) showService = false;
                if (servicePrice < priceMin || servicePrice > priceMax) showService = false;

                service.style.display = showService ? "block" : "none";
            }
        }

        function filterByCategory(event, category) {
            event.preventDefault();
            var categoryLinks = document.getElementsByClassName("category-link");
            for (var i = 0; i < categoryLinks.length; i++) {
                categoryLinks[i].classList.remove("active");
            }
            event.currentTarget.classList.add("active");
            var categoryFilter = document.getElementById("category-filter");
            categoryFilter.value = category;
            applyFilters();
            var exploreServicesTab = document.getElementById("explore-services");
            if (!exploreServicesTab.classList.contains("active")) {
                openTab({ currentTarget: document.querySelector('button[onclick*="explore-services"]') }, 'explore-services');
            }
            document.getElementById("explore-services").scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        function searchServices() {
            var searchInput = document.getElementById("search-input").value.toLowerCase();
            var services = document.getElementsByClassName("service-card");

            for (var i = 0; i < services.length; i++) {
                var service = services[i];
                var title = service.querySelector("h3").textContent.toLowerCase();
                var description = service.querySelector(".service-description").textContent.toLowerCase();

                if (title.includes(searchInput) || description.includes(searchInput)) {
                    service.style.display = "block";
                } else {
                    service.style.display = "none";
                }
            }
        }

        document.querySelector('.user-menu').addEventListener('click', function() {
            var dropdown = document.querySelector('.user-menu-dropdown');
            dropdown.classList.toggle('active');
        });

        document.addEventListener('click', function(event) {
            var userMenu = document.querySelector('.user-menu');
            if (!userMenu.contains(event.target)) {
                var dropdown = document.querySelector('.user-menu-dropdown');
                dropdown.classList.remove('active');
            }
        });

        const hamburgerMenu = document.querySelector('.hamburger-menu');
        const mobileNav = document.querySelector('.mobile-nav');
        hamburgerMenu.addEventListener('click', () => {
            hamburgerMenu.classList.toggle('active');
            mobileNav.classList.toggle('active');
            document.body.classList.toggle('menu-open');
        });
    </script>
</body>
</html>