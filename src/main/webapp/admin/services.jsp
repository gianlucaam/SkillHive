<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillhive.model.Service, java.util.List, com.skillhive.model.User, com.skillhive.dao.DataStub" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillHive Admin - Gestione Servizi</title>
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
    
    List<Service> allServices = (List<Service>) request.getAttribute("allServices");
    List<Service> pendingServices = (List<Service>) request.getAttribute("pendingServices");
    
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
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
        
        <div class="admin-content">
            <header class="admin-header">
                <h1>Gestione Servizi</h1>
                <div class="admin-user">
                    <span>Admin</span>
                </div>
            </header>
            
            <% if (successMessage != null) { %>
                <div class="admin-content-section">
                    <div class="alert success">
                        <% if ("status_updated".equals(successMessage)) { %>
                            Stato del servizio aggiornato con successo.
                        <% } else if ("service_removed".equals(successMessage)) { %>
                            Servizio rimosso con successo.
                        <% } else if ("service_updated".equals(successMessage)) { %>
                            Servizio aggiornato con successo.
                        <% } %>
                    </div>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="admin-content-section">
                    <div class="alert error">
                        <% if ("update_failed".equals(errorMessage)) { %>
                            Errore durante l'aggiornamento del servizio.
                        <% } else if ("invalid_id".equals(errorMessage)) { %>
                            ID servizio non valido.
                        <% } else if ("missing_params".equals(errorMessage)) { %>
                            Parametri mancanti nella richiesta.
                        <% } else if ("service_not_found".equals(errorMessage)) { %>
                            Servizio non trovato.
                        <% } else if ("remove_failed".equals(errorMessage)) { %>
                            Errore durante la rimozione del servizio.
                        <% } else if ("missing_id".equals(errorMessage)) { %>
                            ID servizio mancante.
                        <% } else if ("invalid_format".equals(errorMessage)) { %>
                            Formato dati non valido.
                        <% } %>
                    </div>
                </div>
            <% } %>
            
            <div class="admin-content-section">
                <h3>Servizi in attesa di approvazione (<%=pendingServices.size()%>)</h3>
                
                <% if (pendingServices.isEmpty()) { %>
                    <p>Non ci sono servizi in attesa di approvazione.</p>
                <% } else { %>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Titolo</th>
                                <th>Descrizione</th>
                                <th>Prezzo</th>
                                <th>Categoria</th>
                                <th>Venditore</th>
                                <th>Azioni</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Service service : pendingServices) { 
                                User seller = DataStub.getUserById(service.getSellerId());
                            %>
                            <tr>
                                <td><%= service.getId() %></td>
                                <td><%= service.getTitle() %></td>
                                <td class="description-cell"><%= service.getDescription() %></td>
                                <td>€<%= String.format("%.2f", service.getPrice()) %></td>
                                <td><%= service.getCategory() %></td>
                                <td><%= seller != null ? seller.getUsername() : "N/A" %></td>
                                <td class="action-cell">
                                    <form action="${pageContext.request.contextPath}/admin/service/status" method="post" style="display: inline;">
                                        <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                                        <input type="hidden" name="status" value="approved">
                                        <button type="submit" class="btn approve">Approva</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/service/status" method="post" style="display: inline;">
                                        <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                                        <input type="hidden" name="status" value="rejected">
                                        <button type="submit" class="btn reject">Rifiuta</button>
                                    </form>
                                    <a href="${pageContext.request.contextPath}/admin/service/edit?id=<%= service.getId() %>" class="btn edit">Modifica</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
            
            <div class="admin-content-section">
                <h3>Tutti i servizi (<%=allServices.size()%>)</h3>
                
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Titolo</th>
                            <th>Prezzo</th>
                            <th>Categoria</th>
                            <th>Venditore</th>
                            <th>Stato</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Service service : allServices) { 
                            User seller = DataStub.getUserById(service.getSellerId());
                            String statusClass = "";
                            String statusText = "";
                            
                            if (service.isPending()) {
                                statusClass = "pending";
                                statusText = "In attesa";
                            } else if (service.isApproved()) {
                                statusClass = "approved";
                                statusText = "Approvato";
                            } else if (service.isRejected()) {
                                statusClass = "rejected";
                                statusText = "Rifiutato";
                            }
                        %>
                        <tr>
                            <td><%= service.getId() %></td>
                            <td><%= service.getTitle() %></td>
                            <td>€<%= String.format("%.2f", service.getPrice()) %></td>
                            <td><%= service.getCategory() %></td>
                            <td><%= seller != null ? seller.getUsername() : "N/A" %></td>
                            <td><span class="status <%= statusClass %>"><%= statusText %></span></td>
                            <td class="action-cell">
                                <a href="${pageContext.request.contextPath}/admin/service/edit?id=<%= service.getId() %>" class="btn edit">Modifica</a>
                                <form action="${pageContext.request.contextPath}/admin/service/remove" method="post" style="display: inline;" onsubmit="return confirm('Sei sicuro di voler rimuovere questo servizio?');">
                                    <input type="hidden" name="serviceId" value="<%= service.getId() %>">
                                    <button type="submit" class="btn delete">Rimuovi</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <footer class="admin-footer">
            <p>&copy; 2025 SkillHive - Pannello di Amministrazione</p>
        </footer>
    </div>
    
    <!-- Script per la gestione della sidebar e delle funzionalità responsive -->
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>
