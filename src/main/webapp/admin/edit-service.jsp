<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillhive.model.Service, com.skillhive.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillHive Admin - Modifica Servizio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <% 
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        return;
    }
    
    Service service = (Service) request.getAttribute("service");
    if (service == null) {
        response.sendRedirect(request.getContextPath() + "/admin/services?error=service_not_found");
        return;
    }
    %>
    
    <!-- Toggle per la sidebar mobile -->
    <button class="admin-sidebar-toggle" aria-label="Toggle menu">
        <i class="fas fa-bars"></i>
    </button>
    
    <!-- Overlay per chiudere la sidebar su mobile -->
    <div class="sidebar-overlay"></div>
    
    <div class="admin-container">
        <div class="admin-sidebar">
            <div class="admin-sidebar-header">
                <a href="${pageContext.request.contextPath}/utente/dashboard.jsp" class="logo">
                    <div class="honeycomb">
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                        <div></div>
                    </div>
                    <h2>SkillHive Admin</h2>
                </a>
            </div>
            <nav class="admin-nav">
                <a href="${pageContext.request.contextPath}/admin/services" class="active">Gestione Servizi</a>
                <a href="${pageContext.request.contextPath}/admin/reports">Report e Analisi</a>
                <a href="${pageContext.request.contextPath}/admin/support">Gestione Assistenza</a>
                <a href="${pageContext.request.contextPath}/utente/dashboard.jsp">Torna al Sito</a>
            </nav>
        </div>
        
        <main class="admin-main">
            <div class="admin-content">
                <header class="admin-header">
                    <h1>Modifica Servizio</h1>
                    <div class="admin-user">
                        <span>Admin</span>
                    </div>
                </header>
                
                <div class="admin-content-section">
                    <form action="${pageContext.request.contextPath}/admin/services/update" method="post" class="admin-form">
                        <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                        
                        <div class="form-group">
                            <label for="title">Titolo:</label>
                            <input type="text" id="title" name="title" class="form-control" value="<%= service.getTitle() %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="description">Descrizione:</label>
                            <textarea id="description" name="description" class="form-control" rows="5" required><%= service.getDescription() %></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="price">Prezzo (€):</label>
                            <input type="number" id="price" name="price" class="form-control" value="<%= service.getPrice() %>" step="0.01" min="0" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="category">Categoria:</label>
                            <select id="category" name="category" class="form-control" required>
                                <option value="Development & IT" <%= service.getCategory().equals("Development & IT") ? "selected" : "" %>>Development & IT</option>
                                <option value="Design & Creative" <%= service.getCategory().equals("Design & Creative") ? "selected" : "" %>>Design & Creative</option>
                                <option value="Digital Marketing" <%= service.getCategory().equals("Digital Marketing") ? "selected" : "" %>>Digital Marketing</option>
                                <option value="Writing & Translation" <%= service.getCategory().equals("Writing & Translation") ? "selected" : "" %>>Writing & Translation</option>
                                <option value="Video & Animation" <%= service.getCategory().equals("Video & Animation") ? "selected" : "" %>>Video & Animation</option>
                                <option value="Music & Audio" <%= service.getCategory().equals("Music & Audio") ? "selected" : "" %>>Music & Audio</option>
                                <option value="Photography" <%= service.getCategory().equals("Photography") ? "selected" : "" %>>Photography</option>
                                <option value="Business" <%= service.getCategory().equals("Business") ? "selected" : "" %>>Business</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="status">Stato:</label>
                            <select id="status" name="status" class="form-control" required>
                                <option value="pending" <%= service.getStatus().equals("pending") ? "selected" : "" %>>In attesa</option>
                                <option value="approved" <%= service.getStatus().equals("approved") ? "selected" : "" %>>Approvato</option>
                                <option value="rejected" <%= service.getStatus().equals("rejected") ? "selected" : "" %>>Rifiutato</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Salva Modifiche</button>
                            <a href="${pageContext.request.contextPath}/admin/services" class="btn btn-secondary">Annulla</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
        
        <footer class="admin-footer">
            <p>&copy; 2025 SkillHive - Pannello di Amministrazione</p>
        </footer>
    </div>
    
    <!-- Script per la gestione della sidebar e delle funzionalità responsive -->
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>
