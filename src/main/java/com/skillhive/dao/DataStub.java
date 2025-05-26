package com.skillhive.dao;

import com.skillhive.model.Order;
import com.skillhive.model.Service;
import com.skillhive.model.User;

import java.util.ArrayList;
import java.util.List;

public class DataStub {
    private static List<User> users = new ArrayList<>();
    private static List<Service> services = new ArrayList<>();
    private static List<Order> orders = new ArrayList<>();
    private static int nextServiceId = 1;
    private static long nextOrderId = 1;

    // Inizializzazione statica dei dati
    static {
        // Aggiunta di utenti (professionisti)
        users.add(new User());
        users.get(0).setId(1);
        users.get(0).setUsername("TechWizard");
        users.get(0).setEmail("u1@example.com");
        users.get(0).setPassword("123");

        users.add(new User());
        users.get(1).setId(2);
        users.get(1).setUsername("CreativeFox");
        users.get(1).setEmail("creativefox@skillhive.com");
        users.get(1).setPassword("password123");

        users.add(new User());
        users.get(2).setId(3);
        users.get(2).setUsername("CodeMaster");
        users.get(2).setEmail("codemaster@skillhive.com");
        users.get(2).setPassword("password123");

        users.add(new User());
        users.get(3).setId(4);
        users.get(3).setUsername("VideoPro");
        users.get(3).setEmail("videopro@skillhive.com");
        users.get(3).setPassword("password123");

        users.add(new User());
        users.get(4).setId(5);
        users.get(4).setUsername("AppGuru");
        users.get(4).setEmail("appguru@skillhive.com");
        users.get(4).setPassword("password123");

        users.add(new User());
        users.get(5).setId(6);
        users.get(5).setUsername("DesignerPro");
        users.get(5).setEmail("designerpro@skillhive.com");
        users.get(5).setPassword("password123");

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
        services.add(service);
        nextServiceId++;
    }

    public static void removeService(Service service) {
        services.remove(service);
    }

    public static List<Service> getServices() {
        return new ArrayList<>(services);
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
                        // Aggiorna il totale dell'ordine
                        order.setTotal(order.getTotal() - serviceToRemove.getPrice());
                        i--; // Aggiusta l'indice dopo la rimozione
                    }
                }
                
                if (serviceInOrder) {
                    ordersUpdated++;
                    // Se l'ordine è vuoto, aggiungilo alla lista di quelli da rimuovere
                    if (orderServices.isEmpty()) {
                        ordersToRemove.add(order);
                    }
                }
            }
            
            // Rimuovi gli ordini vuoti
            if (!ordersToRemove.isEmpty()) {
                ordersRemoved = ordersToRemove.size();
                orders.removeAll(ordersToRemove);
            }
            
            System.out.println("DataStub.removeService - Ordini aggiornati: " + ordersUpdated + ", Ordini rimossi: " + ordersRemoved);
        }
        
        return removed;
    }
}