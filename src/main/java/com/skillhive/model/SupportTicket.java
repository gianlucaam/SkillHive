package com.skillhive.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SupportTicket {
    private long id;
    private long userId; // ID dell'utente che ha aperto il ticket
    private String subject;
    private String status; // open, in_progress, resolved, closed
    private Date createdAt;
    private Date updatedAt;
    private String priority; // low, medium, high
    private List<Message> messages;
    private String type; // support, dispute
    private Long disputeOrderId; // ID dell'ordine oggetto della disputa (solo per dispute)
    private Long assignedAdminId; // ID dell'admin assegnato al ticket
    
    public SupportTicket() {
        this.messages = new ArrayList<>();
        this.createdAt = new Date();
        this.updatedAt = new Date();
        this.status = "open";
        this.priority = "medium";
    }
    
    // Getters and setters
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
    
    public String getSubject() {
        return subject;
    }
    
    public void setSubject(String subject) {
        this.subject = subject;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
        this.updatedAt = new Date();
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Date getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getPriority() {
        return priority;
    }
    
    public void setPriority(String priority) {
        this.priority = priority;
        this.updatedAt = new Date();
    }
    
    public List<Message> getMessages() {
        return messages;
    }
    
    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }
    
    public void addMessage(Message message) {
        this.messages.add(message);
        this.updatedAt = new Date();
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public Long getDisputeOrderId() {
        return disputeOrderId;
    }
    
    public void setDisputeOrderId(Long disputeOrderId) {
        this.disputeOrderId = disputeOrderId;
    }
    
    public Long getAssignedAdminId() {
        return assignedAdminId;
    }
    
    public void setAssignedAdminId(Long assignedAdminId) {
        this.assignedAdminId = assignedAdminId;
        this.updatedAt = new Date();
    }
    
    // Utility methods
    public boolean isOpen() {
        return "open".equals(status);
    }
    
    public boolean isInProgress() {
        return "in_progress".equals(status);
    }
    
    public boolean isResolved() {
        return "resolved".equals(status);
    }
    
    public boolean isClosed() {
        return "closed".equals(status);
    }
    
    public boolean isDispute() {
        return "dispute".equals(type);
    }
    
    public boolean isSupport() {
        return "support".equals(type);
    }
    
    public String getLastMessagePreview() {
        if (messages.isEmpty()) {
            return "Nessun messaggio";
        }
        Message lastMessage = messages.get(messages.size() - 1);
        String content = lastMessage.getContent();
        if (content.length() > 50) {
            return content.substring(0, 47) + "...";
        }
        return content;
    }
    
    public Message getLastMessage() {
        if (messages.isEmpty()) {
            return null;
        }
        return messages.get(messages.size() - 1);
    }
}
