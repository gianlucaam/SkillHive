/**
 * SkillHive - My Orders Page JavaScript
 * 
 * Gestisce la funzionalità della pagina "I Miei Ordini" dell'acquirente, inclusa
 * la sincronizzazione in tempo reale dello stato degli ordini.
 */

// WebSocket per gli aggiornamenti in tempo reale
let statusSocket = null;
let userId = null;
const SOCKET_RETRY_DELAY = 5000;
let localStorageCheckInterval = null;

// Inizializza la pagina degli ordini
document.addEventListener('DOMContentLoaded', function() {
    // Ottieni l'ID dell'utente corrente
    userId = document.querySelector('meta[name="user-id"]')?.content;
    
    if (!userId) {
        console.error('User ID not found');
        return;
    }
    
    // In ambiente di sviluppo, usa localStorage per la sincronizzazione
    if (!isProductionEnvironment()) {
        // Controlla subito per eventuali aggiornamenti
        checkLocalStorageForUpdates();
        
        // Imposta un controllo periodico per gli aggiornamenti
        localStorageCheckInterval = setInterval(checkLocalStorageForUpdates, 3000);
    } else {
        // In produzione, inizializza il WebSocket per gli aggiornamenti di stato
        initStatusWebSocket();
    }
    
    // Inizializza i filtri degli ordini
    initOrderFilters();
    
    // Aggiungi la funzionalità per le recensioni
    initReviewButtons();
});

/**
 * Verifica se siamo in un ambiente di produzione
 */
function isProductionEnvironment() {
    // Per ora restituiamo sempre false per usare le simulazioni
    // Quando sarà pronto il backend, cambiare questa funzione
    return false;
}

/**
 * Controlla il localStorage per aggiornamenti agli ordini
 */
function checkLocalStorageForUpdates() {
    try {
        // Recupera gli ordini aggiornati dal localStorage
        const updatedOrdersJson = localStorage.getItem('updatedOrders');
        if (!updatedOrdersJson) return;
        
        const updatedOrders = JSON.parse(updatedOrdersJson);
        let updatesFound = false;
        
        // Per ogni ordine nella pagina, controlla se ci sono aggiornamenti
        document.querySelectorAll('.order-card').forEach(orderCard => {
            const orderId = orderCard.getAttribute('data-order-id');
            if (!orderId) return;
            
            // Se l'ordine è stato aggiornato nel localStorage
            if (updatedOrders[orderId]) {
                const orderUpdate = updatedOrders[orderId];
                const currentStatus = orderCard.querySelector('.order-status')?.textContent.trim();
                const newStatusText = orderUpdate.statusText;
                
                // Se lo stato è diverso, aggiorna l'UI
                if (currentStatus !== newStatusText) {
                    console.log(`Aggiornamento trovato per ordine #${orderId}: ${orderUpdate.status}`);
                    updateOrderStatusUI(orderId, orderUpdate.status);
                    updatesFound = true;
                    
                    // Mostra una notifica
                    showNotification(`Ordine #${orderId} aggiornato a "${orderUpdate.statusText}"`, 'success');
                }
            }
        });
        
        if (updatesFound) {
            // Ri-applica il filtro corrente per nascondere/mostrare ordini in base al loro nuovo stato
            const activeFilter = document.querySelector('.filter-btn.active')?.getAttribute('data-filter') || 'all';
            filterOrders(activeFilter);
        }
    } catch (error) {
        console.error('Errore durante il controllo degli aggiornamenti nel localStorage:', error);
    }
}

/**
 * Inizializza il WebSocket per gli aggiornamenti di stato degli ordini
 */
function initStatusWebSocket() {
    // Chiudi la connessione esistente se presente
    if (statusSocket && statusSocket.readyState === WebSocket.OPEN) {
        statusSocket.close();
    }
    
    // Crea una nuova connessione WebSocket
    const wsProtocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
    const wsUrl = `${wsProtocol}${window.location.host}/order-status?userId=${userId}`;
    
    try {
        statusSocket = new WebSocket(wsUrl);
        
        statusSocket.onopen = function(event) {
            console.log('Status WebSocket connection established');
            showNotification('Connesso per aggiornamenti in tempo reale', 'info');
        };
        
        statusSocket.onmessage = function(event) {
            const data = JSON.parse(event.data);
            
            if (data.type === 'status_update') {
                // Aggiorna lo stato dell'ordine nell'UI
                updateOrderStatusUI(data.orderId, data.newStatus);
                
                // Mostra una notifica
                showNotification(`Ordine #${data.orderId} aggiornato a "${getStatusText(data.newStatus)}"`, 'success');
            }
        };
        
        statusSocket.onclose = function(event) {
            console.log('Status WebSocket connection closed');
            
            // Tenta di riconnettersi dopo un ritardo
            setTimeout(() => {
                initStatusWebSocket();
            }, SOCKET_RETRY_DELAY);
        };
        
        statusSocket.onerror = function(error) {
            console.error('Status WebSocket error:', error);
        };
    } catch (error) {
        console.error('Error creating Status WebSocket:', error);
        
        // Tenta di riconnettersi dopo un ritardo
        setTimeout(() => {
            initStatusWebSocket();
        }, SOCKET_RETRY_DELAY);
    }
}

/**
 * Inizializza i filtri per gli ordini
 */
function initOrderFilters() {
    const filterButtons = document.querySelectorAll('.filter-btn');
    
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Rimuovi la classe active da tutti i pulsanti
            filterButtons.forEach(btn => btn.classList.remove('active'));
            
            // Aggiungi la classe active al pulsante cliccato
            this.classList.add('active');
            
            // Ottieni il filtro selezionato
            const filter = this.getAttribute('data-filter');
            
            // Filtra gli ordini
            filterOrders(filter);
        });
    });
    
    // Attiva il filtro "Tutti gli ordini" di default
    document.querySelector('.filter-btn[data-filter="all"]').classList.add('active');
}

/**
 * Filtra gli ordini in base allo stato selezionato
 * @param {string} filter - Il filtro da applicare (all, pending, accepted, completed, rejected)
 */
function filterOrders(filter) {
    const orderCards = document.querySelectorAll('.order-card');
    
    orderCards.forEach(card => {
        if (filter === 'all') {
            card.style.display = 'block';
        } else {
            if (card.classList.contains(filter)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        }
    });
    
    // Mostra il messaggio "Nessun ordine" se non ci sono ordini visibili
    const visibleOrders = document.querySelectorAll('.order-card[style="display: block"]');
    const noOrdersElement = document.querySelector('.no-orders');
    
    if (visibleOrders.length === 0 && orderCards.length > 0) {
        // Crea l'elemento se non esiste
        if (!noOrdersElement) {
            const noOrders = document.createElement('div');
            noOrders.className = 'no-orders filtered-message';
            noOrders.innerHTML = `
                <i class="fas fa-filter"></i>
                <h3>Nessun ordine ${getFilterText(filter)}</h3>
                <p>Cambia il filtro per visualizzare altri ordini.</p>
            `;
            document.querySelector('.orders-grid').appendChild(noOrders);
        } else if (noOrdersElement.classList.contains('filtered-message')) {
            noOrdersElement.style.display = 'flex';
            const title = noOrdersElement.querySelector('h3');
            if (title) {
                title.textContent = `Nessun ordine ${getFilterText(filter)}`;
            }
        }
    } else {
        // Nascondi il messaggio se ci sono ordini visibili
        const filteredMessage = document.querySelector('.filtered-message');
        if (filteredMessage) {
            filteredMessage.style.display = 'none';
        }
    }
}

/**
 * Ottiene il testo del filtro per il messaggio "Nessun ordine"
 * @param {string} filter - Il filtro applicato
 * @returns {string} - Il testo del filtro
 */
function getFilterText(filter) {
    switch (filter) {
        case 'pending':
            return 'in attesa';
        case 'accepted':
            return 'accettato';
        case 'completed':
            return 'completato';
        case 'rejected':
            return 'rifiutato';
        default:
            return '';
    }
}

/**
 * Aggiorna l'interfaccia utente per riflettere il nuovo stato dell'ordine
 * @param {number} orderId - L'ID dell'ordine da aggiornare
 * @param {string} newStatus - Il nuovo stato dell'ordine
 */
function updateOrderStatusUI(orderId, newStatus) {
    // Trova la card dell'ordine
    const orderCard = document.querySelector(`.order-card[data-order-id="${orderId}"]`);
    
    if (!orderCard) {
        console.error(`Order card with ID ${orderId} not found`);
        return;
    }
    
    // Aggiorna le classi CSS della card
    const oldStatusClass = Array.from(orderCard.classList).find(cls => 
        ['pending', 'accepted', 'completed', 'rejected', 'cancelled'].includes(cls)
    );
    
    if (oldStatusClass) {
        orderCard.classList.remove(oldStatusClass);
    }
    
    orderCard.classList.add(newStatus);
    
    // Aggiorna il badge dello stato
    const statusElement = orderCard.querySelector('.order-status');
    if (statusElement) {
        // Rimuovi tutte le classi di stato
        statusElement.className = 'order-status';
        // Aggiungi la nuova classe di stato
        statusElement.classList.add(newStatus);
        // Aggiorna il testo
        statusElement.textContent = getStatusText(newStatus);
    }
    
    // Aggiorna i pulsanti di azione in base allo stato
    updateActionButtons(orderCard, newStatus);
    
    // Aggiorna eventuali altri elementi dell'interfaccia utente che dipendono dallo stato
    updateOtherUiElements(orderCard, newStatus);
}

/**
 * Aggiorna i pulsanti di azione in base al nuovo stato
 * @param {HTMLElement} orderCard - La card dell'ordine
 * @param {string} newStatus - Il nuovo stato dell'ordine
 */
function updateActionButtons(orderCard, newStatus) {
    // Mostra/nascondi il pulsante per lasciare una recensione
    const reviewButton = orderCard.querySelector('.review-btn');
    if (reviewButton) {
        if (newStatus === 'completed') {
            reviewButton.style.display = 'inline-block';
        } else {
            reviewButton.style.display = 'none';
        }
    }
    
    // Aggiorna altri pulsanti di azione se necessario
    // ...
}

/**
 * Aggiorna altri elementi dell'interfaccia utente in base al nuovo stato
 * @param {HTMLElement} orderCard - La card dell'ordine
 * @param {string} newStatus - Il nuovo stato dell'ordine
 */
function updateOtherUiElements(orderCard, newStatus) {
    // Aggiorna eventuali altri elementi UI che dipendono dallo stato
    // Ad esempio, mostrare/nascondere elementi specifici, cambiare colori, ecc.
    
    // Esempio: aggiorna il testo della data di completamento
    if (newStatus === 'completed') {
        const completionDateElement = orderCard.querySelector('.completion-date');
        if (completionDateElement) {
            const now = new Date();
            completionDateElement.textContent = `Completato il ${now.toLocaleDateString()}`;
        }
    }
}

/**
 * Converte lo stato in una classe CSS
 * @param {string} status - Lo stato dell'ordine
 * @returns {string} - La classe CSS corrispondente
 */
function getStatusClass(status) {
    switch (status) {
        case 'pending':
            return 'pending';
        case 'accepted':
            return 'accepted';
        case 'completed':
            return 'completed';
        case 'rejected':
            return 'rejected';
        case 'cancelled':
            return 'cancelled';
        default:
            return 'unknown';
    }
}

/**
 * Converte lo stato in un testo leggibile
 * @param {string} status - Lo stato dell'ordine
 * @returns {string} - Il testo leggibile corrispondente
 */
function getStatusText(status) {
    switch (status) {
        case 'pending':
            return 'In attesa';
        case 'accepted':
            return 'Accettato';
        case 'completed':
            return 'Completato';
        case 'rejected':
            return 'Rifiutato';
        case 'cancelled':
            return 'Annullato';
        default:
            return 'Sconosciuto';
    }
}

/**
 * Inizializza i pulsanti per lasciare recensioni
 */
function initReviewButtons() {
    const reviewButtons = document.querySelectorAll('.review-btn');
    
    reviewButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Ottieni l'ID dell'ordine e del venditore
            const orderId = this.getAttribute('data-order-id');
            const sellerId = this.getAttribute('data-seller-id');
            
            // Reindirizza alla pagina di recensione
            if (orderId && sellerId) {
                window.location.href = `/utente/review.jsp?orderId=${orderId}&sellerId=${sellerId}`;
            } else {
                showNotification('Impossibile lasciare una recensione, dati mancanti.', 'error');
            }
        });
    });
}

/**
 * Mostra una notifica all'utente
 * @param {string} message - Il messaggio da mostrare
 * @param {string} type - Il tipo di notifica (success, error, info, warning)
 * @param {number} duration - La durata in millisecondi (default: 5000)
 */
function showNotification(message, type = 'info', duration = 5000) {
    // Crea l'elemento di notifica
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    
    // Icona in base al tipo
    let icon = '';
    switch (type) {
        case 'success':
            icon = '<i class="fas fa-check-circle"></i>';
            break;
        case 'error':
            icon = '<i class="fas fa-exclamation-circle"></i>';
            break;
        case 'warning':
            icon = '<i class="fas fa-exclamation-triangle"></i>';
            break;
        default:
            icon = '<i class="fas fa-info-circle"></i>';
    }
    
    // Contenuto HTML
    notification.innerHTML = `
        <div class="notification-icon">${icon}</div>
        <div class="notification-content">${message}</div>
        <button class="notification-close"><i class="fas fa-times"></i></button>
    `;
    
    // Crea un contenitore per le notifiche se non esiste
    let notificationContainer = document.querySelector('.notification-container');
    if (!notificationContainer) {
        notificationContainer = document.createElement('div');
        notificationContainer.className = 'notification-container';
        document.body.appendChild(notificationContainer);
    }
    
    // Aggiungi la notifica al contenitore
    notificationContainer.appendChild(notification);
    
    // Gestisci la chiusura della notifica
    const closeButton = notification.querySelector('.notification-close');
    closeButton.addEventListener('click', function() {
        notification.classList.add('closing');
        setTimeout(() => {
            notification.remove();
        }, 300);
    });
    
    // Chiudi automaticamente dopo la durata specificata
    setTimeout(() => {
        if (notification.parentNode) {
            notification.classList.add('closing');
            setTimeout(() => {
                notification.remove();
            }, 300);
        }
    }, duration);
}
