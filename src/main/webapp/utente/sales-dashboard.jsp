<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.util.ArrayList, java.text.SimpleDateFormat, com.skillhive.model.Order, com.skillhive.model.Service, com.skillhive.model.User, com.skillhive.dao.DataStub" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%
    // Imposta intestazioni HTTP per disabilitare la cache
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Genera un cache buster per i file statici
    String cacheBuster = String.valueOf(System.currentTimeMillis());

    // Controlla se l'utente è loggato
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("../login.jsp");
        return;
    }

    // Variabili per i messaggi
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    // Rimuovi i messaggi dalla sessione dopo averli letti
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }

    // Recupera i servizi dell'utente
    List<Service> userServices = DataStub.getServicesBySellerId(user.getId());

    // Recupera gli ordini dell'utente
    List<Order> allOrders = DataStub.getOrders();
    List<Order> userOrders = new ArrayList<>();

    // Lista per memorizzare gli ordini ricevuti
    List<Order> receivedOrders = new ArrayList<>();

    // Filtra gli ordini che contengono servizi dell'utente
    for (Order order : allOrders) {
        for (Service service : order.getServices()) {
            if (service.getSellerId() == user.getId()) {
                userOrders.add(order);
                break; // Un ordine viene aggiunto una sola volta
            }
        }
    }

    // Conta ordini in attesa, completati, ecc.
    int pendingOrders = 0;
    int completedOrders = 0;
    int cancelledOrders = 0;
    double totalEarnings = 0;

    for (Order order : userOrders) {
        if (order.getStatus().equalsIgnoreCase("pending")) {
            pendingOrders++;
        } else if (order.getStatus().equalsIgnoreCase("completed")) {
            completedOrders++;
            totalEarnings += order.getTotal();
        } else if (order.getStatus().equalsIgnoreCase("cancelled")) {
            cancelledOrders++;
        }
    }

    // Calcola guadagni mensili
    double monthlyEarnings = 0;
    Calendar cal = Calendar.getInstance();
    int currentMonth = cal.get(Calendar.MONTH);
    int currentYear = cal.get(Calendar.YEAR);

    for (Order order : userOrders) {
        if (order.getStatus().equalsIgnoreCase("completed")) {
            Date orderDate = order.getOrderDate();
            if (orderDate != null) {
                cal.setTime(orderDate);
                if (cal.get(Calendar.MONTH) == currentMonth && cal.get(Calendar.YEAR) == currentYear) {
                    monthlyEarnings += order.getTotal();
                }
            }
        }
    }

    // Tab attivo
    String activeTab = request.getParameter("tab");
    if (activeTab == null) activeTab = "my-services";

    // Format per la data
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="user-id" content="<%= user.getId() %>">
    <meta name="user-name" content="<%= user.getUsername() %>">
    <title>Sales Dashboard - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/common.css?v=<%= cacheBuster %>">
    <link rel="stylesheet" href="../css/sales-dashboard.css?v=<%= cacheBuster %>">
    <link rel="stylesheet" href="../css/chat.css?v=<%= cacheBuster %>">
    <script src="../js/messages.js" defer></script>
    <script src="../js/sales-dashboard.js" defer></script>
    <script src="../js/chat.js" defer></script>
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
            <a href="dashboard.jsp">Explore Services</a>
            <a href="sales-dashboard.jsp" class="active">Sales Dashboard</a>
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
        <a href="dashboard.jsp">Explore Services</a>
        <a href="sales-dashboard.jsp" class="active">Sales Dashboard</a>
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
<% if (errorMessage != null) { %>
<div class="error-message">
    <p><%= errorMessage %></p>
</div>
<% } %>
<% if (successMessage != null) { %>
<div class="success-message">
    <p><%= successMessage %></p>
</div>
<% } %>

<!-- Main Content -->
<section class="sales-section">
    <div class="container">
        <h1 class="page-title">Sales Dashboard</h1>

        <!-- Dashboard Tabs -->
        <div class="dashboard-tabs">
            <button class="tab-button <%= activeTab.equals("my-services") ? "active" : "" %>" onclick="location.href='sales-dashboard.jsp?tab=my-services'">My Services</button>
            <button class="tab-button <%= activeTab.equals("orders-management") ? "active" : "" %>" onclick="location.href='sales-dashboard.jsp?tab=orders-management'">Orders Management</button>
        </div>

        <!-- My Services Tab -->
        <div id="my-services" class="tab-content <%= activeTab.equals("my-services") ? "active" : "" %>">
            <!-- Stats Summary -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stat-value"><%= userServices.size() %></div>
                    <div class="stat-label">Active Services</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <div class="stat-value">€<%= String.format("%.2f", totalEarnings) %></div>
                    <div class="stat-label">Total Earnings</div>
                </div>

                <div class="stat-card" onclick="location.href='add-service.jsp'">
                    <div class="stat-icon">
                        <i class="fas fa-plus"></i>
                    </div>
                    <div class="stat-value">Add New Service</div>
                    <div class="stat-label"><a href="add-service.jsp" class="btn btn-primary">Create</a></div>
                </div>
            </div>

            <!-- Services List -->
            <div class="services-grid">
                <% if (userServices != null && !userServices.isEmpty()) {
                    for (Service service : userServices) { %>
                <div class="service-card" data-service-id="<%= service.getId() %>">
                    <div class="service-image">
                        <%
                            String imagePath = service.getImage();
                            if (imagePath == null || imagePath.isEmpty()) {
                                imagePath = "images/placeholder.jpg";
                            }
                        %>
                        <img src="../<%= imagePath %>" alt="<%= service.getTitle() %>" onerror="this.src='../images/placeholder.jpg'">
                        <div class="service-category"><%= service.getCategory() %></div>
                    </div>
                    <div class="service-details">
                        <h3 class="service-title"><%= service.getTitle() %></h3>
                        <p class="service-description"><%= service.getDescription() %></p>
                        <div class="service-meta">
                            <span class="service-price">€<%= String.format("%.2f", service.getPrice()) %></span>
                            <span class="service-delivery"><%= service.getDeliveryTime() %> days delivery</span>
                        </div>
                    </div>
                    <div class="service-actions">
                        <a href="add-service.jsp?id=<%= service.getId() %>" class="edit-btn">Edit</a>
                        <button class="delete-btn" onclick="confirmDeleteService(<%= service.getId() %>)">Delete</button>
                    </div>
                </div>
                <% } } else { %>
                <div class="no-services">
                    <p>You haven't published any services yet. Create your first service now!</p>
                    <a href="add-service.jsp" class="cta">Add New Service</a>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Orders Management Tab -->
        <div id="orders-management" class="tab-content <%= activeTab.equals("orders-management") ? "active" : "" %>">
            <!-- Order Filters -->
            <div class="order-filters">
                <button class="filter-btn" data-filter="all">All Orders</button>
                <button class="filter-btn" data-filter="pending">Pending</button>
                <button class="filter-btn" data-filter="accepted">Accepted</button>
                <button class="filter-btn" data-filter="completed">Completed</button>
                <button class="filter-btn" data-filter="rejected">Rejected</button>
            </div>

            <!-- Orders List -->
            <div class="orders-grid">
                <% 
                // Usa userOrders invece di cercare un attributo della request che non esiste
                if (userOrders != null && !userOrders.isEmpty()) {
                    for (Order order : userOrders) {
                        String statusClass = "";
                        String statusText = "";
                        
                        switch (order.getStatus()) {
                            case "pending":
                                statusClass = "pending";
                                statusText = "In attesa";
                                break;
                            case "accepted":
                                statusClass = "accepted";
                                statusText = "Accettato";
                                break;
                            case "rejected":
                                statusClass = "rejected";
                                statusText = "Rifiutato";
                                break;
                            case "completed":
                                statusClass = "completed";
                                statusText = "Completato";
                                break;
                            case "cancelled":
                                statusClass = "cancelled";
                                statusText = "Annullato";
                                break;
                            default:
                                statusClass = "pending";
                                statusText = "In attesa";
                        }
                        
                        // Trova l'acquirente per questo ordine
                        User buyer = DataStub.getUserById((int)order.getUserId());
                        
                        String buyerName = buyer != null ? buyer.getUsername() : "Cliente";
                        String buyerEmail = buyer != null ? buyer.getEmail() : "";
                %>
                <div class="order-card <%= statusClass %>">
                    <div class="order-header">
                        <h3>Ordine #<%= order.getId() %></h3>
                        <span class="order-date"><%= order.getOrderDate() != null ? new SimpleDateFormat("dd/MM/yyyy").format(order.getOrderDate()) : "N/A" %></span>
                    </div>
                    <div class="order-details">
                        <p>
                            <span>Cliente:</span>
                            <span><%= buyerName %></span>
                        </p>
                        <p>
                            <span>Servizio:</span>
                            <span><%= order.getServices() != null && !order.getServices().isEmpty() ? order.getServices().get(0).getTitle() : "N/A" %></span>
                        </p>
                        <p>
                            <span>Prezzo:</span>
                            <span>€<%= String.format("%.2f", order.getTotal()) %></span>
                        </p>
                        <p>
                            <span>Stato:</span>
                            <span class="status <%= statusClass %>"><%= statusText %></span>
                        </p>
                    </div>
                    <div class="order-actions">
                        <button class="contact-btn" data-email="<%= buyerEmail %>" data-name="<%= buyerName %>" data-order-id="<%= order.getId() %>" data-user-id="<%= order.getUserId() %>">
                            <i class="fas fa-envelope"></i> Contatta cliente
                        </button>
                        
                        <%-- Mostra sempre i pulsanti di azione appropriati in base alla classe di stato --%>
                        <% if (statusClass.equals("pending")) { %>
                        <div class="status-actions">
                            <button class="status-btn accept" data-order-id="<%= order.getId() %>">Accetta</button>
                            <button class="status-btn decline" data-order-id="<%= order.getId() %>">Rifiuta</button>
                        </div>
                        <% } else if (statusClass.equals("accepted")) { %>
                        <div class="status-actions">
                            <button class="status-btn complete" data-order-id="<%= order.getId() %>">Completa</button>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% 
                    }
                } else {
                %>
                <div class="no-orders">
                    <p>Non hai ancora ricevuto ordini</p>
                    <p>Quando riceverai ordini, appariranno qui e potrai gestirli facilmente</p>
                </div>
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

<!-- Status Confirmation Modal -->
<div id="status-confirmation-modal" class="modal">
    <div class="modal-content">
        <span class="close-modal">&times;</span>
        <h3 id="status-confirmation-title">Conferma cambio stato</h3>
        <p id="status-confirmation-message">Sei sicuro di voler cambiare lo stato di questo ordine?</p>
        <div class="modal-actions">
            <button id="status-confirm-btn" class="primary-btn">Conferma</button>
            <button id="status-cancel-btn" class="secondary-btn">Annulla</button>
        </div>
    </div>
</div>

<!-- Chat Modal -->
<div class="chat-modal">
    <div class="chat-container">
        <div class="chat-header">
            <h3>
                <span class="chat-recipient">Nome Cliente</span>
                <span class="chat-order-id">Ordine #123</span>
            </h3>
            <button class="close-chat">&times;</button>
        </div>
        <div class="chat-status-bar">
            <div class="user-status">
                <span class="status-indicator offline"></span> Controllo stato...
            </div>
            <div class="connection-status">
                <span class="status-indicator offline"></span> Connessione...
            </div>
        </div>
        <div class="chat-messages">
            <!-- I messaggi verranno inseriti qui dinamicamente -->
        </div>
        <div class="chat-input">
            <textarea id="chat-message" placeholder="Scrivi un messaggio..."></textarea>
            <button class="send-chat-btn">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                    <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"></path>
                </svg>
            </button>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="delete-confirmation-modal" class="modal">
    <div class="modal-content">
        <span class="close-modal" id="close-delete-modal">&times;</span>
        <h3>Conferma Eliminazione</h3>
        <p>Sei sicuro di voler eliminare questo servizio? Questa azione non può essere annullata.</p>
        <div class="modal-actions">
            <button class="cancel-btn" id="cancel-delete-btn">Annulla</button>
            <button class="delete-btn" id="confirm-delete-btn">Elimina</button>
        </div>
    </div>
</div>

<script>
    // Hamburger Menu
    document.querySelector('.hamburger-menu').addEventListener('click', function() {
        document.querySelector('.mobile-nav').classList.toggle('active');
        this.classList.toggle('active');
    });

    // Tabs
    const tabLinks = document.querySelectorAll('.tab-link');
    tabLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            
            // Hide all tab contents
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            
            // Deactivate all tabs
            tabLinks.forEach(link => {
                link.classList.remove('active');
            });
            
            // Activate the clicked tab and its content
            this.classList.add('active');
            document.getElementById(targetId).classList.add('active');
        });
    });

    // Delete Service Confirmation
    let serviceToDelete = null;
    
    function confirmDeleteService(serviceId) {
        serviceToDelete = serviceId;
        const deleteModal = document.getElementById('delete-confirmation-modal');
        deleteModal.style.display = 'flex';
        console.log("Modal opened for service ID:", serviceId);
    }

    // Initialize delete confirmation functionality when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        const confirmDeleteBtn = document.getElementById('confirm-delete-btn');
        const cancelDeleteBtn = document.getElementById('cancel-delete-btn');
        const closeDeleteModal = document.getElementById('close-delete-modal');
        const deleteModal = document.getElementById('delete-confirmation-modal');
        
        // Confirm delete action
        confirmDeleteBtn.addEventListener('click', function() {
            if (serviceToDelete) {
                console.log("Deleting service ID:", serviceToDelete);
                
                // Qui inserire la chiamata AJAX per eliminare il servizio
                // Per ora simuliamo con un timeout
                showToast('Eliminazione del servizio in corso...', 'info');
                
                setTimeout(function() {
                    // Nascondere la modale
                    deleteModal.style.display = 'none';
                    
                    // Simulare l'eliminazione riuscita e aggiornare l'UI
                    const serviceCard = document.querySelector(`.service-card[data-service-id="${serviceToDelete}"]`);
                    if (serviceCard) {
                        serviceCard.style.opacity = '0';
                        setTimeout(function() {
                            serviceCard.remove();
                            showToast('Servizio eliminato con successo!', 'success');
                        }, 300);
                    } else {
                        showToast('Servizio eliminato con successo!', 'success');
                    }
                    
                    // Reset serviceToDelete
                    serviceToDelete = null;
                }, 1000);
            }
        });
        
        // Cancel delete action
        cancelDeleteBtn.addEventListener('click', function() {
            deleteModal.style.display = 'none';
            serviceToDelete = null;
        });
        
        // Close modal with X button
        closeDeleteModal.addEventListener('click', function() {
            deleteModal.style.display = 'none';
            serviceToDelete = null;
        });
        
        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            if (event.target === deleteModal) {
                deleteModal.style.display = 'none';
                serviceToDelete = null;
            }
        });
    });

    // Toast notification with type parameter
    function showToast(message, type = 'default') {
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.textContent = message;
        document.body.appendChild(toast);
        
        // Force reflow to ensure animation works
        void toast.offsetWidth;
        
        setTimeout(() => {
            toast.classList.add('show');
        }, 10);
        
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => {
                document.body.removeChild(toast);
            }, 500);
        }, 5000);
    }
</script>

<!-- Include SalesJS -->
<script src="${pageContext.request.contextPath}/js/sales-dashboard.js"></script>

</body>
</html>
