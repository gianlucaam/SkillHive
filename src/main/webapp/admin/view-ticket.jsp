<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.skillhive.model.SupportTicket" %>
<%@ page import="com.skillhive.model.Message" %>
<%@ page import="com.skillhive.model.User" %>
<%@ page import="com.skillhive.model.Order" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    SupportTicket ticket = (SupportTicket) request.getAttribute("ticket");
    List<Message> messages = (List<Message>) request.getAttribute("messages");
    User ticketUser = (User) request.getAttribute("ticketUser");
    Order disputeOrder = (Order) request.getAttribute("disputeOrder");
    User sellerUser = (User) request.getAttribute("sellerUser");
    Map<Long, String> usernames = (Map<Long, String>) request.getAttribute("usernames");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String errorMessage = request.getParameter("error");
    String successMessage = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillHive Admin - Visualizza Ticket</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .ticket-details {
            background-color: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .ticket-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .ticket-title {
            font-size: 1.5rem;
            margin: 0 0 0.5rem 0;
            color: #2c3e50;
        }
        
        .ticket-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-top: 0.5rem;
        }
        
        .ticket-meta-item {
            display: flex;
            flex-direction: column;
        }
        
        .ticket-meta-label {
            font-size: 0.85rem;
            color: #7f8c8d;
            margin-bottom: 0.25rem;
        }
        
        .ticket-meta-value {
            font-weight: 500;
            color: #2c3e50;
        }
        
        .ticket-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-start;
        }
        
        .ticket-actions form {
            margin: 0;
        }
        
        .dropdown-form {
            position: relative;
            display: inline-block;
        }
        
        .dropdown-form select {
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: white;
            margin-right: 0.5rem;
        }
        
        .message-container {
            background-color: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .message-list {
            margin-bottom: 2rem;
        }
        
        .message {
            display: flex;
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .message-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        
        .message-avatar i {
            color: #666;
        }
        
        .message-content {
            flex-grow: 1;
            background-color: #f5f7fa;
            padding: 1rem;
            border-radius: 0.5rem;
            position: relative;
        }
        
        .message-content::before {
            content: '';
            position: absolute;
            top: 10px;
            left: -10px;
            border-width: 10px 10px 10px 0;
            border-style: solid;
            border-color: transparent #f5f7fa transparent transparent;
        }
        
        .message.admin .message-content {
            background-color: #e3f2fd;
        }
        
        .message.admin .message-content::before {
            border-color: transparent #e3f2fd transparent transparent;
        }
        
        .message-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
        
        .message-sender {
            font-weight: 500;
            color: #2c3e50;
        }
        
        .message-date {
            color: #7f8c8d;
            font-size: 0.85rem;
        }
        
        .message-text {
            color: #333;
            line-height: 1.5;
        }
        
        .message-form {
            background-color: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .message-form textarea {
            width: 100%;
            padding: 1rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 1rem;
            resize: vertical;
            min-height: 120px;
        }
        
        .message-form button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        
        .message-form button:hover {
            background-color: #2980b9;
        }
        
        .dispute-details {
            background-color: #fff8e1;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }
        
        .dispute-details h3 {
            color: #ff6f00;
            margin-top: 0;
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }
        
        .dispute-details p {
            margin: 0.5rem 0;
        }
        
        .dispute-order-details {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 0.5rem;
        }
        
        .dispute-order-detail {
            background-color: white;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
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
    
    // Se il ticket non esiste, reindirizza alla lista ticket
    if (ticket == null) {
        response.sendRedirect(request.getContextPath() + "/admin/support?error=ticket-not-found");
        return;
    }
    %>
    
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
                <a href="${pageContext.request.contextPath}/admin/reports">Report e Analisi</a>
                <a href="${pageContext.request.contextPath}/admin/support" class="active">Gestione Assistenza</a>
                <a href="${pageContext.request.contextPath}/utente/dashboard.jsp">Torna al Sito</a>
            </nav>
        </div>
        
        <div class="admin-content">
            <header class="admin-header">
                <h1>Ticket #<%= ticket.getId() %></h1>
                <div class="admin-user">
                    <span>Admin</span>
                </div>
            </header>
            
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert alert-danger">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <div class="ticket-details">
                <div class="ticket-header">
                    <div>
                        <h2 class="ticket-title"><%= ticket.getSubject() %></h2>
                        <div class="ticket-meta">
                            <div class="ticket-meta-item">
                                <span class="ticket-meta-label">Cliente</span>
                                <span class="ticket-meta-value"><%= ticketUser != null ? ticketUser.getFullName() : "Utente non trovato" %></span>
                            </div>
                            <div class="ticket-meta-item">
                                <span class="ticket-meta-label">Email</span>
                                <span class="ticket-meta-value"><%= ticketUser != null ? ticketUser.getEmail() : "N/A" %></span>
                            </div>
                            <div class="ticket-meta-item">
                                <span class="ticket-meta-label">Data creazione</span>
                                <span class="ticket-meta-value"><%= dateFormat.format(ticket.getCreatedAt()) %></span>
                            </div>
                            <div class="ticket-meta-item">
                                <span class="ticket-meta-label">Ultimo aggiornamento</span>
                                <span class="ticket-meta-value"><%= dateFormat.format(ticket.getUpdatedAt()) %></span>
                            </div>
                            <div class="ticket-meta-item">
                                <span class="ticket-meta-label">Stato</span>
                                <span class="ticket-meta-value">
                                    <span class="status-badge status-<%= ticket.getStatus().replaceAll("[^a-zA-Z0-9]", "-").toLowerCase() %>"><%= ticket.getStatus() %></span>
                                </span>
                            </div>
                            <div class="ticket-meta-item">
                                <span class="ticket-meta-label">Priorità</span>
                                <span class="ticket-meta-value">
                                    <span class="priority-badge priority-<%= ticket.getPriority().replaceAll("[^a-zA-Z0-9]", "-").toLowerCase() %>"><%= ticket.getPriority() %></span>
                                </span>
                            </div>
                            <div class="ticket-meta-item">
                                <span class="ticket-meta-label">Tipo</span>
                                <span class="ticket-meta-value">
                                    <span class="type-badge type-<%= ticket.isDispute() ? "dispute" : "support" %>">
                                        <%= ticket.isDispute() ? "Disputa" : "Supporto" %>
                                    </span>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="ticket-actions">
                        <!-- Aggiorna stato -->
                        <form action="${pageContext.request.contextPath}/admin/support/update-ticket" method="post" class="dropdown-form">
                            <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                            <input type="hidden" name="action" value="update-status">
                            <select name="status" class="form-select">
                                <option value="" disabled selected>Cambia stato...</option>
                                <option value="Open">Aperto</option>
                                <option value="In Progress">In Lavorazione</option>
                                <option value="Resolved">Risolto</option>
                                <option value="Closed">Chiuso</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Aggiorna</button>
                        </form>
                        
                        <!-- Aggiorna priorità -->
                        <form action="${pageContext.request.contextPath}/admin/support/update-ticket" method="post" class="dropdown-form">
                            <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                            <input type="hidden" name="action" value="update-priority">
                            <select name="priority" class="form-select">
                                <option value="" disabled selected>Cambia priorità...</option>
                                <option value="Low">Bassa</option>
                                <option value="Medium">Media</option>
                                <option value="High">Alta</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Aggiorna</button>
                        </form>
                        
                        <!-- Assegna ticket -->
                        <form action="${pageContext.request.contextPath}/admin/support/update-ticket" method="post">
                            <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                            <input type="hidden" name="action" value="assign-ticket">
                            <button type="submit" class="btn btn-success">Assegna a me</button>
                        </form>
                    </div>
                </div>
                
                <% if (ticket.isDispute() && disputeOrder != null) { %>
                    <div class="dispute-details">
                        <h3>Dettagli Disputa</h3>
                        <p><strong>Ordine:</strong> #<%= disputeOrder.getId() %></p>
                        <p><strong>Venditore:</strong> <%= sellerUser != null ? sellerUser.getFullName() : "Non disponibile" %></p>
                        <p><strong>Importo:</strong> € <%= String.format("%.2f", disputeOrder.getAmount()) %></p>
                        <p><strong>Data ordine:</strong> <%= dateFormat.format(disputeOrder.getCreatedAt()) %></p>
                    </div>
                <% } %>
            </div>
            
            <div class="message-container">
                <h3>Cronologia comunicazioni</h3>
                
                <div class="message-list">
                    <% if (messages != null && !messages.isEmpty()) { %>
                        <% for (Message message : messages) { %>
                            <div class="message <%= message.isFromAdmin() ? "admin" : "" %>">
                                <div class="message-avatar">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="message-content">
                                    <div class="message-header">
                                        <div class="message-sender">
                                            <%= message.isFromAdmin() ? "Amministratore" : usernames.get(message.getSenderId()) %>
                                        </div>
                                        <div class="message-date">
                                            <%= dateFormat.format(message.getCreatedAt()) %>
                                        </div>
                                    </div>
                                    <div class="message-text">
                                        <%= message.getContent().replace("\n", "<br>").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("&lt;br&gt;", "<br>") %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <p>Nessun messaggio disponibile.</p>
                    <% } %>
                </div>
                
                <div class="message-form">
                    <h3>Rispondi al ticket</h3>
                    <form action="${pageContext.request.contextPath}/admin/support/reply-ticket" method="post">
                        <input type="hidden" name="ticketId" value="<%= ticket.getId() %>">
                        <div class="form-group">
                            <textarea name="message" class="form-control" placeholder="Scrivi la tua risposta qui..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Invia risposta</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
