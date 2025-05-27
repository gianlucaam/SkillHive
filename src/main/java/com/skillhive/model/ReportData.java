package com.skillhive.model;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Model class for storing and processing report data
 */
public class ReportData {
    // Sales data
    private Map<Date, Double> salesByDate;
    private Map<String, Double> salesByCategory;
    private Map<Integer, Double> salesBySeller;
    
    // Registration data
    private Map<Date, Integer> registrationsByDate;
    
    // Service performance data
    private Map<Integer, Integer> serviceOrderCounts;
    private Map<Integer, Double> serviceRevenue;
    private Map<String, Integer> ordersByStatus;
    
    // Category popularity
    private Map<String, Integer> categoryCounts;
    
    // Total calculations
    private double totalSales;
    private int totalUsers;
    private int totalServices;
    private int totalOrders;
    
    // Date range
    private Date startDate;
    private Date endDate;
    
    public ReportData() {
        salesByDate = new HashMap<>();
        salesByCategory = new HashMap<>();
        salesBySeller = new HashMap<>();
        registrationsByDate = new HashMap<>();
        serviceOrderCounts = new HashMap<>();
        serviceRevenue = new HashMap<>();
        ordersByStatus = new HashMap<>();
        categoryCounts = new HashMap<>();
    }

    // Getters and setters
    public Map<Date, Double> getSalesByDate() {
        return salesByDate;
    }

    public void setSalesByDate(Map<Date, Double> salesByDate) {
        this.salesByDate = salesByDate;
    }

    public Map<String, Double> getSalesByCategory() {
        return salesByCategory;
    }

    public void setSalesByCategory(Map<String, Double> salesByCategory) {
        this.salesByCategory = salesByCategory;
    }

    public Map<Integer, Double> getSalesBySeller() {
        return salesBySeller;
    }

    public void setSalesBySeller(Map<Integer, Double> salesBySeller) {
        this.salesBySeller = salesBySeller;
    }

    public Map<Date, Integer> getRegistrationsByDate() {
        return registrationsByDate;
    }

    public void setRegistrationsByDate(Map<Date, Integer> registrationsByDate) {
        this.registrationsByDate = registrationsByDate;
    }

    public Map<Integer, Integer> getServiceOrderCounts() {
        return serviceOrderCounts;
    }

    public void setServiceOrderCounts(Map<Integer, Integer> serviceOrderCounts) {
        this.serviceOrderCounts = serviceOrderCounts;
    }

    public Map<Integer, Double> getServiceRevenue() {
        return serviceRevenue;
    }

    public void setServiceRevenue(Map<Integer, Double> serviceRevenue) {
        this.serviceRevenue = serviceRevenue;
    }

    public Map<String, Integer> getOrdersByStatus() {
        return ordersByStatus;
    }

    public void setOrdersByStatus(Map<String, Integer> ordersByStatus) {
        this.ordersByStatus = ordersByStatus;
    }

    public Map<String, Integer> getCategoryCounts() {
        return categoryCounts;
    }

    public void setCategoryCounts(Map<String, Integer> categoryCounts) {
        this.categoryCounts = categoryCounts;
    }

    public double getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(double totalSales) {
        this.totalSales = totalSales;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalServices() {
        return totalServices;
    }

    public void setTotalServices(int totalServices) {
        this.totalServices = totalServices;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    // Helper methods for data processing
    public void calculateTotals() {
        totalSales = salesByDate.values().stream().mapToDouble(Double::doubleValue).sum();
        totalOrders = serviceOrderCounts.values().stream().mapToInt(Integer::intValue).sum();
    }
    
    // Add an order to the report data
    public void addOrderData(Order order, List<User> users, List<Service> services) {
        Date orderDate = order.getOrderDate();
        double total = order.getTotal();
        
        // Add to sales by date
        salesByDate.put(orderDate, salesByDate.getOrDefault(orderDate, 0.0) + total);
        
        // Add to sales by seller
        for (Service service : order.getServices()) {
            Integer sellerId = service.getSellerId();
            String category = service.getCategory();
            double price = service.getPrice();
            
            // Sales by seller
            salesBySeller.put(sellerId, salesBySeller.getOrDefault(sellerId, 0.0) + price);
            
            // Sales by category
            salesByCategory.put(category, salesByCategory.getOrDefault(category, 0.0) + price);
            
            // Service order counts
            Integer serviceId = service.getId();
            serviceOrderCounts.put(serviceId, serviceOrderCounts.getOrDefault(serviceId, 0) + 1);
            
            // Service revenue
            serviceRevenue.put(serviceId, serviceRevenue.getOrDefault(serviceId, 0.0) + price);
            
            // Category counts
            categoryCounts.put(category, categoryCounts.getOrDefault(category, 0) + 1);
        }
        
        // Orders by status
        String status = order.getStatus();
        ordersByStatus.put(status, ordersByStatus.getOrDefault(status, 0) + 1);
    }
    
    // Add user registration data
    public void addUserRegistrationData(User user) {
        Date registrationDate = user.getRegistrationDate();
        if (registrationDate != null) {
            registrationsByDate.put(registrationDate, registrationsByDate.getOrDefault(registrationDate, 0) + 1);
        }
    }
}
