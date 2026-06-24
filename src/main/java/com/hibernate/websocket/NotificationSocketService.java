package com.hibernate.websocket;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import com.hibernate.dto.NotificationDto;

import java.util.List;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class NotificationSocketService {

    private final SimpMessagingTemplate messagingTemplate;

    public void broadcastToUser(Integer userId, NotificationDto notification) {
        if (userId == null || notification == null) {
            return;
        }
        messagingTemplate.convertAndSend("/topic/notifications/" + userId, notification);
    }

    public void broadcastNotifications(List<NotificationDto> notifications) {
        if (notifications == null) {
            return;
        }
        for (NotificationDto notification : notifications) {
            if (notification != null && notification.getUserId() != null) {
                messagingTemplate.convertAndSend("/topic/notifications/" + notification.getUserId(), notification);
            }
        }
    }
}
