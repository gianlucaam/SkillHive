/**
 * SkillHive Real-time Chat System
 * 
 * This file contains functionality for the real-time chat system between buyers and sellers.
 */

// WebSocket connection
let chatSocket = null;
let recipientId = null;
let senderId = null;
let orderId = null;
let currentUserName = '';
let userRole = 'seller'; // Default role, will be set based on the current page
let currentUserOnline = false; // Stato dell'utente per la simulazione

// Chat history simulation for development
const simulatedChatHistory = {
    // key: `${senderId}-${recipientId}-${orderId}`
};

// Initialize chat functionality
function initChat() {
    // Get the current user ID and name from meta tags
    senderId = document.querySelector('meta[name="user-id"]')?.content;
    currentUserName = document.querySelector('meta[name="user-name"]')?.content;
    
    // Determine if we're on the buyer or seller page
    userRole = window.location.pathname.includes('my-orders.jsp') ? 'buyer' : 'seller';
    
    const chatButtons = document.querySelectorAll('.contact-btn');
    const chatModal = document.querySelector('.chat-modal');
    const closeChatBtn = document.querySelector('.close-chat');
    const sendMessageBtn = document.querySelector('.send-chat-btn');
    const messageInput = document.querySelector('#chat-message');
    
    // Add click event listeners to all chat buttons
    chatButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Get recipient details based on role
            if (userRole === 'seller') {
                // Seller is contacting buyer
                recipientId = this.getAttribute('data-user-id');
                const buttonLabel = 'Contatta cliente';
            } else {
                // Buyer is contacting seller
                recipientId = this.getAttribute('data-seller-id');
                const buttonLabel = 'Contatta venditore';
            }
            
            orderId = this.getAttribute('data-order-id');
            const recipientName = this.getAttribute('data-name');
            
            // Set the chat header
            document.querySelector('.chat-recipient').textContent = recipientName;
            document.querySelector('.chat-order-id').textContent = `Ordine #${orderId}`;
            
            // Clear previous messages
            document.querySelector('.chat-messages').innerHTML = '';
            
            // Show the modal
            chatModal.style.display = 'flex';
            
            // Per lo sviluppo, simuliamo invece di usare il WebSocket reale
            simulateWebSocketConnection();
            
            // Check if recipient is online - simuliamo per lo sviluppo
            simulateUserStatus();
            
            // Load chat history - simuliamo per lo sviluppo
            simulateChatHistory();
        });
    });
    
    // Close chat when clicking the close button
    if (closeChatBtn) {
        closeChatBtn.addEventListener('click', function() {
            chatModal.style.display = 'none';
            closeWebSocketSimulation();
        });
    }
    
    // Close chat when clicking outside the modal content
    window.addEventListener('click', function(event) {
        if (event.target === chatModal) {
            chatModal.style.display = 'none';
            closeWebSocketSimulation();
        }
    });
    
    // Send message functionality
    if (sendMessageBtn && messageInput) {
        // Send on button click
        sendMessageBtn.addEventListener('click', function() {
            sendChatMessage();
        });
        
        // Send on Enter key
        messageInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendChatMessage();
            }
        });
        
        // Auto-resize textarea
        messageInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
    }
}

/**
 * Simulate WebSocket connection for development
 */
function simulateWebSocketConnection() {
    console.log('Simulazione connessione WebSocket per la chat');
    
    // Simulate successful connection
    setTimeout(() => {
        document.querySelector('.connection-status').innerHTML = 
            '<span class="status-indicator online"></span> Connessione simulata attiva';
    }, 1000);
}

/**
 * Close simulated WebSocket connection
 */
function closeWebSocketSimulation() {
    console.log('Chiusura simulazione WebSocket');
    
    // Reset status
    document.querySelector('.connection-status').innerHTML = 
        '<span class="status-indicator offline"></span> Disconnesso';
}

/**
 * Simulate user status check for development
 */
function simulateUserStatus() {
    const userStatus = document.querySelector('.user-status');
    userStatus.innerHTML = '<span class="status-indicator"></span> Controllo stato...';
    
    // Simulate random online status (50% chance)
    setTimeout(() => {
        currentUserOnline = Math.random() > 0.5;
        
        if (currentUserOnline) {
            userStatus.innerHTML = '<span class="status-indicator online"></span> Online';
        } else {
            userStatus.innerHTML = '<span class="status-indicator offline"></span> Offline';
        }
    }, 1500);
}

/**
 * Simulate chat history for development
 */
function simulateChatHistory() {
    // Create unique key for this conversation
    const conversationKey = `${senderId}-${recipientId}-${orderId}`;
    
    // If we don't have history for this conversation, create empty array
    if (!simulatedChatHistory[conversationKey]) {
        simulatedChatHistory[conversationKey] = [];
    }
    
    // Display existing history
    displayChatHistory(simulatedChatHistory[conversationKey]);
    
    // If empty, add welcome message
    if (simulatedChatHistory[conversationKey].length === 0) {
        setTimeout(() => {
            // Add system welcome message
            const welcomeMessage = {
                type: 'chat',
                senderId: 'system',
                senderName: 'Sistema',
                recipientId: senderId,
                orderId: orderId,
                text: `Benvenuto nella chat per l'ordine #${orderId}. Questa è una simulazione durante lo sviluppo.`,
                timestamp: new Date().toISOString()
            };
            
            displayChatMessage(welcomeMessage);
        }, 1000);
    }
}

// Initialize WebSocket connection - not used during development
function initWebSocket(recipientId, orderId) {
    // Close any existing connection
    closeWebSocket();
    
    // Create new WebSocket connection
    const wsProtocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
    const wsUrl = `${wsProtocol}${window.location.host}/chat?senderId=${senderId}&recipientId=${recipientId}&orderId=${orderId}`;
    
    try {
        chatSocket = new WebSocket(wsUrl);
        
        chatSocket.onopen = function(event) {
            console.log('WebSocket connection established');
            
            // Set online status indicator
            document.querySelector('.connection-status').innerHTML = 
                '<span class="status-indicator online"></span> Connessione attiva';
        };
        
        chatSocket.onmessage = function(event) {
            const message = JSON.parse(event.data);
            
            if (message.type === 'chat') {
                // Handle chat message
                displayChatMessage(message);
            } else if (message.type === 'status') {
                // Handle status update
                handleStatusUpdate(message);
            } else if (message.type === 'history') {
                // Handle chat history
                displayChatHistory(message.messages);
            }
        };
        
        chatSocket.onclose = function(event) {
            console.log('WebSocket connection closed');
            
            // Update connection status
            document.querySelector('.connection-status').innerHTML = 
                '<span class="status-indicator offline"></span> Disconnesso';
        };
        
        chatSocket.onerror = function(error) {
            console.error('WebSocket error:', error);
            
            // Update connection status
            document.querySelector('.connection-status').innerHTML = 
                '<span class="status-indicator error"></span> Errore di connessione';
        };
    } catch (error) {
        console.error('Error creating WebSocket:', error);
        document.querySelector('.connection-status').innerHTML = 
            '<span class="status-indicator error"></span> Impossibile connettersi';
    }
}

// Close WebSocket connection
function closeWebSocket() {
    if (chatSocket && chatSocket.readyState === WebSocket.OPEN) {
        chatSocket.close();
    }
}

// Load chat history - not used during development
function loadChatHistory(senderId, recipientId, orderId) {
    // Make API call to get chat history
    fetch(`/api/chat/history?senderId=${senderId}&recipientId=${recipientId}&orderId=${orderId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success && data.messages) {
                displayChatHistory(data.messages);
            }
        })
        .catch(error => {
            console.error('Error loading chat history:', error);
        });
}

// Send a chat message
function sendChatMessage() {
    const messageInput = document.querySelector('#chat-message');
    const messageText = messageInput.value.trim();
    
    if (!messageText) {
        return;
    }
    
    const message = {
        type: 'chat',
        senderId: senderId,
        senderName: currentUserName || 'Me',
        recipientId: recipientId,
        orderId: orderId,
        text: messageText,
        timestamp: new Date().toISOString()
    };
    
    // Durante lo sviluppo, salviamo i messaggi localmente invece di inviare via WebSocket
    const conversationKey = `${senderId}-${recipientId}-${orderId}`;
    if (!simulatedChatHistory[conversationKey]) {
        simulatedChatHistory[conversationKey] = [];
    }
    simulatedChatHistory[conversationKey].push(message);
    
    // Clear input
    messageInput.value = '';
    messageInput.style.height = 'auto';
    
    // Display message optimistically
    displayChatMessage(message, true);
    
    // Se il destinatario è offline, simula l'invio di un'email
    if (!currentUserOnline) {
        console.log('Simulazione invio email di notifica a utente offline');
    }
    
    // Simula risposta automatica dopo un breve ritardo
    if (Math.random() > 0.7) {
        setTimeout(() => {
            const autoReply = {
                type: 'chat',
                senderId: recipientId,
                senderName: document.querySelector('.chat-recipient').textContent,
                recipientId: senderId,
                orderId: orderId,
                text: getRandomReply(),
                timestamp: new Date().toISOString()
            };
            
            // Aggiungi alla cronologia simulata
            simulatedChatHistory[conversationKey].push(autoReply);
            
            // Visualizza la risposta
            displayChatMessage(autoReply);
        }, 2000 + Math.random() * 3000);
    }
}

/**
 * Genera una risposta casuale per la simulazione
 */
function getRandomReply() {
    const replies = [
        "Grazie per il messaggio! Ti risponderò al più presto.",
        "Ho ricevuto la tua richiesta, ci sto lavorando.",
        "Certo, posso aiutarti con questo.",
        "Grazie per l'aggiornamento!",
        "Perfetto, ho capito.",
        "Mi serve qualche informazione in più. Puoi fornire dettagli aggiuntivi?",
        "Ci sto lavorando, ti aggiorno appena possibile.",
        "Quanto tempo pensi che ci vorrà?",
        "Possiamo fissare una chiamata per discutere meglio i dettagli?",
        "Ricevuto, grazie!"
    ];
    
    return replies[Math.floor(Math.random() * replies.length)];
}

// Display a chat message in the UI
function displayChatMessage(message, isSentByMe = false) {
    const chatMessages = document.querySelector('.chat-messages');
    const messageDiv = document.createElement('div');
    
    // Determine if the message is sent by the current user
    isSentByMe = isSentByMe || message.senderId === senderId;
    
    // Add appropriate class based on who sent the message
    messageDiv.className = `message ${isSentByMe ? 'sent' : 'received'}`;
    
    // Format timestamp
    const timestamp = new Date(message.timestamp);
    const formattedTime = timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    
    // Create message content
    messageDiv.innerHTML = `
        <div class="message-content">
            <p>${message.text}</p>
            <span class="message-time">${formattedTime}</span>
        </div>
    `;
    
    // Add to chat container
    chatMessages.appendChild(messageDiv);
    
    // Scroll to bottom
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

// Display chat history
function displayChatHistory(messages) {
    if (!messages || messages.length === 0) return;
    
    // Clear existing messages
    const chatMessages = document.querySelector('.chat-messages');
    chatMessages.innerHTML = '';
    
    // Display each message
    messages.forEach(message => {
        displayChatMessage(message);
    });
}

// Handle status updates
function handleStatusUpdate(statusMessage) {
    if (statusMessage.userId === recipientId) {
        // Update user status
        const userStatus = document.querySelector('.user-status');
        
        if (statusMessage.online) {
            userStatus.innerHTML = '<span class="status-indicator online"></span> Online';
            currentUserOnline = true;
        } else {
            userStatus.innerHTML = '<span class="status-indicator offline"></span> Offline';
            currentUserOnline = false;
        }
    }
}

// Check if a user is online - not used during development
function checkUserOnlineStatus(userId) {
    // Set initial status to "checking"
    const userStatus = document.querySelector('.user-status');
    userStatus.innerHTML = '<span class="status-indicator"></span> Controllo stato...';
    
    // Make API call to check user status
    fetch(`/api/users/${userId}/status`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (data.online) {
                    userStatus.innerHTML = '<span class="status-indicator online"></span> Online';
                    currentUserOnline = true;
                } else {
                    userStatus.innerHTML = '<span class="status-indicator offline"></span> Offline';
                    currentUserOnline = false;
                }
            } else {
                userStatus.innerHTML = '<span class="status-indicator error"></span> Stato sconosciuto';
                currentUserOnline = false;
            }
        })
        .catch(error => {
            console.error('Error checking user status:', error);
            userStatus.innerHTML = '<span class="status-indicator error"></span> Errore';
            currentUserOnline = false;
        });
}

// Send email notification when user is offline - not used during development
function sendEmailNotification(recipientId, message) {
    // Get the order-specific details
    const orderNumber = document.querySelector('.chat-order-id').textContent.replace('Ordine #', '');
    const recipientName = document.querySelector('.chat-recipient').textContent;
    
    // Make API call to send email notification
    fetch('/api/notifications/email', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            recipientId: recipientId,
            recipientName: recipientName,
            senderId: senderId,
            senderName: currentUserName,
            orderId: orderId,
            orderNumber: orderNumber,
            message: message,
            userRole: userRole
        })
    })
    .then(response => response.json())
    .then(data => {
        console.log('Email notification sent:', data);
    })
    .catch(error => {
        console.error('Error sending email notification:', error);
    });
}

// Initialize the chat when the DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initChat();
});
