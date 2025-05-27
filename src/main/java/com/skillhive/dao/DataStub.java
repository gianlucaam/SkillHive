package com.skillhive.dao;

import com.skillhive.model.Message;
import com.skillhive.model.Order;
import com.skillhive.model.ReportData;
import com.skillhive.model.Service;
import com.skillhive.model.SupportTicket;
import com.skillhive.model.User;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class DataStub {
    private static List<User> users = new ArrayList<>();
    private static List<Service> services = new ArrayList<>();
    private static List<Order> orders = new ArrayList<>();
    private static List<SupportTicket> tickets = new ArrayList<>();
    private static List<Message> messages = new ArrayList<>();
    private static int nextServiceId = 1;
    private static long nextOrderId = 1;
    private static long nextTicketId = 1;
    private static long nextMessageId = 1;

    // Inizializzazione statica dei dati
    static {
        // Aggiungiamo alcuni utenti di esempio
        User admin = new User();
        admin.setId(1);
        admin.setUsername("admin");
        admin.setEmail("admin@skillhive.com");
        admin.setPassword("admin");
        admin.setRole("admin");
        admin.setRegistrationDate(new Date());
        users.add(admin);
        
        User user1 = new User();
        user1.setId(2);
        user1.setUsername("CreativeFox");
        user1.setEmail("creativefox@email.com");
        user1.setPassword("password");
        user1.setRole("user");
        
        // Set registration date to a past date for better reporting data visualization
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -6);
        user1.setRegistrationDate(cal.getTime());
        users.add(user1);
        
        User user2 = new User();
        user2.setId(3);
        user2.setUsername("CodeMaster");
        user2.setEmail("codemaster@email.com");
        user2.setPassword("password");
        user2.setRole("user");
        
        // Set registration date to a different past date
        cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -4);
        user2.setRegistrationDate(cal.getTime());
        users.add(user2);
        
        User user3 = new User();
        user3.setId(4);
        user3.setUsername("DesignPro");
        user3.setEmail("designpro@email.com");
        user3.setPassword("password");
        user3.setRole("user");
        
        // Set registration date to a different past date
        cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -2);
        user3.setRegistrationDate(cal.getTime());
        users.add(user3);
        
        User user4 = new User();
        user4.setId(5);
        user4.setUsername("VideoPro");
        user4.setEmail("videopro@skillhive.com");
        user4.setPassword("password123");
        user4.setRole("user");
        cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -3);
        user4.setRegistrationDate(cal.getTime());
        users.add(user4);
        
        User user5 = new User();
        user5.setId(6);
        user5.setUsername("AppGuru");
        user5.setEmail("appguru@skillhive.com");
        user5.setPassword("password123");
        user5.setRole("user");
        cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -1);
        user5.setRegistrationDate(cal.getTime());
        users.add(user5);
        
        User user6 = new User();
        user6.setId(7);
        user6.setUsername("DesignerPro");
        user6.setEmail("designerpro@skillhive.com");
        user6.setPassword("password123");
        user6.setRole("user");
        cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -5);
        user6.setRegistrationDate(cal.getTime());
        users.add(user6);
        
        // Aggiungiamo un admin
        User adminUser = new User();
        adminUser.setId(8);
        adminUser.setUsername("Admin");
        adminUser.setEmail("admin@skillhive.com");
        adminUser.setPassword("admin123");
        adminUser.setRole("admin");
        adminUser.setRegistrationDate(new Date());
        users.add(adminUser);

        // Aggiunta di servizi esistenti
        services.add(new Service(nextServiceId++, "Custom Web Development", "Build a custom website tailored to your needs.", 500.00, 1, "Development", "images/web_dev.jpg", 7));
        services.add(new Service(nextServiceId++, "Graphic Design", "Professional logo and branding design.", 200.00, 2, "Graphic Design", "images/graphic_design.jpg", 5));
        services.add(new Service(nextServiceId++, "Software Development", "Custom software solutions for your business.", 800.00, 3, "Development", "images/software_dev.jpg", 14));
        services.add(new Service(nextServiceId++, "Video Editing", "High-quality video editing for any project.", 300.00, 4, "Video Editing", "images/video_editing.jpg", 7));
        services.add(new Service(nextServiceId++, "Custom App Development", "Develop a mobile or web app from scratch.", 1000.00, 5, "Development", "images/app_dev.jpg", 21));
        services.add(new Service(nextServiceId++, "Premium Logo Design", "Unique and professional logo design.", 250.00, 6, "Graphic Design", "images/logo_design.jpg", 5));

        // Aggiunta di nuovi servizi
        services.add(new Service(nextServiceId++, "Database Development", "Build robust and scalable database solutions.", 600.00, 3, "Development", "images/database_dev.jpg", 14));
        services.add(new Service(nextServiceId++, "UI/UX Design", "Design intuitive and beautiful user interfaces.", 500.00, 6, "Graphic Design", "images/ui_ux_design.jpg", 14));
        
        // Aggiungiamo un servizio in stato pending per test
        Service pendingService = new Service(nextServiceId++, "AI Implementation", "Integrate AI solutions into your existing software.", 1200.00, 1, "AI & Machine Learning", "images/ai_dev.jpg", 30);
        pendingService.setStatus("pending");
        services.add(pendingService);
        
        // Aggiungiamo un ordine per test
        Order testOrder = new Order();
        testOrder.setId(nextOrderId++);
        testOrder.setUserId(2); // CreativeFox è l'acquirente
        testOrder.setOrderDate(new Date());
        testOrder.setStatus("completed");
        List<Service> orderServices = new ArrayList<>();
        orderServices.add(services.get(0)); // Custom Web Development
        testOrder.setServices(orderServices);
        testOrder.setTotal(500.00);
        orders.add(testOrder);
        
        // Aggiungiamo alcuni ticket di supporto per test
        // Ticket 1: Supporto generale
        SupportTicket supportTicket = new SupportTicket();
        supportTicket.setId(nextTicketId++);
        supportTicket.setUserId(2); // CreativeFox
        supportTicket.setSubject("Problema con il pagamento");
        supportTicket.setType("support");
        supportTicket.setPriority("high");
        supportTicket.setStatus("open");
        supportTicket.setCreatedAt(new Date(System.currentTimeMillis() - 86400000)); // 1 giorno fa
        
        Message message1 = new Message();
        message1.setId(nextMessageId++);
        message1.setTicketId(supportTicket.getId());
        message1.setSenderId(2);
        message1.setSenderType("user");
        message1.setContent("Buongiorno, ho provato ad effettuare un pagamento ma la transazione non è andata a buon fine. Potete aiutarmi?");
        message1.setTimestamp(new Date(System.currentTimeMillis() - 86400000)); // 1 giorno fa
        
        supportTicket.addMessage(message1);
        tickets.add(supportTicket);
        messages.add(message1);
        
        // Ticket 2: Disputa su un ordine
        SupportTicket disputeTicket = new SupportTicket();
        disputeTicket.setId(nextTicketId++);
        disputeTicket.setUserId(2); // CreativeFox
        disputeTicket.setSubject("Qualità del servizio non soddisfacente");
        disputeTicket.setType("dispute");
        disputeTicket.setDisputeOrderId(1L);
        disputeTicket.setPriority("medium");
        disputeTicket.setStatus("in_progress");
        disputeTicket.setAssignedAdminId(7L); // Assegnato all'Admin
        disputeTicket.setCreatedAt(new Date(System.currentTimeMillis() - 172800000)); // 2 giorni fa
        
        Message disputeMessage1 = new Message();
        disputeMessage1.setId(nextMessageId++);
        disputeMessage1.setTicketId(disputeTicket.getId());
        disputeMessage1.setSenderId(2);
        disputeMessage1.setSenderType("user");
        disputeMessage1.setContent("Il sito web che ho ricevuto non corrisponde a quanto concordato. Mancano diverse funzionalità promesse.");
        disputeMessage1.setTimestamp(new Date(System.currentTimeMillis() - 172800000)); // 2 giorni fa
        
        Message disputeMessage2 = new Message();
        disputeMessage2.setId(nextMessageId++);
        disputeMessage2.setTicketId(disputeTicket.getId());
        disputeMessage2.setSenderId(7);
        disputeMessage2.setSenderType("admin");
        disputeMessage2.setContent("Buongiorno, abbiamo ricevuto la sua segnalazione. Stiamo contattando il venditore per avere maggiori informazioni. La terremo aggiornata.");
        disputeMessage2.setTimestamp(new Date(System.currentTimeMillis() - 158400000)); // 1,8 giorni fa
        
        Message disputeMessage3 = new Message();
        disputeMessage3.setId(nextMessageId++);
        disputeMessage3.setTicketId(disputeTicket.getId());
        disputeMessage3.setSenderId(1);
        disputeMessage3.setSenderType("user");
        disputeMessage3.setContent("Sono il venditore. Le funzionalità mancanti non erano incluse nel pacchetto base acquistato. Sono disponibile a implementarle con un costo aggiuntivo.");
        disputeMessage3.setTimestamp(new Date(System.currentTimeMillis() - 144000000)); // 1,6 giorni fa
        
        disputeTicket.addMessage(disputeMessage1);
        disputeTicket.addMessage(disputeMessage2);
        disputeTicket.addMessage(disputeMessage3);
        tickets.add(disputeTicket);
        messages.add(disputeMessage1);
        messages.add(disputeMessage2);
        messages.add(disputeMessage3);
        
        // Ticket 3: Ticket risolto
        SupportTicket resolvedTicket = new SupportTicket();
        resolvedTicket.setId(nextTicketId++);
        resolvedTicket.setUserId(4); // VideoPro
        resolvedTicket.setSubject("Come ritirare i miei guadagni?");
        resolvedTicket.setType("support");
        resolvedTicket.setPriority("low");
        resolvedTicket.setStatus("resolved");
        resolvedTicket.setAssignedAdminId(7L);
        resolvedTicket.setCreatedAt(new Date(System.currentTimeMillis() - 345600000)); // 4 giorni fa
        
        Message resolvedMessage1 = new Message();
        resolvedMessage1.setId(nextMessageId++);
        resolvedMessage1.setTicketId(resolvedTicket.getId());
        resolvedMessage1.setSenderId(4);
        resolvedMessage1.setSenderType("user");
        resolvedMessage1.setContent("Salve, ho accumulato alcuni guadagni sulla piattaforma. Come posso prelevarli sul mio conto bancario?");
        resolvedMessage1.setTimestamp(new Date(System.currentTimeMillis() - 345600000)); // 4 giorni fa
        
        Message resolvedMessage2 = new Message();
        resolvedMessage2.setId(nextMessageId++);
        resolvedMessage2.setTicketId(resolvedTicket.getId());
        resolvedMessage2.setSenderId(7);
        resolvedMessage2.setSenderType("admin");
        resolvedMessage2.setContent("Buongiorno, può effettuare il prelievo dal suo profilo nella sezione 'Pagamenti'. È necessario aver verificato il suo conto bancario. Se ha bisogno di ulteriore assistenza, non esiti a chiedere.");
        resolvedMessage2.setTimestamp(new Date(System.currentTimeMillis() - 345000000)); // 4 giorni fa meno 10 minuti
        
        Message resolvedMessage3 = new Message();
        resolvedMessage3.setId(nextMessageId++);
        resolvedMessage3.setTicketId(resolvedTicket.getId());
        resolvedMessage3.setSenderId(4);
        resolvedMessage3.setSenderType("user");
        resolvedMessage3.setContent("Grazie mille per l'informazione. Sono riuscito a completare l'operazione.");
        resolvedMessage3.setTimestamp(new Date(System.currentTimeMillis() - 344000000)); // 4 giorni fa meno 30 minuti
        
        resolvedTicket.addMessage(resolvedMessage1);
        resolvedTicket.addMessage(resolvedMessage2);
        resolvedTicket.addMessage(resolvedMessage3);
        tickets.add(resolvedTicket);
        messages.add(resolvedMessage1);
        messages.add(resolvedMessage2);
        messages.add(resolvedMessage3);
    }

    public static void addUser(User user) {
        users.add(user);
    }

    public static User getUserByEmail(String email) {
        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return user;
            }
        }
        return null;
    }

    public static List<User> getUsers() {
        return new ArrayList<>(users);
    }

    public static boolean isEmailUnique(String email) {
        return getUserByEmail(email) == null;
    }

    public static void addService(Service service) {
        service.setId(nextServiceId++);
        service.setStatus("pending"); // New services are pending by default
        services.add(service);
    }

    public static void removeService(Service service) {
        services.remove(service);
    }

    public static List<Service> getServices() {
        return new ArrayList<>(services);
    }
    
    public static List<Service> getPendingServices() {
        List<Service> pendingServices = new ArrayList<>();
        for (Service service : services) {
            if (service.isPending()) {
                pendingServices.add(service);
            }
        }
        return pendingServices;
    }
    
    public static Service getServiceById(int id) {
        for (Service service : services) {
            if (service.getId() == id) {
                return service;
            }
        }
        return null;
    }
    
    public static boolean updateServiceStatus(int serviceId, String status) {
        Service service = getServiceById(serviceId);
        if (service != null) {
            service.setStatus(status);
            return true;
        }
        return false;
    }
    
    public static boolean updateService(Service updatedService) {
        for (int i = 0; i < services.size(); i++) {
            Service service = services.get(i);
            if (service.getId() == updatedService.getId()) {
                services.set(i, updatedService);
                return true;
            }
        }
        return false;
    }

    public static int getNextServiceId() {
        return nextServiceId;
    }

    // Metodo per ottenere l'utente dal sellerId
    public static User getUserById(int id) {
        for (User user : users) {
            if (user.getId() == id) {
                return user;
            }
        }
        return null;
    }
    
    // Metodi per la gestione degli ordini
    public static List<Order> getOrders() {
        return new ArrayList<>(orders);
    }
    
    public static void addOrder(Order order) {
        order.setId(nextOrderId++);
        orders.add(order);
    }
    
    public static Order getOrderById(long id) {
        for (Order order : orders) {
            if (order.getId() == id) {
                return order;
            }
        }
        return null;
    }
    
    public static List<Order> getOrdersByUserId(long userId) {
        List<Order> userOrders = new ArrayList<>();
        for (Order order : orders) {
            if (order.getUserId() == userId) {
                userOrders.add(order);
            }
        }
        return userOrders;
    }
    
    public static List<Service> getServicesBySellerId(int sellerId) {
        List<Service> sellerServices = new ArrayList<>();
        for (Service service : services) {
            if (service.getSellerId() == sellerId) {
                sellerServices.add(service);
            }
        }
        return sellerServices;
    }

    /**
     * Rimuove un servizio dall'elenco dei servizi
     * @param serviceId ID del servizio da rimuovere
     * @param sellerId ID del venditore (per sicurezza)
     * @return true se il servizio è stato rimosso, false altrimenti
     */
    public static boolean removeService(int serviceId, int sellerId) {
        System.out.println("DataStub.removeService - Tentativo di rimozione servizio: ID=" + serviceId + ", SellerId=" + sellerId);
        
        // Trova il servizio
        Service serviceToRemove = null;
        for (Service s : services) {
            if (s.getId() == serviceId && s.getSellerId() == sellerId) {
                serviceToRemove = s;
                break;
            }
        }
        
        // Se non trovato, ritorna false
        if (serviceToRemove == null) {
            System.out.println("DataStub.removeService - Servizio non trovato o non autorizzato");
            return false;
        }
        
        // Rimuovi il servizio
        boolean removed = services.remove(serviceToRemove);
        System.out.println("DataStub.removeService - Servizio rimosso: " + removed);
        
        // Se rimosso, aggiorna anche gli ordini
        if (removed) {
            int ordersUpdated = 0;
            int ordersRemoved = 0;
            
            // Lista di ordini da rimuovere
            List<Order> ordersToRemove = new ArrayList<>();
            
            for (Order order : orders) {
                List<Service> orderServices = order.getServices();
                boolean serviceInOrder = false;
                
                // Rimuovi il servizio dalla lista dei servizi dell'ordine
                for (int i = 0; i < orderServices.size(); i++) {
                    Service s = orderServices.get(i);
                    if (s.getId() == serviceId) {
                        serviceInOrder = true;
                        orderServices.remove(i);
                        break;
                    }
                }
                
                if (serviceInOrder) {
                    ordersUpdated++;
                    
                    // Se l'ordine non ha più servizi, aggiungi alla lista per la rimozione
                    if (orderServices.isEmpty()) {
                        ordersToRemove.add(order);
                    }
                }
            }
            
            // Rimuovi gli ordini vuoti
            for (Order orderToRemove : ordersToRemove) {
                orders.remove(orderToRemove);
                ordersRemoved++;
            }
            
            System.out.println("DataStub.removeService - Ordini aggiornati: " + ordersUpdated);
            System.out.println("DataStub.removeService - Ordini rimossi: " + ordersRemoved);
        }
        
        return removed;
    }
    
    /**
     * Rimuove un servizio da admin (senza verifica del sellerId)
     * @param serviceId ID del servizio da rimuovere
     * @return true se il servizio è stato rimosso, false altrimenti
     */
    public static boolean adminRemoveService(int serviceId) {
        System.out.println("DataStub.adminRemoveService - Tentativo di rimozione servizio da admin: ID=" + serviceId);
        
        // Trova il servizio
        Service serviceToRemove = null;
        for (Service s : services) {
            if (s.getId() == serviceId) {
                serviceToRemove = s;
                break;
            }
        }
        
        // Se non trovato, ritorna false
        if (serviceToRemove == null) {
            System.out.println("DataStub.adminRemoveService - Servizio non trovato");
            return false;
        }
        
        // Rimuovi il servizio
        boolean removed = services.remove(serviceToRemove);
        System.out.println("DataStub.adminRemoveService - Servizio rimosso: " + removed);
        
        // Gestisci ordini come nella versione utente
        if (removed) {
            // ... codice per gestire gli ordini come nel metodo removeService
        }
        
        return removed;
    }
    
    // Metodi per la gestione dei ticket di supporto
    public static List<SupportTicket> getTickets() {
        return new ArrayList<>(tickets);
    }
    
    public static List<SupportTicket> getOpenTickets() {
        List<SupportTicket> openTickets = new ArrayList<>();
        for (SupportTicket ticket : tickets) {
            if (ticket.isOpen() || ticket.isInProgress()) {
                openTickets.add(ticket);
            }
        }
        return openTickets;
    }
    
    public static List<SupportTicket> getTicketsByUserId(long userId) {
        List<SupportTicket> userTickets = new ArrayList<>();
        for (SupportTicket ticket : tickets) {
            if (ticket.getUserId() == userId) {
                userTickets.add(ticket);
            }
        }
        return userTickets;
    }
    
    public static SupportTicket getTicketById(long id) {
        for (SupportTicket ticket : tickets) {
            if (ticket.getId() == id) {
                return ticket;
            }
        }
        return null;
    }
    
    public static void addTicket(SupportTicket ticket) {
        ticket.setId(nextTicketId++);
        ticket.setCreatedAt(new Date());
        ticket.setUpdatedAt(new Date());
        tickets.add(ticket);
    }
    
    public static boolean updateTicket(SupportTicket updatedTicket) {
        for (int i = 0; i < tickets.size(); i++) {
            SupportTicket ticket = tickets.get(i);
            if (ticket.getId() == updatedTicket.getId()) {
                updatedTicket.setUpdatedAt(new Date());
                tickets.set(i, updatedTicket);
                return true;
            }
        }
        return false;
    }
    
    public static void addMessage(Message message) {
        message.setId(nextMessageId++);
        message.setTimestamp(new Date());
        
        // Aggiorna il ticket con il nuovo messaggio
        SupportTicket ticket = getTicketById(message.getTicketId());
        if (ticket != null) {
            ticket.addMessage(message);
            ticket.setUpdatedAt(new Date());
            
            // Se il ticket è in stato 'open' e un admin risponde, imposta in_progress
            if (ticket.isOpen() && message.isFromAdmin()) {
                ticket.setStatus("in_progress");
                ticket.setAssignedAdminId(message.getSenderId());
            }
        }
        
        messages.add(message);
    }
    
    public static List<Message> getMessagesByTicketId(long ticketId) {
        List<Message> ticketMessages = new ArrayList<>();
        for (Message message : messages) {
            if (message.getTicketId() == ticketId) {
                ticketMessages.add(message);
            }
        }
        return ticketMessages;
    }
    
    public static boolean updateTicketStatus(long ticketId, String status) {
        SupportTicket ticket = getTicketById(ticketId);
        if (ticket != null) {
            ticket.setStatus(status);
            return true;
        }
        return false;
    }
    
    public static boolean assignTicketToAdmin(long ticketId, long adminId) {
        SupportTicket ticket = getTicketById(ticketId);
        if (ticket != null) {
            ticket.setAssignedAdminId(adminId);
            
            // Se il ticket è in stato 'open', imposta in_progress
            if (ticket.isOpen()) {
                ticket.setStatus("in_progress");
            }
            
            return true;
        }
        return false;
    }
    
    public static boolean updateTicketPriority(long ticketId, String priority) {
        SupportTicket ticket = getTicketById(ticketId);
        if (ticket != null) {
            ticket.setPriority(priority);
            return true;
        }
        return false;
    }
    
    // Report generation methods
    public static ReportData generateReportData(Date startDate, Date endDate, String category, Integer sellerId) {
        ReportData reportData = new ReportData();
        reportData.setStartDate(startDate);
        reportData.setEndDate(endDate);
        
        // Process orders
        for (Order order : orders) {
            Date orderDate = order.getOrderDate();
            
            // Skip if outside date range
            if ((startDate != null && orderDate.before(startDate)) || 
                (endDate != null && orderDate.after(endDate))) {
                continue;
            }
            
            // Filter by seller if specified
            if (sellerId != null) {
                boolean hasSeller = false;
                for (Service service : order.getServices()) {
                    if (service.getSellerId() == sellerId) {
                        hasSeller = true;
                        break;
                    }
                }
                if (!hasSeller) continue;
            }
            
            // Filter by category if specified
            if (category != null && !category.isEmpty()) {
                boolean hasCategory = false;
                for (Service service : order.getServices()) {
                    if (category.equals(service.getCategory())) {
                        hasCategory = true;
                        break;
                    }
                }
                if (!hasCategory) continue;
            }
            
            // Add order data
            reportData.addOrderData(order, users, services);
        }
        
        // Process user registrations
        for (User user : users) {
            Date registrationDate = user.getRegistrationDate();
            if (registrationDate != null) {
                // Skip if outside date range
                if ((startDate != null && registrationDate.before(startDate)) || 
                    (endDate != null && registrationDate.after(endDate))) {
                    continue;
                }
                
                reportData.addUserRegistrationData(user);
            }
        }
        
        // Calculate totals
        reportData.calculateTotals();
        reportData.setTotalUsers(users.size());
        reportData.setTotalServices(services.size());
        reportData.setTotalOrders(orders.size());
        
        return reportData;
    }

    // Metodi per l'accesso ai dati
    public static List<User> getAllUsers() {
        return new ArrayList<>(users);
    }
    
    public static List<Service> getAllServices() {
        return new ArrayList<>(services);
    }
}