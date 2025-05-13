<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillhive.model.User" %>
<%@ page import="com.skillhive.model.Service" %>
<%@ page import="com.skillhive.dao.DataStub" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<% 
    // Imposta intestazioni HTTP per disabilitare la cache
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Genera un cache buster per i file statici
    String cacheBuster = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillHive - Connect Digital Talent</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/index.css?v=<%= cacheBuster %>">
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("utente/dashboard.jsp");
        return;
    }
    List<Service> services = DataStub.getServices();
    List<User> users = DataStub.getUsers();
    Set<String> categories = new HashSet<>();
    for (Service service : services) {
        categories.add(service.getCategory());
    }
    // Ordinare le categorie alfabeticamente
    List<String> sortedCategories = new ArrayList<>(categories);
    Collections.sort(sortedCategories);
    // Contare i servizi per categoria
    java.util.Map<String, Integer> serviceCountByCategory = new java.util.HashMap<>();
    for (Service service : services) {
        serviceCountByCategory.put(service.getCategory(), 
            serviceCountByCategory.getOrDefault(service.getCategory(), 0) + 1);
    }
    request.setAttribute("services", services);
    request.setAttribute("users", users);
    request.setAttribute("categories", sortedCategories);
%>
    <!-- Header -->
    <header>
        <a href="index.jsp" class="logo">
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
        <nav>
            <a href="#">Marketplace</a>
            <a href="#">Professionals</a>
            <a href="#">Connect with Talent</a>
            <a href="register.jsp">
            <div class="signup-btn">
                <img src="images/img_user.svg" alt="User Icon" width="20" height="20">
                <span>Sign Up</span>
            </div>
            </a>
        </nav>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Connect with Top Digital Talent</h1>
            <p>SkillHive is your platform to discover and hire professionals for custom digital services, from software development to graphic design.</p>
            <div class="get-started-btn">
                <img src="images/img_rocketlaunch.svg" alt="Rocket Launch Icon" width="20" height="20">
                <span>Get Started</span>
            </div>
            <div class="stats">
                <div class="stat">
                    <h2>10k+</h2>
                    <p>Projects Completed</p>
                </div>
                <div class="stat">
                    <h2>5k+</h2>
                    <p>Active Professionals</p>
                </div>
                <div class="stat">
                    <h2>20k+</h2>
                    <p>Satisfied Clients</p>
                </div>
            </div>
        </div>
        <div class="hero-image">
            <video class="promo-video" autoplay loop muted playsinline>
                <source src="videos/skillhive-promo.mp4" type="video/mp4">
                Your browser does not support the video tag.
            </video>
        </div>
    </section>

    <!-- Popular Services Section -->
    <section class="trending">
        <h2 class="section-title">Popular Services</h2>
        <p class="section-subtitle">Explore our most sought-after digital services.</p>
        <div class="trending-grid">
            <% for (int i = 0; i < Math.min(4, services.size()); i++) { 
                Service service = services.get(i); %>
                <div class="trending-card">
                    <img src="<%= service.getImage() %>" alt="<%= service.getTitle() %>" class="trending-primary">
                    <div class="trending-secondary-grid">
                        <img src="<%= service.getImage() %>" alt="<%= service.getTitle() %> Sample" class="trending-secondary">
                        <img src="<%= service.getImage() %>" alt="<%= service.getTitle() %> Sample" class="trending-secondary">
                        <div class="trending-more">50+</div>
                    </div>
                    <div class="trending-info">
                        <h3><%= service.getTitle() %></h3>
                        <div class="creator">
                            <img src="images/img_avatar_placeholder_24x24.png" alt="Professional Avatar">
                            <% User seller = DataStub.getUserById(service.getSellerId()); %>
                            <span><%= seller.getUsername() %></span>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Top Professionals Section -->
    <section class="creators">
        <div class="creators-header">
            <div class="creators-header-left">
                <h2 class="section-title">Top Professionals</h2>
                <p class="section-subtitle">Discover our highest-rated digital professionals on SkillHive.</p>
            </div>
            <div class="rankings-btn">
                <img src="images/img_rocketlaunch_20x20.svg" alt="Rocket Launch Icon" width="20" height="20">
                <span>View Rankings</span>
            </div>
        </div>
        <div class="creators-grid">
            <% for (int i = 0; i < users.size(); i++) { 
                User creator = users.get(i); %>
                <div class="creator-card">
                    <div class="creator-number"><%= i + 1 %></div>
                    <img src="images/img_avatar_placeholder_120x120.png" alt="<%= creator.getUsername() %>" class="creator-avatar">
                    <h3 class="creator-name"><%= creator.getUsername() %></h3>
                    <div class="creator-sales">
                        <span class="creator-sales-label">Total Projects:</span>
                        <span class="creator-sales-value"><%= (i + 1) * 25 %></span>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Browse Categories Section -->
    <section class="categories">
        <h2 class="section-title">Browse Categories</h2>
        <div class="categories-grid">
            <% 
                // Mappa categoria-icona per gestire le icone
                java.util.Map<String, String> categoryIcons = new java.util.HashMap<>();
            	categoryIcons.put("Development", 
            	    "<svg viewBox='0 0 640 512'  width='5em' height='5em' xmlns='http://www.w3.org/2000/svg'>" +
            	        "<path fill='white' d='M392.8 1.2c-17-4.9-34.7 5-39.6 22l-128 448c-4.9 17 5 34.7 22 39.6s34.7-5 39.6-22l128-448c4.9-17-5-34.7-22-39.6zm80.6 120.1c-12.5 12.5-12.5 32.8 0 45.3L562.7 256l-89.4 89.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0l112-112c12.5-12.5 12.5-32.8 0-45.3l-112-112c-12.5-12.5-32.8-12.5-45.3 0zm-306.7 0c-12.5-12.5-32.8-12.5-45.3 0l-112 112c-12.5 12.5-12.5 32.8 0 45.3l112 112c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L77.3 256l89.4-89.4c12.5-12.5 12.5-32.8 0-45.3z'/>" +
            	    "</svg>");

                categoryIcons.put("Graphic Design", "images/img_paintbrush.svg");
                categoryIcons.put("Video Editing", "images/img_videocamera.svg");
                categoryIcons.put("Marketing", "images/img_marketing.svg");

                // Mappa categoria-immagine di sfondo
                java.util.Map<String, String> categoryBackgrounds = new java.util.HashMap<>();
                categoryBackgrounds.put("Development", "images/img_image_placeholder_240x240.png");
                categoryBackgrounds.put("Graphic Design", "images/img_image_placeholder_240x240.png");
                categoryBackgrounds.put("Video Editing", "images/img_image_placeholder_240x240.png");
                categoryBackgrounds.put("Marketing", "images/img_image_placeholder_240x240.png");
                

                for (String category : sortedCategories) {
                    String icon = categoryIcons.getOrDefault(category, "images/img_default.svg");
                    String background = categoryBackgrounds.getOrDefault(category, "images/img_image_placeholder_240x240.png");
                    int serviceCount = serviceCountByCategory.getOrDefault(category, 0);
            %>
                <div class="category-card">
                    <div class="category-image">
                        <img src="<%= background %>" alt="<%= category %> Background" width="240" height="240">
                        <div class="category-icon">
    <% if (icon.startsWith("<svg")) { %>
        <%= icon %>
    <% } else { %>
        <img src="<%= icon %>" alt="<%= category %> Icon" width="100" height="100">
    <% } %>
</div>

                    </div>
                    <h3 class="category-name"><%= category %> (<%= serviceCount %>)</h3>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Discover More Services Section -->
    <section class="discover">
        <div class="discover-header">
            <div>
                <h2 class="section-title">Discover More Services</h2>
                <p class="section-subtitle">Explore new trending digital services.</p>
            </div>
            <div class="see-all-btn">
                <img src="images/img_eye.svg" alt="Eye Icon" width="20" height="20">
                <span>See All</span>
            </div>
        </div>
        <div class="nft-grid">
            <% for (int i = 4; i < Math.min(10, services.size()); i++) { 
                Service service = services.get(i); %>
                <div class="nft-card">
                    <img src="<%= service.getImage() %>" alt="<%= service.getTitle() %>" class="nft-image">
                    <div class="nft-info">
                        <h3 class="nft-title"><%= service.getTitle() %></h3>
                        <div class="nft-creator">
                            <img src="images/img_avatar_placeholder_14.png" alt="Professional Avatar">
                            <% User seller = DataStub.getUserById(service.getSellerId()); %>
                            <span><%= seller.getUsername() %></span>
                        </div>
                        <div class="nft-details">
                            <div class="nft-price">
                                <span class="nft-label">Price</span>
                                <span class="nft-value">$<%= service.getPrice() %></span>
                            </div>
                            <div class="nft-bid">
                                <span class="nft-label">Delivery Time</span>
                                <span class="nft-value"><%= service.getDeliveryTime() %> Days</span>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Highlight Service Section -->
    <section class="highlight">
        <div class="highlight-content">
            <div class="highlight-info">
                <div class="highlight-creator">
                    <img src="images/img_avatar_placeholder_1.png" alt="Professional Avatar">
                    <% User seller = DataStub.getUserById(services.get(5).getSellerId()); %>
                    <span><%= seller.getUsername() %></span>
                </div>
                <h2 class="highlight-title"><%= services.get(5).getTitle() %></h2>
                <div class="see-nft-btn">
                    <img src="images/img_eye.svg" alt="Eye Icon" width="20" height="20">
                    <span>View Service</span>
                </div>
            </div>
            <div class="auction-timer">
                <div class="auction-label">Offer available for:</div>
                <div class="auction-countdown">
                    <div class="auction-unit">
                        <div class="auction-number">59</div>
                        <div class="auction-text">Hours</div>
                    </div>
                    <div class="auction-separator">:</div>
                    <div class="auction-unit">
                        <div class="auction-number">59</div>
                        <div class="auction-text">Minutes</div>
                    </div>
                    <div class="auction-separator">:</div>
                    <div class="auction-unit">
                        <div class="auction-number">59</div>
                        <div class="auction-text">Seconds</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="how-it-works">
        <h2 class="section-title">How It Works</h2>
        <p class="section-subtitle">Learn how to get started with SkillHive</p>
        <div class="steps-grid">
            <div class="step-card">
                <img src="images/img_icon.svg" alt="Create Account" class="step-icon">
                <h3 class="step-title">Create Your Account</h3>
                <p class="step-description">Sign up as a client or professional. Connect your account to start exploring or offering services.</p>
            </div>
            <div class="step-card">
                <img src="images/img_icon_250x250.png" alt="Find or Offer Services" class="step-icon">
                <h3 class="step-title">Find or Offer Services</h3>
                <p class="step-description">Browse services or create your own. Add details, set prices, and connect with clients.</p>
            </div>
            <div class="step-card">
                <img src="images/img_icon_1.png" alt="Manage Projects" class="step-icon">
                <h3 class="step-title">Manage Projects</h3>
                <p class="step-description">Track orders, communicate via real-time chat, and deliver results with transparency.</p>
            </div>
        </div>
    </section>

    <!-- Subscribe Section -->
    <section class="subscribe">
        <div class="subscribe-card">
            <img src="images/mascotte.png" alt="Subscribe" class="subscribe-image">
            <div class="subscribe-content">
                <h2 class="subscribe-title">Join Our Community</h2>
                <p class="subscribe-description">Get exclusive updates on new services and top professionals straight to your inbox.</p>
                <div class="subscribe-form">
                    <input type="email" placeholder="Enter your email here" class="subscribe-input">
                    <div class="subscribe-btn">
                        <img src="images/img_envelopesimple.svg" alt="Envelope Icon" width="20" height="20">
                        <span>Subscribe</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <div class="footer-info">
                <div class="footer-logo">
                    <a href="index.jsp" class="logo">
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
                </div>
                <p class="footer-description">SkillHive connects digital professionals with clients for custom services.</p>
                <p>Join our community</p>
                <div class="footer-social">
                    <img src="images/img_discordlogo.svg" alt="Discord" width="32" height="32">
                    <img src="images/img_youtubelogo.svg" alt="YouTube" width="32" height="32">
                    <img src="images/img_twitterlogo.svg" alt="Twitter" width="32" height="32">
                    <img src="images/img_instagramlogo.svg" alt="Instagram" width="32" height="32">
                </div>
            </div>
            <div class="footer-links">
                <h3>Explore</h3>
                <a href="#">Marketplace</a>
                <a href="#">Professionals</a>
                <a href="#">Connect with Talent</a>
            </div>
            <div class="footer-subscribe">
                <h3>Join our weekly digest</h3>
                <p>Get exclusive promotions & updates straight to your inbox.</p>
                <div class="footer-form">
                    <input type="email" placeholder="Enter your email here" class="footer-input">
                    <div class="footer-btn">
                        <span>Subscribe</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-divider"></div>
        <p class="footer-copyright">Ⓒ 2025 SkillHive. All rights reserved.</p>
    </footer>

    <!-- JavaScript -->
    <script>
        function updateCountdown() {
            const hours = document.querySelectorAll('.auction-number')[0];
            const minutes = document.querySelectorAll('.auction-number')[1];
            const seconds = document.querySelectorAll('.auction-number')[2];
            let h = parseInt(hours.textContent);
            let m = parseInt(minutes.textContent);
            let s = parseInt(seconds.textContent);
            s--;
            if (s < 0) {
                s = 59;
                m--;
                if (m < 0) {
                    m = 59;
                    h--;
                    if (h < 0) {
                        h = 0;
                        m = 0;
                        s = 0;
                    }
                }
            }
            hours.textContent = h.toString().padStart(2, '0');
            minutes.textContent = m.toString().padStart(2, '0');
            seconds.textContent = s.toString().padStart(2, '0');
        }
        setInterval(updateCountdown, 1000);
        document.querySelectorAll('.get-started-btn, .rankings-btn, .see-all-btn, .see-nft-btn, .subscribe-btn, .footer-btn').forEach(button => {
            button.addEventListener('click', function() {
                alert('This feature would be implemented in a production environment.');
            });
        });
        document.querySelectorAll('.category-card').forEach(card => {
            card.addEventListener('click', function() {
                alert('Navigating to ' + this.querySelector('.category-name').textContent + ' category.');
            });
        });
        document.querySelectorAll('.nft-card').forEach(card => {
            card.addEventListener('click', function() {
                alert('Viewing details for ' + this.querySelector('.nft-title').textContent + ' service.');
            });
        });
        document.querySelectorAll('.creator-card').forEach(card => {
            card.addEventListener('click', function() {
                alert('Viewing profile of ' + this.querySelector('.creator-name').textContent + '.');
            });
        });
        document.querySelectorAll('.subscribe-btn, .footer-btn').forEach(button => {
            button.addEventListener('click', function() {
                const input = this.parentElement.querySelector('input');
                if (input && input.value) {
                    alert('Thank you for subscribing with: ' + input.value);
                    input.value = '';
                } else {
                    alert('Please enter a valid email address.');
                }
            });
        });
    </script>
</body>
</html>