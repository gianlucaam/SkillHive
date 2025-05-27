<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.skillhive.model.SupportTicket" %>
<%@ page import="com.skillhive.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<SupportTicket> tickets = (List<SupportTicket>) request.getAttribute("tickets");
    String activeFilter = (String) request.getAttribute("activeFilter");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String errorMessage = request.getParameter("error");
    String successMessage = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillHive Admin - Gestione Assistenza</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .ticket-grid {
            display: grid;
            grid-template-columns: 3fr 4fr 2fr 2fr 2fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
            align-items: center;
        }
        
        .ticket-grid-header {
            font-weight: bold;
            background-color: #f5f5f5;
            padding: 1rem;
            border-radius: 4px;
        }
        
        .ticket-item {
            padding: 1rem;
            border-radius: 4px;
            background-color: white;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            transition: all 0.2s ease;
        }
        
        .ticket-item:hover {
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }
        
        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.8rem;
            display: inline-block;
            text-align: center;
        }
        
        .status-open {
            background-color: #e3f2fd;
            color: #0d47a1;
        }
        
        .status-in-progress {
            background-color: #fff8e1;
            color: #ff6f00;
        }
        
        .status-resolved {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        
        .status-closed {
            background-color: #eeeeee;
            color: #616161;
        }
        
        .priority-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.8rem;
            display: inline-block;
            text-align: center;
        }
        
        .priority-high {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .priority-medium {
            background-color: #fff8e1;
            color: #ff6f00;
        }
        
        .priority-low {
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        
        .type-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.8rem;
            display: inline-block;
            text-align: center;
        }
        
        .type-support {
            background-color: #e3f2fd;
            color: #0d47a1;
        }
        
        .type-dispute {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .filter-tabs {
            display: flex;
            margin-bottom: 2rem;
            border-bottom: 1px solid #ddd;
        }
        
        .filter-tab {
            padding: 0.75rem 1.5rem;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.2s ease;
        }
        
        .filter-tab.active {
            border-bottom-color: #1a73e8;
            font-weight: bold;
            color: #1a73e8;
        }
        
        .filter-tab:hover:not(.active) {
            background-color: #f5f5f5;
        }
        
        .filter-tab-count {
            background-color: #eee;
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-left: 0.5rem;
        }
        
        .ticket-preview {
            max-width: 250px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-style: italic;
            color: #777;
            font-size: 0.9rem;
        }
        
        .honeycomb {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 10px;
        }
        
        .honeycomb div {
            width: 10px;
            height: 10px;
            background-color: #f7dc6f;
            display: inline-block;
            margin: 1px;
        }
    </style>
</head>
<body>
    <% 
    // Controllo autorizzazioni - l'utente deve essere admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        return;
    }
    
    // I ticket sono già stati recuperati all'inizio della pagina
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
                <a href="${pageContext.request.contextPath}/admin/services">Gestione Servizi</a>
                <a href="${pageContext.request.contextPath}/admin/support" class="active">Gestione Assistenza</a>
                <!-- Altri link della sidebar -->
            </nav>
        </div>
        
        <div class="admin-content">
            <header class="admin-header">
                <h1>Gestione Assistenza</h1>
                <div class="admin-user">
                    <span>Admin</span>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                </div>
            </header>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-error">
                    <% if (errorMessage.equals("missing_id")) { %>
                        ID ticket mancante.
                    <% } else if (errorMessage.equals("ticket_not_found")) { %>
                        Ticket non trovato.
                    <% } else if (errorMessage.equals("invalid_id")) { %>
                        ID ticket non valido.
                    <% } else if (errorMessage.equals("missing_params")) { %>
                        Parametri mancanti.
                    <% } else if (errorMessage.equals("update_failed")) { %>
                        Aggiornamento fallito.
                    <% } else { %>
                        <%= errorMessage %>
                    <% } %>
                </div>
            <% } %>
            
            <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <% if (successMessage.equals("status_updated")) { %>
                        Stato del ticket aggiornato con successo.
                    <% } else if (successMessage.equals("priority_updated")) { %>
                        Priorità del ticket aggiornata con successo.
                    <% } else if (successMessage.equals("ticket_assigned")) { %>
                        Ticket assegnato con successo.
                    <% } else { %>
                        <%= successMessage %>
                    <% } %>
                </div>
            <% } %>
            
            <div class="filter-tabs">
                <a href="${pageContext.request.contextPath}/admin/support" class="filter-tab <%= activeFilter.equals("all") ? "active" : "" %>">Tutti</a>
                <a href="${pageContext.request.contextPath}/admin/support?filter=open" class="filter-tab <%= activeFilter.equals("open") ? "active" : "" %>">Aperti</a>
                <a href="${pageContext.request.contextPath}/admin/support?filter=support" class="filter-tab <%= activeFilter.equals("support") ? "active" : "" %>">Supporto</a>
                <a href="${pageContext.request.contextPath}/admin/support?filter=dispute" class="filter-tab <%= activeFilter.equals("dispute") ? "active" : "" %>">Dispute</a>
            </div>
            
            <div class="admin-content-section">
                <h2>Ticket <%= activeFilter.equals("all") ? "" : activeFilter %></h2>
                
                <% if (tickets.isEmpty()) { %>
                    <div class="empty-state">
                        <p>Nessun ticket <%= activeFilter.equals("all") ? "" : activeFilter %> trovato.</p>
                    </div>
                <% } else { %>
                    <div class="ticket-grid ticket-grid-header">
                        <div>Soggetto</div>
                        <div>Ultimo messaggio</div>
                        <div>Stato</div>
                        <div>Priorità</div>
                        <div>Data</div>
                        <div>Azioni</div>
                    </div>
                    
                    <% for (SupportTicket ticket : tickets) { %>
                        <div class="ticket-grid ticket-item">
                            <div>
                                <strong><%= ticket.getSubject() %></strong>
                                <div class="type-badge <%= ticket.isDispute() ? "type-dispute" : "type-support" %>">
                                    <%= ticket.isDispute() ? "Disputa" : "Supporto" %>
                                </div>
                                <div>
                                    <small>Da: <%= ((User) request.getAttribute("user_" + ticket.getId())).getUsername() %></small>
                                </div>
                            </div>
                            <div class="ticket-preview">
                                <%= ticket.getLastMessagePreview() %>
                            </div>
                            <div>
                                <span class="status-badge status-<%= ticket.getStatus().replace("_", "-") %>">
                                    <% if (ticket.isOpen()) { %>
                                        Aperto
                                    <% } else if (ticket.isInProgress()) { %>
                                        In lavorazione
                                    <% } else if (ticket.isResolved()) { %>
                                        Risolto
                                    <% } else if (ticket.isClosed()) { %>
                                        Chiuso
                                    <% } %>
                                </span>
                            </div>
                            <div>
                                <span class="priority-badge priority-<%= ticket.getPriority() %>">
                                    <% if (ticket.getPriority().equals("high")) { %>
                                        Alta
                                    <% } else if (ticket.getPriority().equals("medium")) { %>
                                        Media
                                    <% } else if (ticket.getPriority().equals("low")) { %>
                                        Bassa
                                    <% } %>
                                </span>
                            </div>
                            <div>
                                <%= dateFormat.format(ticket.getCreatedAt()) %>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/admin/support/ticket?id=<%= ticket.getId() %>" class="btn btn-primary btn-sm">Visualizza</a>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
    
    <footer class="admin-footer">
        <p>&copy; 2025 SkillHive - Pannello di Amministrazione</p>
    </footer>
    
    <!-- Script per la gestione della sidebar e delle funzionalità responsive -->
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>
