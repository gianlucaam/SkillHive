<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, com.skillhive.model.Service, com.skillhive.model.User, com.skillhive.dao.DataStub" %>
<% 
    // Verifica sessione
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Genera un cache buster per i file statici
    String cacheBuster = String.valueOf(System.currentTimeMillis());

    // Dati del servizio (per modifica)
    String serviceId = request.getParameter("serviceId");
    Service service = null;
    if (serviceId != null) {
        List<Service> allServices = DataStub.getServices();
        for (Service s : allServices) {
            if (s.getId() == Integer.parseInt(serviceId) && s.getSellerId() == user.getId()) {
                service = s;
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= service != null ? "Modifica Servizio" : "Aggiungi Servizio" %> - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/add-service.css?v=<%= cacheBuster %>">
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
                <input type="text" placeholder="Cerca servizi..." id="search-input" oninput="searchServices()">
            </div>
            <nav class="desktop-nav">
                <a href="cart.jsp" class="cart-icon">🛒</a>
                <div class="user-menu">
                    <span class="user-icon">👤</span>
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
        <nav class="mobile-nav">
            <a href="cart.jsp" class="cart-icon">🛒</a>
            <a href="profile.jsp">My Profile</a>
            <a href="../logout" class="logout-btn">Logout</a>
        </nav>
    </header>

    <!-- Add Service Section -->
    <section class="add-service-section">
        <div class="add-service-container animate-on-load">
            <h2 class="heading"><%= service != null ? "Modifica Servizio" : "Aggiungi Servizio" %></h2>
            <p class="sub-heading">Compila i dettagli per <%= service != null ? "modificare" : "pubblicare" %> il tuo servizio su SkillHive.</p>
            <form class="add-service-form" action="../<%= service != null ? "update-service" : "add-service" %>" method="POST" enctype="multipart/form-data">
                <% if (service != null) { %>
                    <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                <% } %>
                <div class="form-group">
                    <label for="title">Titolo del Servizio</label>
                    <input type="text" id="title" name="title" class="input" placeholder="Es. Sviluppo Sito Web" value="<%= service != null ? service.getTitle() : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="description">Descrizione</label>
                    <textarea id="description" name="description" class="textarea" placeholder="Descrivi il tuo servizio..." required><%= service != null ? service.getDescription() : "" %></textarea>
                </div>
                <div class="form-group">
                    <label for="category">Categoria</label>
                    <select id="category" name="category" class="select" required>
                        <option value="" disabled <%= service == null ? "selected" : "" %>>Seleziona una categoria</option>
                        <option value="Development & IT" <%= service != null && service.getCategory().equals("Development & IT") ? "selected" : "" %>>Development & IT</option>
                        <option value="Design & Creative" <%= service != null && service.getCategory().equals("Design & Creative") ? "selected" : "" %>>Design & Creative</option>
                        <option value="Digital Marketing" <%= service != null && service.getCategory().equals("Digital Marketing") ? "selected" : "" %>>Digital Marketing</option>
                        <option value="Writing & Translation" <%= service != null && service.getCategory().equals("Writing & Translation") ? "selected" : "" %>>Writing & Translation</option>
                        <option value="Video & Animation" <%= service != null && service.getCategory().equals("Video & Animation") ? "selected" : "" %>>Video & Animation</option>
                        <option value="Music & Audio" <%= service != null && service.getCategory().equals("Music & Audio") ? "selected" : "" %>>Music & Audio</option>
                        <option value="Photography" <%= service != null && service.getCategory().equals("Photography") ? "selected" : "" %>>Photography</option>
                        <option value="Business" <%= service != null && service.getCategory().equals("Business") ? "selected" : "" %>>Business</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="price">Prezzo (€)</label>
                    <input type="number" id="price" name="price" class="input" placeholder="Es. 50" step="0.01" value="<%= service != null ? String.format("%.2f", service.getPrice()) : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="image">Immagine del Servizio</label>
                    <div class="file-upload">
                        <input type="file" id="image" name="image" accept="image/*">
                        <span class="file-upload-label">
                            <span class="file-upload-icon">📷</span>
                            <%= service != null ? "Modifica Immagine" : "Carica un'immagine" %>
                        </span>
                    </div>
                    <% if (service != null && service.getImage() != null) { %>
                        <div class="image-preview">
                            <img src="<%= service.getImage() %>" alt="Anteprima immagine">
                        </div>
                    <% } %>
                </div>
                <button type="submit" class="submit-btn"><%= service != null ? "Aggiorna Servizio" : "Pubblica Servizio" %></button>
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <p class="form-message error">
                        <%= request.getAttribute("errorMessage") %>
                    </p>
                <% } %>
            </form>
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

        // Anteprima immagine (lato client)
        document.getElementById('image').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    let preview = document.querySelector('.image-preview');
                    if (!preview) {
                        preview = document.createElement('div');
                        preview.classList.add('image-preview');
                        document.querySelector('.file-upload').insertAdjacentElement('afterend', preview);
                    }
                    preview.innerHTML = `<img src="${e.target.result}" alt="Anteprima immagine">`;
                };
                reader.readAsDataURL(file);
            }
        });

        // Funzione di ricerca (allineata con dashboard.jsp)
        function searchServices() {
            var searchInput = document.getElementById("search-input").value.toLowerCase();
            window.location.href = `dashboard.jsp?search=${encodeURIComponent(searchInput)}`;
        }
    </script>
</body>
</html>