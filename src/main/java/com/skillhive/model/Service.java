package com.skillhive.model;

public class Service {
    private int id;
    private String title;
    private String description;
    private double price;
    private int sellerId;
    private String category;
    private String image;
    private int deliveryTime;
    private String status; // pending, approved, rejected

    // Costruttore senza parametri
    public Service() {
        this.status = "pending"; // Default status for new services
    }

    // Costruttore con parametri
    public Service(int id, String title, String description, double price, int sellerId, String category, String image, int deliveryTime) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.sellerId = sellerId;
        this.category = category;
        this.image = image;
        this.deliveryTime = deliveryTime;
        this.status = "approved"; // Default status for predefined services
    }

    // Getter e Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getSellerId() {
        return sellerId;
    }

    public void setSellerId(int sellerId) {
        this.sellerId = sellerId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(int deliveryTime) {
        this.deliveryTime = deliveryTime;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public boolean isPending() {
        return "pending".equals(status);
    }
    
    public boolean isApproved() {
        return "approved".equals(status);
    }
    
    public boolean isRejected() {
        return "rejected".equals(status);
    }
}