/**
 * SkillHive Sales Dashboard JavaScript
 * 
 * This file contains all the functionality for the Sales Dashboard,
 * including order management, contact modal, and order filtering.
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all functionalities
    initContactModal();
    initOrderStatusButtons();
    initOrderFilters();
    
    // Reinitialize after tab switch
    const tabButtons = document.querySelectorAll('.tab-button');
    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Give some time for the DOM to update
            setTimeout(() => {
                initOrderStatusButtons();
                initOrderFilters();
            }, 100);
        });
    });
});

/**
 * Initialize the contact modal functionality
 */
function initContactModal() {
    // Get all contact buttons
    const contactButtons = document.querySelectorAll('.contact-btn');
    const modal = document.querySelector('.modal');
    const closeModalBtn = document.querySelector('.close-modal');
    const sendMessageBtn = document.querySelector('.send-btn');
    
    // Add click event listeners to all contact buttons
    contactButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Get the buyer's email from the data attribute
            const recipientEmail = this.getAttribute('data-email');
            const recipientName = this.getAttribute('data-name');
            const orderId = this.getAttribute('data-order-id');
            
            // Set the recipient field in the modal
            document.getElementById('recipient').value = recipientEmail;
            
            // Set the default subject with order ID
            document.getElementById('subject').value = `Informazioni sull'ordine #${orderId}`;
            
            // Set a default greeting in the message
            document.getElementById('message').value = `Gentile ${recipientName},\n\nIn merito al suo ordine #${orderId}, volevo informarla che...\n\nCordiali saluti,\n[Il tuo nome]`;
            
            // Show the modal
            modal.style.display = 'flex';
        });
    });
    
    // Close modal when clicking the close button
    if (closeModalBtn) {
        closeModalBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });
    }
    
    // Close modal when clicking outside the modal content
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Send message functionality
    if (sendMessageBtn) {
        sendMessageBtn.addEventListener('click', function() {
            const recipient = document.getElementById('recipient').value;
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value;
            
            if (!recipient || !subject || !message) {
                alert('Per favore, compila tutti i campi');
                return;
            }
            
            // Here you would typically send an AJAX request to your server
            // For now, we'll just simulate a successful send
            sendMessage(recipient, subject, message);
        });
    }
}

/**
 * Send a message to a buyer (simulation for now)
 */
function sendMessage(recipient, subject, message) {
    // Simulate sending message with a timeout
    const sendBtn = document.querySelector('.send-btn');
    const originalText = sendBtn.textContent;
    
    sendBtn.textContent = 'Invio in corso...';
    sendBtn.disabled = true;
    
    setTimeout(function() {
        sendBtn.textContent = 'Inviato! ✓';
        
        setTimeout(function() {
            // Reset the form and close the modal
            document.getElementById('recipient').value = '';
            document.getElementById('subject').value = '';
            document.getElementById('message').value = '';
            sendBtn.textContent = originalText;
            sendBtn.disabled = false;
            document.querySelector('.modal').style.display = 'none';
            
            // Show a success message
            showNotification('Messaggio inviato con successo!', 'success');
        }, 1500);
    }, 2000);
    
    // In a real implementation, you would use fetch or XMLHttpRequest to send the data
    /*
    fetch('/send-message', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            recipient: recipient,
            subject: subject,
            message: message
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('Messaggio inviato con successo!');
            document.querySelector('.modal').style.display = 'none';
        } else {
            alert('Errore nell\'invio del messaggio: ' + data.error);
        }
    })
    .catch(error => {
        alert('Errore nell\'invio del messaggio: ' + error);
    });
    */
}

/**
 * Initialize the order status buttons functionality
 */
function initOrderStatusButtons() {
    // Get all accept buttons
    const acceptButtons = document.querySelectorAll('.status-btn.accept');
    
    // Get all decline buttons
    const declineButtons = document.querySelectorAll('.status-btn.decline');
    
    // Get all complete buttons
    const completeButtons = document.querySelectorAll('.status-btn.complete');
    
    // Add event listeners to accept buttons
    acceptButtons.forEach(button => {
        button.addEventListener('click', function() {
            const orderId = this.getAttribute('data-order-id');
            updateOrderStatus(orderId, 'accepted', this);
        });
    });
    
    // Add event listeners to decline buttons
    declineButtons.forEach(button => {
        button.addEventListener('click', function() {
            const orderId = this.getAttribute('data-order-id');
            updateOrderStatus(orderId, 'rejected', this);
        });
    });
    
    // Add event listeners to complete buttons
    completeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const orderId = this.getAttribute('data-order-id');
            updateOrderStatus(orderId, 'completed', this);
        });
    });
}

/**
 * Update the status of an order
 */
function updateOrderStatus(orderId, newStatus, buttonElement) {
    // Find the order card that contains this button
    const orderCard = buttonElement.closest('.order-card');
    
    // Find the status element within the card
    const statusElement = orderCard.querySelector('.status');
    
    // Show confirmation modal instead of browser alert
    let confirmTitle = '';
    let confirmMessage = '';
    
    switch(newStatus) {
        case 'accepted':
            confirmTitle = 'Conferma accettazione';
            confirmMessage = 'Sei sicuro di voler accettare questo ordine? Il cliente sarà notificato.';
            break;
        case 'rejected':
            confirmTitle = 'Conferma rifiuto';
            confirmMessage = 'Sei sicuro di voler rifiutare questo ordine? Il cliente sarà notificato.';
            break;
        case 'completed':
            confirmTitle = 'Conferma completamento';
            confirmMessage = 'Sei sicuro di voler contrassegnare questo ordine come completato? Il cliente sarà notificato.';
            break;
    }
    
    // Set up the confirmation modal
    const modal = document.getElementById('status-confirmation-modal');
    const modalTitle = document.getElementById('status-confirmation-title');
    const modalMessage = document.getElementById('status-confirmation-message');
    const confirmBtn = document.getElementById('status-confirm-btn');
    const cancelBtn = document.getElementById('status-cancel-btn');
    const closeBtn = modal.querySelector('.close-modal');
    
    modalTitle.textContent = confirmTitle;
    modalMessage.textContent = confirmMessage;
    
    // Show the modal
    modal.style.display = 'flex';
    
    // Handle confirm button click
    const confirmHandler = function() {
        // Show loading state on the button
        const originalText = buttonElement.textContent;
        buttonElement.textContent = 'In corso...';
        buttonElement.disabled = true;
        
        // Close the modal
        modal.style.display = 'none';
        
        // Simulate an AJAX request with setTimeout
        setTimeout(function() {
            // Update the status element text and class
            statusElement.textContent = getStatusText(newStatus);
            statusElement.className = 'status ' + newStatus;
            
            // Remove the old status class from the order card and add the new one
            orderCard.classList.remove('pending', 'accepted', 'rejected', 'completed');
            orderCard.classList.add(newStatus);
            
            // Update the status actions based on the new status
            const statusActions = orderCard.querySelector('.status-actions');
            
            if (statusActions) {
                if (newStatus === 'accepted') {
                    // If the order was accepted, show the complete button
                    statusActions.innerHTML = '<button class="status-btn complete" data-order-id="' + orderId + '">Completa</button>';
                    
                    // Add event listener to the new complete button
                    const completeBtn = statusActions.querySelector('.status-btn.complete');
                    if (completeBtn) {
                        completeBtn.addEventListener('click', function() {
                            updateOrderStatus(orderId, 'completed', this);
                        });
                    }
                } else {
                    // For other statuses, hide the status actions
                    statusActions.style.display = 'none';
                }
            }
            
            // Show a success message using a notification instead of alert
            showNotification(`Ordine ${getStatusText(newStatus).toLowerCase()} con successo!`, 'success');
            
            // Reset button state
            buttonElement.textContent = originalText;
            buttonElement.disabled = false;
            
            // Sincronizza lo stato dell'ordine con la vista dell'acquirente
            syncOrderStatusWithBuyer(orderId, newStatus);
        }, 1500);
    };
    
    // Handle cancel button click
    const cancelHandler = function() {
        modal.style.display = 'none';
    };
    
    // Remove any existing event listeners
    confirmBtn.replaceWith(confirmBtn.cloneNode(true));
    cancelBtn.replaceWith(cancelBtn.cloneNode(true));
    closeBtn.replaceWith(closeBtn.cloneNode(true));
    
    // Get the new button references
    const newConfirmBtn = document.getElementById('status-confirm-btn');
    const newCancelBtn = document.getElementById('status-cancel-btn');
    const newCloseBtn = modal.querySelector('.close-modal');
    
    // Add event listeners
    newConfirmBtn.addEventListener('click', confirmHandler);
    newCancelBtn.addEventListener('click', cancelHandler);
    newCloseBtn.addEventListener('click', cancelHandler);
    
    // Close the modal if user clicks outside of it
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            cancelHandler();
        }
    });
}

/**
 * Simula l'aggiornamento dello stato dell'ordine durante lo sviluppo
 */
function simulateOrderStatusUpdate(orderId, newStatus, buttonElement) {
    setTimeout(function() {
        const success = Math.random() > 0.1; // 90% di successo
        
        if (success) {
            // Aggiorna l'UI per riflettere il nuovo stato
            const orderCard = buttonElement.closest('.order-card');
            const statusElement = orderCard.querySelector('.order-status');
            
            // Rimuovi le classi di stato esistenti
            statusElement.className = 'order-status';
            // Aggiungi la nuova classe di stato
            statusElement.classList.add(newStatus);
            // Aggiorna il testo
            statusElement.textContent = getStatusText(newStatus);
            
            // Nascondi tutti i pulsanti di stato
            const actionButtons = orderCard.querySelectorAll('.status-action');
            actionButtons.forEach(button => {
                button.style.display = 'none';
            });
            
            // Aggiorna la card dell'ordine con la nuova classe di stato
            orderCard.className = 'order-card';
            orderCard.classList.add(newStatus);
            
            // Mostra una notifica di successo
            showNotification('Stato aggiornato', `L'ordine #${orderId} è stato aggiornato a "${getStatusText(newStatus)}"`, 'success');
            
            // Salva lo stato dell'ordine nel localStorage per la sincronizzazione tra le pagine
            saveOrderStatusToLocalStorage(orderId, newStatus);
            
            // Sincronizza lo stato con la vista dell'acquirente
            syncOrderStatusWithBuyer(orderId, newStatus);
        } else {
            // Simulazione di errore per lo sviluppo
            showNotification('Errore', 'Si è verificato un errore durante l\'aggiornamento dello stato. Riprova più tardi.', 'error');
        }
        
        // Riabilita il pulsante
        buttonElement.disabled = false;
        buttonElement.classList.remove('loading');
    }, 1000);
}

/**
 * Salva lo stato dell'ordine nel localStorage per la sincronizzazione
 */
function saveOrderStatusToLocalStorage(orderId, newStatus) {
    try {
        // Recupera la lista degli ordini aggiornati o crea una nuova lista
        let updatedOrders = JSON.parse(localStorage.getItem('updatedOrders') || '{}');
        
        // Salva lo stato dell'ordine con un timestamp
        updatedOrders[orderId] = {
            status: newStatus,
            timestamp: new Date().getTime(),
            statusText: getStatusText(newStatus)
        };
        
        // Salva la lista aggiornata
        localStorage.setItem('updatedOrders', JSON.stringify(updatedOrders));
        console.log(`Stato dell'ordine #${orderId} salvato nel localStorage: ${newStatus}`);
    } catch (error) {
        console.error('Errore durante il salvataggio dello stato nel localStorage:', error);
    }
}

/**
 * Get the human-readable status text for a status code
 */
function getStatusText(status) {
    switch(status) {
        case 'pending':
            return 'In attesa';
        case 'accepted':
            return 'Accettato';
        case 'rejected':
            return 'Rifiutato';
        case 'completed':
            return 'Completato';
        case 'cancelled':
            return 'Annullato';
        default:
            return status.charAt(0).toUpperCase() + status.slice(1);
    }
}

/**
 * Initialize the order filters functionality
 */
function initOrderFilters() {
    const filterButtons = document.querySelectorAll('.filter-btn');
    const orderCards = document.querySelectorAll('.order-card');
    
    // Add event listeners to filter buttons
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Get the filter value
            const filter = this.getAttribute('data-filter');
            
            // Update active class on buttons
            filterButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // Filter the order cards
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
            
            // Check if there are no visible orders
            let visibleOrders = false;
            orderCards.forEach(card => {
                if (card.style.display !== 'none') {
                    visibleOrders = true;
                }
            });
            
            // Show or hide the "no orders" message
            const noOrdersMsg = document.querySelector('.no-orders');
            if (noOrdersMsg) {
                if (visibleOrders) {
                    noOrdersMsg.style.display = 'none';
                } else {
                    noOrdersMsg.style.display = 'block';
                }
            }
        });
    });
    
    // Initialize with "all" filter active
    const allFilter = document.querySelector('.filter-btn[data-filter="all"]');
    if (allFilter) {
        allFilter.classList.add('active');
    }
}

/**
 * Show a notification message
 */
function showNotification(message, type = 'info') {
    // Create notification element if it doesn't exist
    let notification = document.querySelector('.notification');
    
    if (!notification) {
        notification = document.createElement('div');
        notification.className = 'notification';
        document.body.appendChild(notification);
    }
    
    // Add type class
    notification.className = 'notification ' + type;
    
    // Set message
    notification.textContent = message;
    
    // Show notification
    notification.style.display = 'block';
    
    // Add animation class
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);
    
    // Hide notification after delay
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.style.display = 'none';
        }, 300);
    }, 3000);
}

/**
 * Sincronizza lo stato dell'ordine con la vista dell'acquirente tramite API
 * @param {number} orderId - ID dell'ordine da aggiornare
 * @param {string} newStatus - Nuovo stato dell'ordine
 */
function syncOrderStatusWithBuyer(orderId, newStatus) {
    // Effettua una chiamata API per aggiornare lo stato nel database
    fetch('/api/orders/' + orderId + '/status', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status: newStatus })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log('Status updated successfully:', data);
        
        // Invia l'aggiornamento tramite WebSocket per la notifica in tempo reale
        sendStatusUpdateNotification(orderId, newStatus);
    })
    .catch(error => {
        console.error('Error updating status:', error);
        showNotification('Errore durante l\'aggiornamento dello stato. Riprova più tardi.', 'error');
    });
}

/**
 * Invia una notifica di aggiornamento stato tramite WebSocket
 * @param {number} orderId - ID dell'ordine aggiornato
 * @param {string} newStatus - Nuovo stato dell'ordine
 */
function sendStatusUpdateNotification(orderId, newStatus) {
    // Controlla se esiste già una connessione WebSocket
    if (!window.statusSocket || window.statusSocket.readyState !== WebSocket.OPEN) {
        // Crea una nuova connessione WebSocket
        const wsProtocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
        const userId = document.querySelector('meta[name="user-id"]')?.content;
        
        if (!userId) {
            console.error('User ID not found');
            return;
        }
        
        window.statusSocket = new WebSocket(`${wsProtocol}${window.location.host}/order-status?userId=${userId}`);
        
        window.statusSocket.onopen = function() {
            // Invia l'aggiornamento di stato una volta che la connessione è stabilita
            sendStatusUpdate();
        };
        
        window.statusSocket.onerror = function(error) {
            console.error('WebSocket error:', error);
        };
    } else {
        // Usa la connessione esistente
        sendStatusUpdate();
    }
    
    // Funzione interna per inviare l'aggiornamento di stato
    function sendStatusUpdate() {
        const statusUpdate = {
            type: 'status_update',
            orderId: orderId,
            newStatus: newStatus,
            timestamp: new Date().toISOString()
        };
        
        window.statusSocket.send(JSON.stringify(statusUpdate));
    }
}
