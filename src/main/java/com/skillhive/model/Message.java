package com.skillhive.model;

import java.util.Date;

public class Message {
    private long id;
    private long ticketId;
    private long senderId;
    private String senderType; // user, admin
    private String content;
    private Date timestamp;
    private boolean isRead;
    private String attachmentUrl; // URL dell'allegato (se presente)
    
    public Message() {
        this.timestamp = new Date();
        this.isRead = false;
    }
    
    // Getters and setters
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public long getTicketId() {
        return ticketId;
    }
    
    public void setTicketId(long ticketId) {
        this.ticketId = ticketId;
    }
    
    public long getSenderId() {
        return senderId;
    }
    
    public void setSenderId(long senderId) {
        this.senderId = senderId;
    }
    
    public String getSenderType() {
        return senderType;
    }
    
    public void setSenderType(String senderType) {
        this.senderType = senderType;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Date getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
    
    public String getAttachmentUrl() {
        return attachmentUrl;
    }
    
    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }
    
    // Utility methods
    public boolean isFromAdmin() {
        return "admin".equals(senderType);
    }
    
    public boolean isFromUser() {
        return "user".equals(senderType);
    }
    
    public boolean hasAttachment() {
        return attachmentUrl != null && !attachmentUrl.isEmpty();
    }
}
