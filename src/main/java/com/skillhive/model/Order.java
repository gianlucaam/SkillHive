package com.skillhive.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Order {
    private long id;
    private long userId;
    private List<Service> services;
    private double total;
    private String status;
    private Date orderDate;
    private String shippingAddress;
    private String paymentMethod;
    
    public Order() {
        this.services = new ArrayList<>();
        this.orderDate = new Date();
        this.status = "PENDING";
    }
    
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public long getUserId() {
        return userId;
    }
    
    public void setUserId(long userId) {
        this.userId = userId;
    }
    
    public List<Service> getServices() {
        return services;
    }
    
    public void setServices(List<Service> services) {
        this.services = services;
    }
    
    public double getTotal() {
        return total;
    }
    
    public void setTotal(double total) {
        this.total = total;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }
    
    public String getShippingAddress() {
        return shippingAddress;
    }
    
    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public void addService(Service service) {
        this.services.add(service);
        this.total += service.getPrice();
    }
}
