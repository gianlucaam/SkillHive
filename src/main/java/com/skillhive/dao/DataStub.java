package com.skillhive.dao;

import com.skillhive.model.Service;
import com.skillhive.model.User;

import java.util.ArrayList;
import java.util.List;

public class DataStub {
    private static List<User> users = new ArrayList<>();
    private static List<Service> services = new ArrayList<>();
    private static int nextServiceId = 1;

    // Inizializzazione statica dei dati
    static {
        // Aggiunta di utenti (professionisti)
        users.add(new User());
        users.get(0).setId(1);
        users.get(0).setUsername("TechWizard");
        users.get(0).setEmail("techwizard@skillhive.com");
        users.get(0).setPassword("password123");

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
}