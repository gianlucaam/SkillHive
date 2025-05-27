<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.util.ArrayList, java.text.SimpleDateFormat, com.skillhive.model.Order, com.skillhive.model.Service, com.skillhive.model.User, com.skillhive.dao.DataStub" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%
    // Genera un cache buster basato sul timestamp corrente
    String cacheBuster = String.valueOf(new Date().getTime());

    // Recupera l'utente dalla sessione
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // Redirect alla pagina di login se l'utente non è autenticato
        response.sendRedirect("../index.jsp");
        return;
    }
    
    // Recupera gli ordini dell'utente
    List<Order> userOrders = new ArrayList<>();
    for (Order order : DataStub.getOrders()) {
        if (order.getUserId() == user.getId()) {
            userOrders.add(order);
        }
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="user-id" content="<%= user.getId() %>">
    <meta name="user-name" content="<%= user.getUsername() %>">
    <title>I Miei Ordini - SkillHive</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Work+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/common.css?v=<%= cacheBuster %>">
    <link rel="stylesheet" href="../css/orders.css?v=<%= cacheBuster %>">
    <link rel="stylesheet" href="../css/chat.css?v=<%= cacheBuster %>">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <script src="../js/messages.js" defer></script>
    <script src="../js/my-orders.js" defer></script>
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
        
        <nav class="desktop-nav">
            <ul>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="explore.jsp">Esplora Servizi</a></li>
                <li><a href="my-orders.jsp" class="active">I Miei Ordini</a></li>
                <li><a href="profile.jsp">Profilo</a></li>
            </ul>
        </nav>
        
        <div class="user-actions">
            <div class="user-info">
                <span>Ciao, <%= user.getUsername() %></span>
            </div>
            <a href="messages.jsp" class="icon-link">
                <i class="fas fa-envelope"></i>
            </a>
            <a href="../logout.jsp" class="icon-link">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
        
        <button class="hamburger-menu">
            <span></span>
            <span></span>
            <span></span>
        </button>
        
        <div class="mobile-nav">
            <ul>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="explore.jsp">Esplora Servizi</a></li>
                <li><a href="my-orders.jsp">I Miei Ordini</a></li>
                <li><a href="profile.jsp">Profilo</a></li>
                <li><a href="../logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
</header>

<section class="orders-section">
    <div class="container">
        <h1 class="page-title">I Miei Ordini</h1>
        
        <!-- Order Filters -->
        <div class="order-filters">
            <button class="filter-btn" data-filter="all">Tutti gli ordini</button>
            <button class="filter-btn" data-filter="pending">In attesa</button>
            <button class="filter-btn" data-filter="accepted">Accettati</button>
            <button class="filter-btn" data-filter="completed">Completati</button>
            <button class="filter-btn" data-filter="rejected">Rifiutati</button>
        </div>
        
        <!-- Orders Grid -->
        <div class="orders-grid">
            <% 
            if (userOrders != null && !userOrders.isEmpty()) {
                for (Order order : userOrders) {
                    // Determina le classi e il testo per lo stato dell'ordine
                    String statusClass = "";
                    String statusText = "";
                    
                    switch (order.getStatus().toLowerCase()) {
                        case "pending":
                        case "in attesa":
                            statusClass = "pending";
                            statusText = "In attesa";
                            break;
                        case "accepted":
                        case "accettato":
                            statusClass = "accepted";
                            statusText = "Accettato";
                            break;
                        case "completed":
                        case "completato":
                            statusClass = "completed";
                            statusText = "Completato";
                            break;
                        case "rejected":
                        case "rifiutato":
                            statusClass = "rejected";
                            statusText = "Rifiutato";
                            break;
                        case "cancelled":
                            statusClass = "cancelled";
                            statusText = "Annullato";
                            break;
                        default:
                            statusClass = "pending";
                            statusText = "In attesa";
                    }
                    
                    // Trova il venditore per questo ordine
                    User seller = null;
                    Service orderService = null;
                    
                    if (order.getServices() != null && !order.getServices().isEmpty()) {
                        orderService = order.getServices().get(0);
                        seller = DataStub.getUserById(orderService.getSellerId());
                    }
                    
                    String sellerName = seller != null ? seller.getUsername() : "Venditore";
                    String sellerEmail = seller != null ? seller.getEmail() : "";
                    int sellerId = seller != null ? seller.getId() : 0;
            %>
            <div class="order-card <%= statusClass %>" data-order-id="<%= order.getId() %>">
                <div class="order-header">
                    <h3>Ordine #<%= order.getId() %></h3>
                    <span class="order-date"><%= order.getOrderDate() != null ? new SimpleDateFormat("dd/MM/yyyy").format(order.getOrderDate()) : "N/A" %></span>
                </div>
                <div class="order-details">
                    <p>
                        <span>Venditore:</span>
                        <span><%= sellerName %></span>
                    </p>
                    <p>
                        <span>Servizio:</span>
                        <span><%= orderService != null ? orderService.getTitle() : "N/A" %></span>
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
                    <button class="contact-btn primary-btn" data-seller-id="<%= sellerId %>" data-name="<%= sellerName %>" data-order-id="<%= order.getId() %>">
                        <i class="fas fa-envelope"></i> Contatta venditore
                    </button>
                    
                    <% if (statusClass.equals("completed")) { %>
                    <button class="review-btn" data-service-id="<%= orderService != null ? orderService.getId() : 0 %>" data-order-id="<%= order.getId() %>">
                        <i class="fas fa-star"></i> Lascia recensione
                    </button>
                    <% } %>
                </div>
            </div>
            <% 
                }
            } else {
            %>
            <div class="no-orders">
                <i class="fas fa-shopping-cart"></i>
                <h3>Non hai ancora effettuato ordini</h3>
                <p>Esplora i servizi disponibili e acquista quelli che ti interessano.</p>
                <a href="explore.jsp" class="primary-btn">Esplora servizi</a>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="container footer-content">
        <div class="footer-logo">
            <div class="honeycomb small">
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
            </div>
            <span>SkillHive</span>
        </div>
        
        <div class="footer-columns">
            <div class="footer-column">
                <h4>Categories</h4>
                <ul>
                    <li><a href="#">Development</a></li>
                    <li><a href="#">Marketing</a></li>
                    <li><a href="#">Design</a></li>
                    <li><a href="#">Writing</a></li>
                </ul>
            </div>
            
            <div class="footer-column">
                <h4>About</h4>
                <ul>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">How it Works</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#">Press</a></li>
                </ul>
            </div>
            
            <div class="footer-column">
                <h4>Support</h4>
                <ul>
                    <li><a href="#">Help & Support</a></li>
                    <li><a href="#">Trust & Safety</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
            </div>
            
            <div class="footer-column">
                <h4>Language</h4>
                <div class="language-selector">
                    <select>
                        <option value="en">EN</option>
                        <option value="it" selected>IT</option>
                        <option value="es">ES</option>
                        <option value="fr">FR</option>
                    </select>
                </div>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; <%= Calendar.getInstance().get(Calendar.YEAR) %> SkillHive. All rights reserved.</p>
            <div class="social-links">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
    </div>
</footer>

<!-- Chat Modal -->
<div class="chat-modal">
    <div class="chat-container">
        <div class="chat-header">
            <h3>
                <span class="chat-recipient">Nome Venditore</span>
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

<!-- Review Modal -->
<div id="review-modal" class="modal">
    <div class="modal-content">
        <span class="close-modal">&times;</span>
        <h3>Lascia una recensione</h3>
        <form id="review-form">
            <input type="hidden" id="service-id" name="serviceId" value="">
            <input type="hidden" id="order-id" name="orderId" value="">
            
            <div class="rating-container">
                <p>Valutazione:</p>
                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" /><label for="star5"></label>
                    <input type="radio" id="star4" name="rating" value="4" /><label for="star4"></label>
                    <input type="radio" id="star3" name="rating" value="3" /><label for="star3"></label>
                    <input type="radio" id="star2" name="rating" value="2" /><label for="star2"></label>
                    <input type="radio" id="star1" name="rating" value="1" /><label for="star1"></label>
                </div>
            </div>
            
            <div class="form-group">
                <label for="review-title">Titolo:</label>
                <input type="text" id="review-title" name="title" placeholder="Inserisci un titolo per la tua recensione" required>
            </div>
            
            <div class="form-group">
                <label for="review-comment">Commento:</label>
                <textarea id="review-comment" name="comment" placeholder="Condividi la tua esperienza con questo servizio" required></textarea>
            </div>
            
            <div class="modal-actions">
                <button type="submit" class="primary-btn">Invia recensione</button>
                <button type="button" class="secondary-btn cancel-review">Annulla</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Hamburger Menu
    document.querySelector('.hamburger-menu').addEventListener('click', function() {
        document.querySelector('.mobile-nav').classList.toggle('active');
        this.classList.toggle('active');
    });
    
    // Chiudi mobile nav quando si clicca su un link
    document.querySelectorAll('.mobile-nav a').forEach(link => {
        link.addEventListener('click', function() {
            document.querySelector('.mobile-nav').classList.remove('active');
            document.querySelector('.hamburger-menu').classList.remove('active');
        });
    });
    
    // Inizializza il modal per le recensioni
    document.addEventListener('DOMContentLoaded', function() {
        const reviewModal = document.getElementById('review-modal');
        const reviewButtons = document.querySelectorAll('.review-btn');
        const closeReviewModal = document.querySelector('#review-modal .close-modal');
        const cancelReviewBtn = document.querySelector('.cancel-review');
        
        reviewButtons.forEach(button => {
            button.addEventListener('click', function() {
                const serviceId = this.getAttribute('data-service-id');
                const orderId = this.getAttribute('data-order-id');
                
                document.getElementById('service-id').value = serviceId;
                document.getElementById('order-id').value = orderId;
                
                reviewModal.style.display = 'flex';
            });
        });
        
        closeReviewModal.addEventListener('click', function() {
            reviewModal.style.display = 'none';
        });
        
        cancelReviewBtn.addEventListener('click', function() {
            reviewModal.style.display = 'none';
        });
        
        window.addEventListener('click', function(event) {
            if (event.target === reviewModal) {
                reviewModal.style.display = 'none';
            }
        });
        
        // Handle review form submission
        document.getElementById('review-form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const serviceId = document.getElementById('service-id').value;
            const orderId = document.getElementById('order-id').value;
            const rating = document.querySelector('input[name="rating"]:checked')?.value;
            const title = document.getElementById('review-title').value;
            const comment = document.getElementById('review-comment').value;
            
            if (!rating) {
                alert('Per favore seleziona una valutazione');
                return;
            }
            
            // Simulate sending the review to the server
            console.log('Invio recensione:', {
                serviceId,
                orderId,
                rating,
                title,
                comment
            });
            
            // Show success message and close modal
            alert('Recensione inviata con successo!');
            reviewModal.style.display = 'none';
        });
    });
</script>
</body>
</html>
