package com.hibernate.dto;

import com.hibernate.entity.NotificationEntity;
import com.hibernate.entity.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NotificationDto {

    private Integer id;
    private Integer userId;
    private String title;
    private String message;
    private Boolean isRead;
    private String notificationType;
    private String linkUrl;
    private String createdAt;
    private Integer senderId;
    private String senderName;

    public static NotificationDto fromEntity(NotificationEntity notification) {
        NotificationDto dto = new NotificationDto();
        dto.setId(notification.getId());
        if (notification.getUser() != null) {
            dto.setUserId(notification.getUser().getId());
        }
        dto.setTitle(notification.getTitle());
        dto.setMessage(notification.getMessage());
        dto.setIsRead(notification.getIsRead());
        dto.setNotificationType(notification.getNotificationType());
        dto.setLinkUrl(notification.getLinkUrl());
        dto.setCreatedAt(notification.getCreatedAt() != null ? notification.getCreatedAt().toString() : "");

        User sender = notification.getSender();
        if (sender != null) {
            dto.setSenderId(sender.getId());
            dto.setSenderName(sender.getFullName() != null ? sender.getFullName() : sender.getUsername());
        }

        return dto;
    }
}
