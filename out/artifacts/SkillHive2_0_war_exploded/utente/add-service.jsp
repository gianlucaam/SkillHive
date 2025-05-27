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
    // Controlla anche il parametro "id" che viene usato nel link dalla sales-dashboard
    if (serviceId == null) {
        serviceId = request.getParameter("id");
    }
    
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
            
            <!-- Desktop Nav -->
            <nav class="desktop-nav">
                <a href="cart.jsp" class="cart-icon">
                    <svg class="icon-cart" viewBox="0 0 24.38 30.52" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg">
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
                    <label for="deliveryTime">Giorni di consegna</label>
                    <input type="number" id="deliveryTime" name="deliveryTime" class="input" placeholder="Es. 3" min="1" value="<%= service != null ? service.getDeliveryTime() : "" %>" required>
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
    </script>
</body>
</html>